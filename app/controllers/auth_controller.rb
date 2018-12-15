class AuthController < ActionController::Base

  layout "login"

  # ログイン画面の表示
  def login_form
  end

  # ログイン処理の実行
  def login
    user = User.find_by(email: params[:email])
    # ハッシュ化したパスワードで認証
    if user && user.authenticate(params[:password]);
      session[:user_id] = user.id
      flash[:notice] = "ログインしました"
      redirect_to(:root)
    else
      flash[:error] = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]

      render action: :login_form
    end
  end

  # ログアウト処理の実行
  def logout
    session[:user_id] = nil
    flash[:info] = "ログアウトしました"
    redirect_to(:root)
  end
end
