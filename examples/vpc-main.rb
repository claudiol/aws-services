#!/usr/bin/env ruby
#
# Example for using the AwsELB class
#
# The config.yaml file needs to have the following section in it to support Amazon EC2, S3 etc...
#
# aws:
#  access_key_id: ACCESS_KEY_ID
#  secret_access_key: SECRET_ACCESS_KEY
#
# You will need to use your own ACCESS_KEY_ID and SECRET_ACCESS_KEY
#
load 'aws_vpc.rb'

# Create a new ELB class instance
vpc = AwsVPC.new('config.yaml')

options={:instance_tenancy => "default"}
vpc_instance = vpc.create_vpc("172.11.0.0/24", options)

id = vpc_instance.vpc_id

puts "VPC ID created: #{id}"

vpc_instance.delete
puts "VPC ID deleted: #{id}"

# get existing VPC instances
vpcs = vpc.get_vpcs

vpcs.each { |existingvpc|

   puts "Deleting existing VPC ID: #{existingvpc.vpc_id}"
   vpc.delete_vpc("#{existingvpc.vpc_id}")
}