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

  def skills_logo_select(skill)
    filename =
      case skill
      when "C#"
        "CS.png"
      when "C++"
        "Cpp.png"
      when "Ruby on Rails"
        "Rails.png"
      else
        "#{skill}.png"
      end

    image_tag "learning_skills/#{filename}"
  end
end