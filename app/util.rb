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

module ImageHandling
  def save_image params
    if params['image']
      tempfile = params['image'][:tempfile]
      fp = image_path
      FileUtils.copy_file(tempfile.path, fp)

      unless params.has_key? 'images'
        params['images'] = []
      end

      params['images'] << image_url_path(fp)
    end
    params
  end

  def image_url_path img_path
    '/' + img_path.split('/').delete_if{|e| e == 'public' || e == 'spec'}.join('/')
  end

  def image_path
    iup = config['image_upload_path']
    count = Dir[File.join(iup, '*')].count.to_s
    File.join(iup, count + '.png')
  end
end
