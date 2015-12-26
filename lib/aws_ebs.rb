require 'aws-sdk'
require 'readline'
require 'yaml'

module AWS
  class EBS
    # @!method initialize
    # @param region - Region name you want to create your EBS e.g. :region => "us-west-1"
    # @param config_file - Name of the YAML config file.
    #
    def initialize (region=nil, config_file)
      if (config_file == nil)
        @config_file = 'config.yaml'
      else
        @config_file = config_file
      end
      @config = self.read_config (config_file)

      @region=""

      @access_key_id = @config['aws']['access_key_id']
      @secret_access_key = @config['aws']['secret_access_key']

      if (region == nil)
        @region = @config['aws']['default_region']
      end

      puts @access_key_id.inspect
      puts @secret_access_key.inspect

      AWS.config(
          :access_key_id => @access_key_id,
          :secret_access_key => @secret_access_key
      )

      puts @region.inspect

      # Create the basic ELB object
      @ec2_instance = AWS::EC2.new(:region => @region)

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

    def list()

      puts "In list() ..."
      # Create some local variables ...

      # Dynamic list to add values to the dialog dynamic list ...
      list = {}

      # Count of regions ...
      count = 0

      # Save first entry and make it the default region
      first = nil

      # Go through all available EBS Volumes returned from EC2
      # and add them to list

      @ec2_instance.volumes.each do |v|
        count += 1
        if count == 1
          first = v.id
        end
        list[v.id]  = "#{v.id}"
      end

      if count == 0
        return nil
      else
        return list
        end
    end

    def list_attached_volumes()
      instances = @ec2_instance.instances

      instances.each do |i|
        maps = i.block_device_mappings
        puts "Instance: #{i} Attached to: #{maps.inspect}"
        list_instance_tags(i)
      end
    end

    def list_instance_tags (instance)
      tags = instance.tags
      tags.each do |t|
        puts "Tag for Instance [#{instance.id}]: #{t}"
      end
    end

    def list_block_devices_for_instance(instance)
      instance.block_devices.each do |b|
        puts "Device: #{b[:device_name]}"
      end
    end

    def get_ec2_instances
      instances = @ec2_instance.instances
      return instances
    end

    def get_ec2_instance(instance_id)
      instance = @ec2_instance.instances["#{instance_id}"]
      return instance
    end
  end
end
