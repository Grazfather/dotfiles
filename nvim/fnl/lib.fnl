(fn seq?
  [tbl]
  (~= (. tbl 1) nil))

(fn seq
  [tbl]
  (if (seq? tbl)
    (ipairs tbl)
    (pairs tbl)))

(fn reduce
  [f acc tbl]
  (accumulate [acc acc
               k v (seq tbl)]
    (f acc v k)))

(fn merge [& tbls]
  (reduce
    (fn [merged tbl]
      (each [k v (pairs tbl)]
        (tset merged k v))
      merged)
    {}
    tbls))

{: seq?
 : seq
 : reduce
 : merge}
