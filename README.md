# GetFixBytes
Powershell用の文字固定長バイト区切り関数です。

SubStringや、GetBytesを使用したサンプルはいくつかありますが
SJISやUTF-16のサロゲートが考慮されておらず、文字が途切れるため
正しい文字境界で区切る関数を作成しました。

### パラメータ
* $text string
	バイト配列にする文字を含む文字列
* $count int
	バイト配列にするバイト数
* $enc_dst System.Text.Encoding
	文字コードによって一文字のバイト数が異なるため、最初に出力したい文字列のEncodingを指定します。
* padding_str string
	対象の文字が途切れた場合に代わりに詰める文字を指定
	デフォルトは、空白

### 戻り値
* Byte[]
	指定した文字のセットをエンコードした結果を格納しているバイト配列。

### 例
``` powershell
# Sample 1
$enc_dst = [System.Text.Encoding]::GetEncoding('UTF-16')
$dst_bytes = GetFixBytes "test𠀋日本語" 11 $enc_dst "*"
[System.IO.File]::WriteAllBytes(".\write.txt", $dst_bytes)
```