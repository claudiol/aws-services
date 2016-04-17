#!/usr/bin/env ruby
#
# Start of the Ruby AWS
# AwsEC2 class
#
require 'aws-sdk'
require 'readline'
require 'yaml'

#
# Module for AWS
#
module CFAWS
#
# Class to support for AWS EC2
#
  class EC2
    # @!method initialize
    # @param region - Region name you want to create your ELB e.g. :region => "us-west-1"
    # @param config_file - Name of the YAML config file.
    #
    def initialize (region=nil, config_file)
      if (config_file == nil)
        @config_file = 'config.yaml'
      else
        @config_file = config_file
      end
      @config = self.read_config (config_file)

      @access_key_id = @config['aws']['access_key_id']
      @secret_access_key = @config['aws']['secret_access_key']

      if (region == nil)
        @region = @config['aws']['default_region']
      end

      AWS.config(
          :access_key_id => @access_key_id,
          :secret_access_key => @secret_access_key
      )

      # Create the basic EC2 object
      @ec2_object = AWS::EC2.new(:region => @region)

    end

    #
    # @!method read_config
    #
    # @param config_name [String] Configuration file name
    #
    # @return [Collection] Returns the YAML collection of configuration items.
    def read_config (filename)
      begin
        return YAML.load_file(filename)
      rescue => exception
        puts exception.message
      end
    end


    # @!method availability_zones
    #
    #
    # @return [AWS::AvailabilityZoneCollection] Collection of zones for the Amazon region we are connected to.
    #
    def availability_zones
      begin
        zones = @ec2_object.availability_zones
        return zones
      rescue => exception
        puts exception.message
      end
    end


    # @!method available_subnets
    # List of available regions in EC2
    #
    # @return [AWS::SubnetCollection] .
    #
    def available_subnets
      return @ec2_object.subnets
    end

    # @!method available_regions
    # List of available regions in EC2
    #
    # @return [AWS::RegionCollection] .
    #
    def available_regions
      return @ec2_object.regions
    end

    # @!method available_vpcs
    # List of available VPCs in the region associated with the ec2 instance.
    # This is configured in the config.yaml
    # aws:
    #   default_region: 'us-west-2'
    #
    # @return [AWS::VPCCollection] .
    #
    def available_vpcs
      return @ec2_object.vpcs
    end

    # @!method available_instances
    # List of available instances in the region associated with the ec2 instance.
    # This is configured in the config.yaml
    # aws:
    #   default_region: 'us-west-2'
    #
    # @return [AWS::InstanceCollection] .
    #
    def available_instances
      return @ec2_object.instances
    end

    # @!method key_pairs
    # List of available regions in EC2
    #
    # @return [AWS::SubnetCollection] .
    #
    def key_pairs
      return @ec2_object.key_pairs
    end

    def all_images
      return @ec2_object.images
    end
  end
end
