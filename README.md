==========
S3Uploader
==========

S3Uploader add convenient methods within Rails controllers to generate the policy and signature needed to directly upload files from the client to an Amazon S3 bucket. Unlike [S3 Direct Upload](https://github.com/waynehoover/s3_direct_upload‎) which is tightly coupled to the excellent jQuery File Upload library, this gem is front end agnostic and leaves handling of uploads up to the developer.

Or install it yourself as:

    $ gem install s3_uploader

Setup your configuration initializer

### config/initializers/s3_uploader.rb

	S3Uploader.config do |c|
	  c.aws_id = ""              # your access key id
	  c.access_key = ""          # your secret access key
	  c.bucket = ""              # default bucket
	end

Including the S3Uploader::Upload module within any controller will add a few methods:
	* s3_policy(key_starts_with: "uploads/")
	* s3_signature(s3_policy)

If you want to use the jQuery File Upload library, here's an example of how you would implement it.

### Gemfile

	gem 'jquery-rails'

	group :assets do
		gem 'jquery-fileupload-rails'
	end

### app/controllers/examples_controller.rb

	class ExamplesController < ApplicationController
		include S3Uploader::Upload

		#
		# Typical index, show, etc. actions here
		#

		def upload
			respond_with @creatives do |format|
			  upload_guid = SecureRandom.uuid

			  policy = s3_policy(key_starts_with: "upload/video/#{upload_guid}/", content_type: 'video/', bucket: video_bucket)
			  signature = s3_signature(policy)

			  format.json { render json: {
			    url: "https://s3.amazonaws.com/#{video_bucket}/",
			    policy: policy,
			    signature: signature,
			    key: "upload/video/#{upload_guid}/${filename}"
			  } }
			end
		end
	end

### app/views/examples/new.html.erb

    <div class="video-upload"></div>

    <%= content_tag :input, '', id: 'video-upload', style: 'display: none;', data: { 'upload-url' => 
    	polymorphic_path([:upload, :examples]) } %>

### app/assets/javascripts/examples.js

	$().ready(function() {

	  $('#video-upload').fileupload({
	    autoUpload: false,
	    maxNumberOfFiles: 1,
	    dataType: 'xml',
	    add: function (event, data) {
	      $.ajax({
	        url: $('#video-upload').data('upload-url'),
	        type: 'POST',
	        dataType: 'json',
	        async: false,
	        success: function(retdata) {
	          console.dir(retdata)
	          
	          // after we created our document in rails, it is going to send back JSON of they key,
	          // policy, and signature.  We will put these into our form before it gets submitted to amazon.
	          $('#video-upload').fileupload('option', {
	            url: retdata.url,
	            formData: [
	            {
	              name: 'key',
	              value: retdata.key
	            }, {
	              name: 'AWSAccessKeyId',
	              value: retdata.aws_key
	            }, {
	              name: 'acl',
	              value: 'private'
	            }, {
	              name: 'policy',
	              value: retdata.policy
	            }, {
	              name: 'signature',
	              value: retdata.signature
	            }, {
	              name: 'success_action_status',
	              value: 201
	            }, {
	              name: 'Content-Type',
	              value: data.files[0].type
	            }]
	          });

	          upload = data.submit();
	        }
	      });
	    });
	});
