class User::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  before_action :find_user

  def create
    if @user.valid_password?(params[:password])
      render :show
    else
      render json: { errors: { password: [:invalid_password] } }, status: :bad_request
    end
  end

  private

  def find_user
    @user = User.find_by_email(params[:email])
    return render json: { errors: { user: [:not_found] } }, status: :not_found unless @user
  end
end
