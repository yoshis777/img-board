module PostsHelper
  def body_format(body)
    simple_format(replace_anchar_to_link(body, "/posts/"))
  end

  def lazy_image_tag(source, options = {})
    options['data-original'] = asset_path(source)
    if options[:class].blank?
      options[:class] = 'lazy'
    else
      options[:class] = "lazy #{options[:class]}"
    end

    image_tag(options['data-original'], options)
  end
end
