class DigestHeaderWriter
  def initialize(header, user, password)
    @header = header
    @user = user
    @password = password
  end

  def call
    str_pieces = @header["WWW-Authenticate"].split(/\"/)
    { 
      "ACCEPT" => "application/vnd.api+json",
      "Authorization" => 
      "Digest username=\"#{@user}\","\
      "realm=\"#{str_pieces[1]}\","\
      "nonce=\"#{str_pieces[5]}\","\
      "uri=\"/kinds/1\","\
      "nc=00000001"\
      "algorithm=MD5"\
      "qop=auth"\
      "opaque=#{str_pieces[7]}"
    }
  end
end

# > Authorization: Digest 
# username="Victor",
# realm="Application",
# nonce="MTY2MDY4NDc4MTo3YzgzOGZjNGIxMmM4ZWNkY2NjZGJlMTg0ZDhhNDJkYg==",
# uri="/kinds/1",
# cnonce="233d0ce522e724744473e856a7faf2ae",
# nc=00000001,
# algorithm=MD5,
# response="cc656472ac596fad6fd519bfaadf1290",
# qop="auth",
# opaque="5d5ba5ba4a787523d37a8ad54c64a8a9"

[
  "Digest realm=",
  "Application",
  ", qop=",
  "auth",
  ", algorithm=MD5, nonce=",
  "MTY2MDY4NTQ5MTpiMmE3N2FhYWJlMTYwYmI3ZTM3YzZkY2VlMjcxZmEyOA==",
  ", opaque=",
  "5d5ba5ba4a787523d37a8ad54c64a8a9"
]  

# "WWW-Authenticate"=>
# "Digest realm=\"Application\",
#  qop=\"auth\",
#  algorithm=MD5,
#  nonce=\"MTY2MDY4NTQ5MTpiMmE3N2FhYWJlMTYwYmI3ZTM3YzZkY2VlMjcxZmEyOA==\",
#  opaque=\"5d5ba5ba4a787523d37a8ad54c64a8a9\"", 