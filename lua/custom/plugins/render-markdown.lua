return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ft = { 'markdown', 'rust', 'lua', 'codecompanion' },
  opts = {
    completions = { lsp = { enabled = true } },
    file_types = { 'markdown', 'codecompanion' },
  },
}
