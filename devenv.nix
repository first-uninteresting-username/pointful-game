{pkgs, ...}: let
  godot = pkgs.godot;
  templates = pkgs.godot-export-templates-bin;
  # e.g. "4.7.2.stable" — the directory name Godot looks for
  templatesVersion = builtins.replaceStrings ["-"] ["."] godot.version;

  # Editor plugins that must always be enabled in project.godot
  requiredPlugins = ["res://addons/godot_super-wakatime/plugin.cfg"];

  # Adds any missing requiredPlugins to [editor_plugins] enabled=PackedStringArray(...)
  enablePlugins = pkgs.writeText "enable-plugins.py" ''
    import re, sys

    path, plugins = sys.argv[1], sys.argv[2:]
    text = open(path).read()
    missing = [p for p in plugins if f'"{p}"' not in text]
    if not missing:
        sys.exit()

    entries = ", ".join(f'"{p}"' for p in missing)
    line = re.search(r"^enabled=PackedStringArray\((.*)\)$", text, re.M)
    if "[editor_plugins]" in text and line:
        current = line.group(1).strip()
        new = f"{current}, {entries}" if current else entries
        text = text[: line.start()] + f"enabled=PackedStringArray({new})" + text[line.end() :]
    else:
        text = text.rstrip("\n") + f"\n\n[editor_plugins]\n\nenabled=PackedStringArray({entries})\n"
    open(path, "w").write(text)
    print("enabled editor plugins:", ", ".join(missing))
  '';
in {
  packages = [
    godot
    pkgs.gdtoolkit_4 # gdformat, gdlint
    pkgs.python3 # local web server
  ];

  # Godot only looks for export templates under $XDG_DATA_HOME, so link the
  # nix-provided ones there (skipped if that version is already installed).
  enterShell = ''
    tpl_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/godot/export_templates"
    if [ ! -e "$tpl_dir/${templatesVersion}" ]; then
      mkdir -p "$tpl_dir"
      ln -s "${templates}/share/godot/export_templates/${templatesVersion}" "$tpl_dir/${templatesVersion}"
    fi
    echo "godot $(godot --version)"
  '';

  scripts = let
    # Project scripts only: skips vendored addons and generated directories.
    findGd = "find \"$DEVENV_ROOT\" \\( -name addons -o -name .godot -o -name .devenv \\) -prune -o -name '*.gd'";
  in {
    editor.exec = ''
      python3 ${enablePlugins} "$DEVENV_ROOT/project.godot" ${pkgs.lib.escapeShellArgs requiredPlugins}
      godot --editor --path "$DEVENV_ROOT" "$@"
    '';
    export-web.exec = ''
      mkdir -p "$DEVENV_ROOT/build/web"
      godot --headless --path "$DEVENV_ROOT" --export-release Web "$DEVENV_ROOT/build/web/index.html"
    '';
    serve-web.exec = "python3 -m http.server --directory \"$DEVENV_ROOT/build/web\" \"\${1:-8060}\"";
    lint.exec = "${findGd} -exec gdlint {} + && ${findGd} -exec gdformat --check {} +";
    fmt.exec = "${findGd} -exec gdformat {} +";
  };

  git-hooks.hooks = {
    check-added-large-files.enable = true;
    check-merge-conflicts.enable = true;
    detect-private-keys.enable = true;
    end-of-file-fixer = {
      enable = true;
      excludes = ["devenv.lock"];
    };
    trim-trailing-whitespace.enable = true;
    check-json.enable = true;
    check-yaml.enable = true;
    alejandra.enable = true;
  };
}
