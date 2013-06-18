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

    if params['address'] == '' || params['address'] == nil
      address_found = Geocoder.kung_foo params['lat'], params['lon']
      params['address'] = address_found if address_found != ''
    end

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

  def add_to id, key, value
    issue = find_issue id
    delete_unwanted_params issue

    if issue.has_key?(key)
      if (issue[key].class == Array)
        issue[key] << value
      end
    else
      issue[key] = [value]
    end

    @db['issues'].update({'_id' => BSON::ObjectId(id.to_s)}, issue)
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
