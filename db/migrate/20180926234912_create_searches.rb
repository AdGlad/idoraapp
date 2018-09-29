class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.string :idwc
      t.string :id1
      t.string :id2
      t.string :tagwc
      t.string :tag1
      t.string :tag2
      t.string :tag3
      t.string :tag4
      t.string :tag5
      t.timestamps
    end
  end
end
