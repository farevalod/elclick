module ApplicationHelper
	def title
		base_title = "ElClick"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
	def logo
	    image_tag("logo.png", :alt => "ElClickApp", :class => "round")
    end
end
