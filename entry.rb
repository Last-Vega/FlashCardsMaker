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
# 内容の受け取り
# その際, インジェクション対策でエスケープ処理をする
level = CGI.escapeHTML(c["level"])
word = CGI.escapeHTML(c["word"])
meaning = CGI.escapeHTML(c["meaning"])
speech = CGI.escapeHTML(c["speech"])
synonym = CGI.escapeHTML(c["synonym"])
sentence = CGI.escapeHTML(c["sentence"])
date = CGI.escapeHTML(c["date"])
login_id = CGI.escapeHTML(session["id"])
db_name = "flashcards_" + login_id + ".db"


=begin
ログインユーザーのデータベースに受け取った値を登録する関数
引数: db_name, level, word, meaning, speech, synonym, sentence, date
=end
def entry(db_name, level, word, meaning, speech, synonym, sentence, date)
  db = SQLite3::Database.new(db_name)
  table1 = level
  table2 = "count_#{level}"
    db.transaction{
      db.execute("insert into #{table1} values(?, ?, ?, ?, ?, ?)", word, meaning, speech, synonym, sentence, date)
      db.execute("insert into #{table2} values(?, ?, ?)", word, 0, 0)
    }

end

entry(db_name, level, word, meaning, speech, synonym, sentence, date)

rescue => ex
  puts ex.message
  puts ex.backtrace
end

# html本体
print <<-EOS
<!DOCTYPE html>
<html lang = "ja">
<head>
<title>単語登録</title>
</head>
  <body>
    <h1>登録完了！</h1>
    <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/entry_form.rb?login_id=#{login_id}">続けて登録する</a>
    <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>

  </body>
</html>
EOS
