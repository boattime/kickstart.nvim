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
    {
      "<leader>sp",
      "<cmd>ObsidianProjects<CR>",
      desc = "[S]earch [P]rojects",
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

    vim.api.nvim_create_user_command("ObsidianNewProject", function(args)
      local util = require("obsidian.util")
      local client = require("obsidian").get_client()
      local name = args.fargs[1]

      local dir_path = client:vault_root()
      dir_path = dir_path:joinpath("Projects/" .. name)
      dir_path:mkdir({
        exist_ok = true
      })

      local id = util.zettel_id()
      client:create_note({
        id = id,
        title = name,
        dir = "Projects/" .. name,
      })

      client:update_ui()

    end, {
        nargs = 1,
    }),

    vim.api.nvim_create_user_command("ObsidianProjects", function()
      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local util = require('custom.config.utils')
      local client = require("obsidian").get_client()
      local base_path = client:vault_root()
      base_path = tostring(base_path:joinpath("Projects/"))

      print(base_path)

      local dirs = util.get_directories(base_path)

      -- Create telescope picker
      local picker = pickers.new({}, {
        prompt_title = 'Select Directory',
        finder = finders.new_table {
            results = dirs
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()

            -- Get the full path of the selected directory
            local dir_path = base_path .. '/' .. selection[1]

            -- Get and open the first file
            local first_file = util.get_first_file(dir_path)
            if first_file then
              vim.cmd('edit ' .. first_file)
            else
              print("No files found in the selected directory")
            end
          end)
          return true
          end,
      })

      picker:find()

    end, {})
  },
}
