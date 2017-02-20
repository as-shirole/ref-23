module ApplicationHelper
	def time_of_day(hour)
		case hour
			when 0..11
				["Morning", "Breakfast"]
			when 12..16
				["Afternoon", "Lunch"]
			when 17..20
				["Evening", "Dinner"]
			else
				["Night", "Dinner"]
		end
	end

	def open_now(val)
		return val == true ? "Yes" : "No"
	end

end
