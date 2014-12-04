Apipie.configure do |config|
  config.app_name                = "City Report Cluj-Napoca"
  config.api_base_url            = ""
  config.doc_base_url            = "/doc"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
  config.validate = false

  config.app_info = <<-EOS
    Coded with love for Cluj-Napoca
  EOS
end
