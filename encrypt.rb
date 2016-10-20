#coding: utf-8
require "./ango_util.rb"

# =============================================
# 指定のディラクトリあるファイルを暗号化する
# =============================================
def encrypt_files(pass, raw_dir, enc_dir, salt)

  afu = AngoFileUtil.new()

  Dir.glob("./#{raw_dir}/*.*") do |inputfile|

    afu.encrypt_file pass, inputfile, enc_dir, salt

  end
end

raw_dir = "raw_files"
enc_dir = "enc_files"
salt_dir = "salt"

puts "Enter pasword:"
pass = gets.chomp

encrypt_files pass, raw_dir, enc_dir, salt_dir
