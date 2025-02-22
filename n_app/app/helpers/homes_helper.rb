module HomesHelper
  def responsive_activity_image_tag(source, options = {})
    image_tag(source, options.merge({ 'data-action' => 'load->top#adjustImageSize' }))
  end
end
