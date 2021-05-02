# 暗号化トークンを返すコントローラー
  # ブラウザからのparams[:session]を受け取って、登録ユーザーかを判定
  # 作成する生成モジュール(Jwt::TokenProvider)を使って暗号化トークンを生成
  # json形式で返す
  # 登録ユーザーでなければ、入力ミスとしてエラーメッセージを返す

class Api::SessionsController < ApplicationController
  def create
    # privateメソッドのemailデータを元にUserを見つけ、userに代入
    user = User.find_by(email: session_params[:email])
      # user& = userがnilじゃない場合に
      # application_controllerの authenticateメソッド を実行(=>ログイン判定)
    # つまり、params[:email]から登録ユーザーである確認が取れて、ログインする時
    if user&.authenticate(session_params[:password])
      # token_provider.rbの callアクションを呼び出し
      # 暗号化したトークンを token に代入
      token = Jwt::TokenProvider.call(user_id: user.id)
      # 登録確認できたuserデータのうち
      # app/serializers/user_serializer.rb でattributesした情報で
      # json形式のserializerインスタンスを生成して、jsonで返す
      render json: { user: ActiveModelSerializers::SerializableResource.new(user, adapter: :attributes), token: token }, status: :created
        # 作成した config/initialozers/active_model_serializer.rb (設定ファイル)
        # での、ハッシュの中身だけ用いる記載 => adapter: :attributes

    # 登録ユーザーである確認ができない場合
    else
      # jsonで message と unauthorizedステータス を返す
      render json: { error: { messages: ['メールアドレスまたはパスワードに誤りがあります。'] } },
      status: :unauthorized
    end
  end

  private

  # ブラウザからのパラメーターで受け取るデータを定義
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
