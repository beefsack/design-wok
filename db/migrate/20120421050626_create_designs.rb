class CreateDesigns < ActiveRecord::Migration
  def change
    create_table :designs do |t|

      t.timestamps
    end
  end
end
