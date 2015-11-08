#
#            Automate Method
#
# Method to validate the name of the RDS Instance:
#
# Constraints: Must contain from 1 to 63 (1 to 15 for SQL Server) alphanumeric characters or hyphens.
# First character must be a letter. Cannot end with a hyphen or contain two consecutive hyphens.
#
require 'aws-sdk'

@method = "create-rds-instance"
$evm.log("info", "======= #{@method} ====== Automate Method Started")

$evm.log("info", "========== AWS #{@method} ATTRIBUTE LOG =================================")
$evm.log("info", "Listing ROOT Attributes:")
$evm.root.attributes.sort.each { |k, v| $evm.log("info", "\t#{k}: #{v}")}
$evm.log("info", "=========== AWS #{@method}ATTRIBUTE LOG ================================")
prov.get_option(:)
begin
  access_key_id = nil
  secret_access_key = nil

# Get the Amazon authentication credentials...
  access_key_id ||= $evm.object['access_key_id']
  secret_access_key = $evm.object.decrypt('secret_access_key')
  AWS.config(
      :access_key_id => access_key_id,
      :secret_access_key => secret_access_key
  )

  # Get the name of the bucket name from the request ... validate_bucket_name adds it
  elb_name = $evm.root['elb_name']
  # Retrieve the region from the dialog

  # Retrieve all the Dialog items to provision the RDS Service

  auto_upgrade = $evm.root['dialog_auto_upgrade']
  rds_storage = $evm.root['dialog_rds_alloc_storage']
  backup_period = $evm.root['dialog_rds_backup_period']
  db_auto_backups = $evm.root['dialog_rds_db_auto_backups']
  db_az_deployment = $evm.root['dialog_rds_db_az_deployment']
  db_engine = $evm.root['dialog_rds_db_engine']
  db_instance_class = $evm.root['dialog_rds_db_instance_class']
  db_name = $evm.root['dialog_rds_db_name']
  db_port = $evm.root['dialog_rds_db_port']
  db_subnet = $evm.root['dialog_rds_db_subnet']
  db_user_id = $evm.root['dialog_rds_db_user_id']
  db_version = $evm.root['dialog_rds_db_version']
  db_vpc = $evm.root['dialog_rds_db_vpc']
  instance_name = $evm.root['dialog_rds_instance_name']
  rds_public_access = $evm.root['dialog_rds_public_access']
  rds_use_iops = $evm.root['dialog_rds_use_iops']


  region      = $evm.root['default_aws_region']
  auto_backups = (db_auto_backups) ? true : false
  az_deployment = (db_az_deployment) ? true : false
  use_iops = (rds_use_iops) ? 1 : 0
  public_access = (rds_public_access) ? true : false

  $evm.log("info", "===> Region: #{region}")

  # Create the basic EC2 object
  ec2_instance = AWS::EC2.new(:region => region)
  rds_instance = AWS::RDS.new(:region => region)

  upgrade = (auto_upgrade) ? true : false

  options={ :db_name => "#{db_name}", :allocated_storage => rds_storage.to_i, :db_instance_class => "#{db_instance_class}",
            :engine => "#{db_engine}", :master_username => "#{db_user_id}", :master_user_password => "ChangeMe",
            :auto_minor_version_upgrade => upgrade, :backup_retention_period => backup_period.to_i, :multi_az => az_deployment,
            :port => db_port.to_i, :master_username => db_user_id,  :engine_version => "#{db_version}",
            :db_instance_identifier => "#{instance_name}", :publicly_accessible => public_access }
  rds_instance.db_instances.create(instance_name, options)
  #
  #
  #
  $evm.log("info", "======= #{@method} ====== Automate Method Ended")
  exit MIQ_OK
rescue => err
  $evm.log("info", "====== Automate Method Ended ======")
  $evm.log("info", "====== AWS RDS Exception ======")
  $evm.log("info", "======= #{err.message} ====== Automate Method Ended")
  exit MIQ_ABORT
end
