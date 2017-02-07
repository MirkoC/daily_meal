class User::RegistrationsController < Devise::RegistrationsController
  # POST /users
  def create
    @user = User.new(registration_params)
    if @user.save
      render :show
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  # PUT /users
  # def update
  # end

  private

  def registration_params
    params.permit(:email, :password, :password_confirmation)
  end
end
