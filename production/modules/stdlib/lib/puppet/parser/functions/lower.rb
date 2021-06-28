#
# lower.rb
#

module Puppet::Parser::Functions
  newfunction(:lower, :type => :rvalue, :doc => <<-EOS
Converts a string or an array of strings to lowercase.

*Examples:*

    lower("SENTHILNATHAN")

Will return:

    senthilnathan
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "lower(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'lower(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.downcase : i }
    else
      result = value.downcase
    end

    return result
  end
end

