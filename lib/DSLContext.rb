class DslContext
  def self.execute(*args)
    rules = polish_text(args[0])
	#significant change to allow class instance variables to be set on the initialize, ahead
	#of the evaluation of the DSL - allows dynamic props to be sent to the class
	#see VPMSProductSchemaInterpreter, which gets a param from the package interpreter
    inst = (args.length > 1) ? self.new(args.slice(1,1)) : self.new
    rules.each do |rule|
      result = inst.instance_eval(rule)
      #passes results as parm into code that was passed with call to execute (if any was)
      yield result if block_given?
    end
    inst.getResult
  end

  def self.polish_text(text)
    rules = text.split("\n")
    rules.collect do |rule|
      rule << " "
    end
  end
  
  def self.bubble(*methods)
    methods.each do |method|
      define_method(method) {}
    end
  end
end 