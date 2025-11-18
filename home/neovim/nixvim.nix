{
config,
lib,
inputs,
...
}:
{
  options = {
    neovim.enable = lib.mkEnableOption "enables neovim";
  };

  imports = [
    ./options.nix
    ./colorscheme.nix
    ./autogroups.nix
    ./globals.nix
    ./keymaps.nix
    ./plugins.nix
  ];

  config = lib.mkIf config.neovim.enable {
    programs.nixvim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.x86_64-linux.neovim;

      clipboard.providers.wl-copy.enable = true;

      highlightOverride = {
        Pmenu = {
          bg = "none";
        };
      };

      extraConfigLua = ''
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#b8fcec", bold = false });
      vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true });
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#fcd6a9", bold = false });

      vim.o.background = "dark"

      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

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
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
              or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        silent = true,
      })

      vim.o.winborder = "rounded"
      '';
    };
  };
}
