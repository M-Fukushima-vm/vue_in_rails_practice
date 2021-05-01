# トークンの発行に関わるモジュール...エンコード(暗号化変換)をする
module Jwt::TokenProvider
  # 呼び出し可能にする extend self
    # =>以下のアクションを モジュール名.アクション名 で呼び出し可能にする
    # https://qiita.com/yaotti/items/c75d51c5b79a8554feba
  extend self

# ここからアクション
  def call(payload)
    # ↓のprivateメソッド issue_token の実行
    issue_token(payload)
  end

# ここからprivateメソッド
  private

  # エンコード(暗号化変換)
  def issue_token(payload)
    # Railsの秘密鍵で暗号化
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end