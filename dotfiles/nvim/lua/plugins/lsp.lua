return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local lspconfig = require("lspconfig")
			local servers = {
				lua_ls = {},
				denols = {},
			}
			for server, config in pairs(servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},
}
