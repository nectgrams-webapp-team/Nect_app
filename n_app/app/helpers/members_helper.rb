module MembersHelper
	def learning_checkbox(member, attribute, selected, hash)
		hash.map do |num, label|
			value = member.object.send(attribute) || 0
			checked = (num & value) != 0
			content_tag(:div, class: 'col') do
				member.check_box(selected, { multiple: true, checked: checked }, num) + member.label(selected, label, value: num)
			end
		end.join.html_safe
	end
end