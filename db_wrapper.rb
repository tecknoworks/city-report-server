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
    @config = DbWrapper.read_config config_file

    client = Mongo::MongoClient.new(@config['db_host'], @config['db_port'])
    @db = client[@config['db_name']]
  end

  def issues
    @db['issues'].find.to_api
  end

  def create_issue params
    delete_image_params params
    result = @db['issues'].insert(params)
    @db['issues'].find({'_id' => result}).to_api.first
  end

  def save_image params
    if params['image']
      tempfile = params['image'][:tempfile]
      fp = image_path

      FileUtils.copy_file(tempfile.path, fp)
      params['images'] = [ image_url_path(fp) ]
    end
  end

  def image_url_path img_path
    '/' + img_path.split('/').delete_if{|e| e == 'public' || e == 'spec'}.join('/')
  end

  def image_path
    iup = config['image_upload_path']
    count = Dir[File.join(iup, '*')].count.to_s
    File.join(iup, count + '.png')
  end

  private

  def delete_image_params params
    params.delete(:image)
    params.delete('image')
  end

  def self.read_config config_file
    YAML.load_file config_file
  end
end
