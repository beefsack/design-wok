class CreateDesignFiles < ActiveRecord::Migration
  def change
    create_table :design_files do |t|

      t.timestamps
    end
  end
end
