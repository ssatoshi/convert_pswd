#coding: utf-8
require "base64"
require "./ango_util.rb"

class AngoFileUtil

  # =============================================
  #
  # =============================================
  def encrypt_file(pass, inputfile, enc_dir, salt_dir)

    outputfile = "./#{enc_dir}/#{File.basename(inputfile, ".*")}.enc"
    saltfile = "./#{salt_dir}/#{File.basename(inputfile, ".*")}.salt"

    ango = AngoUtil.new()
    ango.create_key(pass)
    data = ""

    open(inputfile, "r:utf-8") do |f|
      data = f.read
    end

    ango_str = ango.encrypt(data)

    open(outputfile, "w:utf-8") do |f|
      f.puts Base64.encode64(ango_str)
    end

    open(saltfile, "w:utf-8") do |f|
      f.puts Base64.encode64(ango.salt)
    end

    batch = "./#{File.basename(inputfile, ".*")}.ps1"
    open(batch, "w:utf-8") do |f|
      f.puts "ruby decrypt.rb #{File.basename(inputfile, ".*")}"
    end
  end
end

# =============================================
#
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


# =============================================
=begin
def decrypt(pass, inputfile, outputfile)

  data = ""
  ango = AngoUtil.new()
  ango.create_key(pass)

  open(inputfile, "r:utf-8") do |f|
    data = Base64.decode64(f.read)
  end

  hira = ango.decrypt(data)

  open(outputfile, "w:utf-8") do |f|
    f.puts hira.force_encoding("utf-8")
  end

end
=end

# =============================================
=begin
def decrypt_files(pass, enc_dir, dec_dir)

  Dir.glob("./#{enc_dir}/*.*") do |inputfile|

    outputfile = "./#{dec_dir}/#{File.basename(inputfile, ".*")}.txt"

    decrypt pass, inputfile, outputfile

  end
end
=end


#decrypt_files pass, enc_dir, dec_dir
