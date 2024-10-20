local M = {}

function M.open_daily_note()
    local date = os.date("*t")
    local year = date.year
    local week = os.date("%W")
    local filename = string.format("%04d-%02d-%02d.md", year, date.month, date.day)
    local path = string.format("~/Documents/notes/Daily/%d/W%s/%s", year, week, filename)
    vim.cmd('edit ' .. path)
end

return M
