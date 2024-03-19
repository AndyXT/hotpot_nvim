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
                                             :topdelete {:text "‾"}}}}
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
                                        (vim.keymap.set :n :<leader>sh
                                                        builtin.help_tags
                                                        {:desc "[S]earch [H]elp"})
                                        (vim.keymap.set :n :<leader>sk
                                                        builtin.keymaps
                                                        {:desc "[S]earch [K]eymaps"})
                                        (vim.keymap.set :n :<leader>sf
                                                        builtin.find_files
                                                        {:desc "[S]earch [F]iles"})
                                        (vim.keymap.set :n :<leader>ss
                                                        builtin.builtin
                                                        {:desc "[S]earch [S]elect Telescope"})
                                        (vim.keymap.set :n :<leader>sw
                                                        builtin.grep_string
                                                        {:desc "[S]earch current [W]ord"})
                                        (vim.keymap.set :n :<leader>sg
                                                        builtin.live_grep
                                                        {:desc "[S]earch by [G]rep"})
                                        (vim.keymap.set :n :<leader>sd
                                                        builtin.diagnostics
                                                        {:desc "[S]earch [D]iagnostics"})
                                        (vim.keymap.set :n :<leader>sr
                                                        builtin.resume
                                                        {:desc "[S]earch [R]esume"})
                                        (vim.keymap.set :n :<leader>s.
                                                        builtin.oldfiles
                                                        {:desc "[S]earch Recent Files (\".\" for repeat)"})
                                        (vim.keymap.set :n :<leader><leader>
                                                        builtin.buffers
                                                        {:desc "[ ] Find existing buffers"})
                                        (vim.keymap.set :n :<leader>/
                                                        (fn []
                                                          (builtin.current_buffer_fuzzy_find ((. (require :telescope.themes)
                                                                                                 :get_dropdown) {:previewer false
                                                                                                 :winblend 10})))
                                                        {:desc "[/] Fuzzily search in current buffer"})
                                        (vim.keymap.set :n :<leader>s/
                                                        (fn []
                                                          (builtin.live_grep {:grep_open_files true
                                                                              :prompt_title "Live Grep in Open Files"}))
                                                        {:desc "[S]earch [/] in Open Files"})
                                        (vim.keymap.set :n :<leader>sn
                                                        (fn []
                                                          (builtin.find_files {:cwd (vim.fn.stdpath :config)}))
                                                        {:desc "[S]earch [N]eovim files"})
                                        (vim.keymap.set :n :<leader>.
                                                        (fn []
                                                          ; (builtin.find_files {:search_dirs [(vim.api.nvim_buf_get_name 0)]}))
                                                          (MiniFiles.open (vim.api.nvim_buf_get_name 0) false))
                                                        {:desc "[.] Search Files in buffer CWD"}))
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
                                                                                       (. (require :telescope.builtin)
                                                                                          :lsp_definitions)
                                                                                       "[G]oto [D]efinition")
                                                                                  (map :gr
                                                                                       (. (require :telescope.builtin)
                                                                                          :lsp_references)
                                                                                       "[G]oto [R]eferences")
                                                                                  (map :gI
                                                                                       (. (require :telescope.builtin)
                                                                                          :lsp_implementations)
                                                                                       "[G]oto [I]mplementation")
                                                                                  (map :<leader>D
                                                                                       (. (require :telescope.builtin)
                                                                                          :lsp_type_definitions)
                                                                                       "Type [D]efinition")
                                                                                  (map :<leader>ds
                                                                                       (. (require :telescope.builtin)
                                                                                          :lsp_document_symbols)
                                                                                       "[D]ocument [S]ymbols")
                                                                                  (map :<leader>ws
                                                                                       (. (require :telescope.builtin)
                                                                                          :lsp_dynamic_workspace_symbols)
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
                                        (local servers
                                               {:lua_ls {:settings {:Lua {:completion {:callSnippet :Replace}
                                                                          :runtime {:version :LuaJIT}
                                                                          :workspace {:checkThirdParty false
                                                                                      :library ["${3rd}/luv/library"
                                                                                                (unpack (vim.api.nvim_get_runtime_file ""
                                                                                                                                       true))]}}}}
                                                :clangd {}})
                                        ((. (require :mason) :setup))
                                        (local ensure-installed
                                               (vim.tbl_keys (or servers {})))
                                        (vim.list_extend ensure-installed
                                                         [:stylua])
                                        ((. (require :mason-tool-installer)
                                            :setup) {:ensure_installed ensure-installed})
                                        ((. (require :mason-lspconfig) :setup) {:handlers [(fn [server-name]
                                                                                             (local server
                                                                                                    (or (. servers
                                                                                                           server-name)
                                                                                                        {}))
                                                                                             (set server.capabilities
                                                                                                  (vim.tbl_deep_extend :force
                                                                                                                       {}
                                                                                                                       capabilities
                                                                                                                       (or server.capabilities
                                                                                                                           {})))
                                                                                             ((. (. (require :lspconfig)
                                                                                                    server-name)
                                                                                                 :setup) server))]}))
                              :dependencies [:williamboman/mason.nvim
                                             :williamboman/mason-lspconfig.nvim
                                             :WhoIsSethDaniel/mason-tool-installer.nvim
                                             {1 :j-hui/fidget.nvim :opts {}}]}
                             {1 :stevearc/conform.nvim
                              :opts {:format_on_save {:lsp_fallback true
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
                                                                                         :<C-n> (cmp.mapping.select_next_item)
                                                                                         :<C-p> (cmp.mapping.select_prev_item)
                                                                                         :<C-y> (cmp.mapping.confirm {:select true})})
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
                                      (vim.cmd.colorscheme :tokyonight-night)
                                      (vim.cmd.hi "Comment gui=none"))
                              :priority 1000}
                             {1 :folke/todo-comments.nvim
                              :dependencies [:nvim-lua/plenary.nvim]
                              :event :VimEnter
                              :opts {:signs false}}
                             {1 :echasnovski/mini.nvim
                              :config (fn []
                                        ((. (require :mini.ai) :setup) {:n_lines 500})
                                        ((. (require :mini.surround) :setup))
                                        ((. (require :mini.starter) :setup))
                                        ((. (require :mini.indentscope) :setup))
                                        ((. (require :mini.misc) :setup))
                                        ((. (require :mini.extra) :setup))
                                        ((. (require :mini.sessions) :setup))
                                        ((. (require :mini.files) :setup))
                                        ((. (require :mini.notify) :setup))
                                        ((. (require :mini.bracketed) :setup))
                                        ((. (require :mini.splitjoin) :setup))
                                        ((. (require :mini.jump) :setup))
                                        (local statusline
                                               (require :mini.statusline))
                                        (statusline.setup {:use_icons vim.g.have_nerd_font})
                                        (set statusline.section_location
                                             (fn [] "%2l:%-2v")))}
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
