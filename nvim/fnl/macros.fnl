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
  res
  )

(fn get? [name]
  "Get the value of a vim opt"
  (let [name (tostring name)]
    `(let [(ok?# value#) (pcall #(: (. vim.opt ,name) :get))]
       (if ok?# value# nil))))

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

(fn call-module-func [m method ...]
  "Call a module's specified function if the module can be imported."
  (assert-compile (= :string (type m)) "expected string for module name" m)
  (assert-compile (= :string (type method)) "expected string for function name" m)
  `((. (require ,m) ,method) ,...))

(fn setup [m ...]
  "Call a module's setup function if the module can be imported."
  (call-module-func m :setup ...))

{: get?
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
 : setup}
