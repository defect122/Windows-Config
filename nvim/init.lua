vim.opt.termguicolors = true
-- Add Rose Pine theme and Gruvbox-Material
vim.pack.add({
	"https://github.com/sainnhe/gruvbox-material",
	"https://github.com/rose-pine/neovim",
	"https://github.com/ellisonleao/gruvbox.nvim",
})

vim.cmd.colorscheme("gruvbox")

local function set_transparent() -- set UI component to transparent
	local groups = {
		"Normal",
		"NormalNC",
		"EndOfBuffer",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"StatusLine",
		"StatusLineNC",
		"TabLine",
		"TabLineFill",
		"TabLineSel",
		"ColorColumn",
	}
	for _, g in ipairs(groups) do
		vim.api.nvim_set_hl(0, g, { bg = "none" })
	end
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

set_transparent()

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 2 -- tabwidth
vim.opt.shiftwidth = 2 -- indent width
vim.opt.softtabstop = 2 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line

vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type

vim.opt.inccommand = "split" -- allows split preview to look below
vim.opt.signcolumn = "yes" -- always show a sign column
vim.opt.showmatch = true -- highlights matching brackets
vim.opt.cmdheight = 0 -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.showmode = false -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 10 -- popup menu transparency
vim.opt.winblend = 0 -- floating window transparency
vim.opt.concealcursor = "" -- do not hide cursorline in markup
vim.opt.synmaxcol = 300 -- syntax highlighting limit
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines
-- vim.opt.conceallevel = 2 -- Obsidian

local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false -- do not create a backup file
vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile
vim.opt.undofile = true -- do create an undo file
vim.opt.undodir = undodir -- set the undo directory
vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- timeout duration
vim.opt.ttimeoutlen = 50 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
vim.opt.autowrite = false -- do not auto-save

vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no error sounds
vim.opt.backspace = "indent,eol,start" -- better backspace behaviour
vim.opt.autochdir = false -- do not autochange directories
vim.opt.iskeyword:append("-") -- include - in words
vim.opt.path:append("**") -- include subdirs in search
vim.opt.selection = "inclusive" -- include last char in selection
vim.opt.mouse = "a" -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true -- allow buffer modifications

vim.opt.guicursor = {
	"n-v-c:block-Cursor",
	"i-ci-ve:ver25-Cursor/lCursor-blinkwait300-blinkon200-blinkoff150",
	"r-cr:hor20",
	"o:hor50",
}
-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right
vim.opt.laststatus = 3
vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60") -- improve diff display
vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000 -- increase max memory
vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60") -- improve diff display
vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000 -- increase max memory

-- ============================================================================
-- STATUSLINE
-- ============================================================================

-- Git branch function with caching and Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
	local now = vim.uv.now()
	if now - last_check > 5000 then -- Check every 5 seconds
		local branch = vim.fn.system("git branch --show-current 2>nul")
		if vim.v.shell_error == 0 then
			cached_branch = branch:gsub("%s+", "")
		else
			cached_branch = ""
		end
		last_check = now
	end
	if cached_branch ~= "" then
		return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
	end
	return ""
end

-- File type with Nerd Font icon
local function file_type()
	local ft = vim.bo.filetype
	local icons = {
		lua = "\u{e620} ", -- nf-dev-lua
		python = "\u{e73c} ", -- nf-dev-python
		javascript = "\u{e74e} ", -- nf-dev-javascript
		typescript = "\u{e628} ", -- nf-dev-typescript
		javascriptreact = "\u{e7ba} ",
		typescriptreact = "\u{e7ba} ",
		html = "\u{e736} ", -- nf-dev-html5
		css = "\u{e749} ", -- nf-dev-css3
		scss = "\u{e749} ",
		json = "\u{e60b} ", -- nf-dev-json
		markdown = "\u{e73e} ", -- nf-dev-markdown
		vim = "\u{e62b} ", -- nf-dev-vim
		sh = "\u{f489} ", -- nf-oct-terminal
		bash = "\u{f489} ",
		zsh = "\u{f489} ",
		rust = "\u{e7a8} ", -- nf-dev-rust
		go = "\u{e724} ", -- nf-dev-go
		c = "\u{e61e} ", -- nf-dev-c
		cpp = "\u{e61d} ", -- nf-dev-cplusplus
		java = "\u{e738} ", -- nf-dev-java
		php = "\u{e73d} ", -- nf-dev-php
		ruby = "\u{e739} ", -- nf-dev-ruby
		swift = "\u{e755} ", -- nf-dev-swift
		kotlin = "\u{e634} ",
		dart = "\u{e798} ",
		elixir = "\u{e62d} ",
		haskell = "\u{e777} ",
		sql = "\u{e706} ",
		yaml = "\u{f481} ",
		toml = "\u{e615} ",
		xml = "\u{f05c} ",
		dockerfile = "\u{f308} ", -- nf-linux-docker
		gitcommit = "\u{f418} ", -- nf-oct-git_commit
		gitconfig = "\u{f1d3} ", -- nf-fa-git
		vue = "\u{fd42} ", -- nf-md-vuejs
		svelte = "\u{e697} ",
		astro = "\u{e628} ",
	}

	if ft == "" then
		return " \u{f15b} " -- nf-fa-file_o
	end

	return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- File size with Nerd Font icon
local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end
	local size_str
	if size < 1024 then
		size_str = size .. "B"
	elseif size < 1024 * 1024 then
		size_str = string.format("%.1fK", size / 1024)
	else
		size_str = string.format("%.1fM", size / 1024 / 1024)
	end
	return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

-- Mode indicators with Nerd Font icons
local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = " \u{f121}  NORMAL",
		i = " \u{f11c}  INSERT",
		v = " \u{f0168} VISUAL",
		V = " \u{f0168} V-LINE",
		["\22"] = " \u{f0168} V-BLOCK",
		c = " \u{f120} COMMAND",
		s = " \u{f0c5} SELECT",
		S = " \u{f0c5} S-LINE",
		["\19"] = " \u{f0c5} S-BLOCK",
		R = " \u{f044} REPLACE",
		r = " \u{f044} REPLACE",
		["!"] = " \u{f489} SHELL",
		t = " \u{f120} TERMINAL",
	}
	return modes[mode] or (" \u{f059} " .. mode)
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				"  ",
				"%#StatusLineBold#",
				"%{v:lua.mode_icon()}",
				"%#StatusLine#",
				" \u{e0b1} %f %h%m%r", -- nf-pl-left_hard_divider
				"%{v:lua.git_branch()}",
				"\u{e0b1} ", -- nf-pl-left_hard_divider
				"%{v:lua.file_type()}",
				"\u{e0b1} ", -- nf-pl-left_hard_divider
				"%{v:lua.file_size()}",
				"%=", -- Right-align everything after this
				" \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
			})
		end,
	})
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
		end,
	})
end

setup_dynamic_statusline()

-- ============================================================================
-- KEYMAPS
-- ============================================================================
vim.g.mapleader = " " -- space for leader
vim.g.maplocalleader = " " -- space for localleader
vim.keymap.set("i", "kj", "<Esc>") -- quick exit of insert mode

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
-- Better pane navigation
vim.keymap.set("n", "<C-q>", "<C-w>q", { desc = "Exit pane" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })
-- Create new windows
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without pasting" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves lines up in visual selection" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word cursor is on globally" }
)

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })

vim.keymap.set("n", "<leader>pa", function() -- show file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

-- ============================================================================
-- AUTOCMDS
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
	callback = function(args)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format({ async = false, id = args.data.client_id })
			end,
		})
	end,
})

-- ==========================================================================
-- I have no idea why this doesn't work for .jsx, .js, .css, and other files
-- ==========================================================================
--
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
-- --Format on save (ONLY real file buffers, ONLY when efm is attached)
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = augroup,
-- 	pattern = {
-- 		"*.lua",
-- 		"*.py",
-- 		"*.go",
-- 		"*.js",
-- 		"*.jsx",
-- 		"*.ts",
-- 		"*.tsx",
-- 		"*.json",
-- 		"*.css",
-- 		"*.scss",
-- 		"*.html",
-- 		"*.sh",
-- 		"*.bash",
-- 		"*.zsh",
-- 		"*.c",
-- 		"*.cpp",
-- 		"*.h",
-- 		"*.hpp",
-- 	},
-- 	callback = function(args)
-- 		-- avoid formatting non-file buffers (helps prevent weird write prompts)
-- 		if vim.bo[args.buf].buftype ~= "" then
-- 			return
-- 		end
-- 		if not vim.bo[args.buf].modifiable then
-- 			return
-- 		end
-- 		if vim.api.nvim_buf_get_name(args.buf) == "" then
-- 			return
-- 		end
--
-- 		local has_efm = false
-- 		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
-- 			if c.name == "efm" then
-- 				has_efm = true
-- 				break
-- 			end
-- 		end
-- 		if not has_efm then
-- 			return
-- 		end
--
-- 		pcall(vim.lsp.buf.format, {
-- 			bufnr = args.buf,
-- 			timeout_ms = 5000,
-- 			filter = function(c)
-- 				return c.name == "efm"
-- 			end,
-- 		})
-- 	end,
-- })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
vim.pack.add({
	-- QOL plugins
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-lua/plenary.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://github.com/sphamba/smear-cursor.nvim",
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	-- Auto Completion
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
	-- Markdown
	"https://github.com/meanderingprogrammer/render-markdown.nvim",
	-- "https://github.com/obsidian-nvim/obsidian.nvim",
})
-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================

-- https://www.reddit.com/r/neovim/comments/1r92p2y/small_utility_for_listing_and_deleting_inactive/
-- :lua vim.pack.update(nil, { offline = true }) to see the state of all plugins managed by vim.pack. The { offline = true } is optional to not re-download new updates.
-- The shown confirmation buffer already shows all plugins, active (i.e. loaded) or not. The not active plugins have a visible (not active) suffix in their title.
-- You can delete a plugin via in-process LSP code action. With default mappings, type gra when the cursor is on the plugin you want to delete. It should open a vim.ui.select() dialog with available actions and "Delete plugin-name" should be present. Choose it and the plugin is deleted from disk.

-- TreeSitterConfig
local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"vim",
		"vimdoc",
		"rust",
		"c",
		"cpp",
		"go",
		"html",
		"css",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"typescript",
		"vue",
		"svelte",
		"bash",
	}

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(config.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

-- Fuzzy search config
require("fzf-lua").setup({})

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

-- Smear Cursor config
require("smear_cursor").setup({})

-- Mini nvim config
local MiniFiles = require("mini.files") -- file tree
MiniFiles.setup({
	mappings = {
		go_in = "<CR>",
		go_in_plus = "L",
		go_out = "_",
		go_out_plus = "H",
	},
})
vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

local MiniExtra = require("mini.extra")
MiniExtra.setup({})
vim.keymap.set("n", "<leader>pk", function()
	MiniExtra.pickers.keymaps()
end, {
	desc = "Search keymaps",
})
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({
	-- only show messages
	content = {
		format = function(notif)
			return notif.msg
		end,
	},
})
require("mini.icons").setup({})
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "▎", change = "▎", delete = "▎" },
	},
})

require("mini.git").setup({})

local MiniDiff = require("mini.diff")
vim.keymap.set("n", "]h", function()
	MiniDiff.goto_hunk("next")
end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function()
	MiniDiff.goto_hunk("prev")
end, { desc = "Prev git hunk" })
vim.keymap.set("n", "<leader>hs", MiniDiff.operator, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hp", function()
	MiniDiff.toggle_overlay()
end, { desc = "Preview diff overlay" })
vim.keymap.set("n", "<leader>hb", function()
	require("mini.git").show_at_cursor()
end, { desc = "Git blame/show" })

require("mason").setup({})

-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================
-- clear logs
-- :lua io.open(vim.lsp.get_log_path(), "w"):close()

local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61}",
	Info = "\u{f05a}",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)

	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	-- Next diagnostic
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)

	-- Previous diagnostic
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	vim.keymap.set("n", "<leader>fr", function()
		require("fzf-lua").lsp_references()
	end, opts)
	vim.keymap.set("n", "<leader>ft", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>fs", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fi", function()
		require("fzf-lua").lsp_implementations()
	end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
		-- menu = {
		--   auto_show = function()
		--     return vim.bo.filetype ~= "markdown"
		--   end,
		-- },
	},
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	snippets = {
		preset = "luasnip",
	},
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("marksman", {})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("vtsls", {})
vim.lsp.config("gopls", {})
vim.lsp.config(
	"clangd",
	{ init_options = { fallbackFlags = { "--std=c++20" } }, cmd = { "clangd", "--background-index" } }
)
vim.lsp.config("csslsp", {})
vim.lsp.config("htmllsp", {})

vim.g.rustaceanvim = {
	server = {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
	},
}

do
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	local fixjson = require("efmls-configs.formatters.fixjson")

	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	local cpplint = require("efmls-configs.linters.cpplint")
	local clangfmt = require("efmls-configs.formatters.clang_format")

	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")

	vim.lsp.config("efm", {
		filetypes = {
			"c",
			"cpp",
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"python",
			"sh",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},

		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c = { clangfmt, cpplint },
				go = { gofumpt, go_revive },
				cpp = { clangfmt, cpplint },
				css = { prettier_d },
				html = { prettier_d },
				javascript = { prettier_d },
				javascriptreact = { prettier_d },
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },
				lua = { luacheck, stylua },
				markdown = { prettier_d },
				python = { flake8, black },
				sh = { shellcheck, shfmt },
				typescript = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				vue = { eslint_d, prettier_d },
				svelte = { eslint_d, prettier_d },
			},
		},
	})
end

vim.lsp.enable({
	"lua_ls",
	-- "pyright",
	"bashls",
	"vtsls",
	"htmllsp",
	"marksman",
	-- "csslsp",
	-- "gopls",
	"clangd",
	"efm",
})

-- ============================================================================
-- Markdown
-- ============================================================================

require("render-markdown").setup({})

local function open_relative_note(day_offset)
	local notes_dir = vim.fn.expand("~/Documents/notes/")
	local target_time = os.time() + (day_offset * 24 * 60 * 60)
	local date_str = os.date("%Y-%m-%d", target_time)
	local file_path = notes_dir .. date_str .. ".md"

	if vim.fn.isdirectory(notes_dir) == 0 then
		vim.fn.mkdir(notes_dir, "p")
	end

	vim.cmd("edit " .. vim.fn.fnameescape(file_path))

	if vim.fn.filereadable(file_path) == 0 then
		local label = "Today"
		if day_offset == -1 then
			label = "Yesterday"
		end
		if day_offset == 1 then
			label = "Tomorrow"
		end

		local template = {
			"# Daily Note: " .. date_str .. " (" .. label .. ")",
			"",
			"## Focus Areas",
			"- [ ] ",
			"",
			"## Log and Scratchpad",
			"",
			"## Reflection",
		}
		vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
		vim.cmd("write")
	end
end

vim.api.nvim_create_user_command("YesterdayNote", function()
	open_relative_note(-1)
end, {})
vim.api.nvim_create_user_command("Daily", function()
	open_relative_note(0)
end, {})
vim.api.nvim_create_user_command("TomorrowNote", function()
	open_relative_note(1)
end, {})

vim.keymap.set("n", "<leader>dy", function()
	open_relative_note(-1)
end, { desc = "Open yesterday's note" })
vim.keymap.set("n", "<leader>dn", function()
	open_relative_note(0)
end, { desc = "Open today's note" })
vim.keymap.set("n", "<leader>dt", function()
	open_relative_note(1)
end, { desc = "Open tomorrow's note" })

-- require("obsidian").setup({
-- 	legacy_commands = false, -- this will be removed in 4.0.0
-- 	picker = { name = "fzf-lua" },
-- 	workspaces = {
-- 		{ name = "personal", path = "~/Documents/notes/" },
-- 	},
-- 	note_id_func = function(title)
-- 		local name = ""
-- 		if title ~= nil then
-- 			-- Replaces spaces with hyphens and makes it lowercase
-- 			-- e.g., "My New Note" -> "my-new-note"
-- 			name = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
-- 		else
-- 			-- If you don't provide a title, generate a random 4-letter string
-- 			for _ = 1, 4 do
-- 				name = name .. string.char(math.random(65, 90))
-- 			end
-- 		end
-- 		return name
-- 	end,
-- })
--
-- vim.keymap.set("n", "<leader>no", "<cmd>Obsidian <cr>", { desc = "Obsidian: Open actions panel" })
-- vim.keymap.set("n", "<leader>nn", "<cmd>Obsidian new<cr>", { desc = "Obsidian: Create a new note with title" })
-- vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian: Find note" })
-- vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Obsidian: Search notes" })
-- vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>", { desc = "Obsidian: Today's daily note" })

-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================
vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function()
		if vim.v.event.status == 0 then
			vim.api.nvim_buf_delete(0, {})
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

local terminal_state = { buf = nil, win = nil, is_open = false }

local function FloatingTerminal()
	if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
		return
	end

	if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
		terminal_state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[terminal_state.buf].bufhidden = "hide"
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[terminal_state.win].winblend = 0
	vim.wo[terminal_state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
	vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

	local has_terminal = vim.bo[terminal_state.buf].buftype == "terminal"
	if not has_terminal then
		local ps_cmd = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
		vim.fn.termopen(ps_cmd)
	end

	terminal_state.is_open = true
	vim.cmd("startinsert")

	local term_augroup = vim.api.nvim_create_augroup("FloatingTermLeave_" .. terminal_state.win, { clear = true })
	vim.api.nvim_create_autocmd("BufLeave", {
		group = term_augroup,
		buffer = terminal_state.buf,
		callback = function()
			if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
				vim.api.nvim_win_close(terminal_state.win, false)
				terminal_state.is_open = false
			end
		end,
		once = true,
	})
end

vim.keymap.set("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Terminal normal mode" })
vim.keymap.set("t", "<C-q>", function()
	if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
	end
end, { noremap = true, silent = true, desc = "Close floating terminal" })
