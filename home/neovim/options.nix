{
  config,
  ...
}:
{
  programs.nixvim = {
      opts = {
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
        mouse = "";
        undofile = true;
        undodir = "${config.home.homeDirectory}/.undodir";
        hlsearch = false;
        incsearch = true;
        ignorecase = true;
        smartcase = true;

        scrolloff = 8;
        signcolumn = "yes";
        colorcolumn = "120";

        splitright = true;

        wildmenu = false;
        wildmode = "";

        fileencoding = "utf-8";
      };
  };
}
