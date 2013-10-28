require "s3uploader/version"

module S3uploader
  extend ActiveSupport::Concern

  mattr_accessor :s3_key
  mattr_accessor :bucket

  def s3_signature(s3_policy)
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), self.s3_key, s3_policy)).gsub(/\n/, '')
  end
end
