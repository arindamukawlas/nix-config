return {
	"Shatur/neovim-ayu",
	priority = 1000,
	config = function()
		local colors = require("ayu.colors")
		colors.generate()

		require("ayu").setup({
			overrides = { LineNr = { fg = colors.guide_active } },
		})
		vim.cmd.colorscheme("ayu-dark")
	end,
}
