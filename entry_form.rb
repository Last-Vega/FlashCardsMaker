#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require("cgi")
require("cgi/session")
c = CGI.new
session = CGI::Session.new(c)

require("sqlite3")
require("date")
print c.header("text/html; charset=utf-8")
# ユーザーidの受け取り
login_id = session["id"]
d = Date.today

# html本体
=begin
ログインユーザーのデータベースに単語などを登録する。
その際、 check_entry.js の check()関数を呼び出して値のチェックを行う。
具体的には、単語と意味は登録の際必ず必要で、またhtmlタグは使用できないようにした。
=end
print <<-EOS
<!DOCTYPE html>
<html lang = "ja">
<head>
<script type="text/javascript" src="check_entry.js"></script>
<title>単語登録</title>
</head>
  <body>
    <h1>単語登録</h1>
    <form
      action = "http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/entry.rb"
      method = "post"
      name = "myform"
      onsubmit = "return check();"
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
      <div> 単語: <input type = "text" name = "word" id = "tango"> </div>
      <div> 意味: <input type = "text" name = "meaning" id = "mean"> </div>
      <div> 品詞： <select name="speech">
        <option value="Verb">動詞</option>
        <option value="Noun">名詞</option>
        <option value="Adj">形容詞</option>
        <option value="Adv">副詞</option>
        <option value="Prep">前置詞</option>
        <option value="Conj">接続詞</option>
        </select>
      </div>
      <div> 類義語: <input type = "text" name = "synonym" id = "syn"> </div>
      <div> <textarea placeholder="例文" cols="50" rows="10"  name = "sentence" id = "sntnc"></textarea>
      <div> 登録日: <input type="text" name = "date" value="#{d.year}-#{d.month}-#{d.day}"readonly></div>
      <p>
        <input type = "submit" value = "登録">
        <input type = "reset" value = "取り消し">
      </p>
    </form>
    <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
  </body>
</html>
EOS
