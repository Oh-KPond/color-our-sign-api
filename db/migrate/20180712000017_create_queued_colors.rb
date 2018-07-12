class CreateQueuedColors < ActiveRecord::Migration[5.2]
  def change
    create_table :queued_colors do |t|
      t.string :color

      t.timestamps
    end
  end
end
