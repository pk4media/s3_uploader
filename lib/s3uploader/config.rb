module S3Uploader
  class << self
    attr_accessor :config
  end

  def self.config
    self.configuration ||= Config.new
    yield configuration
  end

  class Config
    attr_accessor :access_key
    attr_accessor :bucket

    def initialize
      @access_key = ENV['AWS_ACCESS_KEY']
      @bucket = nil
      @expiration = 3.minutes
      @content_type_starts_with = 'jpg'
      @success_action_status = '201'
    end
  end
end