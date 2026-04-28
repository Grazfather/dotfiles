(fn collect-deleteme-markers [lines]
  (accumulate [pairs [[] []]
               i line (ipairs lines)]
    (match [(string.match line "DELETEME>>")
            (string.match line "DELETEME<<")]
      [nil nil] pairs
      [_ nil] [(doto (. pairs 1) (table.insert i)) (. pairs 2)]
      [nil _] [(. pairs 1) (doto (. pairs 2) (table.insert i))]
      [_ _] [(doto (. pairs 1) (table.insert i))
             (doto (. pairs 2) (table.insert i))])))

(fn should-keep-line? [line i [start-indices end-indices]]
  "Predicate to determine if a line should be kept. It should be kept if:
   - It doesn't have 'DELETEME' at the end of a line
   - It isn't between any set of DELETEME markers"
  (and (not (string.match line "DELETEME$"))
       (accumulate [keep true
                    idx start (ipairs start-indices)]
         (and keep
              (or (< i start)
                  (> i (. end-indices idx)))))))

(fn filter-lines [lines pairs]
  (icollect [i line (ipairs lines)]
    (when (should-keep-line? line i pairs)
      line)))

(fn calculate-cursor-pos [old-pos new-line-count]
  [(math.min (. old-pos 1) new-line-count)
   (. old-pos 2)])

(fn delete-deleteme-lines []
  (let [cursor-pos (vim.api.nvim_win_get_cursor 0)
        lines (vim.api.nvim_buf_get_lines 0 0 -1 false)
        [start-indices end-indices] (collect-deleteme-markers lines)]

    (if (not (= (length start-indices) (length end-indices)))
        (vim.notify "Mismatched or incomplete DELETEME markers found!" vim.log.levels.ERROR)
        (let [filtered-lines (filter-lines lines [start-indices end-indices])
              new-pos (calculate-cursor-pos cursor-pos (length filtered-lines))]
          (vim.api.nvim_buf_set_lines 0 0 -1 false filtered-lines)
          (vim.api.nvim_win_set_cursor 0 new-pos)))))

(fn get-comment-string []
  "Get appropriate comment string for current buffer"
  (let [cms vim.bo.commentstring]
    (if (= cms "")
        "// "  ; Default to C-style if none set
        (string.gsub cms "%%s" " "))))

(fn add-delete-markers []
  "Add DELETEME markers around visual selection"
  (let [[_ l1 _ _] (vim.fn.getpos "v")
        [_ l2 _ _] (vim.fn.getpos ".")
        cs (get-comment-string)
        start-marker (.. cs " DELETEME>>")
        end-marker (.. cs " DELETEME<<")
        ; Figure out which end of the selection is first
        [start-line end-line] (if (< l1 l2)
                                [l1 l2]
                                [l2 l1])]
    (vim.api.nvim_buf_set_lines 0 end-line end-line true [end-marker])
    (vim.api.nvim_buf_set_lines 0 (- start-line 1) (- start-line 1) true [start-marker])))

{: delete-deleteme-lines
 : add-delete-markers}
