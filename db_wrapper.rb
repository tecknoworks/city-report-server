module Mongo
  class Cursor
    def to_api
      self.collect{ |row|
        row['id'] = row['_id'].to_s
        row.delete('_id')
        row
      }
    end
  end
end

class DbWrapper
  attr_reader :db, :config

  def initialize config_file
    @config = YAML.load_file(config_file)
    client = Mongo::MongoClient.new(config[:db_host], config[:db_port])
    @db = client[config['db_name']]
  end

  def issues
    @db['issues'].find.to_api
  end

  def create_issue params
    params.delete(:image)
    @db['issues'].insert params
  end
end
