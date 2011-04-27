class AddDetailsToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :tool_id, :integer
    add_column :machines, :comment, :string
  end

  def self.down
    remove_column :machines, :comment
    remove_column :machines, :tool_id
  end
end
