require "s3uploader/version"

module S3uploader

  extend ActiveSupport::Concern

  mattr_accessor :s3_key
  mattr_accessor :bucket

  @options = {
  	expiration: 3.minutes.from_now.utc.xmlschema,
  	key_starts_with: '',
  	max_file_size: 786432000,
    bucket: self.config.bucket,
    acl: 'private',
    success_action_status: '201'
  }


  def s3_signature(s3_policy)
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), self.s3_key, s3_policy)).gsub(/\n/, '')
  end

  def s3_policy(key: @options[:key_starts_with], content_types: [])

		conditions = [
			["starts-with", "$utf8", ""],
			["starts-with", "$key", key],
			["starts-with", "$x-requested-with", ""],
			["content-length-range", 0, @options[:max_file_size]],
			["starts-with","$content-type", @options[:content_type_starts_with] ||""],
			{bucket: @options[:bucket]},
			{acl: @options[:acl]},
			{success_action_status: @options[:success_action_status]}
		]
    
    content_types.each do |type|
      conditions << ["starts-with", "$Content-Type", type]
    end
    
    policy = {
      expirations: options[:expiration],
      conditions: conditions 
    }
  end

end
