require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

if vim.filetype then
    vim.filetype.add({
        pattern = {
            ["*.tx3"] = "tx3"
        }
    })
end
