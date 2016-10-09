#coding: utf-8
require "base64"
require "./ango_util.rb"


# =============================================
def encrypt(pass, salt, filename, encfilename)

  data = ""
  ango = AngoUtil.new()
  ango.create_key(pass, salt)

  open(filename, "r:utf-8") do |f|
    data = f.read
  end

  ango_str = ango.encrypt(data)

  open(encfilename, "w:utf-8") do |f|
    f.puts Base64.encode64(ango_str)
  end

end

# =============================================
def decrypt(pass, salt, inputfile, outputfile)

  data = ""
  ango = AngoUtil.new()
  ango.create_key(pass, salt)

  open(inputfile, "r:utf-8") do |f|
    data = Base64.decode64(f.read)
  end

  hira = ango.decrypt(data)

  open(outputfile, "w:utf-8") do |f|
    f.puts hira.force_encoding("utf-8")
  end

end

# =============================================
def encrypt_files(pass, salt)

  raw_dir = "raw_files"
  enc_dir = "enc_files"

  Dir.glob("./#{raw_dir}/*.*") do |file|

    enc_file = "./#{enc_dir}/#{File.basename(file, ".*")}.enc"

    encrypt pass, salt, file, enc_file

  end

end


# =============================================
def decrypt_files(pass, salt)

  enc_dir = "enc_files"
  dec_dir = "dec_files"

  Dir.glob("./#{enc_dir}/*.*") do |inputfile|

    outputfile = "./#{dec_dir}/#{File.basename(inputfile, ".*")}.txt"

    decrypt pass, salt, inputfile , outputfile

  end

end

puts "Enter pasword:"
pass = gets.chomp

puts "Enter salt:"
salt = gets.chomp

encrypt_files pass, salt

decrypt_files pass, salt
