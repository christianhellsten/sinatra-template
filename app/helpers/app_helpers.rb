module AppHelpers
  #
  # Returns app's version string.
  #
  def version_string
    "v#{Version.current} #{App.environment}"
  end

  #
  # Render CSRF token.
  #
  def csrf_token
    %{<input name="authenticity_token" value="#{session[:csrf]}" type="hidden"/>}
  end

  #
  # Render a JavaScript include tag.
  #
  def js_tag(name)
    file = App.asset_path(name, :js)
    content_tag :script, nil, src: file, type: 'text/javascript'
  end

  #
  # Render a CSS include tag.
  #
  def css_tag(name)
    file = App.asset_path(name, :css)
    content_tag :link, nil, href: file, rel: 'stylesheet', type: 'text/css'
  end

  #
  # Generate a HTML tag.
  #
  def content_tag(name, content, attributes = nil)
    name = html_escape(name) unless name.html_safe?
    content = html_escape(content) if content && !content.html_safe?
    attributes = attributes.map do |name, value|
      value = html_escape(value) unless value.html_safe?
      %Q{#{name}="#{value}"}
    end if attributes && attributes.any?
    start = [name, attributes.join(" ")].reject(&:nil?).join(' ')
    "<#{start}>#{content}</#{name}>"
  end

  #
  # Paginate a collection.
  #
  def paginate(collection)
    options = {
      inner_window: 0,
      outer_window: 0,
      page_links: false,
      previous_label: '&laquo; Edellinen sivu',
      next_label: 'Seuraava sivu &raquo;'
    }
    will_paginate collection, options
  end

  #
  # Translate a string.
  #
  def t(*args)
    ::I18n::t(*args)
  end

  #
  # Set or render CSS classes for body tag.
  #
  def body_classes(classes=nil)
    if classes
      content_for(:body_classes) { classes }
    else
      body = yield_content(:body_classes)
      parts = []
      parts << body if body.present?
      parts << (signed_in? ? 'signed-in' : 'signed-out')
      parts << I18n.locale
      parts.join(' ')
    end
  end

  # 
  # Set or render view variables.
  #
  # Example:
  #
  #  # Set
  #  meta :title, "Page title"
  #
  #  # Get
  #  meta :title
  #
  def meta(key, value = nil)
    content_blocks.clear if content_for?(key) && value.present?
    value ? content_for(key) { value } : (yield_content(key).presence || nil)
  end
end
