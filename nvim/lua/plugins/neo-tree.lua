return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- This forces hidden files to show
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
