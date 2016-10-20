#coding: utf-8
require "base64"
require "./ango_util.rb"

# ====================================
# 指定のファイルを開いてBase64でデコード
# ====================================
def open_file(file)

  base64_data = ""
  open(file, "r") do |f|
    base64_data = f.read
  end

  Base64.decode64(base64_data)

end

# 暗号ファイル保存フォルダ
enc_directory = "./enc_files/"

# Saltファイル保存フォルダ
salt_directory = "./salt/"

unless ARGV.size == 1
  # 引数は必ず１つ必要
  puts "USAGE: decrypt.rb [FILE]"
  exit
end

# デコード対象ファイル
target = ARGV[0].chomp

# パスワード
puts "Enter password:"
pass = STDIN.gets.chomp

encrypt_data = open_file("./#{enc_directory}#{target}.enc")
salt_data = open_file("./#{salt_directory}#{target}.salt")

ango = AngoUtil.new(salt_data)
ango.create_key(pass)

open("./______.txt", "w") do |f|
  f.puts ango.decrypt(encrypt_data)
end
