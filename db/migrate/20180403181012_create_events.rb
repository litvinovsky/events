class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.belongs_to :batch
      t.string :name
      t.timestamps
    end
  end
end
