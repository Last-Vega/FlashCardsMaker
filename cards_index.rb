#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require("cgi")
require("cgi/session")
c = CGI.new
session = CGI::Session.new(c)
login_id = c["login_id"]
require("sqlite3")
require("date")
session["id"] = login_id
print c.header("text/html; charset=utf-8")
begin
  
=begin
データベースのテーブルを作成する関数
引数: db_name
=end
def create(db_name)
  db = SQLite3::Database.new(db_name)
  i = 1
  while i < 6
    db.transaction{
      db.execute("create table level#{i}(
        word text,
        meaning text,
        partofspeech text,
        synonym text,
        sentence text,
        date text,
        primary key(word)
        )"
      )
      db.execute("create table count_level#{i}(
        word text,
        count_stored integer,
        count_unstored integer,
        primary key(word)
        )"
      )
    }
    i += 1
  end
end

#データベース名を変数db_nameとして保存
db_name = "flashcards_" + login_id + ".db"
if File.exist?(db_name)
  #なにもしない
else
  #関数呼び出し
  create(db_name)
end
#例外処理
rescue => ex
  puts ex.message
  puts ex.backtrace
end

# html本体
print <<-EOS
<!DOCTYPE html>
<html lang = "ja">
<head>
<title>FlashCards Maker</title>
</head>
  <body>
    <h1>FlashCards Maker</h1>
    <p>#{session["id"]}さんの単語帳です</p>

    <h2><a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/entry_form.rb">単語を登録</a></h2>
    <h2>勉強する</h2>
    <form
      action = "http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/study.rb"
      method = "post"
      >
      <p>
      <div> デッキ： <select name="level">
        <option value="level1">レベル１</option>
        <option value="level2">レベル２</option>
        <option value="level3">レベル３</option>
        <option value="level4">レベル４</option>
        <option value="level5">レベル５</option>
        </select>
      </div>
      <p>
        <input type = "submit" value = "勉強開始！">
      </p>
    </form>
    <form
      action = "http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/exam.rb"
      method = "post"
      >
      <p>
      <h2>テストする</h2>
      <div> デッキ： <select name="level">
        <option value="level1">レベル１</option>
        <option value="level2">レベル２</option>
        <option value="level3">レベル３</option>
        <option value="level4">レベル４</option>
        <option value="level5">レベル５</option>
        </select>
      </div>
      <p>
        <input type = "submit" value = "テスト開始！">
      </p>
    </form>
  </body>
</html>
EOS
