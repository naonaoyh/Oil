require File.join(File.dirname(__FILE__),'DSLContext')

#create class that fills in for the RAILS class when rails is not around, e.g. when testing
#when RAILS is around this will have no effect
class HashWithIndifferentAccess < Hash
end

class CollesceProductInterpreter < DslContext

  bubble :than, :is, :list, :the, :to, :at, :it, :end
    
  def getResult
    result = Array.new
    result[0] = @entities
    result[1] = @coverages
    result
  end
  
  def product(*args)
    @entities = Hash.new
    @coverages = Hash.new
  end
  
  def endproduct
  end
  
  def entities(*args)
    @libtype = "entities"
  end
  
  def endentities    
  end
  
  def coverages(*args)
    @libtype = "coverages"
  end
  
  def endcoverages    
  end
  
  def has_one(*args)
    @entities[args[0]] = "has_one" if @libtype == "entities"
    @coverages[args[0]] = "has_one" if @libtype == "coverages"
  end
  
  def has_many(*args)
  end
end