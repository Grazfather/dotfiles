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

(fn set! [name value ...]
  "Set a vim opt to an explicit value"
  (when (not (= nil name))
    (let [name (tostring name)]
      `(do (tset vim.opt ,name ,value) ,(set! ...)))))

(fn set-toggle! [name ...]
  "Toggle the value of a vim opt"
  (when (not (= nil name))
    (let [name (tostring name)]
      `(do (tset vim.opt ,name (not (get? ,name))) ,(set-toggle! ...)))))

(fn set-append! [name value ...]
  "Append a value to a vim opt"
  (when (not (= nil name))
    (let [name (tostring name)]
      `(do (: (. vim.opt ,name) :append ,value) ,(set-append! ...)))))

(fn set-true! [name ...]
  "Set a vim opt to true"
  (when (not (= nil name))
    (let [name (tostring name)]
      `(do (tset vim.opt ,name true) ,(set-true! ...)))))

(fn set-false! [name ...]
  "Set a vim opt to false"
  (when (not (= nil name))
    (let [name (tostring name)]
      `(do (tset vim.opt ,name false) ,(set-false! ...)))))

(fn map!- [modes keys cmd options]
  (let [modes (tostring modes)
        keys (tostring keys)]
    `(do
       ,(unpack (icollect [mode (string.gmatch modes ".")]
                          `(vim.api.nvim_set_keymap ,mode ,keys ,cmd ,options))))))

(fn map! [modes keys cmd ...]
  (when (not (= nil modes))
    `(do ,(map!- modes keys cmd {})
         ,(map! ...))))

(fn nmap! [keys cmd ...]
  (when (not (= nil keys))
    `(do ,(map!- "n" keys cmd {})
         ,(nmap! ...))))

(fn noremap! [modes keys cmd ...]
  (when (not (= nil modes))
    `(do ,(map!- modes keys cmd {:noremap true})
         ,(noremap! ...))))

(fn nnoremap! [keys cmd ...]
  (when (not (= nil keys))
    `(do ,(map!- "n" keys cmd {:noremap true})
         ,(nnoremap! ...))))

{: get?
 : let!
 : set!
 : set-toggle!
 : set-append!
 : set-true!
 : set-false!
 : map!
 : nmap!
 : noremap!
 : nnoremap! }