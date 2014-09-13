Date::DATE_FORMATS[:full] = ->(date) { date.strftime("%a, %b #{date.day.ordinalize}") }
