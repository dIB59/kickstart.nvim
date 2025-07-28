-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' })
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup()

      -- basic telescope configuration
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

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = 'Harpoon: ' .. desc })
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })

      map('<leader>ha', function()
        harpoon:list():add()
      end, 'Add file')
      map('<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, 'Toggle menu')
      map('<leader>h1', function()
        harpoon:list():select(1)
      end, 'Go to file 1')
      map('<leader>h2', function()
        harpoon:list():select(2)
      end, 'Go to file 2')
      map('<leader>h3', function()
        harpoon:list():select(3)
      end, 'Go to file 3')
      map('<leader>h4', function()
        harpoon:list():select(4)
      end, 'Go to file 4')
    end,
  },
}
