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
#require 'aws/s3'
#load 'aws-s3.rb'
#load 'aws-elb.rb'
load 'aws-ec2.rb'

# EC2 class test ....
begin
  # Local variable that contains the name for your bucket
  puts "1"
  ec2 = AwsEC2.new('config.yaml')
  puts "2"
  images = ec2.all_images
  puts "3"
  images.each { | image |
    puts "Image: #{image.name}"
  }
    #end
rescue => exception
  puts exception.message
  puts exception.backtrace
end
