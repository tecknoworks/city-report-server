file_path = File.join(Rails.root.to_s, "config", "config.yml")
APP_CONFIG = YAML.load_file(file_path)[Rails.env]
