(fn partition [n seq]
  (let [res []]
    (for [i 1 (length seq) n]
      (let [temp []]
        (for [j 0 (- n 1)]
          (let [v (. seq (+ i j))]
            (when (~= v nil)
              (table.insert temp v))))
        (when (> (length temp) 0)
          (table.insert res temp))))
    res))

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

(fn parse-map-args [default-options args]
  (let [last-idx (length args)
        last (. args last-idx)
        has-options? (and (> last-idx 0)
                          (= :table (type last))
                          (not (. last 1)))
        options (if has-options? last default-options)
        remaining (if has-options?
                    (let [r []]
                      (for [i 1 (- last-idx 1)] (table.insert r (. args i)))
                      r)
                    args)]
    [options remaining]))

(fn xmap! [modes ...]
  (let [args [...]
        [options remaining] (parse-map-args {:remap true} args)]
    `(do ,(unpack (icollect [_ [keys cmd] (ipairs (partition 2 remaining))]
                    (map!- modes keys cmd options))))))

(fn map! [...]
  (let [args [...]
        [options remaining] (parse-map-args {:remap true} args)]
    `(do ,(unpack (icollect [_ [modes keys cmd] (ipairs (partition 3 remaining))]
                    (map!- modes keys cmd options))))))

(fn cmap! [...] (xmap! "c" ...))
(fn imap! [...] (xmap! "i" ...))
(fn nmap! [...] (xmap! "n" ...))

(fn descxmap! [modes ...]
  (let [args [...]
        [options remaining] (parse-map-args {:remap true} args)]
    `(do ,(unpack (icollect [_ [desc keys cmd] (ipairs (partition 3 remaining))]
                    (let [opts (let [t {}]
                                 (each [k v (pairs options)] (tset t k v))
                                 (tset t :desc desc)
                                 t)]
                      (map!- modes keys cmd opts)))))))

(fn descnmap! [...]
  (descxmap! "n" ...))

(fn xnoremap! [modes ...]
  (let [args [...]
        [options remaining] (parse-map-args {} args)]
    `(do ,(unpack (icollect [_ [keys cmd] (ipairs (partition 2 remaining))]
                    (map!- modes keys cmd options))))))

(fn nnoremap! [...]
  (xnoremap! "n" ...))

(fn keys! [...]
  "Generate lazy.nvim :keys table entries.
   Usage: (keys! desc mode keys cmd desc2 mode2 keys2 cmd2 ...)"
  (let [res []]
    (each [_ [desc mode keys cmd] (ipairs (partition 4 [...]))]
      (table.insert res {1 (tostring keys) 2 cmd :desc desc :mode mode}))
    res))

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
 : xmap!
 : map!
 : cmap!
 : imap!
 : nmap!
 : descxmap!
 : descnmap!
 : xnoremap!
 : nnoremap!
 : keys!
 : call-module-func
 : setup}
