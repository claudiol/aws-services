#!/usr/bin/env ruby
#
# Example for using the AwsS3 class
#
# The config.yaml file needs to have the following section in it to support Amazon EC2, S3 etc...
#
# aws:
#  access_key_id: ACCESS_KEY_ID
#  secret_access_key: SECRET_ACCESS_KEY
#
# You will need to use your own ACCESS_KEY_ID and SECRET_ACCESS_KEY
#
load 'aws-s3.rb'
load 'aws-elb.rb'

# S3 class test ....
begin
	# Local variable that contains the name for your bucket
	bucket_name = 'claudiol-s3-bucket'

	# Create a new instance of the AwsS3 class 
	s3 = AwsS3.new('config.yaml')

	# Ask if the bucket exists
	if s3.exists(bucket_name) == true
		puts 'Deleting bucket ...'
		s3.delete_bucket(bucket_name)
		puts 'Done.'
  end

  # Now let's create the bucket ...
	puts 'Creating bucket ...'
	bucket = s3.create_bucket(bucket_name)

	# Check to make sure the create_bucket method succeeded 
	if bucket != nil
		puts 'Bucket created: #{bucket.inspect} ...'
		puts 'Writing to Bucket ...'
		s3.write_to_bucket(bucket_name, 'config.yaml')
		puts 'done!'
	else
		puts "Please see the exception thrown from create_bucket"
	end

  s3.enable_logging(bucket_name)

  s3.list_buckets.each do | bucket |
      puts bucket.name
  end


	# Ask if the bucket exists
	#if s3.exists(bucket_name) == true
  #	puts 'Deleting bucket ...'
	#	s3.delete_bucket(bucket_name)
	#	puts 'Done.'
	#end
rescue => exception
	puts exception.message
end
