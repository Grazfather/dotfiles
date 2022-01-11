(module core.utils)

(fn call-module-method
  [m method ...]
  "Call a module's specified method if the module can be imported."
  (let [(ok? mod) (pcall require m) ]
    (if ok?
      (-?> mod
           (. method)
           ((fn [f ...] (f ...)) ...))
      (print "Could not import module " m))))

(fn call-module-setup
  [m ...]
  "Call a module's setup function if the module can be imported."
  (call-module-method m :setup ...))

{: call-module-method
 : call-module-setup}
