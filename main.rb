require 'dotenv/load'
require 'httparty'
require 'yaml'
require_relative 'lib/stock_tracker'
require_relative 'lib/notifier'

# Load configuration
config = YAML.load_file('config/stocks.yml')

# Initialize Stock Tracker and Notifier
stock_tracker = StockTracker.new(config['stocks'])
notifier = Notifier.new

# Main loop
loop do
  stock_tracker.track do |symbol, price, upper_threshold, lower_threshold|
    if price > upper_threshold
      notifier.alert("ALERT: #{symbol} price ($#{price}) exceeded upper threshold ($#{upper_threshold})")
    elsif price < lower_threshold
      notifier.alert("ALERT: #{symbol} price ($#{price}) fell below lower threshold ($#{lower_threshold})")
    end
  end
  sleep 60 # Check every 60 seconds
end