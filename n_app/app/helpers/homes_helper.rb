module HomesHelper
  def responsive_activity_image_tag(source, options = {})
    image_tag(source, options.merge({ onload: "adjustImageSize(this)" }))
  end
end
