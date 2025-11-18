{
lib,
pkgs,
...
}:
{
  programs.nixvim = {
    plugins = {
      harpoon = {
        enable = true;
        settings = {
          settings = {
            save_on_toggle = true;
            sync_on_ui_close = true;
          };
        };
      };

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
          lazygit = {
            configure = true;
          };
        };
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
        settings = {
          move = {
            enable = true;
            set_jumps = true;
            goto_next_start = {
              "]m" = "@function.outer";
              "gj" = "@function.outer";
              "]]" = "@class.outer";
              "]b" = "@block.outer";
              "]a" = "@parameter.inner";
            };
            goto_next_end = {
              "]M" = "@function.outer";
              "gJ" = "@function.outer";
              "][" = "@class.outer";
              "]B" = "@block.outer";
              "]A" = "@parameter.inner";
            };
            goto_previous_start = {
              "[m" = "@function.outer";
              "gk" = "@function.outer";
              "[[" = "@class.outer";
              "[b" = "@block.outer";
              "[a" = "@parameter.inner";
            };
            goto_previous_end = {
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
          "<leader>ds" = {
            action = "lsp_document_symbols";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
        };
      };

      treesj = {
        enable = true;
      };

      gitsigns = {
        enable = true;
        settings = {
          on_attach.__raw = ''
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
            cpp = [ "clang-format" ];
            c = [ "clang-format" ];
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

      cmp = {
        enable = true;
      };

      lspkind = {
        enable = true;
      };

      blink-cmp = {
        enable = true;
        settings = {
          snippets = { preset = "luasnip"; };
          sources = {
            default = [ "lsp" "path" "snippets" "buffer" ];
          };
          completion = {
            ghost_text.enabled = false;
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 300;
            };
            menu = {
              auto_show = true;
              draw = {
                columns.__raw = ''{
                  { "label", "label_description", gap = 1 },
                  { "kind_icon", gap = 1, "kind" }
                }'';
                components = {
                  kind_icon = {
                    text.__raw = ''
                      function(ctx)
                        local lspkind = require("lspkind")
                        local icon = ctx.kind_icon
                        if vim.tbl_contains({ "Path" }, ctx.source_name) then
                          local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                          if dev_icon then
                            icon = dev_icon
                          end
                        else
                          icon = require("lspkind").symbolic(ctx.kind, {
                            mode = "symbol",
                          })
                        end

                        return icon .. ctx.icon_gap
                      end
                      '';
                    highlight.__raw = ''
                      function(ctx)
                        local hl = ctx.kind_hl
                        if vim.tbl_contains({ "Path" }, ctx.source_name) then
                          local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                          if dev_icon then
                            hl = dev_hl
                          end
                        end
                        return hl
                      end
                      '';
                  };
                };
              };
            };
          };
          keymap = {
            "<C-space>" = [
              "select_and_accept"
            ];
            "<C-y>" = [
              "show"
              "show_documentation"
              "hide_documentation"
            ];
          };
        };
      };

      lsp = {
        enable = true;
        inlayHints = false;
        keymaps = {
          silent = true;
          lspBuf = {
            "<leader>ca" = "code_action";
            "gd" = "definition";
            "gD" = "declaration";
          };
          extra = [
            {
              key = "<leader>ff";
              mode = "n";
              action.__raw = "function() vim.lsp.buf.format({ async = false, timeout_ms = 1000 }) end";
            }
          ];
        };
        servers = {
          html = {
            enable = true;
          };
          lua_ls = {
            enable = true;
          };
          nixd = {
            enable = true;
          };
          gopls = {
            enable = true;
            settings = {
              gofumpt = true;
            };
          };
          clangd = {
            enable = true;
            filetypes = [ "c" "cpp" ];
          };
          ts_ls = {
            enable = true;
            filetypes = [
              "typescript"
              "javascript"
              "typescriptreact"
              "javascriptreact"
            ];
            settings = {
              preferences = {
                quotePreference = "double";
              };
            };
          };
          tailwindcss = {
            enable = true;
            filetypes = [ "go" ];
            settings = {
              tailwindCSS = {
                includeLanguages = {
                  go = "html";
                };
                experimental = {
                  classRegex = [
                    [
                      "Class\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                    [
                      "ClassX\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                    [
                      "ClassIf\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                    [
                      "Classes\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                  ];
                };
              };
            };
          };
          ols = {
            enable = true;
          };
          zls = {
            enable = true;
          };
          protols = {
            enable = true;
          };
        };
      };
    };
  };
}
