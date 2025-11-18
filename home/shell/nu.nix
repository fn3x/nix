{
lib,
config,
...
}:
let
  username = "fn3x";
  nushell-theme = "${config.xdg.configHome}/nushell/gruvbox-dark.nu";
in
{
  options = {
    nu.enable = lib.mkEnableOption "enables nu";
  };

  config = lib.mkIf config.nu.enable {
    home.file."${nushell-theme}" = {
      text = ''
        # Retrieve the theme settings
        export def main [] {
            return {
                binary: '#b16286'
                block: '#458588'
                cell-path: '#a89984'
                closure: '#689d6a'
                custom: '#ebdbb2'
                duration: '#d79921'
                float: '#fb4934'
                glob: '#ebdbb2'
                int: '#b16286'
                list: '#689d6a'
                nothing: '#cc241d'
                range: '#d79921'
                record: '#689d6a'
                string: '#98971a'

                bool: {|| if $in { '#8ec07c' } else { '#d79921' } }

                datetime: {|| (date now) - $in |
                    if $in < 1hr {
                        { fg: '#cc241d' attr: 'b' }
                    } else if $in < 6hr {
                        '#cc241d'
                    } else if $in < 1day {
                        '#d79921'
                    } else if $in < 3day {
                        '#98971a'
                    } else if $in < 1wk {
                        { fg: '#98971a' attr: 'b' }
                    } else if $in < 6wk {
                        '#689d6a'
                    } else if $in < 52wk {
                        '#458588'
                    } else { 'dark_gray' }
                }

                filesize: {|e|
                    if $e == 0b {
                        '#a89984'
                    } else if $e < 1mb {
                        '#689d6a'
                    } else {{ fg: '#458588' }}
                }

                shape_and: { fg: '#b16286' attr: 'b' }
                shape_binary: { fg: '#b16286' attr: 'b' }
                shape_block: { fg: '#458588' attr: 'b' }
                shape_bool: '#8ec07c'
                shape_closure: { fg: '#689d6a' attr: 'b' }
                shape_custom: '#98971a'
                shape_datetime: { fg: '#689d6a' attr: 'b' }
                shape_directory: '#689d6a'
                shape_external: '#689d6a'
                shape_external_resolved: '#8ec07c'
                shape_externalarg: { fg: '#98971a' attr: 'b' }
                shape_filepath: '#689d6a'
                shape_flag: { fg: '#458588' attr: 'b' }
                shape_float: { fg: '#fb4934' attr: 'b' }
                shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
                shape_glob_interpolation: { fg: '#689d6a' attr: 'b' }
                shape_globpattern: { fg: '#689d6a' attr: 'b' }
                shape_int: { fg: '#b16286' attr: 'b' }
                shape_internalcall: { fg: '#689d6a' attr: 'b' }
                shape_keyword: { fg: '#b16286' attr: 'b' }
                shape_list: { fg: '#689d6a' attr: 'b' }
                shape_literal: '#458588'
                shape_match_pattern: '#98971a'
                shape_matching_brackets: { attr: 'u' }
                shape_nothing: '#cc241d'
                shape_operator: '#d79921'
                shape_or: { fg: '#b16286' attr: 'b' }
                shape_pipe: { fg: '#b16286' attr: 'b' }
                shape_range: { fg: '#d79921' attr: 'b' }
                shape_raw_string: { fg: '#ebdbb2' attr: 'b' }
                shape_record: { fg: '#689d6a' attr: 'b' }
                shape_redirection: { fg: '#b16286' attr: 'b' }
                shape_signature: { fg: '#98971a' attr: 'b' }
                shape_string: '#98971a'
                shape_string_interpolation: { fg: '#689d6a' attr: 'b' }
                shape_table: { fg: '#458588' attr: 'b' }
                shape_vardecl: { fg: '#458588' attr: 'u' }
                shape_variable: '#b16286'

                foreground: '#ebdbb2'
                background: '#282828'
                cursor: '#ebdbb2'

                empty: '#458588'
                header: { fg: '#98971a' attr: 'b' }
                hints: '#928374'
                leading_trailing_space_bg: { attr: 'n' }
                row_index: { fg: '#98971a' attr: 'b' }
                search_result: { fg: '#cc241d' bg: '#a89984' }
                separator: '#a89984'
            }
        }

        # Update the Nushell configuration
        export def --env "set color_config" [] {
            $env.config.color_config = (main)
        }

        # Update terminal colors
        export def "update terminal" [] {
            let theme = (main)

            # Set terminal colors
            let osc_screen_foreground_color = '10;'
            let osc_screen_background_color = '11;'
            let osc_cursor_color = '12;'
                
            $"
            (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
            (ansi -o $osc_screen_background_color)($theme.background)(char bel)
            (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
            "
            # Line breaks above are just for source readability
            # but create extra whitespace when activating. Collapse
            # to one line and print with no-newline
            | str replace --all "\n" '''
            | print -n $"($in)\r"
        }

        export module activate {
            export-env {
                set color_config
                update terminal
            }
        }

        # Activate the theme when sourced
        use activate
      '';
    };

    programs.nushell = {
      enable = true;
      settings = {
        buffer_editor = "nvim";
        show_banner = false;
      };
      envFile.text = ''
      do --env {
        let ssh_agent_file = ($nu.temp-path | path join $"ssh-agent-${username}.nuon")

        if ($ssh_agent_file | path exists) {
          let ssh_agent_env = open ($ssh_agent_file)
          if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) and ($ssh_agent_env.SSH_AUTH_SOCK | path exists) {
            load-env $ssh_agent_env
            return
          } else {
            rm $ssh_agent_file
          }
        }

        # Start new agent
        let ssh_agent_env = ^ssh-agent -c 
          | lines 
          | first 2 
          | parse "setenv {name} {value};" 
          | transpose --header-row 
          | into record

        load-env $ssh_agent_env
        $ssh_agent_env | save --force $ssh_agent_file
        ^ssh-add ~/.ssh/id_github ~/.ssh/id_bitbucket ~/.ssh/id_codeberg
      }
      '';
      configFile.text = ''
      source ${nushell-theme}
      $env.config = {
        hooks: {
          pre_prompt: [{ ||
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
            if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
              $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
            }
          }]
        }
      }
      '';
    };

    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        format = lib.concatStrings [
          "[](color_orange)"
          "$username"
          "[](bg:color_yellow fg:color_orange)"
          "$directory"
          "[](bg:color_yellow fg:color_orange)"
          "$git_branch"
          "$git_status"
          "[](fg:color_aqua bg:color_blue)"
          "$c"
          "$cpp"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$python"
          "[](fg:color_blue bg:color_bg3)"
          "$docker_context"
          "$conda"
          "$pixi"
          "[](fg:color_bg3 bg:color_bg1)"
          "$time"
          "[ ](fg:color_bg1)"
          "$line_break$character"
        ];
        palette = "gruvbox_dark";
        palettes.gruvbox_dark = {
          color_fg0 = "#fbf1c7";
          color_bg1 = "#3c3836";
          color_bg3 = "#665c54";
          color_blue = "#458588";
          color_aqua = "#689d6a";
          color_green = "#98971a";
          color_orange = "#d65d0e";
          color_purple = "#b16286";
          color_red = "#cc241d";
          color_yellow = "#d79921";
        };
        os = {
          disabled = false;
          style = "bg:color_orange fg:color_fg0";
          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            EndeavourOS = "";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
            Pop = "";
            NixOS = " ";
          };
        };
        username = {
          show_always = true;
          style_user = "bg:color_orange fg:color_fg0";
          style_root = "bg:color_orange fg:color_fg0";
          format = "[ $user ]($style)";
        };
        directory = {
          style = "fg:color_fg0 bg:color_yellow";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music"     = "󰝚 ";
            "Pictures"  = " ";
            "Developer" = "󰲋 ";
          };
        };
        git_branch = {
          symbol = "";
          style = "bg:color_aqua";
          format = ''[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)'';
        };
        git_status = {
          style = "bg:color_aqua";
          format = ''[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)'';
        };
        nodejs = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        c = {
          symbol = " ";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        cpp = {
          symbol = " ";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        rust = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        golang = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        php = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        java = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        kotlin = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        haskell = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        python = {
          symbol = "";
          style = "bg:color_blue";
          format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
        };
        docker_context = {
          symbol = "";
          style = "bg:color_bg3";
          format = ''[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'';
        };
        conda = {
          style = "bg:color_bg3";
          format = ''[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'';
        };
        pixi = {
          style = "bg:color_bg3";
          format = ''[[ $symbol( $version)( $environment) ](fg:color_fg0 bg:color_bg3)]($style)'';
        };
        time = {
          disabled = false;
          style = "bg:color_bg1";
          format = ''[[  $time ](fg:color_fg0 bg:color_bg1)]($style)'';
        };
        line_break = {
          disabled = false;
        };
        character = {
          disabled = false;
          success_symbol = "[](bold fg:color_green)";
          error_symbol = "[](bold fg:color_red)";
          vimcmd_symbol = "[](bold fg:color_green)";
          vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
          vimcmd_replace_symbol = "[](bold fg:color_purple)";
          vimcmd_visual_symbol = "[](bold fg:color_yellow)";
        };
      };
    };
  };
}
