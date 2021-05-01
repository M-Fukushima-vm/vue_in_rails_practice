class ApplicationController < ActionController::Base
  # Tokenが一致しなかった場合にsessionを空にする(CSRF対策設定)
  protect_from_forgery with: :null_session

  # 独自例外の定義にStandardErrorを継承(https://blog.toshimaru.net/ruby-standard-error/)
  class AuthenticationError < StandardError; end

  # rescue_from: 例外処理の設定
    # railsのバリデーションエラー(ActiveRecord::RecordInvalid)が起きたら
    # privateメソッドの render_422 を返す
  rescue_from ActiveRecord::RecordInvalid, with: :render_422

  # rescue_from: 例外処理の設定(独自)
    # AuthenticationError(独自)が起きたら
    # privateメソッドの not_authenticated を返す
  rescue_from AuthenticationError, with: :not_authenticated


# ここからアクション
  # ...現在ログイン中のユーザーか判定
  def curreent_user
    # 作成するJwt::UserAuthenticatorの call メソッドを呼ぶ
      # (=>app/services/jwt/user_authenticator.rb)
    # 呼んだ call 内でuser情報を探して、取得できたら代入
    # リクエストヘッダーの情報を引数にして呼ぶ(呼ぶ call メソッド内で使う為)
    @current_user ||= Jwt::UserAuthenticator.call(request.headers)
  end

  # ...現在ログイン中のuserでなければエラーを発生させる
  def authenticate
    # raise 〜 ...〜エラーを発生させる
    # AuthenticationErrorを発生させて、
    # rescue_from:に設定した privateメソッド を実行する
    raise AuthenticationError unless current_user
  end

# ここからprivateメソッド
  private

  def render_422(exception)
    # unprocessable_entityステータスとエラーメッセージをjson形式で返す
      # railsの処理できない実体(unprocessable_entity 422)ステータス
      # https://railsguides.jp/layouts_and_rendering.html#status%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3
    render json: { error: { messages: exception.record.errors.full_messages } },
    status: :unprocessable_entity
  end

  # ログインしていないと判断される時
  def not_authenticated
    # unauthorizedステータスとエラーメッセージをjson形式で返す
    render json: { error: { messages: ['ログインしてください'] } }, status: :unauthorized
  end
end
