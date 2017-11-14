class NewestsController < ApplicationController
  before_action :set_newest, only: [:show, :edit, :update, :destroy]

  # GET /newests
  # GET /newests.json
  def index
    @newests = Newest.order(created_at: :desc).all
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
