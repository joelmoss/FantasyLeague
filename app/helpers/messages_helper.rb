module MessagesHelper

  def markdown(content)
    @@markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true), autolink: true, space_after_headers: true)
    @@markdown.render(content).html_safe
  end

end
