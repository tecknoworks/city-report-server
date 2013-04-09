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
