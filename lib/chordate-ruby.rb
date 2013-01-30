require 'chordate-ruby/chordate'

['typhoeus',
 'celluloid',
 'chordate-ruby/version',
 'chordate-ruby/http',
 'chordate-ruby/error',
 'chordate-ruby/runner',
].each do |file|
  require file
end

Celluloid.logger = nil
