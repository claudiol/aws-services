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
load 'aws_rds.rb'

# Create a new ELB class instance
rds = AwsRDS.new('config.yaml')

# db_name : No Underscores.
options={ :db_name => "ProductionVMDB", :allocated_storage => 5, :db_instance_class => "db.t1.micro",
  :engine => "postgres", :master_username => "dbamin", :master_user_password => "password"}

#
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
#  :character_set_name - (String) For supported engines, indicates that the DB Instance should be associated with the specified CharacterSet.
#  :publicly_accessible - (Boolean) Specifies the accessibility options for the DB Instance. A value of true specifies an Internet-facing instance with a publicly resolvable DNS name, which resolves to a public IP address. A value of false specifies an internal instance with a DNS name that resolves to a private IP address. Default: The default behavior varies depending on whether a VPC has been requested or not. The following list shows the default behavior in each case. Default VPC: true VPC: false If no DB subnet group has been specified as part of the request and the PubliclyAccessible value has not been set, the DB instance will be publicly accessible. If a specific DB subnet group has been specified as part of the request and the PubliclyAccessible value has not been set, the DB instance will be private.


def print_db_info(db_versions)
  db_versions.each {|version_info|
    puts "========== DB Version Information =============="
    puts "DB Engine: #{version_info[:engine]}"
    puts "DB Engine Description: #{version_info[:db_engine_description]}"
    puts "DB Group Family Description: #{version_info[:db_parameter_group_family]}"
    puts "DB Version: #{version_info[:engine_version]}"
    puts "========== DB Version Information =============="
    puts ""
  }
end


#rds.create_rds('MyTestVMDBInstance', options)
# rds.delete_rds('Mynewdb')
db_versions = rds.get_db_version_numbers("postgres")
print_db_info(db_versions)

db_versions = rds.get_db_version_numbers("MySql")
print_db_info(db_versions)

license_model = rds.get_db_license_model("postgres")
puts "#{license_model}"