module S3Uploader
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :access_key
    attr_accessor :bucket
    attr_accessor :expiration
    attr_accessor :content_type_starts_with
    attr_accessor :success_action_status

    def initialize
      @access_key = ENV['AWS_ACCESS_KEY']
      @bucket = nil
      @expiration = 3.minutes
      @content_type_starts_with = 'jpg'
      @success_action_status = '201'
    end
  end
end