# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
# Given an integer calculate the cron minute field to run at the
# specified interval.  This is pseudo randomized by shifting by
# a number of minutes derived from the primary mac address
# ---- original file header ----
#
# @summary
#   Summarise what the function does here
#
Puppet::Functions.create_function(:'puppet::interval_to_minute') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    
    interval = args[0].to_i
    mac = lookupvar('macaddress')
    prn = mac.split(':')[3, 5].join('').hex % interval
    runs = 60 / interval
    (1..runs).map { |x| (x * interval + prn) % 60 }.sort
  
  end
end