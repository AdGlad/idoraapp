class Createuuidextention < ActiveRecord::Migration[5.2]
  def change
    create_table :uuid_extensions do |t|
      enable_extension 'uuid-ossp'
  end
  end
end
