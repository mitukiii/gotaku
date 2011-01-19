$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'gotaku'

ASSETS_DIR   = File.join File.dirname(__FILE__), 'files'
GOTAKU_FILE  = File.join ASSETS_DIR, 'test.5tq'
INVALID_FILE = File.join ASSETS_DIR, 'invalid.5tq'

RSpec.configure do |config|
end
