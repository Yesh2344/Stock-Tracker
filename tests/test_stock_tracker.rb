# Minor edit
require 'rspec'
require_relative '../lib/stock_tracker'

describe StockTracker do
  let(:stocks) {
    [
      { 'symbol' => 'AAPL', 'upper_threshold' => 180, 'lower_threshold' => 150 },
      { 'symbol' => 'MSFT', 'upper_threshold' => 350, 'lower_threshold' => 300 }
    ]
  }

  let(:stock_tracker) { StockTracker.new(stocks) }

  # Mock HTTParty to avoid real API calls
  before do
    allow(HTTParty).to receive(:get).with(
      "https://cloud.iexapis.com/stable/stock/AAPL/quote?token=YOUR_IEX_CLOUD_API_KEY"
    ).and_return(OpenStruct.new(success?: true, 'latestPrice' => 175.0))

    allow(HTTParty).to receive(:get).with(
      "https://cloud.iexapis.com/stable/stock/MSFT/quote?token=YOUR_IEX_CLOUD_API_KEY"
    ).and_return(OpenStruct.new(success?: true, 'latestPrice' => 320.0))

     ENV['IEX_API_KEY'] = "YOUR_IEX_CLOUD_API_KEY"
  end

  it 'initializes with stocks' do
    expect(stock_tracker.stocks).to eq(stocks)
  end

  it 'fetches stock quotes' do
    expect(stock_tracker.get_quote('AAPL')).to eq(175.0)
    expect(stock_tracker.get_quote('MSFT')).to eq(320.0)
  end

  it 'tracks stocks and yields to the block' do
    expect { |b| stock_tracker.track(&b) }.to yield_control.twice
  end

  it 'yields the correct data to the block' do
    stock_tracker.track do |symbol, price, upper_threshold, lower_threshold|
      if symbol == 'AAPL'
        expect(symbol).to eq('AAPL')
        expect(price).to eq(175.0)
        expect(upper_threshold).to eq(180)
        expect(lower_threshold).to eq(150)
      elsif symbol == 'MSFT'
        expect(symbol).to eq('MSFT')
        expect(price).to eq(320.0)
        expect(upper_threshold).to eq(350)
        expect(lower_threshold).to eq(300)
      end
    end
  end

  context "when the API key is not set" do
    before do
      ENV['IEX_API_KEY'] = nil # Unset the environment variable

    end
    it "raises an error if IEX_API_KEY is not set" do
        ENV['IEX_API_KEY'] = nil
        expect { StockTracker.new(stocks) }.to raise_error("IEX_API_KEY is not set in .env")
    end
  end
end