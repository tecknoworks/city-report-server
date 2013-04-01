class DbWrapper
  attr_reader :db, :config

  def initialize config_file
    @config = YAML.load_file(config_file)
    client = Mongo::MongoClient.new(config['db_host'], config['db_port'])
    @db = client[config['db_name']]
  end

  def issues
    @db['issues'].find.collect{ |row| row }
  end

  def create_issue params
    @db['issues'].insert params
  end
end
