# application_controller.rbにcurreent_userを返すモジュール

module Jwt::UserAuthenticator
  # 呼び出し可能にする extend self
    # =>以下のアクションを モジュール名.アクション名 で呼び出し可能にする
    # https://qiita.com/yaotti/items/c75d51c5b79a8554feba
  extend self

# ここからアクション
  def call(request_headers)
    # application_controller.rbから持ってきた request.headers が、ここでの request_headers
    # 必要データを抜き出す為、一旦 @request_headersへ代入
    @request_headers = request_headers

    begin # エラーが起こりそうなアクション
    # privateメソッドで引数に必要なデータを抽出。(=>引数に設定)
    # 作成するJwt::TokenDecryptorの call メソッドを呼ぶ
      # (=>app/services/jwt/token_decryptor.rb)
    # 呼んだ call メソッドで
      # jwtの実データをpayload、jwtの(種別情報を含む)ヘッダー情報を_、へそれぞれ代入
    # payloadのデータを元にユーザーを探す
      # (=>application_controller.rb の curreent_userアクション内に飛ばす)
      payload, _ = Jwt::TokenDecryptor.call(token)
      User.find(payload['user_id'])
    # エラーが起きた時のアクション
    rescue StandardError # StandardError が起きた時
      # nil を返す
      nil
    end
  end

  private

  # @request_headersから authrizationのデータ(tokenのみ)を取得
  def token
    @request_headers['Authorization'].split(' ').last
  end
end