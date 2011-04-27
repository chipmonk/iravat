module Iravat 

#require './ir_module'

class IrAwsConfigManager


#Constructor: takes default configuration from preconfigured path unless changed
# by caller.

def initialize(confXMLPath=IRAVAT_AWS_CONFIG_XML_PATH)
    $ir_logger=IrLogger.new(IRAVAT_AWS_CONFIG_LOGGER)
    $logger=$ir_logger.getLog4rLogger()
    @confXMLPath=confXMLPath
end


def loadConfigurationFile()
    begin
    @xmlDom = Nokogiri::XML(File.open(@confXMLPath).read)

   
    if(@xmlDom.nil?)
        #$log.error("XML DOM is null")        
        $logger.error("AWS XML parsing resulted in error. Document is null.")
    end
    rescue Nokogiri::XML::SyntaxError
       # $log.error("Exception raised while parsing XML file")
        $logger.error("Exception raised while parsing XML file")
        return
    end
end

def getPathFromXML(path)
    nodeSet= @xmlDom.xpath(path)
     if(nodeSet.nil?)
       $logger.error("Nothing present in path:" + path)
       return ""
    end
    #TODO Add multi node
    if(nodeSet.length() != 1)
        $logger.error("Bad XML configuration file:" + @confXMLPath + " for path " + path)
        return ""
    end

    return nodeSet[0].text
end

end

if __FILE__ == $0
    #Unit tester hack
    #require './ir_log_initializer.rb'
    #li = IrLogInitializer.new
    #li.init()
    ########################
    instance = IrAwsConfigManager.new(IRAVAT_AWS_CONFIG_XML_PATH)
    instance.loadConfigurationFile()
    $logger.info(instance.getPathFromXML("/ChipMonkAWSConfigs/AWSAccessKey/AWSAccessKeyID"))
end

end
