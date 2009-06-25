class Element
  attr_accessor :coverage,:name,:children,:parent,:fields,:type

  def initialize(name,isaentityorcoverage,parent,type)
    @coverage = isaentityorcoverage
    @name = name
    @children = []
    @parent = parent
    @fields = []
    @type = type
  end  
end