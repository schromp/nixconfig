#!/usr/bin/env nu
# Colorscheme switcher CLI
# Usage:
#   cs.nu install <program> <colorscheme>  - Install and activate a colorscheme
#   cs.nu list <program>                  - List available colorschemes
#   cs.nu list-all                         - List all programs and colorschemes
#   cs.nu current <program>               - Show current colorscheme
#   cs.nu                                  - Show this help

use ./lib/data.nu
use ./lib/install.nu

# Save current selection to a tracking file
def save-current [program: string, scheme: string] {
    let dir = ([$env.HOME, ".config", "colorschemes"] | path join)
    let file = ([$dir, "current.json"] | path join)
    ^mkdir -p $dir
    
    # Try to read existing file
    let current = (try { ^cat $file | from json } catch { {} })
    
    let updated = ($current | upsert $program $scheme)
    $updated | to json | save --force $file
}

# Run the activation script for a program
# Accepts optional scheme name for substitution in activation command
def activate-cmd [program: string, scheme?: string] {
    let meta = (data get-program-meta $program)
    
    if ($meta.activationScript | is-not-empty) {
        let cmd = (if ($scheme | is-not-empty) {
            # Replace common placeholder patterns
            $meta.activationScript
            | str replace --all "<scheme>" $scheme
            | str replace --all "<theme>" $scheme
            | str replace --all "<name>" $scheme
            | str replace --all "<themeId>" $scheme
            | str replace --all "<id>" $scheme
        } else {
            $meta.activationScript
        })
        print $"running activation: ($cmd)"
        # If command doesn't contain a path separator, search in COLORSCHEMES_OUT/bin
        if not ($cmd | str contains "/") {
            # Check if the binary name (before first space) exists in PATH
            let binName = ($cmd | split row " " | get 0)
            if not ($binName | str contains "/") {
                # First check if command exists in PATH
                let existsInPath = (try { ^which $binName out+err> /dev/null; true } catch { false })
                if $existsInPath {
                    ^bash -c $cmd
                } else {
                    # Fall back to COLORSCHEMES_BIN
                    let fullCmd = [($env.COLORSCHEMES_BIN) $binName] | path join
                    ^bash -c $fullCmd
                }
            } else {
                ^bash -c $cmd
            }
        } else {
            ^bash -c $cmd
        }
    }
}

# Install command
export def do-install [program: string, scheme: string] {
    if not (data has-program $program) {
        print $"error: unknown program '($program)'"
        return
    }
    
    if not (data has-scheme $program $scheme) {
        print $"error: unknown colorscheme '($scheme)' for '($program)'"
        return
    }
    
    print $"switching ($program) → ($scheme)"
    install install-scheme $program $scheme --force true
    save-current $program $scheme
    activate-cmd $program $scheme
    
    print $"($program) is now using ($scheme)"
}

# List command
export def do-list [program: string] {
    let schemes = (data get-schemes $program)
    for scheme in $schemes {
        print $"  ($scheme)"
    }
}

# List-all command
export def do-list-all [] {
    let all = (data list-all)
    for item in $all {
        print $"($item.program):"
        for s in $item.schemes {
            print $"  ($s)"
        }
    }
}

# Apply command - install same scheme to all programs that have it
export def do-apply [scheme: string] {
    let all = (data list-all)
    let programs = ($all | where {|item| $scheme in $item.schemes })
    
    if ($programs | is-empty) {
        print $"error: no programs have colorscheme '($scheme)'"
        return
    }
    
    print $"applying ($scheme) to ($programs | length) programs:"
    
    for item in $programs {
        print $"  → ($item.program)"
        do-install $item.program $scheme
    }
}

# Current command
export def do-current [program: string] {
    let file = ([$env.HOME, ".config", "colorschemes", "current.json"] | path join)
    
    # Try to read the file, use empty object if missing
    let content = (try { ^cat $file | from json } catch { {} })
    let sel = ($content | get --optional $program | default null)
    
    if ($sel | is-not-empty) {
        print $sel
    } else {
        print "no colorscheme selected"
    }
}

# Show usage
def show-usage [] {
    print "Usage:"
    print "  cs.nu install <program> <colorscheme>    Install and activate"
    print "  cs.nu list <program>                    List colorschemes"
    print "  cs.nu list-all                          List all programs"
    print "  cs.nu current <program>                Show current"
    print "  cs.nu apply <colorscheme>              Apply to all programs"
}

# Main entry point - accepts command as first arg, then optional args
export def main [cmd?: string, arg1?: string, arg2?: string] {
    match $cmd {
        null => { show-usage }
        "install" => {
            if ($arg1 | is-empty) or ($arg2 | is-empty) {
                print "error: install requires <program> <colorscheme>"
            } else {
                do-install $arg1 $arg2
            }
        }
        "list" => {
            if ($arg1 | is-empty) {
                print "error: list requires <program>"
            } else {
                do-list $arg1
            }
        }
        "list-all" => {
            do-list-all
        }
        "apply" => {
            if ($arg1 | is-empty) {
                print "error: apply requires <colorscheme>"
            } else {
                do-apply $arg1
            }
        }
        "current" => {
            if ($arg1 | is-empty) {
                print "error: current requires <program>"
            } else {
                do-current $arg1
            }
        }
        _ => {
            print $"error: unknown command '($cmd)'"
            show-usage
        }
    }
}