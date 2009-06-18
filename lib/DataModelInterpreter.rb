require 'set'
require File.join(File.dirname(__FILE__),'DSLContext')
require 'Element'

class DataModelInterpreter < DslContext
  def initialize
    @elements = []
    @elementTree = []
    @depth=0
  end

  def getResult
    #dumpParsedStructure
    result = @elements
    result
  end
  # --parse - implement the grammar
  def datamodel(*args)
  end

  def enddatamodel(*args)
  end

  def createNewElement(name,coverage,parent,type)
    e = ElementFactory(name,coverage,parent,type)
    @elementTree.last.children.push e if @elementTree.last and @elementTree.length > 0
    @elementTree.push e
  end

  def ElementFactory(name,coverage,parent,type)
    @elements.each do |node|
      if node.name == name
        node.parent = parent
        return node
      end
    end
    e = Element.new(name,coverage,parent,type)
    @elements.push e
    return e
  end

  def element(*args)
    createNewElement(args[0],false,@elementTree.last,nil)
  end

  def endelement(*args)
    @elementTree.pop
  end

  def coverage(*args)
    createNewElement(args[0]+ "Coverage",true,@elementTree.last,"coverages")
  end

  def endcoverage(*args)
    @elementTree.pop
  end

  def entity(*args)
    createNewElement(args[0],true,@elementTree.last,"entities")
  end

  def endentity(*args)
    @elementTree.pop
  end

  def field(*args)
    if (args[0][:ctype] != nil)
      if (@elementTree.last.coverage)
        parent = nil
      else
        parent = @elementTree.last
      end
      createNewElement(args[0][:ctype],false,parent,nil) #the parent is nil here since a complex type may be used by many coverages or entities
       @elementTree.pop
    else
      @elementTree.last.fields.push args[0]
    end
  end

  #----------- dump

  def dumpParsedStructure
    @dumpStructure = ""
    @elements.each do |e|
      if (e.coverage)
        @dumpStructure << "#{e.name}:\n"
        listChildren(e)
        @dumpStructure << "\n"
      end
    end
    puts "#{@dumpStructure}"
  end

  def listChildren(e)
     @depth = @depth + 1
     e.children.each do |c|
      str = ""
      @depth.times { str << "\t"}
      @dumpStructure << "#{str}#{c.name}\n"
      c.fields.each do |f|
         str = ""
         @depth.times { str << "\t\t"}
         @dumpStructure << "#{str}field:#{f}\n"
      end
      listChildren(c)
      @depth = @depth - 1
    end
  end
end
