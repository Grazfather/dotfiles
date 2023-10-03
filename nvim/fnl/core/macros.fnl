;; [nfnl-macro]
(fn partition [n seq]
  (var temp [])
  (var res [])
  (each [i v (ipairs seq)]
    (table.insert temp v)
    (when (= (length temp) n)
      (table.insert res temp)
      (set temp [])))
  (when (~= (length temp) 0)
    (table.insert res (icollect [_ v (ipairs temp)] v)))
  res)

(fn get? [name]
  "Get the value of a vim opt"
  (let [name (tostring name)]
    `(let [(ok?# value#) (pcall #(: (. vim.opt ,name) :get))]
       (if ok?# value# nil))))

(fn let! [name value ...]
  "Set vim variable with vim.[g b w t]"
  (when (not (= nil name))
    (let [name (tostring name)
          scope (if (> (length (icollect [_ v (ipairs ["g/" "b/" "w/" "t/"])]
                                         (when (= (name:sub 1 2) v) v))) 0)
                  (name:sub 1 1)
                  nil)
          name (if (= nil scope) name (name:sub 3))]
      (match scope
        "g" `(do (tset vim.g ,name ,value) ,(let! ...))
        "b" `(do (tset vim.b ,name ,value) ,(let! ...))
        "w" `(do (tset vim.w ,name ,value) ,(let! ...))
        "t" `(do (tset vim.t ,name ,value) ,(let! ...))
        _ `(do (tset vim.g ,name ,value) ,(let! ...))))))

(fn set! [...]
  "Set vim opts to explicit values"
  `(do ,(unpack (icollect [_ [name value] (ipairs (partition 2 [...]))]
                  `(tset vim.opt ,(tostring name) ,value)))))

(fn set-toggle! [...]
  "Toggle the values of specified opts"
  `(do ,(unpack (icollect [_ name (ipairs [...])]
                  `(tset vim.opt ,(tostring name) (not (get? ,name)))))))

(fn set-append! [...]
  "Append each value to each vim opt"
  `(do ,(unpack (icollect [_ [name value] (ipairs (partition 2 [...]))]
                  `(: (. vim.opt ,(tostring name)) :append ,value)))))

(fn set-true! [...]
  "Set each vim opt to true"
  `(do ,(unpack (icollect [_ name (ipairs [...])]
                  `(tset vim.opt ,(tostring name) true)))))

(fn set-false! [...]
  "Set each vim opt to false"
  `(do ,(unpack (icollect [_ name (ipairs [...])]
                  `(tset vim.opt ,(tostring name) false)))))

(fn map!- [modes keys cmd options]
  (let [modes (tostring modes)
        keys (tostring keys)]
    ; Don't bother with gensym if the cmd is a string
    (if (= :string (type cmd))
      (icollect [mode (string.gmatch modes ".")]
        `(vim.keymap.set ,mode ,keys ,cmd ,options))
      `(let [cmd# ,cmd]
         ,(unpack (icollect [mode (string.gmatch modes ".")]
                    `(vim.keymap.set ,mode ,keys cmd# ,options)))))))

(fn map! [modes keys cmd ...]
  (when (not (= nil modes))
    `(do ,(map!- modes keys cmd {:remap true})
         ,(map! ...))))

(fn nmap! [keys cmd ...]
  (when (not (= nil keys))
    `(do ,(map!- "n" keys cmd {:remap true})
         ,(nmap! ...))))

(fn descnmap! [desc keys cmd ...]
  (when (not (= nil keys))
    `(do ,(map!- "n" keys cmd {:desc desc :remap true})
         ,(descnmap! ...))))

(fn noremap! [modes keys cmd ...]
  (when (not (= nil modes))
    `(do ,(map!- modes keys cmd {})
         ,(noremap! ...))))

(fn nnoremap! [keys cmd ...]
  (when (not (= nil keys))
    `(do ,(map!- "n" keys cmd {})
         ,(nnoremap! ...))))

(fn call-module-func
  [m method ...]
  "Call a module's specified function if the module can be imported."
  (assert-compile (= :string (type m)) "expected string for module name" m)
  (assert-compile (= :string (type method)) "expected string for function name" m)
  `((. (require ,m) ,method) ,...))

(fn setup
  [m ...]
  "Call a module's setup function if the module can be imported."
  (call-module-func m :setup ...))

(fn autocmd [event opt]
  `(vim.api.nvim_create_autocmd
    ,event ,opt))

(fn autocmds [...]
  (var form `(do))
  (each [_ v (ipairs [...])]
    (table.insert form (autocmd (unpack v))))
  (table.insert form 'nil)
  form)

(fn augroup [name ...]
  (var cmds `(do))
  (var group (sym :group))
  (each [_ v (ipairs [...])]
    (let [(event opt) (unpack v)]
      (tset opt :group group)
      (table.insert cmds (autocmd event opt))))
  (table.insert cmds 'nil)
  `(let [,group
         (vim.api.nvim_create_augroup ,name {:clear true})]
     ,cmds))

{: get?
 : let!
 : set!
 : set-toggle!
 : set-append!
 : set-true!
 : set-false!
 : map!
 : nmap!
 : descnmap!
 : noremap!
 : nnoremap!
 : call-module-func
 : setup
 : autocmd
 : autocmds
 : augroup}
