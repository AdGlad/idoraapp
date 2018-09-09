class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :picture
      t.date :dob
      t.string :team
      t.string :desc

      t.timestamps
    end
  end
end
