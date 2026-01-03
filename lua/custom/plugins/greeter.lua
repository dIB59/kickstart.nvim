return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { title = 'Recent Projects', section = 'projects', padding = 1 },
        { section = 'startup' },
      },
      preset = {
        -- Define your specific buttons here
        keys = {
          -- Using Capital letters or unique symbols prevents motion conflicts
          { icon = '󰛄 ', key = 'L', desc = 'LeetCode', action = ':Leet' },
          { icon = '󰌌 ', key = 'T', desc = 'Typr', action = ':Typr' },
          { icon = '󰒲 ', key = 'S', desc = 'Status', action = ':Lazy' },
          { icon = '󱎫 ', key = 'm', desc = 'Typr Stats', action = ':TyprStats' },
          { icon = '󰀚 ', key = 'P', desc = 'Triforce Profile', action = ':Triforce profile' }, -- Use 'p' for project search since it's not a vertical motion
          { icon = ' ', key = 'F', desc = 'Find Project', action = ':lua Snacks.picker.projects()' },
          { icon = ' ', key = 'Q', desc = 'Quit', action = ':qa' },
        },
      },
    },
  },
}
