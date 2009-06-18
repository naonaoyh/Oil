require 'set'
require File.join(File.dirname(__FILE__),'DSLContext')

class SiteProcessInterpreter < DslContext
  def initialize
    @cmds = []
    @processes = Hash.new #list of all the processes with the value of the first step being stored
    @result = []
    @result[0] = Hash.new
    @result[1] = Array.new
    @result[2] = Set.new
  end

  def getResult
    #massage result[0] so that all navigation that related to processes are replaced with the 1st step of the process
    #rather than the process name
    #...
    @result
  end

  def siteprocesses(*args)
  end

  def endsiteprocesses(*args)
  end

  def reference_datamodel(*args)
  end

  def process(*args)
    @current_process = args[0]
    @processes[@current_process.to_sym] = :FirstStepUnknown
    @cmds.push :process
  end

  def endprocess(*args)
  end

  def products(*args)
  end

  def endproducts(*args)
  end

  def product(*args)
    @result[1].push args[0]
  end

  def endproduct(*args)
  end

  #from here we can derive the product process DSL
  #and also the layout files
  def flow(*args)
    if (@cmds.last == :process)
      @processes[@current_process.to_sym] = args[0]
    end
    @cmds.push :flow

    @result[0]["#{args[0]}".to_sym] = args[1]
    args[1][:data_model].each do |e|
      @result[2].add?(e.to_sym)
    end
  end
end