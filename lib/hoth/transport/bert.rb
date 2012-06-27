begin
  require 'bert'
  require 'bertrpc'
rescue LoadError
  STDERR.puts "You need the 'bertrpc' gem if you want to use Bert transport."
end


module Hoth
  module Transport
    class Bert < Base
      
      class TuplePreparer
        def self.prepare(obj)
          case obj
          when Array
            obj.collect { |o| prepare o }
          when Hash
            obj.each { |k,v| obj[k] = prepare(v) }
          else
            ruby2tuple obj
          end
        end
        
        def self.ruby2tuple(ruby)
          if ruby.respond_to? :to_serialize
            tuple = t[ruby.class.name.underscore, {}]
            ruby.to_serialize.each do |field|
              tuple.last[field] = prepare(ruby.send(field))
            end
            tuple
          else
            ruby
          end
        end
      end
      
      class Deserializer
        def self.deserialize(data)
          case data
          when BERT::Tuple
            tuple2ruby data
          when Array
            data.collect { |o| deserialize o }
          when Hash
            data.each { |k,v| data[k] = deserialize(v) }
          else
            data
          end
        end
        
        def self.tuple2ruby(tuple)
          case tuple
          when BERT::Tuple
            begin
              ruby_class = tuple.first.camelize.constantize
              ruby_obj = ruby_class.new({})
              ruby_obj.to_serialize.each do |field|
                ruby_obj.send("#{field}=", deserialize(tuple.last[field]))
              end
              
              ruby_obj
            rescue NameError => e
              puts %Q{An Exception occured: #{e.message} -- #{e.backtrace.join("\n\t")}}
              tuple
            end
          else
            puts "Was not anything we could decode!"
            tuple
          end
        end
      end
      
      def call_remote_with(*args)
        bert_service = BERTRPC::Service.new(self.endpoint.host, self.endpoint.port)
        
        response = bert_service.call.send(self.name).execute(*TuplePreparer.prepare(args))
        
        if self.return_value
          return Deserializer.deserialize(response)
        else
          return true
        end
      end
      
      def decode_params(params)
        Deserializer.deserialize(params)
      end
      
    end
  end
end