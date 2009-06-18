require 'DSLContext'

class CoverageInterpreter2 < DslContext
  def initialize
    @name = ''
    @entity = Array.new
  end
  
  def getResult
    @entity
  end
 
  def coverage(*args)
    @name = args[0].to_s
  end

  def endcoverage(*args)
    #nothing to do here at the mo
  end
  
  def entity(*args)
    coverage(args)
  end

  def endentity(*args)
    endcoverage(args)
  end
  
  def use(*args)
    # remove the trailing defaults and stuff
    if(args.last.class.name == 'Hash')
      args.pop
    end
    @entity << args.collect{ |p| ':' + (p.to_s()) }.join(',')
  end
end
