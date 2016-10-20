#coding: utf-8
require "openssl"
require "base64"

# ===============================================
# 暗号・復号 ユーティリティクラス
# ===============================================
class AngoUtil

  # 初期化 (saltを引数に渡すことが可能)
  def initialize(salt=nil)
    @key = nil
    @salt = salt || OpenSSL::Random.random_bytes(8)
  end

  # Keyの登録
  def create_key(pswd)

    enc = OpenSSL::Cipher.new("AES-256-CBC")

    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(
      pswd, @salt, 2000, enc.key_len + enc.iv_len)

    key = key_iv[0, enc.key_len]
    iv = key_iv[enc.key_len, enc.iv_len]

    @key = {:key => key, :iv => iv}

  end

  # 復号
  def decrypt(data)

    dec = OpenSSL::Cipher.new("AES-256-CBC")
    dec.decrypt

    dec.key = @key[:key]
    dec.iv = @key[:iv]

    decrypted_data = ""
    decrypted_data << dec.update(data)
    decrypted_data << dec.final

    decrypted_data

  end

  # 暗号化
  def encrypt(data)

    enc = OpenSSL::Cipher.new("AES-256-CBC")
    enc.encrypt

    enc.key = @key[:key]
    enc.iv = @key[:iv]

    encrypted_data = ""
    encrypted_data << enc.update(data)
    encrypted_data << enc.final

    encrypted_data
  end
  attr_reader :salt
end

# ===============================================
# RAWファイルを暗号化するクラス
# ===============================================
class AngoFileUtil

  # ファイル暗号化
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

if __FILE__ == $0

require "base64"

pass = "password1"
data = "abced"

ango = AngoUtil.new()

ango.create_key(pass)

enc = ango.encrypt(data)

puts Base64.encode64(enc)

dec = ango.decrypt(enc)

puts dec

puts Base64.encode64(ango.salt)

end
