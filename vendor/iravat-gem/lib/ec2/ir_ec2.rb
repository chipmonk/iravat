module Iravat

#require './ir_module'

class IrEC2

  def initialize()
    @logger = IrLogger.new(self.class.name).getLog4rLogger()
    awsConfig=IrAwsConfigManager.new(IRAVAT_AWS_CONFIG_XML_PATH)
    awsConfig.loadConfigurationFile()
    @awsKeyID=awsConfig.getPathFromXML("/ChipMonkAWSConfigs/AWSAccessKey/AWSAccessKey")
    @awsSecretKey=awsConfig.getPathFromXML("/ChipMonkAWSConfigs/AWSAccessKey/AWSAccessSecretKey")
  end


  #common error handler for RightScale Lib
  def error_ec2 (err)
      err.errors.each do |e|
        @logger.error(err.errors)
      end
  end 


  def connectToAWS()
    begin
      @ec2   = RightAws::Ec2.new(@awsKeyID,@awsSecretKey)
      if(@ec2.nil?)
        @logger.error("Failed to create an access to EC2")
        return false
      end
        return true
      rescue RightAws::AwsError=>err 
        self.error_ec2(err)
        return false
    end
  end


  def getKey()
    begin
      key = @ec2.describe_key_pairs()[0][:aws_key_name]
      if(key.nil?)
        @logger.error("No Key pair existing")
      end
      return key
      rescue RightAws::AwsError=>err 
        self.error_ec2(err)
        return nil
    end
  end

  
  def  getSecurityGroup()
    begin
      securityGroup = @ec2.describe_key_pairs()[0]
      if(securityGroup.nil?)
        @logger.error("No security group created")
      end
      return securityGroup
      rescue RightAws::AwsError=>err 
        self.error_ec2(err)
        return nil
    end
  end
  

  def printAllActiveImages()
    begin
      awsInstances=@ec2.describe_instances
      #Loop on all instance
      awsInstances.each do |awsInstance|
        @logger.info("============================================")
        @logger.info("AWS Instance ID:" + awsInstance[:aws_instance_id])
        @logger.info("AWS Image ID:" + awsInstance[:aws_image_id])
        @logger.info("AWS State:" + awsInstance[:aws_state])
        if( awsInstance[:aws_state] == "running")
          @logger.info("IP Address:" + awsInstance[:ip_address])
          @logger.info("DNS Name:" + awsInstance[:dns_name])
          @logger.info("AWS Instance Type:" + awsInstance[:aws_instance_type])
          @logger.info("AWS Private DNS Name:" + awsInstance[:private_dns_name])
          @logger.info("AWS Instance Launch Time:" + awsInstance[:aws_launch_time])
          @logger.info("AWS Availability Zone:" + awsInstance[:aws_availability_zone])
      
          blockDevicesMapped=awsInstance[:block_device_mappings]
      
          blockDevicesMapped.each do |blockDevice|
            @logger.info("  -----------------------------------------------")
            @logger.info("  EBS Device Name:" + blockDevice[:device_name])
            @logger.info("  EBS Device ID:" + blockDevice[:ebs_volume_id])
            @logger.info("  EBS Device Attach Time:" + blockDevice[:ebs_attach_time])
            @logger.info("  -----------------------------------------------")
          end
        end

        @logger.info("============================================")     
      end
      rescue RightAws::AwsError=>err 
        self.error_ec2(err)
        return nil
    end
  end


  def createNewInstance(imageID,instanceType, availablilityZone, userCookieData)
    #run_instances(image_id, min_count, max_count, group_ids, key_name, user_data='', addressing_type = nil,
    #instance_type = nil, kernel_id = nil, ramdisk_id = nil, availability_zone = nil, monitoring_enabled = nil,
    #subnet_id = nil, disable_api_termination = nil, instance_initiated_shutdown_behavior = nil, block_device_mappings = nil,
    #placement_group_name = nil, client_token = nil)
    begin
      responseDetails=@ec2.run_instances(imageID,
                       1,
                       1,
                       self.getSecurityGroup()[:aws_group_name],
                       self.getKey(),
                       userCookieData,
                       nil,
                       instanceType,
                       nil,
                       nil,
                       availablilityZone)[0]



      @logger.debug("============================================")
      @logger.debug("AMI instance launched")
      @logger.debug("Instance ID:" + responseDetails[:aws_instance_id])
      @logger.debug("Instance State:" + responseDetails[:aws_state])
      @logger.debug("Instance Type:" + responseDetails[:aws_instance_type])
      @logger.debug("Availability Zone:" + responseDetails[:aws_availability_zone])
      @logger.debug  ("============================================")
      rescue RightAws::AwsError=>err 
        self.error_ec2(err)
        return nil
    end
    return responseDetails[:aws_instance_id]

 end


 def rebootInstance(instanceID)
    begin
      response=@ec2.reboot_instances(instanceID)
      if(response == false)
         @logger.debug("AMI instance id " + instanceID + "failed to reboot")      
      else
         @logger.debug("AMI instance id " + instanceID + "rebooted successfully")
      end
      rescue RightAws::AwsError=>err 
        self.error_ec2(err)
        return nil
    end
 end

  def terminateInstance(instanceID)
     begin
      instanceIDArr=[instanceID]
      responseDetails=@ec2.terminate_instances(instanceIDArr)
      @logger.debug("============================================")
      @logger.debug("AMI instance terminated")
      @logger.debug("Instance ID:" + responseDetails[0][:aws_instance_id])
      @logger.debug("Current State Code:" + responseDetails[0][:aws_current_state_code].to_s())
      @logger.debug("Current State Name:" + responseDetails[0][:aws_current_state_name])
      @logger.debug("Previous State Code:" + responseDetails[0][:aws_prev_state_code].to_s())
      @logger.debug("Previous State Name:" + responseDetails[0][:aws_prev_state_name])
      @logger.debug("============================================")
      rescue RightAws::AwsError=>err 
        self.error_ec2(err)
        return nil
    end      
  end
end

if __FILE__ == $0
    #require './ir_log_initializer.rb'
    #li = IrLogInitializer.new
    #li.init()
    #$ir_logger=IrLogger.new("AnotherLogger")
    #@logger=$ir_logger.getLog4rLogger()
    ec2Manager=IrEC2.new
    if(ec2Manager.connectToAWS() == true)
      ec2Manager.printAllActiveImages()
      instanceID=ec2Manager.createNewInstance("ami-00d62369", "t1.micro","us-east-1b","Sudhanshu-Started")
      ec2Manager.terminateInstance(instanceID)
      ec2Manager.printAllActiveImages()
    end


end

end
