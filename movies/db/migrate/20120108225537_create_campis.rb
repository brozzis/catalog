class CreateCampis < ActiveRecord::Migration
  def change
    create_table :campis do |t|
      t.string :nome
      t.string :s

      t.timestamps
    end
  end
end
