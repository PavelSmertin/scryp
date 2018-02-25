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

    portfolio_coins = PortfolioCoin.where(user_id: user_id, portfolio_id: portfolio.portfolio_id, removed: true)

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

    portfolio_coins = PortfolioCoin.where(user_id: user_id, portfolio_id: portfolio.portfolio_id, removed: true)

    value_holdings = 0;
    change_24h = 0;
    value_7d = 0;

    portfolio_coins.each { |portfolio_coin| 
      change_24h += portfolio_coin.original * portfolio_coin.change_24h if !portfolio_coin.change_24h.nil?
      value_7d += portfolio_coin.original * portfolio_coin.price_7d if !portfolio_coin.price_7d.nil?
      value_holdings += portfolio_coin.original * portfolio_coin.price_now if !portfolio_coin.price_now.nil?
    }

    portfolio.coins_count = portfolio_coins.size

    value_24h = value_holdings - change_24h
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

    return true;
  end

end