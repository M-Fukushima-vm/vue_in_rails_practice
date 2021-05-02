# 設定ファイル
# モデル名のハッシュで包みたい場合
ActiveModelSerializers.config.adapter = :json

# ex. Userモデル(:name, :email)
#      => user: {name:〜, email:〜} な形式で返るようになる 