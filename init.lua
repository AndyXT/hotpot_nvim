-- ~/.config/nvim/init.lua

-- As per lazy's install instructions
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- Bootstap hotpot into lazy plugin dir if it does not exist yet.
local hotpotpath = vim.fn.stdpath("data") .. "/lazy/hotpot.nvim"
if not vim.loop.fs_stat(hotpotpath) then
  vim.notify("Bootstrapping hotpot.nvim...", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    -- You may with to pin a known version tag with `--branch=vX.Y.Z`
    "--branch=v0.9.6",
    "https://github.com/rktjmp/hotpot.nvim.git",
    hotpotpath,
  })
end

-- As per lazy's install instructions, but insert hotpots path at the front
vim.opt.runtimepath:prepend({hotpotpath, lazypath})

require("hotpot") -- optionally you may call require("hotpot").setup(...) here

vim.cmd([[let g:fzf_vim = {}
let g:fzf_vim.preview_bash = 'C:\msys64\usr\bin\bash.exe'
let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
]])

-- include hotpot as a plugin so lazy will update it
-- local plugins = {"rktjmp/hotpot.nvim"}
-- require("lazy").setup(plugins)

-- include the rest of your config
require("kickstart.init")
