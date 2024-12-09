return {
	"jiaoshijie/undotree",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("undotree").setup({
			window = {
				winblend = 0,
			},
		})
		vim.keymap.set("n", "<leader>u", require("undotree").toggle, { noremap = true, silent = true })
	end,
	keys = {
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
}
