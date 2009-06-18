require 'set'
require File.join(File.dirname(__FILE__),'DSLContext')

#create class that fills in for the RAILS class when rails is not around, e.g. when testing
#when RAILS is around this will have no effect
class HashWithIndifferentAccess < Hash
end

class CoverageInterpreter < DslContext

  bubble :than, :is, :list, :the, :to, :at, :it, :end
  
  def initialize(*args)
    @columns = 1
    @hidden_fields = Set.new
  end
  
  def getResult
    widgets = ""
    @widgets.each { |k| widgets << ",'#{k}'" }
    @erb = "<%= widgets(#{widgets[1..-1]}) %>\n" + @erb unless widgets.length == 0
    @erb
  end

  def hideFields(*args)
    args[0].split('&').each { |a| @hidden_fields << a.to_sym }
  end

  def columns(*args)
    @columns = args[0].to_i
  end
 
  def coverage(*args)
    begin_erb(COVERAGE_DEF_ROOT, args)
  end

  def endcoverage(*args)
    end_erb
  end
  
  def entity(*args)
    begin_erb(ENTITY_DEF_ROOT, args)   
  end

  def endentity(*args)
    end_erb
  end
  
  def use(*args)
    #the test on hidden_fields property is a bit too brutal in that it cuts out a whole part of the tree
    #it serves to provide the same hiding capability as we had in the iteration earlier this day
    #but more consideration especially around individual field level restriction needs to be considered
    #i.e. we may want to keep part of the tree but loose some of the fields at that level
    #so that we need considering in the code block below 
    args.each { |a| return if @hidden_fields.include?(a.to_sym) unless a.class.name == 'Hash' }

    # If the last argument is a hash we assume it's a hash of overrides which we remove
    # and merge in later.
    args_hash = nil
    args_hash = args.pop if args.last.class.name == 'Hash'
    
    #now figure out whether the last arg above leads to an empty hash
    #not strictly empty since every hash has an xpath property of the position in the class hierarchy
    #if so backup a level and read the property whose name = the last arg value passed in
    lastArg = ""
    specificProperty = false
    myHash = @prdhash["#{@argName}#{args}"]
    raise "Failed to find [#{@argName}#{args}] in [#{@argName}PropertyHash]" if myHash == nil
    
    # Have a look for meta data pertaining to the class which may specify a type.
    class_meta_data = @prdhash["#{@argName}#{args}MD"]
    specific_widget = class_meta_data[:type] unless class_meta_data == nil
    
    if (myHash.length == 1)
      specificProperty = true
      lastArg = args.pop
      myHash = @prdhash["#{@argName}#{args}"]
      # Since we are delegating to our parent definition we look at that for a type
      # specification if we haven' already found one.
      #class_meta_data = @prdhash["#{@argName}#{args}MD"] if specific_widget == nil
      #specific_widget = class_meta_data[:type] unless class_meta_data == nil
    end
    
    @widgets << specific_widget unless specific_widget == nil    
    @erb << "<% #{specific_widget} \"#\{widgetROOT}/#{specific_widget}\" do %>" unless specific_widget == nil
   
    myHash.each do |property, value|
      if (property != 'xpath' and (property =~ /MD$/) == nil) then
        #properties of type HashWithIndifferentAccess hold metadata about the property
        if (value == "" && (!specificProperty || (specificProperty && property == "#{lastArg}"))) then

          if (@columns > 1)
            @erb << '<tr>' if @col == 1
            @erb << "<td width=\"#{100/@columns}%\">"
            #@erb << "<div style=\"display: inline-block;float: left;width: #{(100/@columns)}%;\">"
          end
          
          metaData = myHash["#{property}MD"]
          metaData = metaData.merge(args_hash) unless args_hash == nil
          sMetaData = "{"        
          metaData.each { |n, v| sMetaData << "'#{n}' => '#{v}'," }
          sMetaData << ":entityName => '#{@argName}#{args}',"
          sMetaData << ":propertyName => '#{property}'"
          sMetaData << "}"         
          #puts "METADATA:#{property}:#{metaData['mask']}_input:#{metaData['type']}_input"
          @erb << "<% singleline_rowpanel \"#\{widgetROOT}/singleline_rowpanel\",\"#{sMetaData}\"  do %>\n"
          @widgets << "singleline_rowpanel"
          
          if (metaData['type'] != nil) then
            @widgets << "#{metaData['type']}_input"
            @erb << "<% #{metaData['type']}_input \"#\{widgetROOT}/#{metaData['type']}_input\",\"#{sMetaData}\"  do %>\n<% end %>"
          elsif (metaData['mask'] != nil) then
            @widgets << "#{metaData['mask']}_input"
            @erb << "<% #{metaData['mask']}_input \"#\{widgetROOT}/#{metaData['mask']}_input\",\"#{sMetaData}\"  do %>\n<% end %>"
          else
            @widgets << "text_input"
            @erb << "<% text_input \"#\{widgetROOT}/text_input\",\"#{sMetaData}\"  do %>\n<% end %>"
          end

          @erb << "\n<% end %>"
          
          if (@columns > 1)
            #@erb << '</div>'
            @erb << '</td>'
            @erb << '</tr>' if @col == @columns
            @col = 0 if @col == @columns
            @col += 1
          end
        end
      end
    end    
    @erb << '<% end %>' unless specific_widget == nil    
  end
   
  private
  def begin_erb(dsl_root, *args)
    @widgets = Set.new
    @col = 1
    @argName = "#{args[0]}"     
    @prdhash = YAML::load(open(File.join(dsl_root,"/#{@argName}PropertyHash"),'r' ))
    # Check to see if there's meta data specifying a type for this class.
    class_meta_data = @prdhash["#{@argName}MD"]
    specific_widget = class_meta_data[:type] unless class_meta_data == nil
    @widgets << specific_widget unless specific_widget == nil
    @erb = ''
    @erb = "<% #{specific_widget} \"#\{widgetROOT}/#{specific_widget}\" do %>" unless specific_widget == nil
    @erb << '<table width="100%">' if @columns > 1
  end
  
  private
  def end_erb()    
    if(@columns > 1)
      @erb << '</tr>' if @erb.match(/tr>$/) == nil
      @erb << '</table>'
    end
    class_meta_data = @prdhash["#{@argName}MD"]
    specific_widget = class_meta_data[:type] unless class_meta_data == nil
    @erb << '<% end %>' unless specific_widget == nil
  end  
end

