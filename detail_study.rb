#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require("cgi")
require("cgi/session")
c = CGI.new
session = CGI::Session.new(c)
require("sqlite3")
require("date")
print c.header("text/html; charset=utf-8")

begin
#必要な情報の受け取り
login_id = session["id"]
level = c["level"]
db_name = "flashcards_" + login_id + ".db"
speech = CGI.escapeHTML(c["speech"])
wordhead = CGI.escapeHTML(c["wordhead"])

# 検索語が何も入力されていない場合の処理
if speech == "Unselected" && wordhead == ""
  print <<-EOS
  <!DOCTYPE html>
  <html lang = "ja">
  <head></head>
  <body>
  <p>検索語を何か入力してください</p>
  <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
  </body>
  </html>
  EOS
  exit
end

=begin
データベースの内容を詳細検索し,表形式で表示する関数
後方一致を用いて頭文字で検索できるようにした。
引数: db_name, level, speech, wordhead
返り値: str
=end
def get_word(db_name, level, speech, wordhead)
  db = SQLite3::Database.new(db_name)
  table = level
  str = ""
  if wordhead != "" && speech != "Unselected"
    db.transaction{
      db.execute("select * from #{table} where word like ? and partofspeech like ?;", wordhead+"%", speech){|rows|
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
  elsif wordhead != ""
    db.transaction{
      db.execute("select * from #{table} where word like ?;", wordhead+"%"){|rows|
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
  elsif speech != "Unselected"
    db.transaction{
      db.execute("select * from #{table} where partofspeech like ?;", speech){|rows|
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
  else
    str += <<-EOS
    </table>
    <p> 一致する単語はありません</p>
    EOS
  end
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
    #{get_word(db_name, level, speech, wordhead)}
    </table>
  </body>
  <p>
  <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
  </p>
</html>
EOS

rescue => ex
  puts ex.massage
  puts ex.backtrace
end
