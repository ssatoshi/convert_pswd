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
  puts "USAGE: decrypt.rb [FILE]"
  exit
end

target = ARGV[0]
target = target.chomp

puts "Enter password:"
pass = STDIN.gets
pass = pass.chomp

encrypt_data = open_file("./#{enc_directory}#{target}.enc")
salt_data = open_file("./#{salt}#{target}.salt")

ango = AngoUtil.new(salt_data)
ango.create_key(pass)

open("./#{target}.txt", "w") do |f|
  f.puts ango.decrypt(encrypt_data)
end
