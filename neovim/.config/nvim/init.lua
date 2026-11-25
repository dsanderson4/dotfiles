vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

require 'settings.settings'
require 'lazy.bootstrap'
require 'lazy.plugins'
require 'settings.mappings'

-- Well-known server address so shells/tools can hand files to the first
-- running Neovim via "nvim --server <addr> --remote <file>". Used by the
-- PowerShell "v"/"vr" functions (powershell/psinit/03-nvim.ps1), the zsh
-- ones (zsh/.config/zsh/40-nvim.zsh, which must compute the same Unix path),
-- vifm's "o" mapping, and lazygit's edit command. Later instances fail to
-- bind and just run without the well-known address.
if vim.fn.has('win32') == 1 then
  pcall(vim.fn.serverstart, [[\\.\pipe\nvim-server]])
else
  local dir = (os.getenv('XDG_RUNTIME_DIR') or os.getenv('TMPDIR') or '/tmp'):gsub('/+$', '')
  local addr = dir .. '/nvim-server.sock'
  -- Unlike Windows pipes, Unix sockets outlive a crashed Neovim. If the file
  -- exists but nobody answers, it's stale: remove it so we can take over.
  if vim.uv.fs_stat(addr) then
    local ok, chan = pcall(vim.fn.sockconnect, 'pipe', addr, { rpc = true })
    if ok and chan > 0 then
      vim.fn.chanclose(chan)
    else
      os.remove(addr)
    end
  end
  pcall(vim.fn.serverstart, addr)
end
