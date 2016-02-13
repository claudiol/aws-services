require 'aws-sdk'
require 'readline'
require 'yaml'


module CFAWS
  #
  # Class to support CRUD for AWS Relational Database Service (RDS)
  # You create a bucket by name. Bucket names must be globally unique and must be DNS compatible.
  #
  class RDS
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
      @rds_instance = AWS::RDS.new(:region => @region)
      @ec2_instance = AWS::EC2.new(:region => @region)
      @connected = true
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
  # @!method create_rds
  #
  # @param instance_name [String] Name of the RDS instance
  #
  # @return [AWS::RDS] Returns an RDS instance created in Amazon

    def create_rds (instance_name, options = {})
      if instance_name == nil || instance_name.length < 1
        raise "Instance name is required and cannot be empty."
      end

      if @connected
        return @rds_instance.db_instances.create(instance_name, options)
      end
    end

    #
    # @!method delete_rds
    #
    # @param instance_name [String] Name of the RDS instance
    # @param options [Hash] - Options for the RDS Instance
    #  :db_name - (String) The name of the database to create when the DB Instance is created. If this parameter is not specified, no database is created in the DB Instance.
    #  :db_instance_identifier - required - (String) The DB Instance identifier. This parameter is stored as a lowercase string.
    #  :allocated_storage - required - (Integer) The amount of storage (in gigabytes) to be initially allocated for the database instance.
    #  :db_instance_class - required - (String) The compute and memory capacity of the DB Instance.
    ###  db.t1.micro | db.m1.small | db.m1.medium | db.m1.large | db.m1.xlarge | db.m2.xlarge | db.m2.2xlarge | db.m2.4xlarge | db.cr1.8xlarge | db.m3.medium | db.m3.large | db.m3.xlarge | db.m3.2xlarge
    #  :engine - required - (String) The name of the database engine to be used for this instance.
    ### MySQL | postgres |oracle-se1 | oracle-se | oracle-ee | sqlserver-ee | sqlserver-se | sqlserver-ex | sqlserver-web
    #  :master_username - required - (String) The name of master user for the client DB Instance.
    #  :master_user_password - required - (String) The password for the master DB Instance user.
    #  :db_security_groups - (Array<) A list of DB Security Groups to associate with this DB Instance.
    #  :vpc_security_group_ids - (Array<) A list of Ec2 Vpc Security Groups to associate with this DB Instance. Default: The default Ec2 Vpc Security Group for the DB Subnet group's Vpc.
    #  :availability_zone - (String) The EC2 Availability Zone that the database instance will be created in.
    #  :db_subnet_group_name - (String) A DB Subnet Group to associate with this DB Instance. If there is no DB Subnet Group, then it is a non-VPC DB instance.
    #  :preferred_maintenance_window - (String) The weekly time range (in UTC) during which system maintenance can occur.
    #  :db_parameter_group_name - (String) The name of the database parameter group to associate with this DB instance. If this argument is omitted, the default DBParameterGroup for the specified engine will be used.
    #  :backup_retention_period - (Integer) The number of days for which automated backups are retained. Setting this parameter to a positive number enables backups. Setting this parameter to 0 disables automated backups.
    #  :preferred_backup_window - (String) The daily time range during which automated backups are created if automated backups are enabled, as determined by the BackupRetentionPeriod.
    #  :port - (Integer) The port number on which the database accepts connections.
    #  :multi_az - (Boolean) Specifies if the DB Instance is a Multi-AZ deployment. You cannot set the AvailabilityZone parameter if the MultiAZ parameter is set to true .
    #  :engine_version - (String) The version number of the database engine to use. Example: 5.1.42
    #  :auto_minor_version_upgrade - (Boolean) Indicates that minor engine upgrades will be applied automatically to the DB Instance during the maintenance window. Default: true
    #  :license_model - (String) License model information for this DB Instance. Valid values: license-included | bring-your-own-license | general-public-license
    #  :iops - (Integer) The amount of provisioned input/output operations per second to be initially allocated for the database instance. Constraints: Must be an integer Type: Integer
    #  :option_group_name - (String) Indicates that the DB Instance should be associated with the specified option group.
    #  :character_set_name - (String) For supported engines, indicates that the DB Instance should be associated with the
    #                         specified CharacterSet.
    #  :publicly_accessible - (Boolean) Specifies the accessibility options for the DB Instance.
    #                         A value of true specifies an Internet-facing instance with a publicly resolvable DNS name,
    #                         which resolves to a public IP address. A value of false specifies an internal instance with
    #                         a DNS name that resolves to a private IP address.
    #                         Default: The default behavior varies depending on whether a VPC has been requested or not.
    #                         The following list shows the default behavior in each case.
    #                         Default VPC: true VPC: false If no DB subnet group has been specified as part of the request
    #                         and the PubliclyAccessible value has not been set, the DB instance will be publicly
    #                         accessible. If a specific DB subnet group has been specified as part of the request and the
    #                         PubliclyAccessible value has not been set, the DB instance will be private.
    # @return [Boolean] Returns true or false

    def delete_rds (instance_name, skip_final_snapshot = true)
      if instance_name == nil || instance_name.length < 1
        raise "delete_rds: Instance name is required and cannot be empty."
      end

      rds_instance = @rds_instance.db_instances["#{instance_name}"]
      if rds_instance != nil
        puts "Found instance: #{instance_name}"
        puts "Deleting instance ..."
        options = {:skip_final_snapshot => true}
        rds_instance.delete(options)
        puts "Done."
        return true
      end
    end

    #
    # @!method create_rds
    #
    # @param instance_name [String] Name of the RDS instance
    #
    # @return [Collection] Returns an Collection of RDS instances

    def get_rds_instances
      return @rds_instance.db_instances
    end

    #
    # @!method get_rds_instance
    #
    # @param instance_name [String] Name of the RDS instance
    #
    # @return [AWS::RDS] Returns an RDS instance that match the instance name passed

    def get_rds_instance (instance_name)
      if instance_name == nil || instance_name.length < 1
        raise "get_rds_instance: Instance name is required and cannot be empty."
      end

      return @rds_instance.db_instances["#{instance_name}"]
    end

    def update_rds (instance_name, options={})

    end

    # - (Core::Response) describe_db_engine_versions(options = {})
    # Calls the DescribeDBEngineVersions API operation.
    # Parameters:
    #    options (Hash) (defaults to: {}) —
    # :engine - (String) The database engine to return.
    # :engine_version - (String) The database engine version to return.
    # :db_parameter_group_family - (String) The name of a specific database parameter group family to return details for. Constraints: Must be 1 to 255 alphanumeric characters First character must be a letter Cannot end with a hyphen or contain two consecutive hyphens
    # :max_records - (Integer) The maximum number of records to include in the response. If more than the MaxRecords value is available, a marker is included in the response so that the following results can be retrieved. Default: 100 Constraints: minimum 20, maximum 100
    # :marker - (String) The marker provided in the previous request. If this parameter is specified, the response includes records beyond the marker only, up to MaxRecords.
    # :default_only - (Boolean) Indicates that only the default version of the specified engine or engine and major version combination is returned.
    # :list_supported_character_sets - (Boolean) If this parameter is specified, and if the requested engine supports the CharacterSetName parameter for CreateDBInstance, the response includes a list of supported character sets for each engine version.
    def get_db_version_numbers(engine_name)
      if @connected
        options = {:engine => "#{engine_name}"}
        client =  AWS::RDS::Client.new
        response = client.describe_db_engine_versions(options)

        # Response to hash ... this is really magical!
        response_hash = response.to_hash

        # Response structure will have db_engine_versions with the version information items. Each items has
        # the following information from :db_engine_versions hash:
        #  {:supported_character_sets=>[],
        #   :db_parameter_group_family=>"postgres9.3",
        #   :engine=>"postgres",
        #   :db_engine_description=>"PostgreSQL",
        #   :engine_version=>"9.3.2",
        #   :db_engine_version_description=>"PostgreSQL 9.3.2-R1"}

        # Let's get the items returned
        db_versions = response_hash[:db_engine_versions]

        #db_versions.each { |db_version_info|
        #  puts "DB Engine: #{db_version_info[:engine]}"
        #  puts "DB Version: #{db_version_info[:engine_version]}""
        #}
        return db_versions
      end
    end

    def get_db_license_model(engine_name)
      options = {:engine => "#{engine_name}"}
      client =  AWS::RDS::Client.new
      response = client.describe_orderable_db_instance_options(options)

      # Response to hash ... this is really magical!
      response_hash = response.to_hash

      # The API from Amazon Returns:
      #    (Core::Response) — The #data method of the response object returns a hash with the following structure:
      #:orderable_db_instance_options - (Array)
      #:engine - (String)
      #:engine_version - (String)
      #:db_instance_class - (String)
      #:license_model - (String)
      #:availability_zones - (Array)
      #:name - (String)
      #:provisioned_iops_capable - (Boolean)
      #:multi_az_capable - (Boolean)
      #:read_replica_capable - (Boolean)
      #:vpc - (Boolean)
      #:marker - (String)

      # Let's get the items returned
      db_info = response_hash[:orderable_db_instance_options]

      db_info.each { |info|
         puts info.inspect
      }
     # puts db_info.inspect

      # We will only return the license model to the user
      # TODO: We should have this in an instance variable.
      return db_info[:license_model]

    end

    # TODO: Implement exists? method
    def exists?

    end
  end
end
