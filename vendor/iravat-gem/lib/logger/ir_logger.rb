module Iravat

#require './ir_module'

class IrLogger
  
  def initialize(loggerType = IRAVAT_LOGGER_DEFAULT_LOGGER)  
      IrLogInitializer::init()
      @module_logger =Log4r::Logger[loggerType]
       
      if( @module_logger.nil?)
          print( " == Unable to initiate logging for module " + loggerType + "==== Falling back to MasterLogger <log4r_config.xml>\n")
          @module_logger =Log4r::Logger[IRAVAT_LOGGER_DEFAULT_LOGGER]
          if (@module_logger.nil? )
            #Falling to default Ruby Logger 
            @module_logger = Logger.new(IRAVAT_LOG_FILE)
            @module_logger.warn("Unable to initiate logging for module MasterLogger\n")
          end
      end
  end


  def getLog4rLogger()
    return @module_logger
  end


  def trace(message)
      if( @module_logger.nil?)
          print("TRACE:" + message + "\n")
      else
           @module_logger.trace(message)
      end
  end


  def debug(message)
      if( @module_logger.nil?)
          print("DEBUG:" + message + "\n")
      else
           @module_logger.debug(message)
      end
  end


  def info(message)
      if( @module_logger.nil?)
          print("INFO:" + message + "\n")
      else
           @module_logger.info(message)
      end
  end


  def warn(message)
      if( @module_logger.nil?)
          print("WARN:" + message + "\n")
      else
           @module_logger.warn(message)
      end
  end


  def error(message)
      if( @module_logger.nil?)
          print("ERROR:" + message + "\n")
      else
           @module_logger.error(message)
      end
  end


  def fatal(message)
      if( @module_logger.nil?)
          print("FATAL:" + message + "\n")
      else
           @module_logger.error(message)
      end
  end
end


if __FILE__ == $0
     require './ir_log_initializer.rb'
     #call only once
     #li = IrLogInitializer.new
     #li.init()
     #IrLogInitializer::init()
     ########################

     #call on head of file
     log = IrLogger.new("AnotherLogger")
     ############
     

     log.debug("Hi debug")
     log.info("Hi info")
     log.warn("Hi warn")
     log.error("Hi error")
     log.fatal("Hi fatal")

end

end
