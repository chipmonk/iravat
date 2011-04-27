require 'right_aws'
require 'logger'
require 'rubygems'
require 'nokogiri'
require 'log4r'
require 'log4r/configurator'


$:.unshift(File.dirname(__FILE__))
require 'logger/ir_logger'
require 'logger/ir_log_initializer'
require 'awsconf/ir_aws_config_manager'
require 's3/ir_s3'
require 'ec2/ir_ec2'

module Iravat

  IRAVAT_RIGHT_SCALE_LOGGER = 'RightScaleLogger'
  IRAVAT_LOGGER_DEFAULT_LOGGER = 'MasterLogger'
  IRAVAT_AWS_CONFIG_LOGGER = 'AWSConfig'

  IRAVAT_LOG_CONFIG_XML = File.expand_path(File.dirname(__FILE__)) +'/' + 'logger/log4r_config.xml'
  IRAVAT_LOG_PATH = './'

  IRAVAT_LOG_FILE = File.expand_path(File.dirname(__FILE__)) + '/' + 'logger/my_configfile.log'

  IRAVAT_AWS_CONFIG_XML_PATH = File.expand_path(File.dirname(__FILE__)) + '/' + 'awsconf/aws_config.xml'
end
