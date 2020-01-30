#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require("cgi")
require("cgi/session")
c = CGI.new
session = CGI::Session.new(c)
require("sqlite3")
require("date")
print c.header("text/html; charset=utf-8")

# 必要な情報の受け取り
login_id = session["id"]
level = c["level"]
db_name = "flashcards_" + login_id + ".db"

=begin
データベースの内容を表形式で表示する関数
引数: db_name, level
返り値: str
=end
def get_word(db_name, level)
  db = SQLite3::Database.new(db_name)
  table = level
  str = ""
  db.transaction{
    db.execute("select word, sentence from #{table};"){|rows|
      str += <<-EOS
      <tr>
      EOS
      word = rows[0]
      rows.each{|row|
        str += <<-EOS
        <td>#{row}</td>
        EOS
      }
      str += <<-EOS
      <td><input type="checkbox" name="stored" value="#{word}"></td>
      <td><input type="checkbox" name="unstored" value="#{word}"></td>
      </tr>
      EOS
    }
  }
  return str
end


# html本体
print <<-EOS
<!DOCTYPE html>
<html lang = "ja">
<head>
<title>確認</title>
</head>
  <body>
  <form
    action = "http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/mark.rb"
    method = "post"
    id = "form"
    >
    <h1>確認テスト！</h1>
    <input type="text" name = "level" value="#{level}" readonly>
    <table border=1>
    <tr>
      <th>単語</th>
      <th>例文</th>
      <th>覚えた！</th>
      <th>まだ覚えてない・・・</th>
    </tr>
    #{get_word(db_name, level)}
    </table>
    <p>
    <input type = "submit" value = "採点！">
    </p>
    <p>
    <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
    </p>
    </form>
  </body>
</html>
EOS
