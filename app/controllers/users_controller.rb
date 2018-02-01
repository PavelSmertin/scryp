class UsersController < ApplicationController
  
  include ErrorSerializer
  skip_before_action :authenticate_user, only: [:create, :public_portfolio]
  skip_before_action :verify_authenticity_token, only: [:create, :data_update]

  def index
    render json: User.all
  end

  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new(user_params)
    if user.save
      user.activate
      render json: {success: true, jwt: Knock::AuthToken.new(payload: {sub: user.id}).token}, status: 200
    else
      render json: ErrorSerializer.serialize(user.errors), status: 422
    end
  end

  def data_update
    updated_at = Time.zone.now
    current_user.data = sync_params[:data]

    # Json положить в таблицы
    h = JSON.parse sync_params[:data]

    h["portfolios"].each do |h_portfolio| 

      new_porfolio = {}
      new_porfolio["user_id"]         = current_user.id
      new_porfolio["portfolio_id"]    = h_portfolio["_id"]
      new_porfolio["base_coin_id"]    = h_portfolio["base_coin_id"]
      new_porfolio["balance"]         = h_portfolio["balance"]
      new_porfolio["original"]        = h_portfolio["original"]
      new_porfolio["price_now"]       = h_portfolio["price_now"]
      new_porfolio["price_original"]  = h_portfolio["price_original"]
      new_porfolio["price_24h"]       = h_portfolio["price_24h"]
      new_porfolio["coins_count"]     = h_portfolio["coins_count"]
      new_porfolio["profit_24h"]      = h_portfolio["profit_24h"]
      new_porfolio["profit_7d"]       = h_portfolio["profit_7d"]
      new_porfolio["created_at"]      = h_portfolio["created_at"]
      new_porfolio["updated_at"]      = updated_at

      if(current_user.first_name.to_s.empty? && current_user.last_name.to_s.empty?)
        new_porfolio["user_name"] = "user#{current_user.id}"
      else
        new_porfolio["user_name"] = "#{current_user.first_name} {current_user.last_name}"
      end

      portfolio = Portfolio.where(user_id: current_user.id, portfolio_id: h_portfolio["_id"]).first_or_initialize
      portfolio.update(new_porfolio)
    end

    h["portfolio_coins"].each do |h_portfolio_coin| 

      client_portfolio_id = h_portfolio_coin["portfolio_id"]

      new_portfolio_coin = {}
      new_portfolio_coin["user_id"]         = current_user.id
      new_portfolio_coin["portfolio_id"]    = h_portfolio_coin["portfolio_id"]
      new_portfolio_coin["coin_id"]         = h_portfolio_coin["coin_id"]
      new_portfolio_coin["exchange_id"]     = h_portfolio_coin["exchange_id"]
      new_portfolio_coin["original"]        = h_portfolio_coin["original"]
      new_portfolio_coin["price_now"]       = h_portfolio_coin["price_now"]
      new_portfolio_coin["price_original"]  = h_portfolio_coin["price_original"]
      new_portfolio_coin["price_24h"]       = h_portfolio_coin["price_24h"]
      new_portfolio_coin["price_7d"]        = h_portfolio_coin["price_7d"]
      new_portfolio_coin["created_at"]      = h_portfolio_coin["created_at"]
      new_portfolio_coin["updated_at"]      = updated_at


      portfolio_coin = PortfolioCoin.where(user_id: current_user.id, portfolio_id: client_portfolio_id).first_or_initialize
      portfolio_coin.update(new_portfolio_coin)

    end

    if current_user.save
      render json: {success: true, updated_at: updated_at}, status: 200
    else
      render json: ErrorSerializer.serialize(user.errors), status: 422
    end
  end

  def data

    # TODO сформировать json из таблиц
    render plain: current_user.data, status: 200
  end

  def public_portfolio
    render json: User.find(params[:user_id]).data, status: 200
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    def sync_params
      params.permit(:data)
    end

end