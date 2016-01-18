#!/usr/bin/env ruby
#
# Start of the Ruby AWS 
# AwsELB class
#
require 'aws-sdk'
require 'readline'
require 'yaml'

module CFAWS
  #
  # Class to support CRUD for AWS Elastic Load Balancers (ELBs)
  #
  class ELB
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

      # Create the basic ELB object
      @elb_instance = AWS::ELB.new(:region => @region)
      @ec2_instance = AWS::EC2.new(:region => @region)

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

    #
    # @!method create_elb
    #
    # @return [Collection] Collection of existing Elastic Load Balancers
    #
    def get_elbs
      return @elb_instance.load_balancers
    end

    #
    # @!method exists?
    #
    # @param elb_name [String] Name of the Elastic Load Balancer
    #
    # @return [boolean] Returns true or false

    def exists? (elb_name)
      begin
        if elb_name == nil
          raise "Elastic Load Balancer name required."
        else
          elbs = self.get_elbs
          elb = elbs[elb_name]
          if elb != nil
            return elb.exists?
          else
            return false
          end
        end
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
        zones = @ec2_instance.availability_zones
        return zones
      rescue => exception
        puts exception.message
      end
    end

    # @!method elb_instances
    #
    #
    # @return [LoadBalancerCollection] Collection of instances for the Load Balancer.
    #
    def elb_instances (elb_name)
      begin
        if elb_name != nil
          elbs = self.get_elbs
          elb = elbs[elb_name]
          return elb.instances
        else
          raise "ELB Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method available_subnets
    # List of available regions in EC2
    #
    # @return [AWS::SubnetCollection] .
    #
    def available_subnets
      return @ec2_instance.subnets
    end

    # @!method available_regions
    # List of available regions in EC2
    #
    # @return [AWS::RegionCollection] .
    #
    def available_regions
      return @ec2_instance.regions
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
      return @ec2_instance.vpcs
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
      return @ec2_instance.instances
    end

    #
    # @!method create_elb
    #
    # @param elb_name [String] Elastic Load Balancer name
    # @param options [Hash]
    #
    # Options Hash (options):
    # :availability_zones (required, Array) — An array of one or more availability zones.
    #       Values may be availability zone name strings, or AWS::EC2::AvailabilityZone objects.
    # :listeners (required, Array<Hash>) — An array of load balancer listener options:
    #        * :protocol - required - (String) Specifies the LoadBalancer transport protocol to use for routing - HTTP, HTTPS, TCP or SSL.
    #          This property cannot be modified for the life of the LoadBalancer.
    #        * :load_balancer_port - required - (Integer) Specifies the external LoadBalancer port number.
    #          This property cannot be modified for the life of the LoadBalancer.
    #        * :instance_protocol - (String) Specifies the protocol to use for routing traffic to back-end instances - HTTP, HTTPS, TCP, or SSL.
    #          This property cannot be modified for the life of the LoadBalancer.
    #          If the front-end protocol is HTTP or HTTPS, InstanceProtocol has to be at the same protocol layer, i.e., HTTP or HTTPS.
    #          Likewise, if the front-end protocol is TCP or SSL, InstanceProtocol has to be TCP or SSL.
    #          If there is another listener with the same InstancePort whose InstanceProtocol is secure, i.e., HTTPS or SSL,
    #          the listener's InstanceProtocol has to be secure, i.e., HTTPS or SSL.
    #          If there is another listener with the same InstancePort whose InstanceProtocol is HTTP or TCP,
    #          the listener's InstanceProtocol must be either HTTP or TCP.
    #        * :instance_port - required - (Integer) Specifies the TCP port on which the instance server is listening.
    #          This property cannot be modified for the life of the LoadBalancer.
    #        * :ssl_certificate_id - (String) The ARN string of the server certificate.
    #          To get the ARN of the server certificate, call the AWS Identity and Access Management UploadServerCertificate API.
    # :subnets (Array) — An list of VPC subnets to attach the load balancer to. This can be an array of subnet ids (strings) or AWS::EC2::Subnet objects. VPC only.
    # :security_groups (Array) — The security groups assigned to your load balancer within your VPC. This can be an array of security group ids or AWS::EC2::SecurityGroup objects. VPC only.
    # :scheme (String) — default: 'internal' The type of a load balancer. Accepts 'internet-facing' or 'internal'. VPC only. — 'internal' The type of a load balancer. Accepts 'internet-facing' or 'internal'. VPC only.
    #
    # Example:
    #
    #load_balancer = elb.load_balancers.create('my-load-balancer',
    #  :availability_zones => %w(us-west-2a us-west-2b),
    #  :listeners => [{
    #    :port => 80,
    #    :protocol => :http,
    #    :instance_port => 80,
    #    :instance_protocol => :http,
    #  }])
    #
    #
    # @return [AWS::ELB] Returns the Amazon ELB object created.
    #
    def create_elb(elb_name, options_hash = {})
      begin
        return @elb_instance.load_balancers.create(elb_name, options_hash)
      rescue => exception
        puts exception.message
      end
    end

    # @!method delete_elb
    #
    # @param elb_name [String] Elastic Load Balancer name
    # @param options [Hash]
    #
    # @return [boolean] Returns true or false
    def delete_elb(elb_name, options_hash = {})
      begin
        elbs = self.get_elbs
        elb = elbs[elb_name]
        if elb != nil
          elb.delete
        end
        return true
      rescue => exception
        puts exception.message
        return false
      end
    end


    # @!method add_instances
    #
    # @param elb_name [String] Elastic Load Balancer name
    # @param aws_instances [Array] Array of instance IDs
    #
    # @return [boolean] true or false.
    #

    def add_instances (elb_name, aws_instances = [])
      begin
        # Make sure that caller passed in a name for the ELB
        if elb_name != nil && aws_instances != nil
          zone = 'us-west-2c'
          puts "Zone = #{zone}"
          puts "2"
          elbs = self.get_elbs
          elb = elbs[elb_name]
          aws_instances.each { |instance|
            puts "Registering Instance ... ELB: [#{elb_name}] Instance id: #{instance}"
            elb.instances.register(instance)
          }
          return true
        else
          raise "Both ELB Name and AWS instance names are required."
        end
      rescue => exception
        puts exception.message
        return false
      end
    end
  end
end
