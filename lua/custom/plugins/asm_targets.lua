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

-- Add clangd for C function validation in assembly files
if vim.fn.executable 'clangd' == 1 then
  lspconfig.clangd.setup {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'asm', 'armasm' },
    root_dir = lspconfig.util.root_pattern('.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', '.asm-lsp.toml', '.git'),
    -- Optional: customize capabilities if needed
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  }
end

-- Set filetype for .S and .s files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.S', '*.s' },
  callback = function()
    vim.bo.filetype = 'asm'
  end,
})

-- safer FileType handler: use opt_local and idempotent syntax commands
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'asm', 'armasm' },
  callback = function()
    -- set buffer-local commentstring using the proper API
    vim.opt_local.commentstring = '@ %s'

    -- don't re-run syntax definitions for this buffer
    if vim.b.asm_comment_ext_added then
      return
    end
    vim.b.asm_comment_ext_added = true
  end,
})

return {}
