# == Schema Information
# Schema version: 20110424081236
#
# Table name: machines
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  state       :string(255)
#  instance    :string(255)
#  os          :string(255)
#  runningtime :string(255)
#  ami         :string(255)
#  zone        :string(255)
#  kernel      :string(255)
#  ramdisk     :string(255)
#  group       :string(255)
#  hardware    :string(255)
#  log         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  tool_id     :integer
#  comment     :string(255)
#

class Machine < ActiveRecord::Base
 attr_accessible :ami, :instance, :region, :tool_id, :comment  
 belongs_to :user
 #TODO add tool_for validation
 validates :instance, :presence => true
 validates :user_id, :presence => true

 default_scope :order => 'machines.created_at DESC'
end
