class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.integer :user_id
      t.string :state
      t.string :instance
      t.string :os
      t.string :tool
      t.string :runningtime
      t.string :ami
      t.string :zone
      t.string :kernel
      t.string :ramdisk
      t.string :group
      t.string :hardware
      t.string :log

      t.timestamps
    end
    add_index :machines, :user_id
  end

  def self.down
    drop_table :machines
  end
end
