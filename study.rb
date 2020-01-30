#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require("cgi")
require("cgi/session")
c = CGI.new
session = CGI::Session.new(c)
require("sqlite3")
require("date")
print c.header("text/html; charset=utf-8")

#必要な情報の受け取り
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
    db.execute("select * from #{table};"){|rows|
      str += <<-EOS
      <tr>
      EOS
      rows.each{|row|
        str += <<-EOS
        <td>#{row}</td>
        EOS
      }
      str += <<-EOS
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
<script type="text/javascript" src="check_entry.js"></script>
<title>確認</title>
</head>
  <body>
    <h1>勉強しよう</h1>
    <table border=1>
    <tr>
      <th>単語</th>
      <th>意味</th>
      <th>品詞</th>
      <th>類義語</th>
      <th>例文</th>
      <th>登録日</th>
    </tr>
    #{get_word(db_name, level)}
    </table>
    <h2>詳細検索（ANDOR検索）</h2>
    <form
      action = "http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/detail_study.rb"
      method = "post"
      name = "myform"
      onsubmit = "return check2();"
      >
      <input type="text" name = "level" value="#{level}" readonly>
      <div> 品詞： <select name="speech">
        <option value="Unselected" selected> 指定しない</option>
        <option value="Verb">動詞</option>
        <option value="Noun">名詞</option>
        <option value="Adj">形容詞</option>
        <option value="Adv">副詞</option>
        <option value="Prep">前置詞</option>
        <option value="Conj">接続詞</option>
        </select>
      </div>
      <div> 頭文字: <input type = "text" name = "wordhead" id = "tango"> </div>
      <input type = "submit" value = "検索する">

    </form>

    <p>
    <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
    </p>
  </body>
</html>
EOS
