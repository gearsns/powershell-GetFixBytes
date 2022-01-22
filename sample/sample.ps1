function GetFixBytes([string]$text, [int]$max_byte, [System.Text.Encoding]$enc_dst, [string]$padding_str = " ") {
	[int]$cnt = 0
	[byte[]]$dst_bytes = @()
	Foreach ($ch in [System.Globalization.StringInfo]::GetTextElementEnumerator($text)) {
		$b = $enc_dst.GetBytes($ch)
		if ($cnt + $b.Length -gt $max_byte) {
			break
		}
		$dst_bytes += $b
		$cnt += $b.Length
	}
	[int]$r = $max_byte - $cnt
	if ($r -gt 0) {
		$b = $enc_dst.GetBytes($padding_str)
		$dst_bytes += $b * [Math]::Truncate($r / $b.Length)
		[int]$rem = $r % $b.Length
		if ($rem -gt 0) {
			$dst_bytes += [byte[]]@(0) * $rem
		}
	}
	return $dst_bytes
}
# Sample 1
$enc_dst = [System.Text.Encoding]::GetEncoding('UTF-16')
$dst_bytes = GetFixBytes "test𠀋日本語" 11 $enc_dst "*"
[System.IO.File]::WriteAllBytes(".\write.txt", $dst_bytes)

# Sample 2
$csvall = Import-Csv -Path "sample.csv"
$enc_dst = [System.Text.Encoding]::GetEncoding('UTF-16')
[void](New-Item -ItemType file utf16.csv -Force)
Foreach ($csv in $csvall) {
	[byte[]]$dst_bytes = @()
	$dst_bytes += GetFixBytes $csv.ID 12 $enc_dst
	$dst_bytes += GetFixBytes $csv.Date 12 $enc_dst
	$dst_bytes += GetFixBytes $csv.Note 20 $enc_dst
	$dst_bytes += GetFixBytes "`r`n" 4 $enc_dst
	$dst_bytes | Add-Content "utf16.csv" -Encoding Byte
}

# Sample 3
$csvall = Import-Csv -Path "sample.csv"
$enc_dst = [System.Text.Encoding]::GetEncoding('shift_jis')
[void](New-Item -ItemType file sjis.csv -Force)
Foreach ($csv in $csvall) {
	[byte[]]$dst_bytes = @()
	$dst_bytes += GetFixBytes $csv.ID 10 $enc_dst
	$dst_bytes += GetFixBytes $csv.Date 10 $enc_dst
	$dst_bytes += GetFixBytes $csv.Note 10 $enc_dst
	$dst_bytes += GetFixBytes "`r`n" 2 $enc_dst
	$dst_bytes | Add-Content "sjis.csv" -Encoding Byte
}