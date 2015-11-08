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

load 'aws_ebs.rb'

# S3 class test ....
begin
  # Create a new instance of the AwsEBS class
  ebs = AwsEBS.new('config.yaml')

  #list = ebs.list

  #if list.nil?
  #  puts "No EBS Volumes defined."
  #end


  #ebs.list_attached_volumes

  #instances=ebs.get_ec2_instances

  # instances.each do | i |
  #   ebs.list_block_devices_for_instance(i)
  # end

  instance = ebs.get_ec2_instance("i-305903c6")
  ebs.list_block_devices_for_instance(instance)

rescue => exception
  puts exception.message
  puts exception.backtrace
end
