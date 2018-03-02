require 'net/http'
require 'json'

class Job::PortfolioCalculator

  def calculate_all

    Portfolio.find_each { |portfolio|  
      calculate_portfolio_v2(portfolio.user_id, portfolio)
    }

    return true;
  end

  def calculate_portfolio(user_id, portfolio)

    portfolio_coins = PortfolioCoin.where(user_id: user_id, portfolio_id: portfolio.portfolio_id, removed: [false,nil])

    value_holdings = 0;
    value_24h = 0;
    value_7d = 0;

    portfolio_coins.each { |portfolio_coin| 
      value_24h += portfolio_coin.original * portfolio_coin.price_24h if !portfolio_coin.price_24h.nil?
      value_7d += portfolio_coin.original * portfolio_coin.price_7d if !portfolio_coin.price_7d.nil?
      value_holdings += portfolio_coin.original * portfolio_coin.price_now if !portfolio_coin.price_now.nil?
    }

    portfolio.coins_count = portfolio_coins.size

    profit_24h = value_holdings - value_24h
    profit_7d  = value_holdings - value_7d

    profit_24h_percent = 0
    profit_7d_percent = 0
    if value_holdings > 0
      profit_24h_percent = profit_24h * 100 / value_holdings
      profit_7d_percent = profit_7d * 100 / value_holdings
    end

    portfolio.profit_24h  = profit_24h_percent
    portfolio.profit_7d   = profit_7d_percent

    portfolio.save

    return true;
  end

  def calculate_portfolio_v2(user_id, portfolio)
    portfolio_coins = PortfolioCoin.where(user_id: user_id, portfolio_id: portfolio.portfolio_id, removed: [false,nil])

    time_now  = 1.days.ago.at_beginning_of_day.to_s(:db)
    time_24h  = 2.days.ago.at_beginning_of_day.to_s(:db)
    time_7d   = 7.days.ago.at_beginning_of_day.to_s(:db)
    exchange = "CCCAGG"

    prices_now = Price.where(date: time_now, exchange: exchange).index_by(&:symbol)
    prices_24h = Price.where(date: time_24h, exchange: exchange).index_by(&:symbol)
    prices_7d  = Price.where(date: time_7d, exchange: exchange).index_by(&:symbol)

    value_holdings = 0;
    value_24h = 0;
    value_7d = 0;

    portfolio_coins.each { |portfolio_coin| 
      symbol    = portfolio_coin.symbol
      price_now = prices_now[symbol].nil? ? 0 : prices_now[symbol].usdt
      price_24h = prices_24h[symbol].nil? ? 0 : prices_24h[symbol].usdt
      price_7d  = prices_7d[symbol].nil? ? 0 : prices_7d[symbol].usdt

      coin_change_24h     = price_now - price_24h 
      coin_change_pct_24h = (price_now - price_24h) * 100 / price_24h if price_24h > 0

      portfolio_coin.change_24h     = coin_change_24h
      portfolio_coin.change_pct_24h = coin_change_pct_24h
      portfolio_coin.price_now      = price_now
      portfolio_coin.price_24h      = price_24h
      portfolio_coin.updated_at     = Time.zone.now

      value_24h       += portfolio_coin.original * price_24h
      value_7d        += portfolio_coin.original * price_7d
      value_holdings  += portfolio_coin.original * price_now

      portfolio_coin.save
    }

    portfolio.coins_count = portfolio_coins.size

    change_24h = value_holdings - value_24h
    change_7d  = value_holdings - value_7d

    profit_24h_percent = 0
    profit_7d_percent = 0
    if value_24h > 0
      profit_24h_percent = change_24h * 100 / value_24h
    end

    if value_7d > 0
      profit_7d_percent = change_7d * 100 / value_7d
    end

    portfolio.profit_24h  = profit_24h_percent
    portfolio.profit_7d   = profit_7d_percent

    portfolio.save

  end

end