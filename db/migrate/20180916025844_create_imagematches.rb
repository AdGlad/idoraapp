class CreateImagematches < ActiveRecord::Migration[5.2]
  def change
    create_table :imagematches do |t|
      t.string :name
      t.string :desc
      t.string :resp
      t.references :image, foreign_key: true

      t.timestamps
    end
  end
end
