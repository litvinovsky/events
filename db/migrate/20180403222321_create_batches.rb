class CreateBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :batches do |t|
      t.integer :size, :interval
      t.boolean :processed
      t.timestamps
    end
  end
end
