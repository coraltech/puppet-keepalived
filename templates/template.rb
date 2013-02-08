
class KeepalivedTemplate
  
  #-----------------------------------------------------------------------------
  # Renderers  
   
  def self.render(type, input, spacer = '')
    output = ''    
    case input.class      
    when Array
      input.each do |data|
        if data.is_a?(Hash)
          output << KeepalivedTemplate.block(type, data)           
        end
      end        
    when Hash
      output << KeepalivedTemplate.block(type, input)
    end              
    return output      
  end
  
  #---
    
  def self.block(type, input, spacer = '')
    if input.is_a?(Hash) || input.is_a?(Array)
       
      name = (input.is_a?(Hash) ? input['name'] : '')
      input.delete('name')
       
      if name.is_a?(Array)
        name = name.flatten.join(' ')          
      elsif ! name.is_a?(String)
        name = ''
      end
        
      output << "#{spacer}#{type} #{name} {\n"
 
      if input.is_a?(Hash)
        input.each do |keyword, data|
          if data.is_a?(Hash) or data.is_a?(Array)
            output << spacer << render(keyword, data, "#{spacer}  ") << "\n"
              
          elsif data.is_a?(String)
            output << "#{spacer}  #{keyword} #{data}\n"
          end
        end
      else
        input.each do |data|
          output << "#{spacer}  #{data}\n"
        end  
      end
        
      output << spacer << "}"
    end  
    return output  
  end  
end