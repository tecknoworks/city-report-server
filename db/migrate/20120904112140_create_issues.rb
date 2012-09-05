class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.float :latitude
      t.float :longitude
      t.integer :category_id

      t.timestamps
    end
  end
end
