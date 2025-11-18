{
lib,
config,
pkgs,
...
}:
{
  options = {
    tmux.enable = lib.mkEnableOption "enables tmux";
  };

  config = lib.mkIf config.tmux.enable {
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
  };
}
