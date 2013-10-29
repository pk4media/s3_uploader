=======
s3uploader
==========

Rails gem to add convenience methods and controller actions for directly uploading to S3

Or install it yourself as:

    $ gem install s3uploader

Setup your configuration initializer

config/initializers/s3_uploader.rb

	S3DirectUpload.config do |c|
	  c.access_key_id = ""       # your access key id
	  c.secret_access_key = ""   # your secret access key
	  c.bucket = ""              # your bucket name
	  c.region = nil             # region prefix of your bucket url (optional), eg. "s3-eu-west-1"
	  c.url = nil                # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/"
	end

Adds methods to the controller

	include S3Uploader::Upload