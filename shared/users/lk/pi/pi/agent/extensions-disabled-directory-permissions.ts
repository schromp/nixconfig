/**
 * Directory Permission Gate Extension
 *
 * By default, allows file access only within ~/repos (and subdirectories).
 * For paths outside trusted directories, asks the user before allowing access.
 * Users can whitelist directories permanently or allow one-time access.
 *
 * Whitelist is persisted to ~/.pi/agent/dir-permissions-whitelist.json
 * so it survives session resets.
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { homedir } from "node:os";
import { resolve, relative, dirname } from "node:path";
import { existsSync, readFileSync, writeFileSync, statSync } from "node:fs";

// ---- Configuration ----
const WHITELIST_FILE = resolve(homedir(), ".pi/agent", "dir-permissions-whitelist.json");
const REPOS_DIR = resolve(homedir(), "repos");

// ---- State ----
let trustedDirs: string[] = [];

// ---- Helpers ----
function loadWhitelist(): string[] {
  try {
    if (existsSync(WHITELIST_FILE)) {
      const raw = readFileSync(WHITELIST_FILE, "utf-8");
      const parsed = JSON.parse(raw) as string[];
      if (Array.isArray(parsed)) {
        return parsed.map((p) => resolve(p));
      }
    }
  } catch {
    // File corrupted or unreadable — start fresh
  }
  return [];
}

function saveWhitelist(dirs: string[]): void {
  const resolved = dirs.map((p) => resolve(p));
  writeFileSync(WHITELIST_FILE, JSON.stringify(resolved, null, 2) + "\n", "utf-8");
}

function isPathUnder(path: string, dir: string): boolean {
  const relPath = relative(dir, path);
  return relPath !== "" && !relPath.startsWith("..");
}

function isTrusted(path: string): boolean {
  const resolvedPath = resolve(path);
  return trustedDirs.some((dir) => resolvedPath === dir || isPathUnder(resolvedPath, dir));
}

function addDirectory(dir: string): boolean {
  const resolvedDir = resolve(dir);
  // Don't add if already trusted (exact or as subdir of an existing dir)
  if (trustedDirs.some((d) => resolvedDir === d || isPathUnder(resolvedDir, d))) {
    return false;
  }
  // Remove any entries that are now subsumed by the new dir
  trustedDirs = trustedDirs.filter((d) => !isPathUnder(d, resolvedDir));
  trustedDirs.push(resolvedDir);
  saveWhitelist(trustedDirs);
  return true;
}

function extractPathsFromBash(command: string): string[] {
  const paths: string[] = [];

  // Match absolute paths, home-relative paths, and relative paths
  const patterns = [
    /(?:^|\s|["'])((?:\/|\~\/|\.\.\/|\.\/)[^\s"';|&<>]+)(?:\s|["';|&<>]|$)/g,
  ];

  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(command)) !== null) {
      paths.push(match[1]);
    }
  }

  return paths;
}

// Whitelisted bash commands that don't need path checking
const SAFE_COMMANDS = new Set([
  "ls", "pwd", "echo", "date", "whoami", "which", "uname", "hostname",
  "ps", "top", "free", "df", "uptime", "cat", "true", "false", "test",
  "head", "tail", "wc", "sort", "uniq", "tr", "cut", "awk", "sed",
]);

async function getTargetDirectory(path: string): Promise<string> {
  const resolved = resolve(path);
  try {
    const st = statSync(resolved);
    return st.isDirectory() ? resolved : dirname(resolved);
  } catch {
    return dirname(resolved);
  }
}

async function handleUntrustedPath(
  path: string,
  toolName: string,
  ctx: ExtensionContext
): Promise<"allow" | "whitelist" | "block"> {
  const displayPath = resolve(path);
  const relPath = relative(process.cwd(), displayPath);
  const display = relPath.startsWith("..") ? displayPath : relPath;

  const choice = await ctx.ui.select(
    `⚠️ Access outside trusted directories\n\n  Tool: ${toolName}\n  Path: ${display}\n\nAllow?`,
    ["Allow once", "Always allow this directory", "Block"]
  );

  if (choice === "Block") return "block";
  if (choice === "Always allow this directory") return "whitelist";
  return "allow";
}

// ---- Main Extension ----
export default function (pi: ExtensionAPI) {
  // Initialize trusted directories on load
  trustedDirs = [REPOS_DIR, ...loadWhitelist()];

  // Reload whitelist on session start (in case another session modified it)
  pi.on("session_start", async (_event, ctx) => {
    trustedDirs = [REPOS_DIR, ...loadWhitelist()];
    if (trustedDirs.length > 1) {
      const extra = trustedDirs.slice(1);
      ctx.ui.notify(
        `Directory permissions active: ~/repos + ${extra.length} whitelisted dir(s)`,
        "info"
      );
    } else {
      ctx.ui.notify("Directory permissions active: ~/repos only", "info");
    }
  });

  // Intercept filesystem tool calls
  pi.on("tool_call", async (event, ctx) => {
    const { toolName } = event;

    // ---- Direct file tools ----
    if (toolName === "read" || toolName === "write" || toolName === "edit") {
      const path = event.input.path as string;
      if (isTrusted(path)) return undefined;
      if (!ctx.hasUI) {
        return { block: true, reason: `Path outside trusted directories (no UI): ${path}` };
      }
      const result = await handleUntrustedPath(path, toolName, ctx);
      if (result === "block") return { block: true, reason: `Blocked by user: ${path}` };
      if (result === "whitelist") {
        const dir = await getTargetDirectory(path);
        addDirectory(dir);
        ctx.ui.notify(`Whitelisted: ${dir}`, "success");
      }
      return undefined;
    }

    // ---- Bash tool ----
    if (toolName === "bash") {
      const command = event.input.command as string;
      const cmdBase = command.trim().split(/[\s|;&]+/)[0]?.toLowerCase();

      // Skip harmless commands
      if (cmdBase && SAFE_COMMANDS.has(cmdBase)) return undefined;

      const paths = extractPathsFromBash(command);
      if (paths.length === 0) return undefined;

      // Check if any path is outside trusted dirs
      for (const p of paths) {
        if (isTrusted(p)) continue;
        if (!ctx.hasUI) {
          return { block: true, reason: `Path outside trusted directories (no UI): ${p}` };
        }
        const result = await handleUntrustedPath(p, `bash (${cmdBase || "?"})`, ctx);
        if (result === "block") return { block: true, reason: `Blocked by user: ${p}` };
        if (result === "whitelist") {
          const dir = await getTargetDirectory(p);
          addDirectory(dir);
          ctx.ui.notify(`Whitelisted: ${dir}`, "success");
        }
        return undefined; // Allow once
      }

      return undefined;
    }

    // ---- Other tools (grep, find, ls) — allow by default for now ----
    return undefined;
  });
}
