require File.join(File.dirname(__FILE__),'DSLContext')

#create class that fills in for the RAILS class when rails is not around, e.g. when testing
#when RAILS is around this will have no effect
class HashWithIndifferentAccess < Hash
end

class RailsProcessInterpreter < DslContext

  bubble :channels,:channel,:processes,:process,:to,:endprocess,:endprocesses,:endchannel,:endchannels

  def getResult
    @result
  end

  def workflow_steps
    @result = ""
  end
  
  def endworkflow_steps
  end

  def flow(*args)
    #serialize array
    sarray ="["
    args[1].each do |a|
      if (a == args[1].first)
        sarray << ":#{a}"
      else
        sarray << ",:#{a}"
      end
    end
    sarray << "]"
    @result << ":#{args[0]} => #{sarray},"
  end

  def valid_flows(*args)
    @result << "def wireProcess\n"
    @result << "@processMap = {"
  end

  def endvalid_flows(*args)
    @result << "}\n"
    @result << "end"
  end
  
  def step(*args)
    #there will be at least five parameters for an IAB app - rails controller, rails action, language, brand, product
    controller_process_step = "if self.respond_to?(:#{args[1][:do].to_s.downcase})\nparams.merge!(#{args[1][:do].to_s.downcase})\nend" if (args[1][:do])
    engine_call = ""
    engine_call << "@results = Communicator.instance.handle(session,\"#{args[1][:do]}\",params)" if (args[1][:do])
    marshalling = ""
    marshalling << "possible_redirect = massage(@results) if @results\nif possible_redirect\nredirect_to possible_redirect\nreturn\nend" if (args[1][:do])
    injectLayoutDict = "introduce_layout_dictionary(\"#{args[1][:template]}\")"
    
    action = "def #{args[0]}\n@template.setParmsForViewUse({:currentstep => :#{args[0]}})\n#{controller_process_step}\n#{engine_call}\n#{marshalling}\n#{injectLayoutDict}\nrender :template => \"#{args[1][:template]}.oil\", :layout => \"#{args[1][:layout]}\"\nend\n" 
    #puts("introducing controller action\n#{action}")
    @result << action
  end
end