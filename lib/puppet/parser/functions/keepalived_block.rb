
module Puppet::Parser::Functions
  newfunction(:keepalived_block, :type => :rvalue) do |args|
    output = ''
    
    unless args[0] and args[1]
      Puppet.warning "Function keepalived_block() requires a type and input data."
          
    else
      type   = args[0]
      input  = args[1]
      name   = input['name']
      spacer = ( args[2] ? args[2] : '' )
      
      if type and ( input.is_a? Hash or input.is_a? Array )
       
        if name.is_a? Array          
          name = name.flatten.join(' ')          
        elsif ! name.is_a? String
          name = ''
        end
        
        output << "%{spacer}%{type} %{name} {\n" % {
          :spacer => spacer,
          :type   => type,
          :name   => name,
        }
 
        if input.is_a? Hash        
          input.each do |keyword, data|
            if data.is_a? Hash or data.is_a? Array 
              output << spacer + keepalived_block(keyword, data, spacer + '  ') + "\n"
              
            elsif data.is_a? String
              output << "%{spacer}  %{keyword} %{data}\n" % {
                :spacer  => spacer,
                :keyword => keyword,
                :data    => data,
              }
            end
          end
        else
          input.each do |data|
            output << "%{spacer}  %{data}\n" % {
              :spacer  => spacer,
              :data    => data,
            } 
          end  
        end
        
        output << spacer + "}\n"
      end
    end
    
    output
  end
end