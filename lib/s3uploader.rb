require "s3uploader/version"

module S3uploader

  def s3_signature(s3_policy)
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), 'z7Zb4PhOSQiqTP9l8LgXTU+DkTnmsCdjW5w9sXVS', s3_policy)).gsub(/\n/, '')
  end
  
end
