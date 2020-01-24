# ramendb

ラーメンデータベース( https://ramendb.supleks.jp/ )のサイトから、

* ユーザ
* 店舗
* レビュー
* レビューコメント

の内容をスクレイピングするPythonスクリプトと、そのスクリプトで収集したデータ、PostgreSQL用のテーブル定義例をまとめた。

## TODO
* 店舗のステータスとして「提供終了」があるので、それも別に収集すること。
   * 提供終了のサンプル： https://kanagawa-ramendb.supleks.jp/s/59819.html

