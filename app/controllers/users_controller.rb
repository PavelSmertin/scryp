class UsersController < ApplicationController
  
  include ErrorSerializer
  skip_before_action :authenticate_user, only: [:create, :public_portfolio]
  skip_before_action :verify_authenticity_token, only: [:create, :data_update, :update]

  def index
    render json: User.all
  end

  def show
    render json: {
      :avatar => current_user.avatar.url, 
      :first_name => current_user.first_name,
      :last_name => current_user.last_name
    }
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

  def update
    user = User.find(current_user.id)

    if user.update(update_params)
      render json: {success: true, message: 'User was successfully updated.'}, status: 200
    else
      render json: ErrorSerializer.serialize(user.errors), status: 422
    end
  end


  def data_update
    updated_at = Time.zone.now
    current_user.data = sync_params[:data]

    # Json положить в таблицы
    h = JSON.parse sync_params[:data]

    portfolios_for_update = []

    h["portfolios"].each do |h_portfolio| 

      created_at = DateTime.strptime(CGI::unescape(h_portfolio["created_at"]), '%Y-%m-%d %H:%M:%S')

      portfolio = Portfolio.where(user_id: current_user.id, portfolio_id: h_portfolio["_id"]).first_or_initialize

      portfolio.user_id         = current_user.id
      portfolio.portfolio_id    = h_portfolio["_id"]
      portfolio.base_coin_id    = h_portfolio["base_coin_id"]
      portfolio.balance         = h_portfolio["balance"]
      portfolio.original        = h_portfolio["original"]
      portfolio.price_original  = h_portfolio["price_original"]
      portfolio.created_at      = created_at
      portfolio.updated_at      = updated_at

      if(current_user.first_name.to_s.empty? && current_user.last_name.to_s.empty?)
        portfolio.user_name = "user#{current_user.id}"
      else
        portfolio.user_name = "#{current_user.first_name} #{current_user.last_name}"
      end

      portfolio.save
      portfolios_for_update << portfolio
    end

    h["portfolio_coins"].each do |h_portfolio_coin| 

      created_at = DateTime.strptime(CGI::unescape(h_portfolio_coin["created_at"]), '%Y-%m-%d %H:%M:%S')

      portfolio_coin = PortfolioCoin.where(user_id: current_user.id, portfolio_coin_id: h_portfolio_coin["_id"]).first_or_initialize

      new_portfolio_coin = {}
      portfolio_coin.user_id           = current_user.id
      portfolio_coin.portfolio_id      = h_portfolio_coin["portfolio_id"]
      portfolio_coin.portfolio_coin_id = h_portfolio_coin["_id"]
      portfolio_coin.coin_id           = h_portfolio_coin["coin_id"]
      portfolio_coin.symbol            = h_portfolio_coin["symbol"]
      portfolio_coin.exchange          = h_portfolio_coin["name"]
      portfolio_coin.exchange_id       = h_portfolio_coin["exchange_id"]
      portfolio_coin.original          = h_portfolio_coin["original"]
      portfolio_coin.price_original    = h_portfolio_coin["price_original"]
      portfolio_coin.created_at        = created_at
      portfolio_coin.updated_at        = updated_at


      portfolio_coin.save

    end

    # portfolios_for_update.each { |portfolio|
    #   calculator = Job::PortfolioCalculator.new
    #   calculator.calculate_portfolio(current_user.id, portfolio)
    # }

    Job.run

    if current_user.save
      render json: {success: true, updated_at: updated_at}, status: 200
    else
      render json: ErrorSerializer.serialize(user.errors), status: 422
    end
  end

  def data
    render plain: current_user.data, status: 200
  end

  def public_portfolio
    #render json: User.find(params[:user_id]).data, status: 200
    render json: PortfolioCoin.where(user_id: params[:user_id], portfolio_id: params[:portfolio_id]), status: 200

  end

  private

    def user_params
      params.require(:user).permit(:avatar, :first_name, :last_name, :email, :password, :password_confirmation)
    end
    def update_params
      params.permit(:avatar, :first_name, :last_name)
    end
    def sync_params
      params.permit(:data)
    end

end