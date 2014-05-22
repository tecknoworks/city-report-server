module ApplicationHelper
  # Hacks over hacks over hacks
  # this method is used to render jbuilder templates
  def preview_jbuilder path
    jbuilder_path = File.join(Rails.root, 'app/views', path)
    jbuilder_path += '.jbuilder' unless jbuilder_path.end_with? '.jbuilder'

    jb = File.read(jbuilder_path)
    if path == 'issues/_issue'
      jb.gsub!('issue', '@issue')
    end

    s = Jbuilder.encode do |json|
      eval jb
    end
    pretty_json s
  end

  def pretty_json h
    JSON.pretty_generate(JSON.parse(h))
  end
end
