#
#            Automate Method
#
$evm.log("info", "===== AWS List ELBs ==== Automate Method Started")
#
#            Method Code Goes here
#
# Load the aws-sdk
require "aws-sdk"


begin
  dialog_field = $evm.object
  access_key_id = nil
  secret_access_key = nil

# Get the Amazon authentication credentials...
  access_key_id ||= $evm.object['access_key_id']
  secret_access_key = $evm.object.decrypt('secret_access_key')

  selected_region = $evm.root['dialog_aws_region']
  selected_elb = $evm.root['dialog_aws_elb']
  $evm.log("info", "Selected Region: #{selected_region}")

  if  selected_region == nil
    default_region = $evm.object['default_aws_region']
  else
    default_region = selected_region
  end


  AWS.config(
      :access_key_id => access_key_id,
      :secret_access_key => secret_access_key
  )

  # Create the basic EC2 object
  ec2_instance = AWS::EC2.new( :region => default_region )
  elb_instance = AWS::ELB.new( :region => default_region )

  elbs = elb_instance.load_balancers

  # Create some local variables ...

  # Dynamic list to add values to the dialog dynamic list ...
  list = {}

  # Count of regions ...
  count = 0

  # Save first entry and make it the default region
  first = nil

  # Go through all regions returned from EC2 and add them to list
  elbs.each do |k|
    count += 1
    if count == 1
      first = k.name
    end
    $evm.log("info", "ELBS: #{k.name} ")
    list[k.name]  = "#{k.name}"
  end

  $evm.log("info", "LIST: #{list.inspect} ")

  # Add list to dialog dynamic list ...
  $evm.object["values"] = list


  # Make the first entry the default value
  $evm.object["default_value"] = first


  $evm.log("info", "Dialog Inspect: #{$evm.object.inspect}")

  $evm.log("info", "====== RETRIEVE AMAZON ELASTIC LOAD BALANCERS =====  Automate Method Ended")
  exit MIQ_OK

rescue => exception
  $evm.log("info", "====== EXCEPTION IN RETRIEVE AMAZON ELASTIC LOAD BALANCERS =====")
  $evm.log("info", exception.message)
end