local M = {}
local loaded = {}

function M.load(lang)
    if loaded[lang] then
        return
    end

    if lang == "rust" then
        require("plugins.debugger.rust")
    elseif lang == "python" then
        -- require("plugins.debugger.python")
        error("python not setup")
    elseif lang == "node" then
        require("plugins.debugger.node")
    end

    loaded[lang] = true
end

return M
