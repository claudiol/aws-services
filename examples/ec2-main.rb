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

@debug = false

def retrieve_all_zones (ec2_object)
    resp = ec2_object.availability_zones
    puts "Found #{resp.availability_zones.count}" if @debug
    if resp.nil?
      return false
    else
      return true
    end
  return false
end


def retrieve_all_instances (ec2_object)
    resp = ec2_object.availability_zones
    puts "Found #{resp.reservations[0].instances.count}" if @debug
    if instances.nil?
    return false
    else
      return true
    end
end


def retrieve_all_subnets (ec2_object)
    resp = ec2_object.available_subnets
    puts "Found #{resp.subnets.count}" if @debug
    if resp.nil?
      return false
    else
      return true
    end
end

def retrieve_all_regions (ec2_object)
    resp = ec2_object.available_regions
    puts "Found #{resp.regions.count}" if @debug
    if resp.nil?
      return false
    else
      return true
    end
end

def retrieve_all_vpcs (ec2_object)
    resp = ec2_object.available_vpcs
    puts "Found #{resp.vpcs.count}" if @debug
    if resp.nil?
      return false
    else
    return true
    end
end


def retrieve_all_instances (ec2_object)
    resp = ec2_object.available_instances
    puts "Found #{resp.instances.count}" if @debug
    if resp.nil?
      return false
    else
      return true
    end
end

def retrieve_key_pairs (ec2_object)
    resp = ec2_object.key_pairs
    puts "Found #{resp.key_pairs.count}" if @debug
    if resp.nil?
      return false
    else
      return true
    end
end

def retrieve_all_images(ec2_object)
    puts "Retrieving all images"
    resp = ec2_object.all_images
    puts "Image count = #{resp.images.count}"
    resp.images.each { | image |
      puts "Image: #{image.name}"
    }
    if resp.nil?
      return false
    else
      return true
    end
  return false
end

# EC2 class test ....
  # Local variable that contains the name for your bucket
  puts "Creating EC2 class"
  ec2 = CFAWS::EC2.new('config.yaml')

  fZones = retrieve_all_zones(ec2)
  fImages = retrieve_all_instances(ec2)
  fRegions = retrieve_all_regions(ec2)
  fSubnets = retrieve_all_subnets(ec2)
  fVpcs = retrieve_all_vpcs(ec2)
  fInstances = retrieve_all_instances(ec2)
  fKeyPairs = retrieve_key_pairs(ec2)
  fImageList = retrieve_all_images(ec2)

  puts "Zone Test = #{fZones}"
  puts "Image Test = #{fImages}"
  puts "Region Test = #{fRegions}"
  puts "Subnet Test = #{fSubnets}"
  puts "VPC Test = #{fVpcs}"
  puts "Instance Test = #{fInstances}"
  puts "Key Pairs Test = #{fKeyPairs}"
  puts "Image List Test = #{fImageList}"
