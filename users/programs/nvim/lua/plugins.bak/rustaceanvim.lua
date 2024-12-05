return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	config = function()
		vim.g.rustaceanvim = function()
			return {
				-- Plugin configuration
				tools = {},
				-- LSP configuration
				server = {
					on_attach = function(client, bufnr)
						local opts = { noremap = true, silent = true }
						vim.api.nvim_buf_set_keymap(
							bufnr,
							"n",
							"s",
							"<cmd>lua require('tree_climber_rust').init_selection()<CR>",
							opts
						)
						vim.api.nvim_buf_set_keymap(
							bufnr,
							"x",
							"s",
							"<cmd>lua require('tree_climber_rust').select_incremental()<CR>",
							opts
						)
						vim.api.nvim_buf_set_keymap(
							bufnr,
							"x",
							"S",
							"<cmd>lua require('tree_climber_rust').select_previous()<CR>",
							opts
						)
					end,
					default_settings = {
						-- rust-analyzer language server configuration
						["rust-analyzer"] = {},
					},
				},
				-- DAP configuration
				dap = {
					adapter = require("rustaceanvim.config").get_codelldb_adapter(
						"$XDG_DATA_HOME/nvim/mason/bin/codelldb",
						"$XDG_DATA_HOME/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
					),
				},
			}
		end
	end,
	dependencies = {
		{
			"saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			config = function()
				require("crates").setup({})
			end,
		},
		{
			"adaszko/tree_climber_rust.nvim",
		},
	},
}
