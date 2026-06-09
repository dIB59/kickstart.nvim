-- Neotest: run tests from inside Neovim with gutter signs, output windows,
-- and a summary sidebar. Tests live under the <leader>T ([T]est) group.
--
-- Adapters configured: Rust (cargo), JS/TS (Vitest), Python (pytest),
-- Elixir (mix test), Go (go test).
--
-- Quick reference (all under <leader>T):
--   Tt  run nearest test        Tl  run last test
--   Tf  run tests in file       Ta  run all tests in cwd
--   Ts  toggle summary sidebar  To  show output for nearest
--   TO  toggle output panel     TS  stop running test(s)
--   Td  debug nearest test      Tw  toggle watch mode

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',

    -- Language adapters
    'rouge8/neotest-rust',
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-python',
    'jfpedroza/neotest-elixir',
    'fredrikaverpil/neotest-golang',
  },
  -- Load lazily the first time a test keymap is pressed.
  keys = {
    {
      '<leader>Tt',
      function()
        require('neotest').run.run()
      end,
      desc = '[T]est nearest',
    },
    {
      '<leader>Tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = '[T]est [f]ile',
    },
    {
      '<leader>Ta',
      function()
        require('neotest').run.run(vim.fn.getcwd())
      end,
      desc = '[T]est [a]ll (cwd)',
    },
    {
      '<leader>Tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = '[T]est [l]ast',
    },
    {
      '<leader>Ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = '[T]est [s]ummary',
    },
    {
      '<leader>To',
      function()
        require('neotest').output.open { enter = true, auto_close = true }
      end,
      desc = '[T]est [o]utput',
    },
    {
      '<leader>TO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = '[T]est [O]utput panel',
    },
    {
      '<leader>TS',
      function()
        require('neotest').run.stop()
      end,
      desc = '[T]est [S]top',
    },
    {
      '<leader>Td',
      function()
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = '[T]est [d]ebug nearest',
    },
    {
      '<leader>Tw',
      function()
        require('neotest').watch.toggle(vim.fn.expand '%')
      end,
      desc = '[T]est [w]atch file',
    },
    -- Jump between failed tests.
    {
      ']T',
      function()
        require('neotest').jump.next { status = 'failed' }
      end,
      desc = 'Next failed [T]est',
    },
    {
      '[T',
      function()
        require('neotest').jump.prev { status = 'failed' }
      end,
      desc = 'Prev failed [T]est',
    },
  },
  config = function()
    -- Register the which-key group for the test keymaps.
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add { { '<leader>T', group = '[T]est' } }
    end

    require('neotest').setup {
      adapters = {
        require 'neotest-rust',
        require 'neotest-vitest',
        require 'neotest-python' {
          dap = { justMyCode = false },
          runner = 'pytest',
        },
        require 'neotest-elixir',
        require 'neotest-golang',
      },
      -- Show diagnostics (failures) inline as virtual text.
      diagnostic = { enabled = true },
      output = { open_on_run = false },
      quickfix = { enabled = false },
      status = { virtual_text = true, signs = true },
    }
  end,
}
