require 'DSLContext'

class ProductInterpreter2 < DslContext

  attr_reader :entity
  attr_reader :coverage
  
  def initialize
    @name = ''
    @entity = Array.new
    @coverage = Array.new
  end
  
  def getResult
    self
  end
  
  def product(*args)
    @name = args[0]
  end
  
  def endproduct(*args)
    
  end
 
  def coverages(*args)
    @currentGroup = @coverage
  end

  def endcoverages(*args)
  end
  
  def entities(*args)
    @currentGroup = @entity
  end

  def endentities(*args)
  end
  
  def has_one(*args)
    @currentGroup.push([args[0].to_s(), 'has_one'])
  end
  
  def has_many(*args)
    @currentGroup.push([args[0].to_s(), 'has_many'])
  end
  
  def has_between(*args)
    @currentGroup.push([args[0].to_s(), 'has_many'])
  end
end
