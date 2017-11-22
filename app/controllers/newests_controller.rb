class NewestsController < ApplicationController
  before_action :set_newest, only: [:show, :edit, :update, :destroy]

  # GET /newests
  # GET /newests.json
  def index
    hash_params = params.fetch(:newests, {}).permit(:start_time, :end_time, category_ids: [], coin_ids: []).to_h

    @start_time = hash_params[:start_time]
    @end_time = hash_params[:end_time]
    @my_categories = hash_params[:category_ids]
    coin_ids = hash_params[:coin_ids].map(&:to_i).split(",") unless hash_params[:coin_ids].nil?
    @my_coins = Coin.where(id: coin_ids)

    @newests = Newest.joins(event: [:coin, :category])
                      .select('newests.id as id, newests.image as image, newests.created_at as created_at, newests.text as text, newests.link as link, events.start_time as start_time, events.end_time as end_time, categories.name as name, coins.id as coin_id, coins.logo as logo, coins.full_name as full_name')
                      .order('newests.created_at DESC')

    @newests = @newests.where("end_time >= ? OR (end_time IS NULL AND start_time >= ?)", @start_time, @start_time) unless @start_time.blank?
    @newests = @newests.where("start_time <= ?", @end_time) unless @end_time.blank?
    @newests = @newests.where(events: {category_id: @my_categories.map(&:to_i).split(",")}) unless @my_categories.nil?
    @newests = @newests.where(events: {coin_id: coin_ids}) unless coin_ids.nil?

  end

  # GET /newests/1
  # GET /newests/1.json
  def show
  end

  # GET /newests/new
  def new
    @newest = Newest.new
  end

  # GET /newests/1/edit
  def edit
  end

  # POST /newests
  # POST /newests.json
  def create

    @event = Event.new(event_params)

    if @event.save
      @newest = Newest.new(newest_params)
      @newest.event_id = @event.id
    else
      format.html { render :new }
      format.json { render json: @newest.errors, status: :unprocessable_entity }
      return
    end

    respond_to do |format|
      if @newest.save
        format.html { redirect_to @newest, notice: 'Newest was successfully created.' }
        format.json { render :show, status: :created, location: @newest }
      else
        format.html { render :new }
        format.json { render json: @newest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /newests/1
  # PATCH/PUT /newests/1.json
  def update
    respond_to do |format|
      if @newest.update(newest_params)
        format.html { redirect_to @newest, notice: 'Newest was successfully updated.' }
        format.json { render :show, status: :ok, location: @newest }
      else
        format.html { render :edit }
        format.json { render json: @newest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /newests/1
  # DELETE /newests/1.json
  def destroy
    @newest.destroy
    respond_to do |format|
      format.html { redirect_to newests_url, notice: 'Newest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newest
      @newest = Newest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def newest_params
      params.fetch(:newest, {}).permit(:text, :link, :image)
    end

        # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.fetch(:event, {}).permit(:title, :describtion, :link, :start_time, :end_time, :coin_id, :category_id)
    end
end
