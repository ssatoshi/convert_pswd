#coding: utf-8
require "openssl"
require "base64"

class AngoUtil

  def initialize()
    @key = nil
  end

  def create_key(pswd, salt)

    enc = OpenSSL::Cipher.new("AES-256-CBC")

    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(
      pswd, salt, 2000, enc.key_len + enc.iv_len)

    key = key_iv[0, enc.key_len]
    iv = key_iv[enc.key_len, enc.iv_len]

    @key = {:key => key, :iv => iv}

  end

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

end

if __FILE__ == $0

pass = "password1"
salt = OpenSSL::Random.random_bytes(8)

ango = AngoUtil.new()
ango.create_key(pass, salt)

data = "abced"

enc = ango.encrypt(data)
puts Base64.encode64(enc)

dec = ango.decrypt(enc)
puts dec

end
