class UsersController < ApplicationController
  
  include ErrorSerializer
  skip_before_action :authenticate_user, only: [:create]
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
      render json: {}, status: 200
    else
      render json: ErrorSerializer.serialize(user.errors), status: 422
    end
  end

  def data_update
    current_user.data = sync_params[:data]
    if current_user.save
      render json: {}, status: 200
    else
      render json: ErrorSerializer.serialize(user.errors), status: 422
    end
  end

  def data
    render plain: current_user.data, status: 200
  end


  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    def sync_params
      params.permit(:data)
    end

end