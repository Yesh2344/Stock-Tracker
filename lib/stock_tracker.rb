require 'httparty'

class StockTracker
  attr_reader :stocks

  def initialize(stocks)
    @stocks = stocks
    @api_key = ENV['IEX_API_KEY']
    raise "IEX_API_KEY is not set in .env" if @api_key.nil? || @api_key.empty?
  end

  def get_quote(symbol)
    url = "https://cloud.iexapis.com/stable/stock/#{symbol}/quote?token=#{@api_key}"
    response = HTTParty.get(url)
    if response.success?
      response['latestPrice']
    else
      puts "Error fetching quote for #{symbol}: #{response.message}"
      nil
    end
  end

  def track
    @stocks.each do |stock|
      symbol = stock['symbol']
      price = get_quote(symbol)

      next if price.nil?

      upper_threshold = stock['upper_threshold']
      lower_threshold = stock['lower_threshold']

      yield symbol, price, upper_threshold, lower_threshold if block_given?
    end
  end
end