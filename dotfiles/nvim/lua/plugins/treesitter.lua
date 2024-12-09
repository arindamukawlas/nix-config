-- Highlight, edit, and navigate code
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
			tree_docs = { enable = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		keys = {
			{
				"[c",
				"lua require('treesitter-context').go_to_context(vim.v.count1)",
				desc = "Goto context",
				silent = true,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	{
		"nvim-treesitter/nvim-treesitter-refactor",
	},
	{
		"nvim-treesitter/nvim-tree-docs",
	},
}
