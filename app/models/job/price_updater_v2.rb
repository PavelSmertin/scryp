require 'net/http'
require 'json'

class Job::PriceUpdaterV2

  CRYPTOCOMPARE_API_URI = 'https://min-api.cryptocompare.com/data/pricemulti'

  def initialize(logger)
    @logger = logger
  end

  def update

    coins = PortfolioCoin.select(:symbol, :coin_id, :exchange_id, :exchange).where(removed: [false,nil]).distinct.index_by(&:symbol)

    parts = []
    coins_keys = coins.keys
    while coins_keys.size > 0 do 
      parts << coins_keys.slice!(0..50)
    end

    exchange = "CCCAGG"

    begin

      parts.each do |part|

        symbols = part.join(',')
        response  = get_response("#{CRYPTOCOMPARE_API_URI}?fsyms=#{symbols}&tsyms=BTC,USDT,USD,EUR")
        rows = []
        response.each do |symbol, prices|
          rows << {
            # :coin_id => coins[symbol].coin_id, 
            # :exchange_id => coins[symbol].exchange_id, 
            :exchange => exchange, 
            :symbol => symbol, 
            :date => Time.zone.now.at_beginning_of_day.to_s(:db), 
            :usdt => prices["USDT"], 
            :usd => prices["USD"], 
            :eur => prices["EUR"], 
            :btc => prices["BTC"], 
            :created_at => Time.zone.now, 
            :updated_at => Time.zone.now
          }

        end
        Price.import rows, on_duplicate_key_update: {conflict_target: [:exchange, :symbol, :date], columns: [:usdt, :usd, :eur, :btc, :updated_at]}
      end

    rescue Exception => ex
      p ex
    end

    return true;
  end


  def init

    coins = PortfolioCoin.select(:symbol, :coin_id, :exchange_id, :exchange).where(removed: [false,nil]).distinct.index_by(&:symbol)

    parts = []
    coins_keys = coins.keys
    while coins_keys.size > 0 do 
      parts << coins_keys.slice!(0..50)
    end

    exchange = "CCCAGG"

    begin

      parts.each do |part|

        symbols = part.join(',')
        response  = get_response("#{CRYPTOCOMPARE_API_URI}?fsyms=#{symbols}&tsyms=BTC,USDT,USD,EUR")
        rows = []
        response.each do |symbol, prices|
          rows << {
            # :coin_id => coins[symbol].coin_id, 
            # :exchange_id => coins[symbol].exchange_id, 
            :exchange => exchange, 
            :symbol => symbol, 
            :date => Time.zone.now.at_beginning_of_day.to_s(:db), 
            :usdt => prices["USDT"], 
            :usd => prices["USD"], 
            :eur => prices["EUR"], 
            :btc => prices["BTC"], 
            :created_at => Time.zone.now, 
            :updated_at => Time.zone.now
          }

          7.times  do |i|
            rows << {
              :exchange => exchange, 
              :symbol => symbol, 
              :date => (i+1).days.ago.at_beginning_of_day.to_s(:db), 
              :usdt => prices["USDT"], 
              :usd => prices["USD"], 
              :eur => prices["EUR"], 
              :btc => prices["BTC"], 
              :created_at => Time.zone.now, 
              :updated_at => Time.zone.now
            }
          end


        end
        Price.import rows, on_duplicate_key_update: {conflict_target: [:exchange, :symbol, :date], columns: [:usdt, :usd, :eur, :btc, :updated_at]}
      end

    rescue Exception => ex
      p ex
    end

    return true;
  end

  private
  def get_response(request)
    uri = URI(request)
    response  = Net::HTTP.get_response(uri)

    @logger.info 'API request: ' + request
    @logger.info 'API request: ' + response.body

    if response.code == "301"
      response = Net::HTTP.get_response(URI.parse(response.header['location']))
    end

    if response.code != "200"
      raise 'Error in CRYPTOCOMPARE API response. code: {response.code}'
    end

    response_parsed = JSON.parse(response.body)

    if response_parsed['Response'] == 'Error'
      raise response_parsed['Message']
    end

    return response_parsed

  end


end