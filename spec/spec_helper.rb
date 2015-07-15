require 'coveralls'
Coveralls.wear!

require 'rspec/its'

require 'pry'
require 'collectr'

include Collectr

def redis_exists?
  Redis.current.dbsize
  true
rescue
  false
end
