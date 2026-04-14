def main [colorscheme: string] {
  let data = ($env.NIX_THEME_DATA | from json)
  print $"Switching to colorscheme: $colorscheme"

  $data | items {|program_name, program_info|
    print $"Configuring ($program_name)..."

    let scheme_info = program_info.colorschemes | get $colorscheme
    let out_path = scheme_info.out

  }
}
