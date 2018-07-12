class CreateDisplayedColors < ActiveRecord::Migration[5.2]
  def change
    create_table :displayed_colors do |t|
      t.string :color

      t.timestamps
    end
  end
end
