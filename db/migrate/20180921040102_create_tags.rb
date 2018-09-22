class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :tag_type
      t.string :desc

      t.timestamps
    end
  end
end
