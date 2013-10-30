module S3Uploader
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield config
  end

  class Config
    attr_accessor :aws_id
    attr_accessor :access_key
    attr_accessor :bucket
    attr_accessor :expiration
    attr_accessor :content_type_starts_with
    attr_accessor :success_action_status

    def initialize
      @aws_id = nil
      @access_key = ENV['AWS_ACCESS_KEY']
      @bucket = nil
      @expiration = 3.minutes
      @content_type_starts_with = 'jpg'
      @success_action_status = '201'
    end
  end
end