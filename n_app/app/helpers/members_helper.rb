module MembersHelper
	def programming_language_checkbox(member, pl_num, language)
	  if (pl_num & member.object.learning_programming_languages) != 0
		content_tag(:div, class: 'col') do
		  member.check_box(:selected_languages, { multiple: true, checked: true }, pl_num) + member.label(:selected_languages, language, value: pl_num)
		end
	  else
		content_tag(:div, class: 'col') do
		  member.check_box(:selected_languages, { multiple: true }, pl_num, {}) + member.label(:selected_languages, language, value: pl_num)
		end
	  end
	end
end