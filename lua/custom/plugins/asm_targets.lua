-- Require lspconfig safely
local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not has_lspconfig then
  vim.notify('nvim-lspconfig not found', vim.log.levels.WARN)
  return
end

-- Simple asm-lsp setup - relies on .asm-lsp.toml for configuration
if vim.fn.executable 'asm-lsp' == 1 then
  lspconfig.asm_lsp.setup {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'armasm' },
    root_dir = function(fname)
      return vim.fn.getcwd()
    end,
  }
end

-- Set filetype for .S and .s files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.S', '*.s' },
  callback = function()
    vim.bo.filetype = 'asm'
  end,
})

-- Set comment string for asm files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'asm', 'armasm' },
  callback = function()
    vim.bo.commentstring = '@ %s'
  end,
})

return {}
