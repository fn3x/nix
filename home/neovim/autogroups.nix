{
  programs.nixvim = {
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
      {
        event = "User";
        pattern = "VeryLazy";
        callback = {
          __raw = ''
            function()
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
            end
            '';
        };
      }
      {
        event = "BufWritePre";
        pattern = "*";
        callback.__raw = ''
          function(args)
            local bufnr = args.buf

            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if string.match(bufname, "/node_modules/") then
              return
            end

            require("conform").format({
              bufnr = bufnr,
              timeout_ms = 500,
              lsp_fallback = true,
              async = false,
            })
          end
          '';
      }
    ];
  };
}
