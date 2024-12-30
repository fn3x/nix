{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.home-manager = {
    enable = true;
  };

  home.username = "fn3x";
  home.homeDirectory = "/home/fn3x";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    inputs.hyprland-qtutils.packages.x86_64-linux.default
    inputs.ghostty.packages.x86_64-linux.default
    pkgs.fontconfig
    oh-my-posh
    zig
    go
    nodejs_23
    telegram-desktop
    vesktop
    mattermost-desktop
    spotify
    fd
    ripgrep
    tmux
    vlc
    btop
    gimp
    flameshot
    lazygit
  ];

  home.file = {
    ".local/share/fonts".source = ../../fonts;
  };

  fonts.fontconfig.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      vim_keys = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
  };

  home.shellAliases = {
    nix-s = "nh os switch ~/nixos/";
    nix-t = "nh os test ~/nixos/";
    nix-c = "nh clean all";
  };

  home.sessionPath = [
    "~/go/bin/"
    "/usr/local/go/bin"
    "~/.local/bin"
    "/bin"
    "/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/usr/local/bin"
    "/local/bin"
    "/lua-5.4.7"
    "~/local/lib"
    "OME/local/share/man"
    "~/perl5/bin"
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "~/local/lib:$LD_LIBRARY_PATH";
    MANPATH = "~/local/share/man:$MANPATH";
    COLORTERM = "truecolor";
    NVM_DIR = "~/.nvm";
  };

  programs.kitty.enable = true; # required for the default Hyprland config

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "ALT";
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind =
        [
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          "$mod, T, exec, $terminal"
          "$mod SHIFT, Q, killactive"
          "$mod, M, exit"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating"
          "$mod, P, pseudo, # dwindle"
          "$mod, J, togglesplit, # dwindle"
          "$mod, SPACE, exec, rofi -show drun -show-icons"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
    };
    extraConfig = ''
      ################
      ### MONITORS ###
      ################

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = DP-1, 2560x1440@170.00Hz, 0x0, 1

      ###################
      ### MY PROGRAMS ###
      ###################

      # Set programs that you use
      $terminal = ghostty
      $fileManager = dolphin

      #################
      ### AUTOSTART ###
      #################

      exec-once = dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
      exec-once = dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Red-Dark'"
      exec-once = dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'"
      exec-once = dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'"
      exec-once = dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'"
      exec-once = swww init
      exec-once = waybar
      exec-once = dunst
      exec-once = [workspace 1 silent] $terminal
      exec-once = [workspace 2 silent] firefox
      exec-once = [workspace 3 silent] telegram-desktop
      exec-once = [workspace 4 silent] mattermost-desktop
      exec-once = [workspace 5 silent] spotify

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hyprland.org/Configuring/Environment-variables/

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24
      env = GBM_BACKEND,nvidia-drm
      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = GDK_BACKEND,wayland,x11,*
      env = QT_QPA_PLATFORM,wayland;xcb
      env = SDL_VIDEODRIVER,wayland
      env = CLUTTER_BACKEND,wayland
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = GTK_THEME,Arc-Dark

      #####################
      ### LOOK AND FEEL ###
      #####################

      # https://wiki.hyprland.org/Configuring/Variables/#general

      general {
          gaps_in = 10
          gaps_out = 0

          border_size = 0

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = dwindle
      }

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration {
          rounding = 10

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0
          inactive_opacity = 1.0

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }
      }

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations {
          enabled = yes, please :)

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 2.5, easeOutQuint
          animation = windows, 1, 2.5, easeOutQuint
          animation = windowsIn, 1, 2.0, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.25, linear, popin 87%
          animation = fadeIn, 1, 1.5, almostLinear
          animation = fadeOut, 1, 1.2, almostLinear
          animation = fade, 1, 2.0, quick
          animation = layers, 1, 2.0, easeOutQuint
          animation = layersIn, 1, 2.0, easeOutQuint, fade
          animation = layersOut, 1, 1.25, linear, fade
          animation = fadeLayersIn, 1, 1.4, almostLinear
          animation = fadeLayersOut, 1, 1.2, almostLinear
          animation = workspaces, 1, 1.5, almostLinear, fade
          animation = workspacesIn, 1, 1.1, almostLinear, fade
          animation = workspacesOut, 1, 1.5, almostLinear, fade
      }

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc {
          force_default_wallpaper = 1
          disable_hyprland_logo = true
      }

      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input {
          kb_layout = us,ru
          kb_variant =
          kb_model = kinesis
          kb_options = grp:win_space_toggle
          kb_rules =

          follow_mouse = 1

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures {
          workspace_swipe = false
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # Ignore maximize requests from apps. You'll probably like this.
      windowrulev2 = suppressevent maximize, class:.*

      # Fix some dragging issues with XWayland
      windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

      workspace = 1,name:terminal,decorate:false,on-created-empty:ghostty
      workspace = 2,name:browser,decorate:false,on-created-empty:firefox
      workspace = 3,name:telegram,decorate:false,on-created-empty:telegram-desktop
      workspace = 4,name:mattermost,decorate:false,on-created-empty:mattermost-desktop
      workspace = 5,name:music,decorate:false,on-created-empty:spotify

      windowrulev2 = tile,maximize,workspace 1,class:com.mitchellh.ghostty,initialClass:(- com.mitchellh.ghostty)
      windowrulev2 = tile,maximize,workspace 2,class:firefox,initialClass:(- firefox)
      windowrulev2 = tile,maximize,workspace 3,class:org.telegram.desktop,initialClass:(- org.telegram.desktop)
      windowrulev2 = tile,maximize,workspace 4,class:Mattermost,initialClass:(- Mattermost)
      windowrulev2 = tile,maximize,workspace 5,class:spotify,initialClass:(- spotify)
    '';
  };

  programs.git = {
    enable = true;
    userName = "Art P.";
    userEmail = "fn3x@yandex.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      floating_window_scaling_factor = 0.9;
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    disableConfirmationPrompt = true;
    sensibleOnTop = true;
    terminal = "screen-256color";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-dir '~/.tmux/resurrect'
        '';
      }
    ];
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      set-option -g mouse on

      ## change mouse drag to be adequate
      unbind -Tcopy-mode MouseDragEnd1Pane

      setw -g pane-base-index 1

      bind p previous-window
      bind n next-window

      ## change the key to enter copy mode from `[` to `a`
      unbind [
      bind a copy-mode

      ## set keys for visual mode (v) and yank/copy (y)
      bind-key -Tcopy-mode-vi 'v' send -X begin-selection
      bind-key -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      set -g history-limit 10000

      bind j select-window -t 1
      bind k select-window -t 2
      bind "l" select-window -t 3
      bind ";" select-window -t 4

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # clock mode
      setw -g clock-mode-colour colour220

      # statusbar
      set -g status-justify left
      set -g status-style 'fg=colour220'
      set -g status-left '#{session_name} -> '
      set -g status-right '%Y-%m-%d %H:%M'
      set -g status-right-length 200
      set -g status-left-length 10
      setw -g window-status-current-style 'fg=colour0 bg=colour220 bold'
      setw -g window-status-current-format ' #I #W #F '
      setw -g window-status-style 'fg=colour220 dim'
      setw -g window-status-format ' #I #[fg=colour7]#W #[fg=colour220]#F '
      setw -g window-status-bell-style 'fg=colour2 bg=colour220 bold'

      # messages
      set -g message-style 'fg=colour2 bg=colour0 bold'
      # copy mode
      setw -g mode-style 'fg=colour178 bg=colour235 bold'
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-position top       # macOS / darwin style
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-features ",xterm-256color:RGB"
      setw -g mode-keys vi
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      # create new windows in the current path
      bind '"' split-window -c '#{pane_current_path}'
      bind % split-window -hc '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'

      # mouse wheel
      bind -n WheelUpPane if -Ft= "#{mouse_any_flag}" "send -M" "send Up"
      bind -n WheelDownPane if -Ft= "#{mouse_any_flag}" "send -M" "send Down"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "robbyrussell";
  };

  nix.settings.trusted-users = [ "fn3x" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "${config.home.homeDirectory}/nixos";
  };

  programs.nixvim = {
    enable = true;

    clipboard.providers.wl-copy.enable = true;

    globalOpts = {
      clipboard = "unnamedplus";

      number = true;
      relativenumber = true;

      autoindent = true;
      cindent = true;
      wrap = false;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      breakindent = true;
      updatetime = 100;

      guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,i:blinkwait500-blinkoff400-blinkon500-Cursor/lCursor";
      termguicolors = true;
      mouse = "";
      undofile = true;
      undodir = "${config.home.homeDirectory}/.undodir";
      hlsearch = false;
      incsearch = true;
      ignorecase = false;
      smartcase = true;

      scrolloff = 8;
      signcolumn = "yes";
      colorcolumn = "120";

      splitright = true;

      wildmenu = false;
      wildmode = "";

      fileencoding = "utf-8";
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      pumheight = 5;
      disable_autoformat = true;
      loaded_node_provider = 0;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Open parent directory";
        };
      }
      # Filetree
      {
        mode = "n";
        key = "<leader>fp";
        action = "<cmd>Oil<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Open parent directory";
        };
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Remove highlights of the last search";
        };
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options = {
          noremap = true;
          silent = true;
          desc = "Move line up by 1 line and format it";
        };
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options = {
          noremap = true;
          silent = true;
          desc = "Move line down by 1 line and format it";
        };
      }

      # Movement
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options = {
          noremap = true;
          silent = true;
          desc = "Scroll down and center";
        };
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options = {
          noremap = true;
          silent = true;
          desc = "Scroll up and center";
        };
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options = {
          noremap = true;
          silent = true;
          desc = "Next occurence and center";
        };
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options = {
          noremap = true;
          silent = true;
          desc = "Previous occurence and center";
        };
      }
      {
        mode = "x";
        key = "<leader>p";
        action = ''"_dP'';
        options = {
          noremap = true;
          silent = true;
          desc = "Replace without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>d";
        action = ''"_d'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>D";
        action = ''"_D'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete until EOL without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>c";
        action = ''"_c'';
        options = {
          noremap = true;
          silent = true;
          desc = "Change without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>C";
        action = ''"_C'';
        options = {
          noremap = true;
          silent = true;
          desc = "Change until EOL without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader><leader>";
        action = "<cmd>:w<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Save current buffer";
        };
      }
      # Snacks keymaps
      {
        mode = "n";
        key = "<leader>n";
        action.__raw = "function() Snacks.notifier.show_history() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Notification History";
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action.__raw = "function() Snacks.git.blame_line() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Git Blame Line";
        };
      }
      {
        mode = "n";
        key = "<leader>gf";
        action.__raw = "function() Snacks.lazygit.log_file() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Lazygit Current File History";
        };
      }
      {
        mode = "n";
        key = "<leader>gg";
        action.__raw = "function() Snacks.lazygit() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Lazygit";
        };
      }
      {
        mode = "n";
        key = "<leader>gl";
        action.__raw = "function() Snacks.lazygit.log() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Lazygit Log (cwd)";
        };
      }
      {
        mode = "n";
        key = "<leader>un";
        action.__raw = "function() Snacks.notifier.hide() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Dismiss All Notifications";
        };
      }
    ];

    autoGroups = {
      HighlightYank = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = "TextYankPost";
        group = "HighlightYank";
        pattern = "*";
        callback = {
          __raw = ''function()vim.highlight.on_yank({higroup = "IncSearch",timeout = 40,}) end'';
        };
      }
    ];

    plugins = {
      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          delete_to_trash = true;
          skip_confirm_for_simple_edits = true;
          buf_options = {
            bufhidden = "hide";
            buflisted = false;
          };
          view_options = {
            show_hidden = true;
          };
        };
      };

      lualine = {
        enable = true;
        autoLoad = true;
        settings = {
          extensions = [ "fzf" ];
        };
      };

      web-devicons = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      undotree = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      sandwich = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      dressing = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      comment = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      refactoring = {
        enable = true;
        settings = {
          lazyLoad = false;
        };
      };

      snacks = {
        enable = true;
        settings = {
          bigfile = {
            enabled = true;
            size = 1.5 * 1024 * 1024;
            notify = true;
          };
          notifier = {
            enabled = true;
            timeout = 2000;
          };
          quickfile = {
            enabled = true;
          };
          styles = {
            notification = {
              wo = {
                wrap = true;
              };
            };
          };
        };
        luaConfig.pre = ''
          vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                  -- Setup some globals for debugging (lazy-loaded)
                  _G.dd = function(...)
                    Snacks.debug.inspect(...);
                  end
                  _G.bt = function()
                    Snacks.debug.backtrace();
                  end
                  vim.print = _G.dd -- Override print to use snacks for `:=` command

                  -- Create some toggle mappings
                  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw");
                  Snacks.toggle.diagnostics():map("<leader>ud");
                end,
              });

              local progress = vim.defaulttable();
              vim.api.nvim_create_autocmd("LspProgress", {
                callback = function(ev)
                  local client = vim.lsp.get_client_by_id(ev.data.client_id);
                  local value = ev.data.params
                      .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
                  if not client or type(value) ~= "table" then
                    return
                  end
                  local p = progress[client.id];

                  for i = 1, #p + 1 do
                    if i == #p + 1 or p[i].token == ev.data.params.token then
                      p[i] = {
                        token = ev.data.params.token,
                        msg = ("[%3d%%] %s%s"):format(
                          value.kind == "end" and 100 or value.percentage or 100,
                          value.title or "",
                          value.message and (" **%s**"):format(value.message) or ""
                        ),
                        done = value.kind == "end",
                      };
                      break
                    end
                  end

                  progress[client.id] = vim.tbl_filter(function(v)
                    return table.insert(msg, v.msg) or not v.done
                  end, p);

                  local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" };
                  vim.notify(table.concat(msg, "\n"), "info", {
                    id = "lsp_progress",
                    title = client.name,
                    opts = function(notif)
                      notif.icon = #progress[client.id] == 0 and " "
                          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                    end,
                  });
                end,
              })'';
      };

      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "javascript"
            "typescript"
            "lua"
            "go"
            "zig"
            "html"
          ];
          auto_install = true;
          sync_install = false;
          highlight = {
            additional_vim_regex_highlighting = false;
            custom_captures = { };
            disable = [ ];
            enable = true;
          };
          ignore_install = [ ];
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = false;
              node_decremental = "grm";
              node_incremental = "grn";
              scope_incremental = "grc";
            };
          };
          indent = {
            enable = true;
          };
          parser_install_dir = {
            __raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'treesitter')";
          };
        };
      };

      treesitter-context = {
        settings = {
          enable = true;
        };
      };

      treesitter-textobjects = {
        enable = true;
        move = {
          enable = true;
          setJumps = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "gj" = "@function.outer";
            "]]" = "@class.outer";
            "]b" = "@block.outer";
            "]a" = "@parameter.inner";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "gJ" = "@function.outer";
            "][" = "@class.outer";
            "]B" = "@block.outer";
            "]A" = "@parameter.inner";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "gk" = "@function.outer";
            "[[" = "@class.outer";
            "[b" = "@block.outer";
            "[a" = "@parameter.inner";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "gK" = "@function.outer";
            "[]" = "@class.outer";
            "[B" = "@block.outer";
            "[A" = "@parameter.inner";
          };
        };
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ab" = "@block.outer";
            "ib" = "@block.inner";
            "al" = "@loop.outer";
            "il" = "@loop.inner";
            "a/" = "@comment.outer";
            "i/" = "@comment.outer";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
          };
        };
      };

      telescope = {
        enable = true;
        settings = {
          defaults = {
            layout_strategy = "horizontal";
          };
        };
        extensions = {
          fzf-native.enable = true;
        };
        keymaps = {
          "<leader>fb" = {
            action = "buffers";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>ps" = {
            action = "live_grep";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>fz" = {
            action = "find_files";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<C-s>" = {
            action = "grep_string";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>fd" = {
            action = "diagnostics";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>;" = {
            action = "resume";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          on_attach = ''
              function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map("n", "]c", function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  gs.next_hunk()
                end)
                return "<Ignore>"
              end, { expr = true })

              map("n", "[c", function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  gs.prev_hunk()
                end)
                return "<Ignore>"
              end, { expr = true })

              -- Actions
              map("n", "<leader>hs", gs.stage_hunk)
              map("n", "<leader>hr", gs.reset_hunk)
              map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end)
              map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end)
              map("n", "<leader>hS", gs.stage_buffer)
              map("n", "<leader>hu", gs.undo_stage_hunk)
              map("n", "<leader>hR", gs.reset_buffer)
              map("n", "<leader>hp", gs.preview_hunk)
              map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
              end)
              map("n", "<leader>tb", gs.toggle_current_line_blame)
              map("n", "<leader>hd", gs.diffthis)
              map("n", "<leader>hD", function()
                gs.diffthis("~")
              end)
              map("n", "<leader>td", gs.toggle_deleted)

              -- Text object
              map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end
          '';
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          default_format_opts = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            lua = [ "stylua" ];
            go = [ "gofumpt" ];
            sql = [ "sql-formatter" ];
            javascript = [
              "prettierd"
              "prettier"
            ];
            html = [
              "prettierd"
              "prettier"
            ];
            typescript = [
              "prettierd"
              "prettier"
            ];
            nix = [ "nixfmt-rfc-style" ];
          };
          formatters = {
            stylua = {
              command = lib.getExe pkgs.stylua;
            };
            prettierd = {
              command = lib.getExe pkgs.prettierd;
            };
            prettier = {
              command = lib.getExe pkgs.nodePackages_latest.prettier;
            };
            gofumpt = {
              command = lib.getExe pkgs.gofumpt;
            };
            nixfmt-rfc-style = {
              command = lib.getExe pkgs.nixfmt-rfc-style;
            };
          };
        };
      };

      luasnip = {
        enable = true;
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };
    };

    extraPlugins = [ pkgs.vimPlugins.gruvbox-material-nvim ];
    extraConfigLua = ''
      require("gruvbox-material").setup();
      vim.g.gruvbox_material_background = "medium";
      vim.g.gruvbox_material_better_performance = 1;
      vim.g.gruvbox_material_enable_bold = 0;
      vim.g.gruvbox_material_menu_selection_background = "aqua";
      vim.g.gruvbox_material_visual = "blue background";
      vim.g.gruvbox_material_foreground = "material";
      vim.g.gruvbox_material_float_style = "bright";
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored";
      vim.cmd.colorscheme("gruvbox-material");
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#b8fcec", bold = false });
      vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true });
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#fcd6a9", bold = false });'';
  };
}
