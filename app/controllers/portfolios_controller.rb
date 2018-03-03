class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]


  def index
    public_portfolios = Portfolio.joins(:user).where("users.activated", true).order("profit_24h DESC").all

    public_portfolios_array = []
    public_portfolios.each { |public_portfolio| 

      next if public_portfolio.price_original <= 0
      
      public_portfolio_element = {}

      public_portfolio_element["portfolio_id"]     = public_portfolio.portfolio_id
      public_portfolio_element["user_id"]          = public_portfolio.user.id
      public_portfolio_element["avatar"]           = public_portfolio.user.avatar.small.url
      public_portfolio_element["coins_count"]      = public_portfolio.coins_count
      public_portfolio_element["profit_24h"]       = public_portfolio.profit_24h
      public_portfolio_element["profit_7d"]        = public_portfolio.profit_7d

      if public_portfolio.user.first_name.to_s.empty? && public_portfolio.user.last_name.to_s.empty?
        public_portfolio_element["user_name"]      = "user#{public_portfolio.user.id}"
      else
        public_portfolio_element["user_name"]      = "#{public_portfolio.user.first_name} #{public_portfolio.user.last_name}"
      end

      public_portfolios_array << public_portfolio_element
    }
    render json: public_portfolios_array, status: 200
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
  end

  # GET /portfolios/new
  def new
    @portfolio = Portfolio.new
  end

  # GET /portfolios/1/edit
  def edit
  end

  # POST /portfolios
  # POST /portfolios.json
  def create

    current_portfolio = Portfolio.where(["user_id = ?", current_user.id]).first

    if(current_portfolio.nil?)
      @portfolio = Portfolio.new(portfolio_params)
      @portfolio.user_id = current_user.id
      respond_to do |format|
        if @portfolio.save
          format.html { redirect_to @portfolio, notice: 'Portfolio was successfully created.' }
          format.json { render :show, status: :created, location: @portfolio }
        else
          format.html { render :new }
          format.json { render json: @portfolio.errors, status: :unprocessable_entity }
        end
      end
    else
      @portfolio = current_portfolio
      respond_to do |format|
        if @portfolio.update(portfolio_params)
          format.html { redirect_to @portfolio, notice: 'Portfolio was successfully updated.' }
          format.json { render :show, status: :ok, location: @portfolio }
        else
          format.html { render :edit }
          format.json { render json: @portfolio.errors, status: :unprocessable_entity }
        end
      end
    end


  end

  # PATCH/PUT /portfolios/1
  # PATCH/PUT /portfolios/1.json
  def update

    respond_to do |format|
      if @portfolio.update(portfolio_params)
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully updated.' }
        format.json { render :show, status: :ok, location: @portfolio }
      else
        format.html { render :edit }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    @portfolio.destroy
    respond_to do |format|
      format.html { redirect_to portfolios_url, notice: 'Portfolio was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portfolio
      @portfolio = Portfolio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def portfolio_params
      params.fetch(:portfolio, {}).permit(:user_name, :coins_count, :profit_24h, :profit_7d)
    end
end
