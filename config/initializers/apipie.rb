Apipie.configure do |config|
  config.app_name                = "CityReport"
  config.api_base_url            = ""
  config.doc_base_url            = "/doc"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
  config.validate = false

  config.app_info = <<-EOS
    === Introduction

    The API has two main components.

    * the image upload service
    * issue reporting service
  EOS
end
