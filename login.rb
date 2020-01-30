#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'cgi'
require 'cgi/session'
c = CGI.new
session = CGI::Session.new(c)
print c.header("text/html; charset=utf-8")

# 簡易ログイン機能を作成
# html本体
print <<-EOS
<!DOCTYPE html>
<html lang = "ja">
<head>
<title>FlashCards Maker</title>
</head>
  <body>
    <h1>FlashCards Maker</h1>
    <form
      action = "http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb"
      method = "post"
      >
    <h2>user id : <input type = "text" name = "login_id"></h2>
    <p>既存の単語帳を使いたい場合は"guest"と入力</p>
    <p>自分オリジナルの単語帳を作りたい場合はidを入力してください</p>
    <input type = "submit" value = "登録">
  </body>
</html>
EOS
