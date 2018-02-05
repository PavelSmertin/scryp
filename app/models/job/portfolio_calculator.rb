require 'net/http'
require 'json'

class Job::PortfolioCalculator

  def calculate_all

    Portfolio.find_each { |portfolio|  
      calculate_portfolio(portfolio.user_id, portfolio)
    }

    return true;
  end

  def calculate_portfolio(user_id, portfolio)

    portfolio_coins = PortfolioCoin.where(user_id: user_id, portfolio_id: portfolio.portfolio_id)

    value_holdings = 0;
    value_24h = 0;
    value_7d = 0;

    portfolio_coins.each { |portfolio_coin| 
      value_24h += portfolio_coin.original * portfolio_coin.price_24h if !portfolio_coin.price_24h.nil?
      value_7d += portfolio_coin.original * portfolio_coin.price_7d if !portfolio_coin.price_7d.nil?
      value_holdings += portfolio_coin.original * portfolio_coin.price_now if !portfolio_coin.price_now.nil?
    }

    portfolio.coins_count = portfolio_coins.size

    profit_24h = value_holdings - value_24h;
    profit_7d  = value_holdings - value_7d;

    portfolio.profit_24h  = profit_24h
    portfolio.profit_7d   = profit_7d

    portfolio.save

    return true;
  end

end