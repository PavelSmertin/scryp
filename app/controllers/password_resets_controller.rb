class PasswordResetsController < ApplicationController

  skip_before_action :authenticate_user
  skip_before_action :verify_authenticity_token


  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      render json: {success: true, user_id: @user.id}, status: 200
    else
      render json: {success: false, messsage: "email not found"}, status: 404
    end
  end

  def update

    @user = User.find(params[:id])

  	if !valid_user
  	  render json: {success: false, messsage: "user not valid"}, status: 440
  	  return
  	end

    if @user.password_reset_expired?
      render json: {success: false, messsage: "code expired"}, status: 440
    elsif user_params[:password].empty?
      render json: {success: false, messsage: "password can't be empty"}, status: 422
    else 
      @user.update_attribute(:password, user_params[:password])
      @user.update_attribute(:reset_digest, nil)
      render json: {success: true, jwt: Knock::AuthToken.new(payload: {sub: @user.id}).token }, status: 422

    end
  end

  private

    def valid_user
      @user && @user.activated? && @user.authenticated?(:reset, user_params[:code])
    end

    def user_params
      params.require(:password_reset).permit(:id, :code, :password , :password_confirmation)
    end



end
