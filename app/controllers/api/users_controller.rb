class Api::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.save!
    # https://railsguides.jp/layouts_and_rendering.html#status%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3
    render json: user, serializer: UserSerializer, status: 201
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
