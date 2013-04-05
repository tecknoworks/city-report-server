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
    params.delete(:image)
    params.delete('image')

    result = @db['issues'].insert(params)
    @db['issues'].find({'_id' => result}).to_api.first
  end

  def save_image params
    if params['image']
      tempfile = params['image'][:tempfile]

      iup = config['image_upload_path']
      FileUtils.copy_file(tempfile.path, filename)
      params['images'] = [ '' ]
    end
  end

  private

  def filename
    iup = config['image_upload_path']
    count = Dir[File.join(iup, '*')].count.to_s
    File.join(iup, count + '.png')
  end

  def self.read_config config_file
    YAML.load_file config_file
  end
end
