#
# upper.rb
#

module Puppet::Parser::Functions
  newfunction(:upper, :type => :rvalue, :doc => <<-EOS
Converts a string or an array of strings to uppercase.

*Examples:*

    upper("deena")

Will return:

    DEENA
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "upper(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'upper(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.upcase : i }
    else
      result = value.upcase
    end

    return result
  end
end

