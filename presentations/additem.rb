#!/usr/bin/env ruby

require 'getoptlong'

if ARGV.length < 2
  abort <<~MSG
    -l: file path :: string
    -t: title :: string
    -d: description :: string
    -p: pdf? :: bool
  MSG
end

opts = GetoptLong.new(
  ['-l', GetoptLong::REQUIRED_ARGUMENT],
  ['-t', GetoptLong::REQUIRED_ARGUMENT],
  ['-d', GetoptLong::REQUIRED_ARGUMENT],
  ['-p', GetoptLong::OPTIONAL_ARGUMENT]
)

link, title, description = nil
pdf = false
opts.each do |opt, arg|
  case opt
  when '-l'
    link = arg
  when '-t'
    title = arg
  when '-d'
    description = arg
  when '-p'
    pdf = true
  end
end

lines = IO.readlines('index.html')
line_above = 0
lines.each_with_index do |i, j|
  next unless i =~ /<!-- this/

  line_above = j
  break
end

pdf_link_tag = "<a href=#{link.sub(/\..+/, '.pdf')}><u>PDF Version</u></a>" if pdf

line_to_add = <<~HTML
  <li>
        <a href='#{link}'>
        <div>
            <h2>#{title}</h2>
            <p>#{description}</p>
            #{pdf ? pdf_link_tag : ''}
        </div>
        </a>
  </li>
HTML

puts line_to_add

abort 'aborting' unless gets.chomp == 'y'

lines.insert(line_above + 1, line_to_add)

# lines.each do |line|
#   puts line
# end

open('index.html', 'r+') do |f|
  lines.each do |line|
    f << line
  end
end

puts 'done'
