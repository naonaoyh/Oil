require File.join(File.dirname(__FILE__),'DSLContext')

#create class that fills in for the RAILS class when rails is not around, e.g. when testing
#when RAILS is around this will have no effect
class HashWithIndifferentAccess < Hash
end

class ProductInterpreter < DslContext

  bubble :than, :is, :list, :the, :to, :at, :it, :end
    
  def getResult
    @classDef+@requires
  end
  
  def product(*args)
    @requires = ""
    @classDef = "class Marshaller::#{args[0]} < ActiveRecord::Base\n"
    @classDef << "@@nodeName = \"#{args[0]}\"\n"
  end
  
  def endproduct
    @classDef << "def self.nodeName\n"
    @classDef << "@@nodeName\n"
    @classDef << "end\n"
    @classDef << "end\n"
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
    @requires << "require '#{LIBRARY_ROOT}/#{@libtype}/#{args[0]}EntityModel.rb'\n"
    @requires << "require '#{LIBRARY_ROOT}/#{@libtype}/#{args[0]}NodeName.rb'\n"
    @classDef << "has_one :#{args[0]}\n"
  end
  
  def has_many(*args)
    @requires << "require '#{LIBRARY_ROOT}/#{@libtype}/#{args[0]}EntityModel.rb'\n"
    @requires << "require '#{LIBRARY_ROOT}/#{@libtype}/#{args[0]}NodeName.rb'\n"
    @classDef << "has_many :#{args[0]}\n"
  end
  
  def has_between(*args)
    @requires << "require '#{LIBRARY_ROOT}/#{@libtype}/#{args[2]}EntityModel.rb'\n"
    @requires << "require '#{LIBRARY_ROOT}/#{@libtype}/#{args[2]}NodeName.rb'\n"
    @classDef << "has_many :#{args[2]}\n"
  end
end