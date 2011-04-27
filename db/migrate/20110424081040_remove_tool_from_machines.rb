class RemoveToolFromMachines < ActiveRecord::Migration
  def self.up
    remove_column :machines, :tool
  end

  def self.down
    add_column :machines, :tool, :string
  end
end
