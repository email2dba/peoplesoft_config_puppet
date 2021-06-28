#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join2strings, :type => :rvalue, :doc => <<-EOS
This function joins two strings into one string 
*Examples:*

    join2string("str1","str2")

Would result in: ["str1str2"]
    EOS
  ) do |arguments|

    # Validate the number of arguments.
    if arguments.size != 2
      raise(Puppet::ParseError, "join2string(): Takes exactly two " +
            "arguments, but #{arguments.size} given.")
    end
    result = arguments[0] + arguments[1]
    return result
  end
end

# vim: set ts=2 sw=2 et :
