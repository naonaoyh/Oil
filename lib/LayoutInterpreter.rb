require File.join(File.dirname(__FILE__),'DSLContext')
require File.join(File.dirname(__FILE__),'CoverageInterpreter')

class LayoutInterpreter < DslContext

  bubble :than, :is, :list, :the, :to, :at, :it, :endheader, :endlayout, :endfooter
  
  def getResult
    widgets = ""
    @widgets.each do |k,v|
      widgets << ",'#{k}'"
    end
    @erb = "<%= widgets(#{widgets[1..-1]}) %>\n" + @erb unless widgets.length == 0
    @erb
  end
  
  def product(*args)
    @product = args[0]
  end

  def navigation(steps)
    @navigationSteps = steps
  end
  
  def layout(*args)
    @widgets = Hash.new
    @erb = "<head>\n"
    @erb << "<%= getCSS('#{args[0]}.css') %>\n"
    @erb << "</head>\n"
    @erb << "<body>\n"
    @erb << "\t<div class=\"container\">\n"
  end

  def endlayout(*args)
    @erb << "\t</div>\n"
    @erb << "</body>"
  end
  
  def header(*args)
    @erb << "\t\t<div class=\"header\">\n"
  end
  
  def endheader(*args)
    @erb << "\t\t</div>\n"
  end

  def miniheader(*args)
    @erb << "\t\t<div class=\"mini-header\">#{args[0]}\n"
  end
  
  def endminiheader(*args)
    @erb << "\t\t</div>\n"
  end

  def column(*args)
    @erb << "\t\t<td style=\"vertical-align: top;\">\n"
  end
  
  def endcolumn
    @erb << "\t\t</td>\n"
  end
  
  def columns
    @erb << "\t\t<table class=\"columnWrapper\"><tr>\n"
  end

  def endcolumns
    @erb << "\t\t</tr></table>\n"
  end
  
  def footer(*args)
    @erb << "\t\t<div class=\"footer\">\n"
  end
  
  def endfooter(*args)
    @erb << "\t\t</div>\n"
  end

  def panel(*args)
    if args.length > 0
      @erb << "\t\t\t<div class=\"#{args[0]}\">\n"
    else
      @erb << "\t\t\t<div>\n"
    end
  end

  def endpanel
    @erb << "\t\t\t</div>\n"
  end
  
  def product_menu(*args)
    #TODO:slidingMenu needs implementing as a single item menu construct
    #that is repeated for each of theargs
    @erb << "\t\t\t"
    @erb << '<%= render :partial => "#{widgetROOT}/sliding_menu/sliding_menu", :locals => { :menuitems => %w('
    @erb << args.join(' ')
    @erb << ') } %>'
    @erb << "\n"
  end
  
  def teaser(*args)
    @erb << "\t\t\t<%= render :partial => \"#\{teaserROOT}/#{args[0]}\" %>\n"
  end
  
  def widget(*args)
    @widgets["#{args[0]}"] = 1

    @erb << "\t\t\t<% #{args[0]} \"#\{widgetROOT}/#{args[0]}\""
    
    widget_args_hash = args[1]
    
    if (@navigationSteps.length > 0)
      if (args[0].to_sym == :submit_panel)
        widget_args_hash = {:nextLayout => @navigationSteps[0].to_sym}
      elsif (args[0].to_sym == :button_panel)
        str = "{:button1 => :#{@navigationSteps.first}"
        i = 1
        @navigationSteps.each do |step|
          str << ",:button#{i += 1} => :#{step}" unless step == @navigationSteps.first
        end
        str << "}"
        widget_args_hash = eval(str)
      end
    end
    
    
    if (widget_args_hash and widget_args_hash.class.name == "Hash")
      sHash = "{"
      comma = ""
      widget_args_hash.each do |n,v|
        sHash << "#{comma}:#{n} => '#{v}'"
        comma = ","
      end
      sHash << "}"  

      @erb << ",\"#{sHash}\" do %>\n"
    else
      @erb << " do %>\n"
    end
  end
  
  def endwidget
    @erb << "\t\t\t <% end %>\n"
  end
  
  def entity(*args)
    interpret(ENTITY_DSL_ROOT, *args)
  end
  
  def coverage(*args)
    interpret(COVERAGE_DSL_ROOT, *args)
  end
  
  private
  def interpret(dslroot, *args)
    path = dslroot.gsub(/%product/,@product)
    open(File.join(path,"/#{args[0]}.oil")) {|f| @contents = f.read }
    dsl = ''
    if (args[1])
      dsl << "hideFields \"#{args[1][:hide]}\"\n" if args[1][:hide]
      dsl << "columns \"#{args[1][:columns]}\"\n" if args[1][:columns]
    end
    #if a use statement accompanies the entity clause in a layout then take this
    #in preference to using the product level view for the entity
    if (args[1] and args[1][:use])
      dsl << "entity :#{args[0]}\nuse #{interpretUse(args[1][:use])}\nendentity"
    else
      dsl << @contents.to_s
    end
    @erb << CoverageInterpreter.execute(dsl, args[1])
  end

  def interpretUse(use)
    result = ''
    use.each do |e|
      result << "#{(e == use.first ? '':',')}:#{e}"
    end
    result
  end
end