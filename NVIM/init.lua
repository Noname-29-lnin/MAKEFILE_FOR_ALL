--  _   _                                  
-- | \ | | ___  _ __   __ _ _ __ ___   ___ 
-- |  \| |/ _ \| '_ \ / _` | '_ ` _ \ / _ \
-- | |\  | (_) | | | | (_| | | | | | |  __/
-- |_| \_|\___/|_| |_|\__,_|_| |_| |_|\___|
-- Welcome to Noname-29-Lnin
--
-- Lazy loading of modules
require("config.lazy")
require("config.options")
require("config.mini-terminal")
require("config.keymaps")
require("config.help-floating")
require("config.helps")

vim.env.PATH = vim.env.PATH .. ":" .. "/home/noname/.nvm/versions/node/v18.20.8/bin"
