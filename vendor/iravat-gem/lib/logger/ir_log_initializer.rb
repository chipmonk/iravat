module Iravat

#require './ir_module'

class IrLogInitializer
    
    include Log4r

    def self.init()
        begin
          Configurator['logpath'] = IRAVAT_LOG_PATH # was './logs'
          Configurator.load_xml_file(IRAVAT_LOG_CONFIG_XML)
          rescue Log4r::ConfigError => e
            puts "Error in configuration log4r ==== " + e.message 
        end
    end
    
end


if __FILE__ == $0
  #li = IrLogInitializer.new
  #li.init()
  IrLogInitializer::init()
  log =Log4r::Logger["MainLogger"]
  log.fatal("hi")
end

end
