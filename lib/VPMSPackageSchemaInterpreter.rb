require File.join(File.dirname(__FILE__),'DSLContext')
require File.join(File.dirname(__FILE__),'VPMSComponentSchemaInterpreter')
require File.join(File.dirname(__FILE__),'CollesceProductInterpreter')
require 'yaml'

#create class that fills in for the RAILS class when rails is not around, e.g. when testing
#when RAILS is around this will have no effect
class HashWithIndifferentAccess < Hash
end

class VPMSPackageSchemaInterpreter < DslContext

  bubble :than, :is, :list, :the, :to, :at, :it, :end
  
  VPMS_SCHEMA_INTERPRETER_ROOT = File.dirname(__FILE__)
  XSL_ROOT = File.join(VPMS_SCHEMA_INTERPRETER_ROOT, 'xslt')
  MOCK_ROOT = File.join(VPMS_SCHEMA_INTERPRETER_ROOT, 'mocks')
  
  def getResult
    @entities = Hash.new
    @coverages = Hash.new
    getResult = ""
    getResult << startSchema
    if (@arProductsSplit != nil) then
      @arProductsSplit.each do |a|
          open(File.join(a,"/product.oil")) {|f| @contents = f.read }
          dsl = @contents.to_s
          h = CollesceProductInterpreter.execute(dsl)
          @entities.merge!(h[0])
          @coverages.merge!(h[1])
          #open(File.join(a,"/product.oil")) {|f| @contents = f.read }
          #dsl = @contents.to_s
          #frag = VPMSProductSchemaInterpreter.execute(dsl,a)
          #getResult << applyTransform(frag)
      end
      collescedProduct = "product :CommercialProperty\n"
      collescedProduct << "entities\n"
      @entities.each do |k,v|
        collescedProduct << "#{v} :#{k}\n"
      end
      collescedProduct << "entities\n"
      collescedProduct << "coverages\n"
      @coverages.each do |k,v|
        collescedProduct << "#{v} :#{k}\n"
      end
      collescedProduct << "coverages\n"
      collescedProduct << "endproduct"
      #puts collescedProduct
      frag = VPMSProductSchemaInterpreter.execute(collescedProduct,"#{OIL_DSL_ROOT.gsub('*','')}Retailer/DSL")
      getResult << applyTransform(frag)
    end
    getResult << endSchema
  end
  
  def package(*args)
	theDir = "#{OIL_DSL_ROOT}"
	@schemaFragments = ""
    @arProductsSplit = Array.new
     Dir.glob(File.join(theDir, '*'), File::FNM_PATHNAME) do |p|
      if File.directory?(p)
      	@arProductsSplit.push(p)
      end
     end
  end

  def endpackage
  end
  
  def startSchema
    #ToDo: Make this a widget - a schema open widget for example
    openSchema = ""
    openSchema << "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
    openSchema << "<xs:schema xmlns:xs=\"http://www.w3.org/2001/XMLSchema\">\n"
    openSchema << "<xs:element xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" name=\"CommercialProperty\">\n"
    openSchema << "<xs:complexType>\n"
    openSchema << "<xs:sequence>\n"
    openSchema
  end

  def endSchema
    endSchema = ""
    endSchema << "</xs:sequence>\n"
    endSchema << "</xs:complexType>\n"
    endSchema << "</xs:element>\n"
    endSchema << "</xs:schema>\n"
    endSchema
  end

  def applyTransform(*args)
      require 'rexml/document'
      require 'xml/xslt'
      xslt = XML::XSLT.new()
      string = args[0]
      doc = REXML::Document.new(string)
      xslt.xml = doc
      xslt.xsl = File.join(XSL_ROOT, "VPMSPackageSchemaInterpreter.xsl")
      transformed_xml = xslt.serve()
      transformed_xml
  end
  
end

