#!/usr/bin/env ruby
#                     __
#    __  _____  ___  / /______
#   / / / / _ \/ _ \/ __/ ___/
#  / /_/ /  __/  __/ /_(__  )
#  \__, /\___/\___/\__/____/
# /____/
#                    _       __
#    _______________(_)___  / /_
#   / ___/ ___/ ___/ / __ \/ __/
#  (__  ) /__/ /  / / /_/ / /_
# /____/\___/_/  /_/ .___/\__/
#                 /_/
#                 for stuff

lines = IO.readlines('index.html')
line_above = 0
lines.each_with_index do |i, j|
  next unless i =~ /<!-- this/

  line_above = j
  puts line_above
  break
end
# line_to_add = "         <div><p>#{ARGV[0]}</p><a href='#{ARGV[1]}'>#{ARGV[2]}</a></div>\n"
line_to_add = <<~HTML
  <li>
        <a href='#{ARGV[0]}'>
        <div>
            <h2>#{ARGV[1]}</h2>
            <p>#{ARGV[2]}</p>
        </div></a>
  </li>
HTML

lines.insert(line_above + 1, line_to_add)
open('index.html', 'r+') do |f|
  lines.each do |line|
    f << line
  end
end
