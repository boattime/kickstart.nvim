local M = {}

function M.open_daily_note()
    local date = os.date("*t")
    local year = date.year
    local week = os.date("%W")
    local filename = string.format("%04d-%02d-%02d.md", year, date.month, date.day)
    local path = string.format("~/Documents/notes/Daily/%d/W%s/%s", year, week, filename)
    vim.cmd('edit ' .. path)
end

function M.get_directories(path)
    local dirs = {}
    local handle = vim.uv.fs_scandir(path)

    while handle do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then break end

        if type == 'directory' then
            table.insert(dirs, name)
        end
    end

    return dirs
end

-- Function to get the first file (chronologically) in a directory
function M.get_first_file(dir_path)
    local files = {}
    local handle = vim.uv.fs_scandir(dir_path)

    while handle do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then break end

        if type == 'file' then
            table.insert(files, name)
        end
    end

    -- Sort files (assuming filenames are timestamps)
    table.sort(files)

    -- Return the first file if any exists
    if #files > 0 then
        return dir_path .. '/' .. files[1]
    end
    return nil
end


return M
