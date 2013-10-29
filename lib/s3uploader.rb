require "s3uploader/version"

module S3Uploader

  extend ActiveSupport::Concern

  def s3_policy(key_starts_with, content_types: [], max_file_size: nil, acl: 'private', success_action_status: '201')
    conditions = [
      ["starts-with", "$utf8", ""],
      ["starts-with", "$key", key_starts_with],
      ["starts-with", "$x-requested-with", ""],
      ["starts-with", "$content-type", config.content_type_starts_with || ""],
      {bucket: config.bucket},
      {acl: acl},
      {success_action_status: success_action_status}
    ]

    unless max_file_size.nil?
      conditions << ["content-length-range", 0, max_file_size]
    end
    
    content_types.each do |type|
      conditions << ["starts-with", "$Content-Type", type]
    end
    
    policy = {
      expirations: @expiration.from_now.utc.xmlschema,
      conditions: conditions 
    }
  end

  def s3_signature(s3_policy)
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), config.access_key, s3_policy)).gsub(/\n/, '')
  end

end
