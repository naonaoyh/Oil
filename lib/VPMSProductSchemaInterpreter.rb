require File.join(File.dirname(__FILE__),'DSLContext')
require File.join(File.dirname(__FILE__),'VPMSComponentSchemaInterpreter')
require 'yaml'

#create class that fills in for the RAILS class when rails is not around, e.g. when testing
#when RAILS is around this will have no effect
class HashWithIndifferentAccess < Hash
end

class VPMSProductSchemaInterpreter < DslContext
 
  bubble :than, :is, :list, :the, :to, :at, :it, :end
  
  VPMS_SCHEMA_INTERPRETER_ROOT = File.dirname(__FILE__)
  XSL_ROOT = File.join(VPMS_SCHEMA_INTERPRETER_ROOT, 'xslt')
  MOCK_ROOT = File.join(VPMS_SCHEMA_INTERPRETER_ROOT, 'mocks')
   
   def initialize(*args)
   		@props = args
   		@useDynamicFileMapping = (args.length > 0) ? true : false
		@productDSLRoot = (args.length > 0) ? args[0] : ENTITY_DSL_ROOT
   end
  
  def getResult
      @getResult = ""
      @getResult << getDenormalisedSchema
  end

  def getDenormalisedSchema
      getSchema = ""
      getSchema << startSchema
      getSchema << startRoot(@classDef)
      getSchema << @schemaFragments
      getSchema << endRoot
      getSchema << endSchema
      getSchema
  end
  
  def applyTransform(*args)
      require 'rexml/document'
      require 'xml/xslt'
      xslt = XML::XSLT.new()
      string = args[0]
      doc = REXML::Document.new(string)
      xslt.xml = doc
      xslt.xsl = File.join(XSL_ROOT, "VPMSSchemaInterpreter.xsl")
      transformed_xml = xslt.serve()
      transformed_xml
  end
  
  def startSchema
    #ToDo: Make this a widget - a schema open widget for example
    openSchema = ""
    openSchema << "<xs:schema xmlns:xs=\"http://www.w3.org/2001/XMLSchema\">\n"
    openSchema
  end
  
  def endSchema
    endSchema = ""
    endSchema << "</xs:schema>\n"
    endSchema
  end

  def startRoot(*args)
    #ToDo: Make this a widget - an element open widget for example
    openElement = ""
    openElement << "<xs:element name=\"#{args[0]}\">\n"
    openElement << "<xs:complexType>\n"
    openElement << "<xs:sequence>\n"
    openElement << "<xs:element name=\"Brand\" type=\"xs:string\"/>\n"
    openElement << "<xs:element name=\"Package\" type=\"xs:string\"/>\n"
    openElement
  end

  def endRoot
    endElement = ""
    endElement << "</xs:sequence>\n"
    endElement << "</xs:complexType>\n"
    endElement << "</xs:element>\n"
    endElement
  end

  def product(*args)
    @requires = ""
    @schemaFragments = ""
    @classDef = "#{args[0]}"
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
  
  def for_ABI_codes(*args)
  end
  
  def conditional_on(*args)
  end
  
  def has_one(*args)
  	has(args)
  end

  def has_many(*args)
  	has(args)
  end

	def has(*args)
  		if (@useDynamicFileMapping == true) then
  			open(File.join(@productDSLRoot,"#{@libtype}/#{args[0]}.oil")) {|f| @contents = f.read }
  		else
  			open(File.join(@productDSLRoot,"/#{args[0]}.oil")) {|f| @contents = f.read }
  		end
    	dsl = @contents.to_s
    	# todo: bit clumsy but need it working
    	if (@useDynamicFileMapping == true) then
    		frag = VPMSComponentSchemaInterpreter.execute(dsl,@useDynamicFileMapping)
    	else
    		frag = VPMSComponentSchemaInterpreter.execute(dsl)
    	end
    	@schemaFragments << applyTransform(frag)
	end

  def has_between(*args)
  		if (@useDynamicFileMapping == true) then
  			open(File.join(@productDSLRoot,"#{@libtype}/#{args[2]}.oil")) {|f| @contents = f.read }
  		else
  			open(File.join(@productDSLRoot,"/#{args[0]}.oil")) {|f| @contents = f.read }
  		end
    	dsl = @contents.to_s
    	# todo: bit clumsy but need it working
    	if (@useDynamicFileMapping == true) then
    		frag = VPMSComponentSchemaInterpreter.execute(dsl,@useDynamicFileMapping)
    	else
    		frag = VPMSComponentSchemaInterpreter.execute(dsl)
    	end
    	@schemaFragments << applyTransform(frag)
  end
  
end
