#!/usr/bin/env ruby
#
# Start of the Ruby AWS
require 'aws-sdk'
require 'yaml'

#
# Class to support CRUD for AWS S3 buckets
# You create a bucket by name. Bucket names must be globally unique and must be DNS compatible.

module CFAWS
	class S3

		#
		# @!method initialize
		#     Whenever Ruby creates a new object, it looks for a method named initialize and executes it. Same as a contructor in C++
		#
		# @param config_name [String] Configuration file name.  This file should be a YAML file.
		#
		def initialize (config_name)
			if config_name == nil
				config_name = "config.yaml"
			end
			@config_name = config_name
			@config = self.read_config(@config_name)
			@access_key_id = @config['aws']['access_key_id']
			@secret_access_key = @config['aws']['secret_access_key']

      # New API changes for aws_sdk 2.X
			# Create basic S3 Instance
      @s3_instance = Aws::S3::Client.new(
					access_key_id:  @access_key_id,
					secret_access_key: @secret_access_key,
			)

			# Defined ACL permissions for buckets from Amazon
			@acl_permissions = [':private', ':public_read', ':public_read_write', ':authenticated_read', ':bucket_owner_read', ':bucket_owner_full_control']
		end

		#
		# @!method read_config
		#
		# @param config_name [String] Configuration file name
		#
		# @return [Collection] Returns the YAML collection of configuration items.
		def read_config(config_name)
				begin
					return YAML.load_file(config_name)
				rescue => exception
					puts exception.message
				end
		end


		#
		# @!method create_bucket
		#
		# @param bucket_name [String] Name for the bucket you want to create
		#
		# @return [AWS::S3::Bucket] Returns the newly created bucket.
		#
		# TODO: Need to figure out how to add the Grant and permission parameter support for this method.
		# Options:
		# 1 - We could just provide setter and getter methods to set the permisions for the bucket.
		# 2 - Add a hash option to pass in the parameters
		#
		# :private
		# :public_read
		# :public_read_write
		# :authenticated_read
		# :bucket_owner_read
		# :bucket_owner_full_control

		def create_bucket(bucket_name)
			if bucket_name == nil
				puts "Required name needed to create a bucket"
			else
				# Load up the 'bucket' we want to store things in
				buckets = @s3_instance.list_buckets

		    buckets.each_with_index do | bucket_elements, index |
					bucket_elements[index].each do | bucket |
	          if bucket.name == "#{bucket_name}"
						  puts "Info: Bucket #{bucket_name} already exists! Returning existing bucket"
							return bucket
						end
					end
				end
				puts "Need to make bucket #{bucket_name}..."
				@s3_instance.create_bucket({bucket: "#{bucket_name}"}) #acl: => :bucket_owner_full_control)
		  end
		end

		#
		# @!method exists
		#
		# @param bucket_name [String] The name for the bucket you wish to check for existence.
		#
		# @return True if the bucket exists else return false.
		#
		def exists(bucket_name)
			begin
				# Load up the 'bucket' we want to store things in
				buckets = @s3_instance.list_buckets

		    buckets.each_with_index do | bucket_elements, index |
					bucket_elements[index].each do | bucket |
						if bucket.name == "#{bucket_name}"
						  puts "Info: Bucket #{bucket_name} already exists! Returning existing bucket"
							return true
						end
					end
				end
        return false
			rescue => exception
				puts exception.message
			end
		end

		#
		# @!method find_bucket
		#
		# @param bucket_name [String] Name of the bucket to write to
		def find_bucket (bucket_name)
			begin
				# Load up the 'bucket' we want to store things in
				buckets = @s3_instance.list_buckets

		    buckets.each_with_index do | bucket_elements, index |
					bucket_elements[index].each do | bucket |
						if bucket.name == "#{bucket_name}"
						  puts "Info: Bucket #{bucket_name} already exists! Returning existing bucket"
							return bucket
						end
					end
				end
        return nil
			rescue => exception
				puts exception.message
			end
		end


		#
		# @!method write_to_bucket
		#
		# @param bucket_name [String] Name of the bucket to write to
		# @param filename [String] Name of the file you would like to write for the
		# TODO: Check that the filename passed also exists...
		def write_to_bucket (bucket_name, filename)
			begin
				if bucket_name == nil || filename == nil
					puts "Bucket Name and Filename are required"
				else
					@s3_resource = Aws::S3::Resource.new
					# Load up the 'bucket' we want to store things in
					#bucket = self.find_bucket(bucket_name)
					key = filename
					object = @s3_resource.bucket("#{bucket_name}").object("#{filename}")
					# Grab a reference to an object in the bucket with the name we require
					#object = bucket.key()[File.basename(filename)]
					puts object.inspect
					# Write a local file to the aforementioned object on S3
					# IO object
					File.open(File.basename(filename), 'rb') do |file|
  					object.put(body: file)
					end
				end
			rescue => exception
				puts exception.message
			end
		end

		def list_buckets()
			begin
				return @s3_instance.list_buckets
			end
		end

		#
		# @!method delete_bucket
		#
		# @param bucket_name [String] Name of the bucket to write to
		#
		# @return Returns True if the bucket is deleted else returns false.
		def delete_bucket (bucket_name)
			begin
				if bucket_name == nil
					puts "Error: Required name for bucket cannot be nil"
				else
					# Load up the 'bucket' we want to store things in
					bucket = self.find_bucket(bucket_name)
					puts bucket.inspect
					# If the bucket exists empty it's objects
					if bucket != nil
						puts "Deleting bucket"
						@s3_instance.delete_bucket(bucket: "#{bucket_name}")
						return true
					else
						puts "Info: Bucket #{bucket_name} does not exist! "
						return false
					end # end if bucket.exists
				end # end if
			rescue => exception
				puts exception.message
			end # end begin
		end # end delete_bucket
	end
end
