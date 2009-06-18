require File.join(File.dirname(__FILE__),'DSLContext')
require 'yaml'

#create class that fills in for the RAILS class when rails is not around, e.g. when testing
#when RAILS is around this will have no effect
class HashWithIndifferentAccess < Hash
end

class VPMSComponentSchemaInterpreter < DslContext

  #ToDo: Sends in an xpath statement to set up a referenceable context for the node
  #in the transformation - i.e. when duplicating complex types

  bubble :than, :is, :list, :the, :to, :at, :it, :end

  VPMS_SCHEMA_INTERPRETER_ROOT = File.dirname(__FILE__)
  XSL_ROOT = File.join(VPMS_SCHEMA_INTERPRETER_ROOT, 'xslt')
  MOCK_ROOT = File.join(VPMS_SCHEMA_INTERPRETER_ROOT, 'mocks')

   def initialize(*args)
   		@props = args
   		@useDynamicFileMapping = (args.length > 0) ? true : false
		@hashesRoot = (args.length > 0) ? OIL_HASH_ROOT : ENTITY_DEF_ROOT
   end
   
  def getResult
      getResult = ""
      getResult << startSchema
      @erbAry.each do |a|
        b = a.first
        #a.to_s
        getResult << "\t"
        getResult << processXPath(a, b)
      end
      getResult << endSchema
      getResult
  end
  
  def processXPath(*args)
    processXpath = ""
    xpath = args[0]
    boolEndOfPath = (args[0].length == 1)
      processXpath << "\t"
      processXpath << startElement(args[0].first, args[1], boolEndOfPath)
      xpath.delete_at(0)
      if xpath.length > 0
        processXpath << startComplexType
        processXpath << processXPath(xpath, args[1])
        processXpath << endComplexType
      end
      processXpath << endElement
    processXpath
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
    openSchema << "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
    openSchema << "<xs:schema xmlns:xs=\"http://www.w3.org/2001/XMLSchema\">\n"
    openSchema
  end

  def endSchema
    endSchema = ""
    endSchema << "</xs:schema>\n"
    endSchema
  end

  def startElement(*args)
    #ToDo: Make this a widget - an element open widget for example
    openElement = ""
    openElement << "<xs:element name=\"#{args[0]}\""
    #ToDo: do something better to get type info - 
    #if this is the ultimate point in the xpath, this pushes in a data type of string - thats all
    if (args[2] == true) then
      openElement << " type=\"xs:string\">\n"
    else
      openElement << ">\n"
    end
    #ToDo: Read the element type and other atts off the MD hash metadata.
    #args 1 is the full xpath of the element used potentially to key into the md hash 
    #Potentially do this if args 2 is true (it's the last xpath step) and use args 1 for the key
    #args 2 represents a key into a hash
    #the @metaProps hash for example - see 'coverage'
    #If there is an entry in that hash for this element's xpath, then a type attribute can be
    #determined for it and gets used from the md hash - When the element is nesting a ct, there's no type attribute
    #This key would be used to read off values in that hash, if it is a hash of hashes - 
    #i.e. if the buildingsCoverSumInsuredAmount key in the metaProps referenced a hash of metadata:
    #It would also be possible to reference entries for this element in the existing 
    #xml dictionary, which is keyed on this element's xpath
    openElement
  end

  def endElement
    endElement = ""
    endElement << "</xs:element>\n"
    endElement
  end

  def startComplexType
    #ToDo: Make this a widget - a schema open widget for example
    openElement = ""
    openElement << "<xs:complexType>\n"
    openElement << startSequence
    openElement
  end

  def endComplexType
    endElement = ""
    endElement << endSequence
    endElement << "</xs:complexType>\n"
    endElement
  end

  def startSequence
    #ToDo: Make this a widget - a schema open widget for example
    openElement = ""
    openElement << "<xs:sequence>\n"
    openElement
  end

  def endSequence
    endElement = ""
    endElement << "</xs:sequence>\n"
    endElement
  end
  
  def coverage(*args)
    @erbAry = []
    @erb = ""
    @argName = "#{args[0]}"
    @useDynamicFileMapping == true ? io = open(File.join(@hashesRoot,"/coverages/#{@argName}PropertyHash"),'r' ) : io = open(File.join(COVERAGE_DEF_ROOT,"/#{@argName}PropertyHash"),'r' ) 
    @prdhash = YAML::load(io)
  end

  def endcoverage(*args)
  end

  def entity(*args)
    @erbAry = []
    @erb = ""
    @argName = "#{args[0]}"
    @useDynamicFileMapping == true ? io = open(File.join(@hashesRoot,"/entities/#{@argName}PropertyHash"),'r' ) : io = open(File.join(ENTITY_DEF_ROOT,"/#{@argName}PropertyHash"),'r' ) 
    @prdhash = YAML::load(io)
  end

  def endentity(*args)
  end
  
  def use(*args)
    
    h = ""
    lasth = ""
    lasta = "" 
    args.each do |a|
      unless a.class == Hash
      lasth = String.new(h)
      h << "#{a}"
      lasta = a
      end
    end

    hashname = @argName + h
    
    #now figure out whether the last arg above leads to an empty hash
    #i.e. it is really a single value field
    #if so backup a level and read the property whose name = the last arg value passed in
    
    specificProperty = false
	
    if !@prdhash.has_key?(hashname)
      puts "missing key for #{hashname} when processing:use #{args}"
    end
    myHash = @prdhash["#{hashname}"].clone
    if (myHash.length == 1)
      hashname = @argName + lasth
      specificProperty = true
    if !@prdhash.has_key?(hashname)
      puts "missing key for #{hashname} when processing:use #{args}"
    end
      myHash = @prdhash["#{hashname}"].clone
    end
    
    @erb << myHash["#{'xpath'}"]

     myHash.each do |property, value|
       if (property != 'xpath' and (property =~ /MD$/) == nil) then
         if (value == "" && (!specificProperty || (specificProperty && property == "#{lasta}"))) then
           @erb << "/"
           @erb << property
           #In progress
           #@metaprop = @erb.sub('/', '') stands as an xpath key to the metadata in the 'element properties' hash
           
         end
       end
     end
     
     erbTemp = @erb.split('/')
     @erbAry.push(erbTemp)
     @erb = ""

  end
end

