module S3Uploader
  module Upload

    extend ActiveSupport::Concern

    def s3_policy(key_starts_with: key_starts_with, content_type: 'video/', max_file_size: nil, acl: 'private', success_action_status: '201', bucket: nil)
      conditions = [
        ["starts-with", "$key", key_starts_with],
        ["starts-with", "$Content-Type", content_type],
        {acl: acl},
        {success_action_status: success_action_status}
      ]

      unless bucket.nil?
        conditions << {bucket: bucket}
      else
        conditions << {bucket: S3Uploader.configuration.bucket}
      end

      unless max_file_size.nil?
        conditions << ["content-length-range", 0, max_file_size]
      end
      
      policy = {
        expiration: S3Uploader.configuration.expiration.from_now.utc.xmlschema,
        conditions: conditions 
      }

      puts policy

      encoded_policy = Base64.encode64(policy.to_json).gsub(/\n/, '')
    end

    def s3_signature(s3_policy)
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), S3Uploader.configuration.access_key, s3_policy)).gsub(/\n/, '')
    end
  end
end
