# -*- coding: utf-8 -*-

require 'time'

module FigureskatingHelpers
  def showdata(c)
    ["<h3>#{c['name']}</h3>",
     "<ul>",
     %Q{<li>日付：#{h(c['date']['from'])} - #{h(c['date']['to'])}},
     %Q{<li>場所：#{h(c['rink'])}},
     %Q{<li>コメント：#{h(c['comment'])}},
     "</ul>"
     ].join("\n")
  end

  def passed?(c, now=Time.now)
    return false unless c['date']
    tm = Time.parse(c['date']['from'])
    tm < now
  end
end

