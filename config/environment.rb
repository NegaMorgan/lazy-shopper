require 'bundler/setup'
Bundler.require(:default)

require 'open-uri'
require 'json'

require_relative '../lib/max_delivery_search'
require_relative '../lib/fresh_direct_search'
require_relative '../lib/delivery_dot_com_search'
require_relative '../lib/lazy_shopper_cli'