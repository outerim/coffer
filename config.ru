$:.insert(0, File.join(File.dirname(__FILE__), 'lib'))
require 'coffer'

use Rack::Reloader
use Rack::ContentLength
run Coffer::App.handler
