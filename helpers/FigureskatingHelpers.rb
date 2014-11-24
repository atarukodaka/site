# -*- coding: utf-8 -*-

require 'time'

module FigureskatingHelpers
  def showdata(c)
    ["<h2>#{c['name']}</h2>",
     "<ul>",
     %Q{<li>日付：#{c['date']['from']} - #{c['date']['to']}},
     %Q{<li>場所：#{c['rink']}},
     "</ul>"
     ].join("\n")
  end

  def passed?(c, now=Time.now)
    return false unless c['date']
    tm = Time.parse(c['date']['from'])
    tm < now
  end
end

