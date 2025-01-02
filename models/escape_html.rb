def h(text)
    text.to_s.gsub('&', '&amp;')
             .gsub('<', '&lt;')
             .gsub('>', '&gt;')
             .gsub('"', '&quot;')
             .gsub("'", '&#39;')
end