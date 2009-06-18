require 'DSLContext'

class RatingEngineResolver < DslContext

  bubble :than, :is, :list, :the, :to, :at, :it
  
  def dictionary(*args)
    xml = "<?xml version='1.0' encoding='UTF-8'?>"
    xml << "<PolMessage Type='TransactionRequestConfig' Version='1'>" if args[0] == "XML"
    xml << "<PolMessage Type='TransactionRequest' Version='1'>" if args[0] != "XML"
    xml << "<Dictionary DictType='#{args[0]}' DictName='#{args[1]}' DictId='#{args[2]}' DictVer='#{args[3]}'/>"
    xml << "<Transaction TranName='QuotationRequest' EffectiveDate='2007-04-30'/>" if args[0] == "XML"
    xml << "<Transaction TranName='QuoteDetail' EffectiveDate='17/7/2007'/>" if args[0] != "XML"
    xml << "<Schemes><Scheme Ref='#{args[4]}'/></Schemes>"
    @dictHeader=xml   
  end
  
  def rating_engine(*args)
    @ratingEngine = args[0]
    @responseContent = args[1]
    if (args[2] != nil) then
      @inboundTransform = args[2]
    else
      @inboundTransform = nil
    end
    if (args[3] != nil) then
      @outboundTransform = args[3]
    else
      @outboundTransform = nil
    end
    if (args[4] != nil) then
      @mockFile = args[4]
    else
      @mockFile = nil
    end    
  end
  
  def getResult
    if (@ratingEngine == 'Mock') then
      closure = "lambda {|xml| "
      closure << "response = SBroker.GetMockRatingResponse('#{@mockFile}'); response"
      closure << "}"
      "#{closure}"
    else
      closure = "lambda {|xml| "
      closure << "keep_xml = xml;"
      if (@inboundTransform != nil) then
          closure << "xml = SBroker.ApplyTransform(xml,'#{@inboundTransform}',nil); "
      end
      closure << "msg = \""
      closure << @dictHeader
      closure << "<PolData Type='Request' Selection='#{@responseContent}'/>"
      closure << "<PolData Type='Input'>"
      closure << "\""
      closure << '+ xml +'
      closure << "\""
      closure << "</PolData></PolMessage>"
          #puts '----------\n';p msg;puts '====\n';p response;    
      closure << "\"; response = SBroker.InvokeRTE(msg);"
      closure << "if (partial) then premium = SBroker.ExtractSectionPremium(keep_xml,response);premium else response end"     
      closure << "}"
      "#{closure}"
    end
  end

  def product(name)
      puts "say the product is #{name}"
  end
  
  def supported_channels(*args)
    puts "say supported channels are "
    args.each do |arg|
      puts "say "+arg
    end
  end

  def supported_processes(*args)
    puts "say supported processes are "
    args.each do |arg|
      puts "say "+arg
    end
  end
  
  def channel(name) 
      puts " say it has a #{name} channel"  
  end
end