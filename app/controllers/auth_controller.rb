# class AuthController < ActionController::Base
class AuthController < ApplicationController
  skip_before_action :login_check, except: [:logout]

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
      flash[:info] = "ログインしました"
      redirect_to(:root)
    else
      flash.now[:error] = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]

      render action: :login_form
    end
  end

  # メールアドレス認証(認証が取れればデータベースにアカウントを登録)
  def user_check
    authcode = REDIS_USER_UNAUTH_PREFIX + params[:authcode]
    redis = Redis.new
    user = redis.hgetall authcode
    if user
      # ユーザ情報をmodelにセットする
      @user = User.new(
        email: user['email'],
        password_digest: user['password_digest'],
        name: user['name'],
        is_valid: user['is_valid']
      )
    else
      # redisからユーザ情報が取得できなかった場合は、再度登録を促す
      flash.now[:error] = "ユーザ認証期限を過ぎています。再度ユーザ登録から行ってください。"
      render :login_form and return
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, flash: {info: 'ユーザ登録が完了しました。'}}
        format.json { render :show, status: :created, location: @user }
      else
        # TODO システムエラー
        format.html { render :login_form}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # ログアウト処理の実行
  def logout
    session[:user_id] = nil
    flash[:info] = "ログアウトしました"
    redirect_to(:root)
  end
end