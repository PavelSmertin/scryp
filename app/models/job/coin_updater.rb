require 'net/http'
require 'json'

class Job::CoinUpdater

  CRYPTOCOMPARE_MEDIA   = 'https://www.cryptocompare.com'
  CRYPTOCOMPARE_API_URI = 'https://www.cryptocompare.com/api/data/coinlist/'

  def update

    cryptocompare_api_uri = URI(CRYPTOCOMPARE_API_URI)

    #@logger.info 'BEGIN: '

    begin

      #@logger.info 'API RESPONSE: '

      response = Net::HTTP.get_response(cryptocompare_api_uri)

      if response.code == "301"
        response = Net::HTTP.get_response(URI.parse(response.header['location']))
      end

      response_parsed = JSON.parse(response.body)

      if response.code != "200"
        #@logger.error response.code 
        raise 'Error in CRYPTOCOMPARE API response. code: {response.code}'
      end

      if response_parsed['Response'] == 'Error'
        raise response_parsed['Message']
      end

      coins = response_parsed['Data']

      coins.each do |symbol, coin|

        current_coin = Coin.find_by(:symbol => symbol)
        if current_coin.nil?
          current_coin = Coin.new

          current_coin.remote_logo_url        = "#{CRYPTOCOMPARE_MEDIA}#{coin['ImageUrl']}"

          current_coin.id                     = coin['Id']
          current_coin.symbol                 = coin['Symbol']
          current_coin.coin_name              = coin['CoinName']
          current_coin.full_name              = coin['FullName']
          current_coin.algorithm              = coin['Algorithm']
          current_coin.proof_type             = coin['ProofType']
          current_coin.fully_premined         = coin['FullyPremined'].to_i
          current_coin.total_coin_supply      = coin['TotalCoinSupply'].to_i 
          current_coin.pre_mined_value        = coin['PreMinedValue'].to_i
          current_coin.total_coins_free_float = coin['TotalCoinsFreeFloat'].to_i
          current_coin.sort_order             = coin['SortOrder'].to_i
          current_coin.sponsored              = coin['Sponsored']

          if !current_coin.save
            #@logger.error "not saved #{current_coin.symbol}"
          end

        end
      end

      #@logger.info 'Coins update Job: SUCCESS'

    rescue Exception => ex
      p ex
      #@logger.error 'Coins update Job: ERROR'
      #@logger.error "Date: #{@utc_date}"
      #@logger.error 'CRYPTOCOMPARE API response: '
      #@logger.error response_parsed.to_s
      #@logger.error "Message: #{ex.inspect}\nTrace:\n#{ex.backtrace.join "\n"}"
    end

    return true;

  end

  #private
  #@logger = Logger.new("#{Rails.root}/log/job.log")

end