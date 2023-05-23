class Hash
  def method_missing(prop, *args)
    if prop.end_with?('=') # check if its a set
      self[prop.to_s.delete_suffix('=').to_sym] = args.first
    elsif (accessed_prop = self[prop]).instance_of? Proc
      # curry the method and then call it with self.
      # This returns another method which can take the rest of the arguments
      accessed_prop.curry.call(self)
    else
      accessed_prop
    end
  end
end

hash = { hello: 'Hi',
         greet: ->(this, name, l_name) { puts "#{this.hello}, #{name}, #{l_name}" },
         play: ->(this, reset, something) { this.hello = reset + something } }

hash.hello = 'greetings'
puts hash.greet.call('Joe', 'Mama') # => "greetings, Joe Mama"
puts hash.play.call('hello', 'no')
