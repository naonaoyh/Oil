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

  def info
    puts "@coverage=#{@coverage},@name=#{@name},@type=#{@type},PARENT=#{parent},CHILDREN=#{offspring}"
  end

  def succinct_info
    "@name=#{@name}"
  end
  
  def parent
    return @parent.info if @parent
  end
  
  def offspring
    childrenStr=""
    if (@children and @children.length > 0)
      @children.each do |c|
        childrenStr += "<#{c.succinct_info}>"
      end
    end
    childrenStr
  end
end