{
  programs.nixvim = {
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
      {
        mode = "n";
        key = "<leader>a";
        action.__raw = "function() require('harpoon'):list():add() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Add file to harpoon list";
        };
      }
      {
        mode = "n";
        key = "<C-e>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon.ui:toggle_quick_menu(harpoon:list()) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Toggle quick menu";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(1) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select first item from the list";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(2) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select second item from the list";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(3) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select third item from the list";
        };
      }
      {
        mode = "n";
        key = "<C-;>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(4) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select fourth item from the list";
        };
      }
    ];
  };
}
