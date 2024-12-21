return {
	{
		"saghen/blink.cmp",
		event = { "LspAttach" },
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			enabled = function()
				return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
			end,
			completion = {
				keyword = { range = "full" },
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				cmdline = {},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},

		opts_extend = { "sources.default" },
	},
}
