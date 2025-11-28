-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Global mapping function accessible by all plugins
local function map(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

return {

  ---------------------------------------------------------------------------
  -- Oil file explorer (<leader>e opens it)
  ---------------------------------------------------------------------------
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    -- all your previous options, nothing changed
    opts = {
      default_file_explorer = true,
      columns = { 'icon' },
      buf_options = { buflisted = false, bufhidden = 'hide' },
      win_options = {
        wrap = false,
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },
      delete_to_trash = false,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,
      lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = false },
      constrain_cursor = 'editable',
      watch_for_changes = false,
      use_default_keymaps = true,
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name)
          return vim.startswith(name, '.')
        end,
        is_always_hidden = function()
          return false
        end,
        natural_order = 'fast',
        case_insensitive = false,
        sort = { { 'type', 'asc' }, { 'name', 'asc' } },
        highlight_filename = function()
          return nil
        end,
      },
      git = {
        add = function()
          return false
        end,
        mv = function()
          return false
        end,
        rm = function()
          return false
        end,
      },
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = nil,
        win_options = { winblend = 0 },
        preview_split = 'auto',
        override = function(conf)
          return conf
        end,
      },
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = 'fast_scratch',
        disable_preview = function()
          return false
        end,
        win_options = {},
      },
      confirmation = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = nil,
        win_options = { winblend = 0 },
      },
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = nil,
        minimized_border = 'none',
        win_options = { winblend = 0 },
      },
      ssh = { border = nil },
      keymaps_help = { border = nil },
    },

    -- key-mapping created **after** Oil is loaded
    config = function(_, opts)
      require('oil').setup(opts)
      map('<leader>e', '<cmd>Oil<CR>', 'Open Oil (file explorer)')
    end,
  },
  -- Lazygit integration
  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      map('<leader>gg', ':LazyGit<CR>', 'Open LazyGit')
    end,
  },

  -- Harpoon (v2 branch)
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      -- telescope integration for harpoon
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      local current_index = 1

      local function goto_next_file()
        local list = harpoon:list()
        local total = #list.items
        if total == 0 then
          return
        end
        current_index = (current_index % total) + 1
        list:select(current_index)
      end

      local function goto_prev_file()
        local list = harpoon:list()
        local total = #list.items
        if total == 0 then
          return
        end
        current_index = (current_index - 2 + total) % total + 1
        list:select(current_index)
      end

      map('<leader><Tab>', goto_next_file, 'Harpoon: Next buffer')
      map('<leader><S-Tab>', goto_prev_file, 'Harpoon: Previous buffer')

      map('<leader>ha', function()
        harpoon:list():add()
      end, 'Harpoon: Add file')
      map('<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, 'Harpoon: Toggle menu')

      map('<leader>h1', function()
        harpoon:list():select(1)
      end, 'Harpoon: Go to file 1')
      map('<leader>h2', function()
        harpoon:list():select(2)
      end, 'Harpoon: Go to file 2')
      map('<leader>h3', function()
        harpoon:list():select(3)
      end, 'Harpoon: Go to file 3')
      map('<leader>h4', function()
        harpoon:list():select(4)
      end, 'Harpoon: Go to file 4')
    end,
  },
}
