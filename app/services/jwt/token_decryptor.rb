# user_authenticater.rbからのauthrizationデータ(token)の
# 暗号化を解除(=復号...暗号を暗号化前の状態に復活)し、
# user_authenticater.rbに戻すモジュール

module Jwt::TokenDecryptor
  # 呼び出し可能にする extend self
  # =>以下のアクションを モジュール名.アクション名 で呼び出し可能にする
  # https://qiita.com/yaotti/items/c75d51c5b79a8554feba
  extend self

# ここからアクション
  def call(token)
    # 下のprivateメソッドを実行
      # (=>user_authenticater.rb の bigin内 payload, _ = の右辺に返す)
    decrypt(token)
  end

  private

  # user_authenticater.rbからの(token)の暗号化解除(=復号)
  def decrypt(token)
    # Railsの秘密鍵で暗号化解除
    JWT.decode(token, Rails.application.credentials.secret_key_base)
  # エラーが起きた時のアクション
  rescue StandardError # StandardErrorが起きた時
    # 独自の InvalidTokenError を返す ↓↓↓
    raise InvalidTokenError
  end

end
# 独自例外の定義にStandardErrorを継承(https://blog.toshimaru.net/ruby-standard-error/)
class InvalidTokenError < StandardError; end
