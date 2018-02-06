require 'net/http'
require 'json'

class Job::PriceUpdater

  CRYPTOCOMPARE_API_URI = 'https://min-api.cryptocompare.com/data/pricehistorical'

  def initialize(logger)
    @logger = logger
  end

  def update

    coins = PortfolioCoin.distinct.pluck(:symbol)
    symbols = coins.join(', ')

    time_24h  = 24.hours.ago.to_time.to_i
    time_7d   = 7.days.ago.to_time.to_i
    request_now = URI("#{CRYPTOCOMPARE_API_URI}?fsym=USDT&tsyms=#{symbols}")
    request_24h = URI("#{CRYPTOCOMPARE_API_URI}?fsym=USDT&tsyms=#{symbols}&ts=#{time_24h}")
    request_7d  = URI("#{CRYPTOCOMPARE_API_URI}?fsym=USDT&tsyms=#{symbols}&ts=#{time_7d}")

    begin

      response_now  = get_response(request_now)
      response_24h  = get_response(request_24h)
      response_7d   = get_response(request_7d)

      # {"USDT":{"BTC":0.0001114}}

      hash_now  = response_now["USDT"]
      hash_24h  = response_24h["USDT"]
      hash_7d   = response_7d["USDT"]


      coins = PortfolioCoin.where(symbol: coins)

      p coins
      coins.each do |coin|
        coin.price_now = 1/hash_now[coin.symbol]  if !hash_now[coin.symbol].nil? && hash_now[coin.symbol] > 0
        coin.price_24h = 1/hash_24h[coin.symbol]  if !hash_24h[coin.symbol].nil? && hash_24h[coin.symbol] > 0
        coin.price_7d = 1/hash_7d[coin.symbol]    if !hash_7d[coin.symbol].nil? && hash_7d[coin.symbol] > 0
        if !coin.save
        end
      end


    rescue Exception => ex
      p ex
    end

    return true;
  end

  private
  def get_response(request)
      response  = Net::HTTP.get_response(request)

      @logger.info 'API request: ' + request
      @logger.info 'API response: ' + response

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