class CreateImageTags < ActiveRecord::Migration[5.2]
  def change
    create_table :image_tags do |t|
      t.integer :image_id
      t.integer :tag_id
    end
  end
end
