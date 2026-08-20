# Data access layer for colorscheme linkFarm
# Uses COLORSCHEMES_DATA_FILE env var set by the wrapper script

# Get all colorscheme data from file
def get-all-data [] {
    if ($env.COLORSCHEMES_DATA_FILE? | is-not-empty) {
        ^cat $env.COLORSCHEMES_DATA_FILE | from json
    } else {
        $env.COLORSCHEMES_DATA | from json
    }
}

# Get COLORSCHEMES_OUT path
export def get-colorschemes-out [] {
    $env.COLORSCHEMES_OUT
}

# Get the path to a specific colorscheme within a program's linkFarm
export def get-scheme-out [program: string, scheme: string] {
    let colors = (get-colorschemes-out)
    [$colors $program $scheme] | path join
}

# List all available programs (color scheme sources)
export def get-programs [] {
    let data = (get-all-data)
    $data | columns
}

# List all available colorschemes for a program
export def get-schemes [program: string] {
    let data = (get-all-data)
    ($data | get $program).colorschemes | columns
}

# Get colorscheme file structure (map of relative paths)
export def get-scheme-files [program: string, scheme: string] {
    let data = (get-all-data)
    ($data | get $program).colorschemes | get $scheme | get files
}

# Get program metadata (directory, activationScript, etc.)
export def get-program-meta [program: string] {
    let data = (get-all-data)
    $data | get $program
}

# List all files that would be installed for a colorscheme
export def get-scheme-file-paths [program: string, scheme: string] {
    let files = (get-scheme-files $program $scheme)
    $files | columns
}

# Check if a program exists
export def has-program [program: string] {
    let programs = (get-programs)
    $program in $programs
}

# Check if a colorscheme exists for a program
export def has-scheme [program: string, scheme: string] {
    let schemes = (get-schemes $program)
    $scheme in $schemes
}

# Print summary of all available programs and their colorschemes
export def list-all [] {
    let data = (get-all-data)
    let programs = ($data | columns)
    
    $programs | each {|program|
      let schemes = (get-schemes $program)
      {
        program: $program
        schemes: $schemes
      }
    }
}