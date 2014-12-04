# Some utils
# TODO: move somewhere else
module ReparaHelper
  def serialize_filename(s)
    ('%10.9f' % Time.now.to_f) + "-#{s}"
  end

  # TODO: better name
  def image?(filename)
    filename.downcase.end_with?('.png')
  end

  def original_url_to_thumbnail_url(s)
    s.downcase.sub('/original/', '/thumb/')
  end
end
