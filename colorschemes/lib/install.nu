# Installation logic for colorschemes
# Handles symlinking files from linkFarm to XDG config directories

use data

# Get XDG_CONFIG_HOME, defaulting to ~/.config
export def get-xdg-config [] {
    let xdg = (try { $env.XDG_CONFIG_HOME } catch { null })
    if ($xdg | is-not-empty) {
        $xdg
    } else {
        [$env.HOME, ".config"] | path join
    }
}

# Get base directory for a program's colorscheme files
# Some programs use XDG_CONFIG_HOME (~/.config), others use ~/.local/share
export def get-base-dir [program: string] {
    let meta = (data get-program-meta $program)
    let custom = (try { $meta.baseDir } catch { null })
    if ($custom | is-not-empty) {
        # Expand ~ to HOME (nushell doesn't do this automatically)
        if ($custom | str starts-with "~") {
            let rest = ($custom | str substring 1..)
            if ($rest | is-empty) {
                $env.HOME
            } else {
                # Direct concatenation to avoid path join issues
                let prefix = if ($env.HOME | str ends-with "/") { $env.HOME } else { $env.HOME + "/" }
                $prefix + $rest
            }
        } else {
            $custom
        }
    } else {
        get-xdg-config
    }
}

# Resolve the target path for a program's colorscheme file
export def get-target-path [program: string, file: string] {
    let base = (get-base-dir $program)
    let meta = (data get-program-meta $program)
    [$base $meta.directory $file] | path join
}

# Resolve the source path for a scheme's file
export def get-source-path [program: string, scheme: string, file: string] {
    let scheme_out = (data get-scheme-out $program $scheme)
    [$scheme_out $file] | path join
}

# Check if a target file/dir already exists
export def target-exists [target: path] {
    try {
        let type = ($target | path type)
        not ($type | is-empty)
    } catch {
        false
    }
}

# Backup an existing file before overwriting
export def backup-target [target: path] {
    if (target-exists $target) {
        let backup = $"($target).bak"
        print $"  backing up existing ($target) → ($backup)"
        ^mv $target $backup
    }
}

# Create parent directories for a path if they don't exist
export def ensure-parent-dir [file: path] {
    let parent = ($file | path parse | get parent)
    if not ($parent | path type | is-empty) {
        ^mkdir -p $parent
    }
}

# Symlink a single file from source to target
# Options:
#   --backup: create .bak if target exists
#   --force: overwrite existing without backup
export def symlink-file [source: path, target: path, --backup = false, --force = false] {
    if (target-exists $target) and $force {
        ^rm -rf $target
    } else if (target-exists $target) and $backup {
        backup-target $target
    } else if (target-exists $target) {
        error make {
            msg: "target-exists"
            label: {
                text: $"target already exists: ($target). Use --backup or --force"
                span: (metadata $target).span
            }
        }
    }

    ensure-parent-dir $target
    ^ln -s $source $target
}

# Install a complete colorscheme (all files)
# Options:
#   --backup: backup existing files before overwriting
#   --force: overwrite without backup
#   --dry-run: show what would be done without doing it
export def install-scheme [program: string, scheme: string, --backup = false, --force = false, --dry-run = false] {
    let files = (data get-scheme-file-paths $program $scheme)
    let count = ($files | length)

    if $dry_run {
        print $"[dry-run] would install ($count) files for ($program)/($scheme):"
    } else {
        print $"installing ($count) files for ($program)/($scheme):"
    }

    for file in $files {
        let source = (get-source-path $program $scheme $file)
        let target = (get-target-path $program $file)

        if $dry_run {
            print $"  ($target) ← ($source)"
        } else {
        if $force {
            symlink-file $source $target --force true
        } else if $backup {
            symlink-file $source $target --backup true
        } else {
            symlink-file $source $target
        }
            print $"  linked: ($file)"
        }
    }

    print $"done!"
}

# List what files would be installed (for verification)
export def preview-scheme [program: string, scheme: string] {
    let files = (data get-scheme-file-paths $program $scheme)

    print $"files for ($program)/($scheme):"
    for file in $files {
        let source = (get-source-path $program $scheme $file)
        let target = (get-target-path $program $file)
        print $"  ($target)"
        print $"    source: ($source)"
    }
}