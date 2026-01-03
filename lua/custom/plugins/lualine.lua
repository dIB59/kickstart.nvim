return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      section_separators = '',
      component_separators = '|',
      -- Disable icons if you want it even cleaner/faster
      icons_enabled = false,
      globalstatus = true, -- Single bar at the bottom instead of per-split
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'filetype' }, -- Only shows if there are errors
      lualine_y = { 'diagnostics' },
      lualine_z = { 'location' },
    },
    -- These remove the default "filetype" and "encoding" from the right side
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
