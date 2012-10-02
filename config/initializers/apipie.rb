Apipie.configure do |config|
  config.app_name = "Repara Clujul"
  config.copyright = "&copy; 2012 SmartTech2000"
  config.doc_base_url = "/apidoc"
  config.api_base_url = ""
  config.validate = false
  config.markup = Apipie::Markup::Markdown.new
  config.reload_controllers = true
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "**","*.rb")
  config.app_info = <<-DOC
    This is the "repara clujul" API documentation. The API is in a relatively primitive state
    but we hope to make great progress in time. If you find any issues, please contact one of
    the developers (ex: cristian.ilea [at] smarttech2000.com ).
  DOC
end
