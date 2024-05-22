(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")
(set vim.g.have_nerd_font false)
(set vim.opt.number true)
(set vim.opt.mouse :a)
(set vim.opt.showmode false)
(set vim.opt.clipboard :unnamedplus)
(set vim.opt.breakindent true)
(set vim.opt.undofile true)
(set vim.opt.ignorecase true)
(set vim.opt.smartcase true)
(set vim.opt.signcolumn :yes)
(set vim.opt.updatetime 250)
(set vim.opt.timeoutlen 300)
(set vim.opt.splitright true)
(set vim.opt.splitbelow true)
(set vim.opt.list true)
(set vim.opt.listchars {:nbsp "␣" :tab "» " :trail "·"})
(set vim.opt.inccommand :split)
(set vim.opt.cursorline true)
(set vim.opt.scrolloff 10)
(set vim.opt.hlsearch true)
(set vim.opt.swapfile false)
(set vim.opt.backup false)
(set vim.opt.undodir (.. (os.getenv :HOME) :/.vim/undodir))
(set vim.opt.undofile true)
(set vim.opt.shell "bash")
(set vim.opt.shellcmdflag "-c")
(set vim.opt.shellxquote "")

(vim.keymap.set :n :<Esc> :<cmd>nohlsearch<CR>)
(vim.keymap.set :n "[d" vim.diagnostic.goto_prev
                {:desc "Go to previous [D]iagnostic message"})
(vim.keymap.set :n "]d" vim.diagnostic.goto_next
                {:desc "Go to next [D]iagnostic message"})
(vim.keymap.set :n :<leader>e vim.diagnostic.open_float
                {:desc "Show diagnostic [E]rror messages"})
(vim.keymap.set :n :<leader>q vim.diagnostic.setloclist
                {:desc "Open diagnostic [Q]uickfix list"})
(vim.keymap.set :t :<Esc><Esc> "<C-\\><C-n>" {:desc "Exit terminal mode"})
(vim.keymap.set :n :<C-h> :<C-w><C-h> {:desc "Move focus to the left window"})
(vim.keymap.set :n :<C-l> :<C-w><C-l> {:desc "Move focus to the right window"})
(vim.keymap.set :n :<C-j> :<C-w><C-j> {:desc "Move focus to the lower window"})
(vim.keymap.set :n :<C-k> :<C-w><C-k> {:desc "Move focus to the upper window"})
(vim.api.nvim_create_autocmd :TextYankPost
                             {:callback (fn [] (vim.highlight.on_yank))
                              :desc "Highlight when yanking (copying) text"
                              :group (vim.api.nvim_create_augroup :kickstart-highlight-yank
                                                                  {:clear true})})
((. (require :lazy) :setup) [:tpope/vim-sleuth
                             :rktjmp/hotpot.nvim
                             {1 :numToStr/Comment.nvim :opts {}}
                             {1 :lewis6991/gitsigns.nvim
                              :opts {:signs {:add {:text "+"}
                                             :change {:text "~"}
                                             :changedelete {:text "~"}
                                             :delete {:text "_"}
                                             :topdelete {:text "‾"}}
                                     :on_attach (fn [bufnr]
                                                  (local gs package.loaded.gitsigns)
                                                  (fn map [mode l r opts]
                                                    (set-forcibly! opts (or opts {}))
                                                    (set opts.buffer bufnr)
                                                    (vim.keymap.set mode l r opts))

                                                  (map :n "]h" gs.next_hunk {:desc "Next Hunk"})
                                                  (map :n "[h" gs.prev_hunk {:desc "Prev Hunk"})
                                                  (map [:n :v] :<leader>ghs ":Gitsigns stage_hunk<CR>"
                                                       {:desc "Stage Hunk"})
                                                  (map [:n :v] :<leader>ghr ":Gitsigns reset_hunk<CR>"
                                                       {:desc "Reset Hunk"})
                                                  (map :n :<leader>ghS gs.stage_buffer {:desc "Stage Buffer"})
                                                  (map :n :<leader>ghu gs.undo_stage_hunk {:desc "Undo Stage Hunk"})
                                                  (map :n :<leader>ghR gs.reset_buffer {:desc "Reset Buffer"})
                                                  (map :n :<leader>ghp gs.preview_hunk_inline
                                                       {:desc "Preview Hunk Inline"})
                                                  (map :n :<leader>ghb (fn [] (gs.blame_line {:full true}))
                                                       {:desc "Blame Line"})
                                                  (map :n :<leader>ghd gs.diffthis {:desc "Diff This"})
                                                  (map :n :<leader>ghD (fn [] (gs.diffthis "~"))
                                                       {:desc "Diff This ~"})
                                                  (map [:o :x] :ih ":<C-U>Gitsigns select_hunk<CR>"
                                                       {:desc "GitSigns Select Hunk"}))}}
                             {1 :folke/which-key.nvim
                              :config (fn []
                                        ((. (require :which-key) :setup))
                                        ((. (require :which-key) :register) {:<leader>c {:_ :which_key_ignore
                                                                                         :name "[C]ode"}
                                                                             :<leader>d {:_ :which_key_ignore
                                                                                         :name "[D]ocument"}
                                                                             :<leader>r {:_ :which_key_ignore
                                                                                         :name "[R]ename"}
                                                                             :<leader>s {:_ :which_key_ignore
                                                                                         :name "[S]earch"}
                                                                             :<leader>w {:_ :which_key_ignore
                                                                                         :name "[W]orkspace"}}))
                              :event :VimEnter}
                             {1 :nvim-telescope/telescope.nvim
                              :config (fn []
                                        ((. (require :telescope) :setup) {:extensions {:ui-select [((. (require :telescope.themes)
                                                                                                       :get_dropdown))]}})
                                        (pcall (. (require :telescope)
                                                  :load_extension)
                                               :fzf)
                                        (pcall (. (require :telescope)
                                                  :load_extension)
                                               :ui-select)
                                        (local builtin
                                               (require :telescope.builtin))
                                        )
                              :dependencies [:nvim-lua/plenary.nvim
                                             {1 :nvim-telescope/telescope-fzf-native.nvim
                                              :build :make
                                              :cond (fn []
                                                      (= (vim.fn.executable :make)
                                                         1))}
                                             [:nvim-telescope/telescope-ui-select.nvim]
                                             {1 :nvim-tree/nvim-web-devicons
                                              :lazy false
                                              :config (fn []
                                                        ((. (require :nvim-web-devicons) :setup) {:default true}))
                                              :enabled true}]
                              :event :VimEnter}
                             {1 :folke/neodev.nvim :opts {}}
                             {1 :neovim/nvim-lspconfig
                              :config (fn []
                                        (vim.api.nvim_create_autocmd :LspAttach
                                                                     {:callback (fn [event]
                                                                                  (fn map [keys
                                                                                           func
                                                                                           desc]
                                                                                    (vim.keymap.set :n
                                                                                                    keys
                                                                                                    func
                                                                                                    {:buffer event.buf
                                                                                                     :desc (.. "LSP: "
                                                                                                               desc)}))

                                                                                  (map :gd
                                                                                       "<cmd>Pick lsp scope='definition'<CR>"
                                                                                       "[G]oto [D]efinition")
                                                                                  (map :gr
                                                                                       "<cmd>Pick lsp scope='references'<CR>"
                                                                                       "[G]oto [R]eferences")
                                                                                  (map :gI
                                                                                       "<cmd>Pick lsp scope='implementation'<CR>"
                                                                                       "[G]oto [I]mplementation")
                                                                                  (map :<leader>D
                                                                                       "<cmd>Pick lsp scope='type_definition'<CR>"
                                                                                       "Type [D]efinition")
                                                                                  (map :<leader>ds
                                                                                       "<cmd>Pick lsp scope='document_symbol'<CR>"
                                                                                       "[D]ocument [S]ymbols")
                                                                                  (map :<leader>ws
                                                                                       "<cmd>Pick lsp scope='workspace_symbol'<CR>"
                                                                                       "[W]orkspace [S]ymbols")
                                                                                  (map :<leader>rn
                                                                                       vim.lsp.buf.rename
                                                                                       "[R]e[n]ame")
                                                                                  (map :<leader>ca
                                                                                       vim.lsp.buf.code_action
                                                                                       "[C]ode [A]ction")
                                                                                  (map :K
                                                                                       vim.lsp.buf.hover
                                                                                       "Hover Documentation")
                                                                                  (map :gD
                                                                                       vim.lsp.buf.declaration
                                                                                       "[G]oto [D]eclaration")
                                                                                  (local client
                                                                                         (vim.lsp.get_client_by_id event.data.client_id))
                                                                                  (when (and client
                                                                                             client.server_capabilities.documentHighlightProvider)
                                                                                    (vim.api.nvim_create_autocmd [:CursorHold
                                                                                                                  :CursorHoldI]
                                                                                                                 {:buffer event.buf
                                                                                                                  :callback vim.lsp.buf.document_highlight})
                                                                                    (vim.api.nvim_create_autocmd [:CursorMoved
                                                                                                                  :CursorMovedI]
                                                                                                                 {:buffer event.buf
                                                                                                                  :callback vim.lsp.buf.clear_references})))
                                                                      :group (vim.api.nvim_create_augroup :kickstart-lsp-attach
                                                                                                          {:clear true})})
                                        (var capabilities
                                             (vim.lsp.protocol.make_client_capabilities))
                                        (set capabilities
                                             (vim.tbl_deep_extend :force
                                                                  capabilities
                                                                  ((. (require :cmp_nvim_lsp)
                                                                      :default_capabilities))))
                                        ((. (require :neodev) :setup))
                                        (local lspconfig (require :lspconfig))
                                        ((. lspconfig :clangd :setup) {:capabilities capabilities})
                                        ((. lspconfig :gopls :setup) {:capabilities capabilities})
                                        ((. lspconfig :lua_ls :setup) {:capabilities capabilities
                                                                      :settings {:Lua {:completion {:callSnippet :Replace}
                                                                      :runtime {:version :LuaJIT}
                                                                      :workspace {:checkThirdParty false
                                                                      :library ["${3rd}/luv/library"
                                                                                (unpack (vim.api.nvim_get_runtime_file ""
                                                                                                                       true))]}}}}))
                              :dependencies [:williamboman/mason.nvim
                                             :williamboman/mason-lspconfig.nvim
                                             :WhoIsSethDaniel/mason-tool-installer.nvim
                                             {1 :j-hui/fidget.nvim :opts {}}]}
                             {1 :stevearc/conform.nvim
                              :opts {:format_on_save {:lsp_fallback false
                                                      :timeout_ms 500}
                                     :formatters_by_ft {:lua [:stylua]}
                                     :notify_on_error false}}
                             {1 :hrsh7th/nvim-cmp
                              :config (fn []
                                        (local cmp (require :cmp))
                                        (local luasnip (require :luasnip))
                                        (luasnip.config.setup {})
                                        (cmp.setup {:completion {:completeopt "menu,menuone,noinsert"}
                                                    :mapping (cmp.mapping.preset.insert {:<C-Space> (cmp.mapping.complete {})
                                                                                         :<C-h> (cmp.mapping (fn []
                                                                                                               (when (luasnip.locally_jumpable (- 1))
                                                                                                                 (luasnip.jump (- 1))))
                                                                                                             [:i
                                                                                                              :s])
                                                                                         :<C-l> (cmp.mapping (fn []
                                                                                                               (when (luasnip.expand_or_locally_jumpable)
                                                                                                                 (luasnip.expand_or_jump)))
                                                                                                             [:i
                                                                                                              :s])
                                                                                         :<tab> (cmp.mapping.select_next_item)
                                                                                         :<S-tab> (cmp.mapping.select_prev_item)
                                                                                         :<CR> (cmp.mapping.confirm {:select true})})
                                                    :snippet {:expand (fn [args]
                                                                        (luasnip.lsp_expand args.body))}
                                                    :sources [{:name :nvim_lsp}
                                                              {:name :luasnip}
                                                              {:name :buffer}
                                                              {:name :path}]}))
                              :dependencies [{1 :L3MON4D3/LuaSnip
                                              :build ((fn []
                                                        (when (or (= (vim.fn.has :win32)
                                                                     1)
                                                                  (= (vim.fn.executable :make)
                                                                     0))
                                                          (lua "return "))
                                                        "make install_jsregexp"))}
                                             :saadparwaiz1/cmp_luasnip
                                             :hrsh7th/cmp-nvim-lsp
                                             :hrsh7th/cmp-path
                                             :hrsh7th/cmp-buffer
                                             {1 :hrsh7th/cmp-cmdline}]
                              :event :InsertEnter}
                             {1 :folke/tokyonight.nvim
                              :init (fn []
                                      ; (vim.cmd.colorscheme :tokyonight-night)
                                      (vim.cmd.hi "Comment gui=none"))
                              :priority 1000}
                             {1 :folke/todo-comments.nvim
                              :dependencies [:nvim-lua/plenary.nvim]
                              :event :VimEnter
                              :opts {:signs false}}
                             {1 :folke/trouble.nvim :dependencies [:nvim-tree/nvim-web-devicons] :opts {}}
                             {1 :echasnovski/mini.nvim
                              :config (fn []
                                        (local opts (fn []
                                                      (let [ai (require :mini.ai)]
                                                        {:custom_textobjects {
                                                         :U (ai.gen_spec.function_call {:name_pattern "[%w_]"})
                                                         :c (ai.gen_spec.treesitter {:a "@class.outer"
                                                                                    :i "@class.inner"}
                                                                                    {})
                                                         :d ["%f[%d]%d+"]
                                                         :e [["%u[%l%d]+%f[^%l%d]"
                                                              "%f[%S][%l%d]+%f[^%l%d]"
                                                              "%f[%P][%l%d]+%f[^%l%d]"
                                                              "^[%l%d]+%f[^%l%d]"]
                                                             "^().*()$"]
                                                         :f (ai.gen_spec.treesitter {:a "@function.outer"
                                                                                    :i "@function.inner"}
                                                                                    {})
                                                         :g (fn []
                                                              (local from {:col 1 :line 1})
                                                              (local to
                                                                     {:col (math.max (: (vim.fn.getline "$")
                                                                                        :len)
                                                                                     1)
                                                                     :line (vim.fn.line "$")})
                                                              {: from : to})
                                                         :o (ai.gen_spec.treesitter {:a ["@block.outer"
                                                                                         "@conditional.outer"
                                                                                         "@loop.outer"]
                                                                                    :i ["@block.inner"
                                                                                        "@conditional.inner"
                                                                                        "@loop.inner"]}
                                                                                    {})
                                                         :t ["<([%p%w]-)%f[^<%w][^<>]->.-</%1>"
                                                             "^<.->().*()</[^/]->$"]
                                                         :u (ai.gen_spec.function_call)}
                                                         :n_lines 500})))
                                        ((. (require :mini.ai) :setup) (opts))
                                        ((. (require :mini.diff) :setup))
                                        ((. (require :mini.surround) :setup))
                                        ((. (require :mini.basics) :setup))
                                        ((. (require :mini.starter) :setup))
                                        ((. (require :mini.indentscope) :setup))
                                        ((. (require :mini.misc) :setup))
                                        ((. (require :mini.extra) :setup))
                                        ((. (require :mini.sessions) :setup))
                                        ((. (require :mini.files) :setup))
                                        ((. (require :mini.notify) :setup))
                                        ((. (require :mini.bracketed) :setup))
                                        ((. (require :mini.splitjoin) :setup))
                                        ((. (require :mini.pick) :setup))
                                        (vim.keymap.set :n :<leader>sh
                                                        "<CMD>Pick help<CR>"
                                                        {:desc "[S]earch [H]elp"})
                                        (vim.keymap.set :n :<leader>sk
                                                        "<CMD>Pick keymaps<CR>"
                                                        {:desc "[S]earch [K]eymaps"})
                                        (vim.keymap.set :n :<leader>sf
                                                        "<CMD>Pick files<CR>"
                                                        {:desc "[S]earch [F]iles"})
                                        ; (vim.keymap.set :n :<leader>ss
                                        ;                 builtin.builtin
                                        ;                 {:desc "[S]earch [S]elect Telescope"})
                                        (vim.keymap.set :n :<leader>sw
                                                        "<CMD>Pick grep pattern='<cword>'<CR>"
                                                        {:desc "[S]earch current [W]ord"})
                                        (vim.keymap.set :n :<leader>sg
                                                        "<CMD>Pick grep_live<CR>"
                                                        {:desc "[S]earch by [G]rep"})
                                        (vim.keymap.set :n :<leader>sd
                                                        "<CMD>Pick diagnostic<CR>"
                                                        {:desc "[S]earch [D]iagnostics"})
                                        (vim.keymap.set :n :<leader>sr
                                                        "<CMD>Pick resume<CR>"
                                                        {:desc "[S]earch [R]esume"})
                                        (vim.keymap.set :n :<leader>s.
                                                        "<CMD>Pick oldfiles<CR>"
                                                        {:desc "[S]earch Recent Files (\".\" for repeat)"})
                                        (vim.keymap.set :n :<leader><leader>
                                                        "<CMD>Pick buffers<CR>"
                                                        {:desc "[ ] Find existing buffers"})
                                        (vim.keymap.set :n :<leader>/
                                                        "<CMD>Pick buf_lines<CR>"
                                                        {:desc "[/] Fuzzily search in current buffer"})
                                        ; (vim.keymap.set :n :<leader>s/
                                        ;                 (fn []
                                        ;                   (builtin.live_grep {:grep_open_files true
                                        ;                                       :prompt_title "Live Grep in Open Files"}))
                                        ;                 {:desc "[S]earch [/] in Open Files"})
                                        ; (vim.keymap.set :n :<leader>sn
                                        ;                 (fn []
                                        ;                   (builtin.find_files {:cwd (vim.fn.stdpath :config)}))
                                        ;                 {:desc "[S]earch [N]eovim files"})
                                        (vim.keymap.set :n :<leader>.
                                                        (fn []
                                                          (MiniFiles.open (vim.api.nvim_buf_get_name 0) false))
                                                        {:desc "[.] Search Files in buffer CWD"})
                                        ((. (require :mini.jump) :setup))
                                        (local statusline
                                               (require :mini.statusline))
                                        (statusline.setup {:use_icons vim.g.have_nerd_font})
                                        (set statusline.section_location
                                             (fn [] "%2l:%-2v"))
                                        (local ns-mini-files (vim.api.nvim_create_namespace :mini_files_git))
                                        (local autocmd vim.api.nvim_create_autocmd)
                                        (local (_ Mini-files) (pcall require :mini.files))
                                        (var git-status-cache {})
                                        (local cache-timeout 2000)
                                        (fn map-symbols [status]
                                        (let [status-map {" M" {:hlGroup :MiniDiffSignChange :symbol "•"}
                                                          :!! {:hlGroup :MiniDiffSignChange :symbol "!"}
                                                          :?? {:hlGroup :MiniDiffSignDelete :symbol "?"}
                                                          "A " {:hlGroup :MiniDiffSignAdd :symbol "+"}
                                                          :AA {:hlGroup :MiniDiffSignAdd :symbol "≈"}
                                                          :AD {:hlGroup :MiniDiffSignChange :symbol "-•"}
                                                          :AM {:hlGroup :MiniDiffSignChange :symbol "⊕"}
                                                          "D " {:hlGroup :MiniDiffSignDelete :symbol "-"}
                                                          "M " {:hlGroup :MiniDiffSignChange :symbol "✹"}
                                                          :MM {:hlGroup :MiniDiffSignChange :symbol "≠"}
                                                          "R " {:hlGroup :MiniDiffSignChange :symbol "→"}
                                                          "U " {:hlGroup :MiniDiffSignChange :symbol "‖"}
                                                          :UA {:hlGroup :MiniDiffSignAdd :symbol "⊕"}
                                                          :UU {:hlGroup :MiniDiffSignAdd :symbol "⇄"}}
                                              result (or (. status-map status) {:hlGroup :NonText :symbol "?"})]
                                          (values result.symbol result.hlGroup)))
                                        (fn fetch-git-status [cwd callback]
                                        (let [stdout ((. (or vim.uv vim.loop) :new_pipe) false)]
                                          (var (handle pid) nil)
                                          (set (handle pid)
                                               ((. (or vim.uv vim.loop) :spawn) :git
                                                                                {:args [:status
                                                                                        :--ignored
                                                                                        :--porcelain]
                                                                                 : cwd
                                                                                 :stdio [nil stdout nil]}
                                                                                (vim.schedule_wrap (fn [code signal]
                                                                                                     (if (= code 0)
                                                                                                         (stdout:read_start (fn [err
                                                                                                                                 content]
                                                                                                                              (when content
                                                                                                                                (callback content)
                                                                                                                                (set vim.g.content
                                                                                                                                     content))
                                                                                                                              (stdout:close)))
                                                                                                         (do
                                                                                                           (vim.notify (.. "Git command failed with exit code: "
                                                                                                                           code)
                                                                                                                       vim.log.levels.ERROR)
                                                                                                           (stdout:close)))))))))
                                        (fn escape-pattern [str] (str:gsub "([%^%$%(%)%%%.%[%]%*%+%-%?])" "%%%1"))
                                        (fn update-mini-with-git [buf-id git-status-map]
                                        (vim.schedule (fn []
                                                        (let [nlines (vim.api.nvim_buf_line_count buf-id)
                                                              cwd (vim.fn.getcwd)]
                                                          (var escapedcwd (escape-pattern cwd))
                                                          (when (= (vim.fn.has :win32) 1)
                                                            (set escapedcwd (escapedcwd:gsub "\\" "/")))
                                                          (for [i 1 nlines]
                                                            (local entry (Mini-files.get_fs_entry buf-id i))
                                                            (when (not entry) (lua :break))
                                                            (local relative-path
                                                                   (entry.path:gsub (.. "^" escapedcwd "/") ""))
                                                            (local status (. git-status-map relative-path))
                                                            (if status
                                                                (let [(symbol hl-group) (map-symbols status)]
                                                                  (vim.api.nvim_buf_set_extmark buf-id ns-mini-files
                                                                                                (- i 1) 0
                                                                                                {:priority 2
                                                                                                 :sign_hl_group hl-group
                                                                                                 :sign_text symbol}))
                                                                (do
                                                                  )))))))
                                        (fn is-valid-git-repo []
                                        (when (= (vim.fn.isdirectory :.git) 0) (lua "return false"))
                                        true)
                                        (fn parse-git-status [content]
                                        (let [git-status-map {}]
                                          (each [line (content:gmatch "[^\r\n]+")]
                                            (local (status file-path) (string.match line "^(..)%s+(.*)"))
                                            (local parts {})
                                            (each [part (file-path:gmatch "[^/]+")] (table.insert parts part))
                                            (var current-key "")
                                            (each [i part (ipairs parts)]
                                              (if (> i 1) (set current-key (.. current-key "/" part))
                                                  (set current-key part))
                                              (if (= i (length parts)) (tset git-status-map current-key status)
                                                  (when (not (. git-status-map current-key))
                                                    (tset git-status-map current-key status)))))
                                          git-status-map))
                                        (fn update-git-status [buf-id]
                                        (when (not (is-valid-git-repo)) (lua "return "))
                                        (local cwd (vim.fn.expand "%:p:h"))
                                        (local current-time (os.time))
                                        (if (and (. git-status-cache cwd)
                                                 (< (- current-time (. (. git-status-cache cwd) :time)) cache-timeout))
                                            (update-mini-with-git buf-id (. (. git-status-cache cwd) :statusMap))
                                            (fetch-git-status cwd
                                                              (fn [content]
                                                                (let [git-status-map (parse-git-status content)]
                                                                  (tset git-status-cache cwd
                                                                        {:statusMap git-status-map
                                                                         :time current-time})
                                                                  (update-mini-with-git buf-id git-status-map))))))
                                        (fn clear-cache [] (set git-status-cache {}))
                                        (fn augroup [name]
                                        (vim.api.nvim_create_augroup (.. :MiniFiles_ name) {:clear true}))
                                        (autocmd :User {:callback (fn [] (local bufnr (vim.api.nvim_get_current_buf))
                                                                  (update-git-status bufnr))
                                                      :group (augroup :start)
                                                      :pattern :MiniFilesExplorerOpen})
                                        (autocmd :User {:callback (fn [] (clear-cache))
                                                      :group (augroup :close)
                                                      :pattern :MiniFilesExplorerClose})
                                        (autocmd :User {:callback (fn [sii]
                                                                  (local bufnr sii.data.buf_id)
                                                                  (local cwd (vim.fn.expand "%:p:h"))
                                                                  (when (. git-status-cache cwd)
                                                                    (update-mini-with-git bufnr
                                                                                          (. (. git-status-cache cwd)
                                                                                             :statusMap))))
                                                      :group (augroup :update)
                                                      :pattern :MiniFilesBufferUpdate}))}
                             {1 :nvim-treesitter/nvim-treesitter
                              :build ":TSUpdate"
                              :config (fn [_ opts]
                                        ((. (require :nvim-treesitter.configs)
                                            :setup) opts))
                              :opts {:auto_install true
                                     :ensure_installed [:bash
                                                        :c
                                                        :python
                                                        :html
                                                        :xml
                                                        :lua
                                                        :fennel
                                                        :markdown
                                                        :tcl
                                                        :vim
                                                        :vimdoc]
                                     :highlight {:enable true}
                                     :indent {:enable true}}}
                             :junegunn/fzf
                             :junegunn/fzf.vim
                             {1 :p00f/clangd_extensions.nvim
                              :config (fn [])
                              :lazy true
                              :opts {:extensions {:ast {:kind_icons {:Compound ""
                                                                     :PackExpansion ""
                                                                     :Recovery ""
                                                                     :TemplateParamObject ""
                                                                     :TemplateTemplateParm ""
                                                                     :TemplateTypeParm ""
                                                                     :TranslationUnit ""}
                                                        :role_icons {:declaration ""
                                                                     :expression ""
                                                                     :specifier ""
                                                                     :statement ""
                                                                     "template argument" ""
                                                                     :type ""}}
                                                  :inlay_hints {:inline false}}}}
                             :vim-pandoc/vim-pandoc
                             :vim-pandoc/vim-pandoc-syntax
                             :gabrielpoca/replacer.nvim
                             {1 :dhananjaylatkar/cscope_maps.nvim
                              :dependencies [:nvim-tree/nvim-web-devicons]
                              :opts {:prefix :<C-c>}}
                             {1 :coffebar/transfer.nvim
                              :cmd [:TransferInit
                                    :DiffRemote
                                    :TransferUpload
                                    :TransferDownload
                                    :TransferDirDiff
                                    :TransferRepeat]
                              :lazy true
                              :opts {}}
                             {1 :linrongbin16/gentags.nvim
                              :config (fn []
                                        ((. (require :gentags) :setup)))}
                             {1 :carbon-steel/detour.nvim
                              :config (fn [] (vim.keymap.set :n :<c-w><cr> ":Detour<cr>"))}
                             {1 :akinsho/git-conflict.nvim :config true :version "*"}
                             :nvim-pack/nvim-spectre
                             {1 :chentoast/marks.nvim
                              :config (fn []
                                        (let [marks (require :marks)] (marks.setup)))}
                             :sindrets/diffview.nvim
                             :radenling/vim-dispatch-neovim
                             :tpope/vim-abolish
                             :tpope/vim-dispatch
                             :tpope/vim-eunuch
                             :tpope/vim-fugitive
                             :tpope/vim-repeat
                             :onsails/lspkind.nvim
                             {1 :yorickpeterse/nvim-pqf
                              :config (fn []
                                        (let [pqf (require :pqf)] (pqf.setup)))}
                             :kevinhwang91/nvim-bqf
                             {1 :max397574/better-escape.nvim
                              :config (fn []
                                        (let [better-escape (require :better_escape)] (better-escape.setup)))}
                             {1 :cbochs/portal.nvim
                              :dependencies [:cbochs/grapple.nvim :ThePrimeagen/harpoon]}
                             {1 :stevearc/aerial.nvim
                              :dependencies [:nvim-treesitter/nvim-treesitter :nvim-tree/nvim-web-devicons]
                              :opts {}}
                             :hiphish/rainbow-delimiters.nvim
                             {1 :romgrk/barbar.nvim
                              :dependencies [:lewis6991/gitsigns.nvim :nvim-tree/nvim-web-devicons]
                              :init (fn [] (set vim.g.barbar_auto_setup true))
                              :opts {}}
                             :jlanzarotta/bufexplorer
                             :sindrets/winshift.nvim
                             :mrjones2014/smart-splits.nvim
                             {1 :anuvyklack/windows.nvim
                              :dependencies [:anuvyklack/middleclass :anuvyklack/animation.nvim]
                              :init (fn []
                                      (set vim.o.winwidth 10)
                                      (set vim.o.winminwidth 10)
                                      (set vim.o.equalalways false)
                                      ((. (require :windows) :setup)))}
                             {1 :nvimdev/lspsaga.nvim
                              :config (fn []
                                        ((. (require :lspsaga) :setup) {}))
                              :dependencies [:nvim-treesitter/nvim-treesitter :nvim-tree/nvim-web-devicons]}
                             :EdenEast/nightfox.nvim
                             {1 :danymat/neogen :config true}
                             :cshuaimin/ssr.nvim
                             :samharju/synthweave.nvim
                             {1 :jiaoshijie/undotree
                              :config true
                              :dependencies :nvim-lua/plenary.nvim
                              :keys [[:<leader>u "<cmd>lua require('undotree').toggle()<cr>"]]}
                             {1 :RaafatTurki/hex.nvim
                              :config (fn []
                                        (. (require :hex) :setup)
                                        (vim.keymap.set :n :<leader>hx
                                                         (fn [] (. (require :hex) :toggle))
                                                         {:desc "Toggle [h]e[x] edit mode"}))}
                             {1 :linrongbin16/fzfx.nvim
                              :config (fn []
                                        ((. (require :fzfx) :setup)))
                              :dependencies [:nvim-tree/nvim-web-devicons :junegunn/fzf]}
                             {1 :eldritch-theme/eldritch-nvim
                              :config (fn [opts]
                                        (local eldritch (require :eldritch))
                                        (eldritch.setup opts))
                              :opts {}
                              :priority 1000}
                             ; {1 :nvim-neorg/neorg
                             ;  :config true
                             ;  :dependencies [:luarocks.nvim]
                             ;  :lazy false
                             ;  :version "*"}
                             {1 :kevinm6/kurayami.nvim
                              :config (fn [] 
                                        ;; (vim.cmd.colorscheme :kurayami)
                                        )
                              :event :VimEnter
                              :priority 1000}
                             :habamax/vim-asciidoctor
                             {1 :nvimtools/hydra.nvim :config (fn []
                                                                (local Hydra (require :hydra))
                                                                (local gitsigns (require :gitsigns))
                                                                (local hint " _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
")
                                                                (Hydra {:body :<leader>G
                                                                        :config {:buffer bufnr
                                                                                 :color :pink
                                                                                 :hint {}
                                                                                 :invoke_on_body true
                                                                                 :on_enter (fn [] (vim.cmd :mkview)
                                                                                             (vim.cmd "silent! %foldopen!")
                                                                                             (set vim.bo.modifiable false)
                                                                                             (gitsigns.toggle_signs true)
                                                                                             (gitsigns.toggle_linehl true))
                                                                                 :on_exit (fn []
                                                                                            (local cursor-pos (vim.api.nvim_win_get_cursor 0))
                                                                                            (vim.cmd :loadview)
                                                                                            (vim.api.nvim_win_set_cursor 0 cursor-pos)
                                                                                            (vim.cmd "normal zv")
                                                                                            (gitsigns.toggle_signs false)
                                                                                            (gitsigns.toggle_linehl false)
                                                                                            (gitsigns.toggle_deleted false))}
                                                                        :heads [[:J
                                                                                 (fn []
                                                                                   (when vim.wo.diff (lua "return \"]c\""))
                                                                                   (vim.schedule (fn [] (gitsigns.next_hunk)))
                                                                                   :<Ignore>)
                                                                                 {:desc "next hunk" :expr true}]
                                                                                [:K
                                                                                 (fn []
                                                                                   (when vim.wo.diff (lua "return \"[c\""))
                                                                                   (vim.schedule (fn [] (gitsigns.prev_hunk)))
                                                                                   :<Ignore>)
                                                                                 {:desc "prev hunk" :expr true}]
                                                                                [:s
                                                                                 ":Gitsigns stage_hunk<CR>"
                                                                                 {:desc "stage hunk" :silent true}]
                                                                                [:u gitsigns.undo_stage_hunk {:desc "undo last stage"}]
                                                                                [:S gitsigns.stage_buffer {:desc "stage buffer"}]
                                                                                [:p gitsigns.preview_hunk {:desc "preview hunk"}]
                                                                                [:d
                                                                                 gitsigns.toggle_deleted
                                                                                 {:desc "toggle deleted" :nowait true}]
                                                                                [:b gitsigns.blame_line {:desc :blame}]
                                                                                [:B
                                                                                 (fn [] (gitsigns.blame_line {:full true}))
                                                                                 {:desc "blame show full"}]
                                                                                ["/" gitsigns.show {:desc "show base file" :exit true}]
                                                                                [:<Enter> :<Cmd>Git<CR> {:desc :Neogit :exit true}]
                                                                                [:q nil {:desc :exit :exit true :nowait true}]]
                                                                        :hint hint
                                                                        :mode [:n :x]
                                                                        :name :Git}))}
                             {1 :grapp-dev/nui-components.nvim :dependencies [:MunifTanjim/nui.nvim]}
                             {1 :vhyrro/luarocks.nvim :config true :priority 1000}
                             :vimwiki/vimwiki
                             :junegunn/fzf-git.sh
                             {1 :ibhagwan/fzf-lua
                              :config (fn []
                                        ;((. (require :fzf-lua) :setup) {}))
                                        )
                              :dependencies [:nvim-tree/nvim-web-devicons]}
                             {1 :nvim-orgmode/orgmode
                              :config (fn []
                                        ((. (require :orgmode) :setup) {:org_agenda_files "~/orgfiles/**/*"
                                                                        :org_default_notes_file "~/orgfiles/refile.org"}))
                              :event :VeryLazy
                              :ft [:org]}
                             {1 :chipsenkbeil/org-roam.nvim
                              :config (fn []
                                        ((. (require :org-roam) :setup) {:directory "~/orgfiles"}))
                              :dependencies [{1 :nvim-orgmode/orgmode}]
                              :tag :0.1.0}
                             {1 :franbach/miramare}
                             {1 :ray-x/go.nvim
                              :build ":lua require(\"go.install\").update_all_sync()"
                              :config (fn []
                                        ((. (require :go) :setup)))
                              :dependencies [:ray-x/guihua.lua
                                             :neovim/nvim-lspconfig
                                             :nvim-treesitter/nvim-treesitter]
                              :event [:CmdlineEnter]
                              :ft [:go :gomod]}
                            ])
(local cmp (require :cmp))
(cmp.setup.cmdline ["/" "?"] {:mapping (cmp.mapping.preset.cmdline)
                   :sources [{:name :buffer}]})
(cmp.setup.cmdline ":"
                   {:mapping (cmp.mapping.preset.cmdline)
                   :sources (cmp.config.sources [{:name :path}]
                                                [{:name :cmdline
                                                        :option {:ignore_cmds [:Man
                                                                                "!"]}}])})

(vim.keymap.set [:n :t] :<A-i> "<CMD>Lspsaga term_toggle<CR>" {:desc "Move focus to the upper window"})
(vim.cmd.colorscheme :miramare)
