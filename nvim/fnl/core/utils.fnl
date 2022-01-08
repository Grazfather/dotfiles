(module core.utils)

(fn call-module-setup
  [m ...]
  "Call a module's setup function if the module can be imported."
  (let [(ok? mod) (pcall require m) ]
    (if ok?
      (-?> mod
           (. :setup)
           ((fn [f ...] (f ...)) ...))
      (print "Could not import module " m))))

{: call-module-setup}
