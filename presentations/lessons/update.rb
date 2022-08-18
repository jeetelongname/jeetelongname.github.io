#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'erb'

lessons = `ls`.split("\n").filter_map do |file|
  name, type = file.split('.')

  [name, type] if %w[html pdf].include?(type) && name != 'index'
end

html = ERB.new(DATA.read, trim_mode: '%<>')
File.write('index.html', html.result)

__END__

<html class="no-js" lang="">
  <head>
      <meta charset="utf-8">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <title>Lessons</title>
      <meta name="description" content="">
      <meta name="viewport" content="width=device-width, initial-scale=1">

      <link rel="apple-touch-icon" href="/apple-touch-icon.png">
      <!-- Place favicon.ico in the root directory -->
      <!-- <link rel="stylesheet" href="../../css/presentation.css" type=
                  "text/css" media="screen"> -->

  </head>
  <body>
    <h1> Lessons </h1>
    <ul>
% lessons.each do |lesson|
        <li> <a href="<%= lesson.join(".") %>"> <%= lesson[0].gsub("-", " ") %> </a> </li>
% end
    </ul>
  </body>
<html>
