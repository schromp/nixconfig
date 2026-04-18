export def main [colorscheme: string] {
  let data = ($env.NIX_THEME_DATA | from json)
  print $"Switching to colorscheme: ($colorscheme)"

  print ($data | to json)
  $data | items {|program_name, program_info|
    print $"Configuring ($program_name)..."
    print $program_info
    let scheme_info = $program_info.colorschemes | get $colorscheme
    let out_path = $program_info.out
  }
}
