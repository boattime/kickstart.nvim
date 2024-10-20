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
      "<leader>fn",
      "<cmd>ObsidianSearch<CR>",
      desc = "Find Obsidian Notes",
    },
  },
  opts = {
    workspaces = {
      {
        name = "work",
        path = "~/Documents/notes",
      },
    },
    notes_subdir = "Rough-Notes",
    new_notes_location = "notes_subdir",
    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    disable_frontmatter = function(filename)
      local dirName = "Templates"

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
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      --local current_file_name = vim.api.nvim_buf_get_name(0)
      --local creationDate = getCreationDate(current_file_name)
      --
      local out = {}
      if note.metadata and note.metadata.type == "daily note" then
        out = { id = tostring(note.id), aliases = note.aliases, tags = note.tags }
      else
        out = { id = tostring(note.id), aliases = note.aliases, tags = note.tags, project = "", area = "" }
      end

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      --out['created_date'] = creationDate

      return out
    end,
  },
}
