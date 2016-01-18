require 'aws-sdk'
require 'readline'
require 'yaml'

#
# Module AWS
#
module CFAWS
  #
  # Class VPC - Contains all the helper methods for VPC's
  #
  class VPC

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
    # @!method get_vpcs
    #
    # @return [Collection] Collection of existing virtual private clouds (VPCs)
    #
    def get_vpcs
      return @ec2_instance.vpcs
    end

    #
    # @!method exists?
    #
    # @param vpc_name [String] Name of the virtual private cloud
    #
    # @return [boolean] Returns true or false

    def exists? (vpc_name)
      begin
        if vpc_name == nil
          raise "Virtual Private Cloud name required."
        else
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          if vpc != nil
            return vpc.exists?
          else
            return false
          end
        end
      rescue => exception
        puts exception.message
      end
    end


    # @!method vpc_instances
    #
    #
    # @return [InstanceCollection] Collection of instances associated with the VPC
    #
    def vpc_instances (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.instances
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method vpc_dhcp_options
    #
    #
    # @return [DHCPOptions] - Returns the dhcp options associated with this VPC.
    #
    def vpc_dhcp_options (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.dhcp_options
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method vpc_internet_gateway
    # @return the internet gateway attached to this VPC.
    def vpc_internet_gateway (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.internet_gateway
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method vpc_network_acls
    # @return [NetworkACLCollection] a filtered collection of network ACLs that are in this VPC.
    #  - (NetworkACLCollection) network_acls
    # Returns

    def vpc_network_acls (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.network_acls
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method vpc_route_tables
    # @return [RouteTableCollection] a filtered collection of network ACLs that are in this VPC.
    #  - (RouteTableCollection) network_acls
    # Returns

    def vpc_route_tables (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.route_tables
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method vpc_security_groups
    # @return [SecurityGroupCollection] a filtered collection of security groups that are in this VPC.

    def vpc_security_groups (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.security_groups
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end


    # @!method vpc_subnets
    # @return [SubnetCollection] a filtered collection of subnets that are in this VPC.

    def vpc_subnets (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.subnets
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method vpc_vpn_gateway
    # @return [VPNGateway] a filtered collection of subnets that are in this VPC.

    def vpc_subnets (vpc_name)
      begin
        if vpc_name != nil
          vpcs = self.get_vpcs
          vpc = vpcs[vpc_name]
          return vpc.vpn_gateway
        else
          raise "VPC Name required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    #
    # @!method create_vpc
    #  Creates a VPC with the CIDR block you specify. The smallest VPC you can
    #  create uses a /28 netmask (16 IP addresses), and the largest uses a /16 netmask (65,536 IP addresses).
    # @param cidr_block (String) — The CIDR block you want the VPC to cover (e.g., 10.0.0.0/16).
    # @param options [Hash] - defaults to: {}
    # Options Hash (options):
    # :instance_tenancy (Boolean) — default: :default — The allowed tenancy of instances launched into the VPC.
    # A value of :default means instances can be launched with any tenancy; a value of :dedicated means all
    # instances launched into the VPC will be launched with dedicated tenancy regardless of the tenancy assigned
    # to the instance at launch.
    # @return [VPC] - Newly created instance
    #
    # vpc = myAwsVPC.vpcs.create('10.0.0.0/16')

    def create_vpc(cidr_block, options_hash = {})
      begin
        if cidr_block != nil
          return self.get_vpcs.create(cidr_block, options_hash)
        else
          raise "cidr_block required."
        end
      rescue => exception
        puts exception.message
        return nil
      end
    end

    # @!method delete_vpc
    #
    # @param vpc_name [String] Virtual Private Cloud name
    #
    # @return [boolean] Returns true or false
    def delete_vpc(vpc_name)
      begin
        vpcs = self.get_vpcs
        vpc = vpcs[vpc_name]
        if vpc != nil
          vpc.delete
        end
        return true
      rescue => exception
        puts exception.message
        return false
      end
    end

  end
end
