require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'pg'

client = PG::connect(
  :host => "localhost",
  :user => ENV.fetch("USER", "ichirakukiho"), :password => '',
  :dbname => "myapp")

get "/post" do
    # 投稿内容を取得する 
    @contents = client.exec_params("SELECT * FROM contents ORDER BY id DESC").to_a
    # contentsテーブルから情報を取ってきます。SELECT *（全て） ORDER BY id:id順で取得(nameだと名前順）DESK:大きいものから取ってくる(ASC:小さいものから)
    return erb :new_post
end

post "/post" do
    # formから飛んできた入力値を受け取る
    name    = params[:name]
    content = params[:content]
    # contentsテーブルに入力値を登録する
    client.exec_params("INSERT INTO contents (name, content) VALUES ($1, $2)", [name, content])
    # ↑contensテーブルに登録… テーブル名には最後sをつける。　　　↑テーブル名（カラム、カラム） VALUESはカラムに何を入れるか$1（変数）[]に$1にnameを渡してる、$2→content
    # 投稿内容を一覧で表示する画面にリダイレクト
    return redirect "/post"
end