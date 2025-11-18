{
  programs.nixvim = {
    colorschemes.gruvbox = {
      enable = true;
      autoLoad = true;
      settings = {
        italic = {
          strings = false;
          emphasis = false;
          comments = true;
          operators = false;
          folds = false;
        };
        transparent_mode = true;
        invert_selection = false;
      };
    };
  };
}
