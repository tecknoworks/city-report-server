class DbWrapper
  include ImageHandling

  attr_reader :db, :config

  def initialize config_file
    @config = DbWrapper.read_config config_file

    client = Mongo::MongoClient.new(@config['db_host'], @config['db_port'])
    @db = client[@config['db_name']]
  end

  def issues
    @db['issues'].find.to_api
  end

  def find_issue id
    @db['issues'].find({'_id' => BSON::ObjectId(id.to_s)}).to_api.first
  end

  def create_issue params
    delete_unwanted_params params
    params['created_at'] = Time.now.to_s
    params['updated_at'] = Time.now.to_s

    address = Geocoder.kung_foo params['lat'], params['lon']
    params['address'] = address if address != ''

    id = @db['issues'].insert(params)
    find_issue id
  end

  def update_issue params, keep_history=false
    id = params['id']
    history = find_issue id

    delete_unwanted_params params
    params['created_at'] = history['created_at'] if history['created_at']
    params['updated_at'] = Time.now.to_s

    if keep_history
      history.delete('id')
      old_issue = history.clone
      old_issue.delete('history')
      if old_issue != params
        params['history'] = history
      end
    end

    @db['issues'].update({'_id' => BSON::ObjectId(id.to_s)}, params)
    find_issue id
  end

  private

  def delete_unwanted_params params
    params.delete('id')
    params.delete(:id)
    params.delete('image')
    params.delete(:image)
  end

  def self.read_config config_file
    YAML.load_file config_file
  end
end
