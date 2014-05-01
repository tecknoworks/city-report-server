module ReparaHelper
  def serialize_filename s
    ("%10.9f" % Time.now.to_f) + "-#{s}"
  end
end
