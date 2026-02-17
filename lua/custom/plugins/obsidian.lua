return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>fn',
      '<cmd>ObsidianSearch<CR>',
      desc = 'Find Obsidian Notes',
    },
  },
  opts = {
    workspaces = {
      {
        name = 'work',
        path = '~/Documents/notes',
        overrides = {
          notes_subdir = 'Rough-Notes',
          templates = {
            folder = 'Templates',
            date_format = '%Y-%m-%d',
            time_format = '%H:%M',
          },
        },
      },
      {
        name = 'personal',
        path = '~/Documents/personal_notes',
        overrides = {
          notes_subdir = 'notes',
          templates = {
            folder = 'Templates',
            date_format = '%Y-%m-%d',
            time_format = '%H:%M',
          },

          daily_notes = {
            folder = 'daily',
            default_tags = { 'daily-note' },
            template = 'daily.md',
          },

          -- Customize how note IDs are generated given an optional title.
          ---@param title string|?
          ---@return string
          note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ''
            if title ~= nil then
              -- If title is given, transform it into valid file name.
              suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            else
              -- If title is nil, just add 4 random uppercase letters to the suffix.
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
              end
            end
            return tostring(os.time()) .. '-' .. suffix
          end,
        },
      },
    },

    new_notes_location = 'notes_subdir',

    disable_frontmatter = function(filename)
      local dirName = 'Templates'

      if string.find(filename, dirName) then
        return true
      end

      return false
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart { 'open', url } -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,
  },
}
