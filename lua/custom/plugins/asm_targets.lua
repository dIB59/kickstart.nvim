-- Require lspconfig safely
local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not has_lspconfig then
  vim.notify('nvim-lspconfig not found, ASM LSP will not start', vim.log.levels.WARN)
  return
end

-- Define ASM targets
local asm_targets = {
  pico = {
    assembler = 'arm-none-eabi-as',
    compiler = 'arm-none-eabi-gcc',
    extraFlags = { '-mthumb', '-mcpu=cortex-m0plus' },
    syntax = 'gas',
  },
  arm = {
    assembler = 'arm-none-eabi-as',
    compiler = 'arm-none-eabi-gcc',
    extraFlags = { '-mcpu=cortex-m3' },
    syntax = 'gas',
  },
  aarch64 = {
    assembler = 'aarch64-linux-gnu-as',
    compiler = 'aarch64-linux-gnu-gcc',
    syntax = 'gas',
  },
  x86 = {
    assembler = 'nasm',
    compiler = 'gcc',
    syntax = 'nasm',
  },
}

-- Check if asm-lsp is installed
local function has_asm_lsp()
  return vim.fn.executable 'asm-lsp' == 1
end

-- Setup ASM LSP
local function setup_asm_lsp(preset)
  local config = asm_targets[preset]
  if not config then
    vim.notify('Unknown ASM target: ' .. preset, vim.log.levels.ERROR)
    return
  end

  if not has_asm_lsp() then
    vim.notify('asm-lsp not found; skipping LSP setup', vim.log.levels.WARN)
    return
  end

  -- Stop existing asm_lsp clients
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == 'asm_lsp' then
      vim.lsp.stop_client(client.id)
    end
  end

  -- Define server configuration
  local asm_lsp_config = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 's', 'S' },
    root_dir = function(fname)
      return vim.fs.find({ '.git', '.asm-lsp.toml' }, { upward = true, path = fname })[1] or vim.fn.getcwd()
    end,
    settings = {
      ['asm-lsp'] = {
        assembler = config.assembler,
        compiler = config.compiler,
        syntax = config.syntax, -- <- added syntax for GAS/NASM
      },
    },
  }

  -- Register server with lspconfig
  lspconfig.asm_lsp = {
    default_config = asm_lsp_config,
  }

  -- Start LSP for current ASM buffer
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  if ft == 'asm' or ft == 's' or ft == 'S' then
    vim.lsp.start { name = 'asm_lsp' }
  end

  vim.notify('ASM target switched to: ' .. preset, vim.log.levels.INFO)
end

-- User command to switch ASM targets
vim.api.nvim_create_user_command('AsmTarget', function(opts)
  setup_asm_lsp(opts.args)
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(asm_targets)
  end,
  desc = 'Switch ASM target (pico, arm, aarch64, x86)',
})

-- Ensure .S and .s files are treated as asm
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.S', '*.s' },
  callback = function()
    vim.bo.filetype = 'asm'
  end,
})

-- Set commentstring for asm files to use @
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'asm',
  callback = function()
    vim.bo.commentstring = '@ %s'
  end,
})

-- Optional: automatically attach Pico target on startup
setup_asm_lsp 'pico'
