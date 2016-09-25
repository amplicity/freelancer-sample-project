class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    info = request.env["omniauth.auth"]
    if info && info.info && !info.info.email.nil?
      @user = User.from_omniauth(info)
      sign_in @user
    end
    redirect_to root_path
  end
end