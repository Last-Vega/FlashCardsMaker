#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require("cgi")
require("cgi/session")
c = CGI.new
session = CGI::Session.new(c)
require("sqlite3")
require("date")
print c.header("text/html; charset=utf-8")
d = Date.today

begin
  # 必要な値の受け取り
  login_id = session["id"]
  level = c["level"]
  db_name = "flashcards_" + login_id + ".db"
  data = c.params["stored"]
  data2 = c.params["unstored"]

  # 何も選択せずに採点しようとした場合
  if data.size == 0 && data2.size == 0
    print <<-EOS
    <!DOCTYPE html>
    <html lang = "ja">
    <head></head>
    <body>
    <p>採点は無効です</p>
    <p>単語１につき「覚えた」「まだ覚えていない」どちらか片方のみを選択してください。</p>
    <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
    </body>
    </html>
    EOS
    exit
  end
  # 1単語でセレクトタグを複数選択されてしまった場合
  for elm in data
    for elm2 in data2
      if elm == elm2
        print <<-EOS
        <!DOCTYPE html>
        <html lang = "ja">
        <head>
        <title>FlashCards Maker</title>
        </head>
        <body>
        <p>採点は無効です</p>
        <p>単語１につき「覚えた」「まだ覚えていない」どちらか片方のみを選択してください。</p>
        <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
        </body>
        </html>
        EOS
        exit
      end
    end
  end
=begin
  テスト結果を記録する関数
  引数: db_name, data, data2, d, level
  返り値: str
=end
  def marking(db_name, data, data2, d, level)
    db = SQLite3::Database.new(db_name)
    table = "count_#{level}"
    str = ""
    db.transaction{
      count_stored = 0
      count_unstored = 0
      data.each{|elm|
        db.execute("select count_unstored from #{table} where word = ?;", elm){|row|
          # １回以上不正解だった単語を覚えられた場合
          if row[0] > 0
            str += <<-EOS
            <p>#{elm}を覚えました。(#{d.year}-#{d.month}-#{d.day})</p>
            EOS
            # 不正解の回数を０に更新する
            db.execute("update #{table} set count_unstored = ? where word = ?;", 0, elm)
          end
        }
        db.execute("select count_stored from #{table} where word = ?;", elm){|row|
          count_stored = row[0] += 1
          db.execute("update #{table} set count_stored = ? where word = ?;", count_stored, elm)
        }
      }
      data2.each{|elm|
        db.execute("select count_stored from #{table} where word = ?;", elm){|row|
          # １回以上正解してた単語が不正解だった場合
          if row[0] > 0
            str += <<-EOS
            <p>#{elm}を忘れてしまいました。(#{d.year}-#{d.month}-#{d.day})</p>
            EOS
            # 正解の回数を０に更新する
            db.execute("update #{table} set count_stored = ? where word = ?;", 0, elm)
          end
        }
        db.execute("select count_unstored from #{table} where word = ?;", elm){|row|
          count_unstored = row[0] += 1
          db.execute("update #{table} set count_unstored = ? where word = ?;", count_unstored, elm)
        }
      }
    }
    return str
  end

=begin
  テスト結果を表示する関数
  引数: db_name, level
  返り値: ｓｔｒ
=end
  def result_display(db_name, level)
    db = SQLite3::Database.new(db_name)
    table = "count_#{level}"
    str = <<-EOS
    <table border=1>
    <tr>
    <th>単語</th>
    <th>覚えた回数</th>
    <th>覚えてない回数</th>
    </tr>
    EOS
    db.transaction{
      db.execute("select * from #{table};"){|rows|
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
    str += <<-EOS
    </table>
    EOS
    return str
  end


# html本体
print <<-EOS
<!DOCTYPE html>
<html lang = "ja">
<head>
<title>FlashCards Maker</title>
</head>
  <body>
  <p>採点完了！<p>
  #{marking(db_name, data, data2, d, level)}
  #{result_display(db_name, level)}
  <a href="http://cgi.u.tsukuba.ac.jp/~s1811552/local_only/wp/cards_index.rb?login_id=#{login_id}">トップに戻る</a>
  </body>
</html>
EOS
rescue => ex
  puts ex.message
  puts ex.backtrace
end
