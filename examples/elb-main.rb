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
load 'aws-s3.rb'
load 'aws-elb.rb'

# Create a new ELB class instance
elb = AwsELB.new('config.yaml')

elbs = elb.get_elbs
# Let's get a list of existing Elastic Load Balancers

elb_count = 0
# Iterate through the ELB's 
elbs.each do |balancer|
	puts balancer.name
	elb_count += 1
end

if elb_count == 0
	puts "No current ELBs found."
else
	puts "Found #{elb_count} ELBs"
end


# Let's iterate through all the EC2 regions
elb.available_regions.each { |region|
  puts "Amazon Region: #{region.name}"
}
# For the fun of it let's iterate through the Amazon Zones
# NOTE: The default Amazon region is us-east unless you instanciate the object in another region
# The config.yaml file has an entry for your default-region: that can be set to the default region you
# want AWS objects in this toolkit to connect to.
#
puts "Availability Zones for our default region defined in config.yaml:"
target_zone = nil
elb.availability_zones.each do |zone|
	puts zone
	target_zone = zone
end



vpcs = elb.available_vpcs
puts "Inspect: #{vpcs.inspect}"
vpc = vpcs['vpc-762ccf13']
puts "Inspect: #{vpc.inspect}"
subnets = vpc.subnets
puts "Inspect: #{subnets.inspect}"
subnetid=[]
count = 0
subnets.each {|subnet|
  subnetid[count] = "#{subnet.id}"
  count += 1
}
puts "Inspect: #{subnetid.inspect}"
#
# Set the options to create the ELB
# NOTE: We want to create the ELB in the us-east-1b zone.  Check the config.yaml file default-region: entry 
# to make sure it is in the correct region.  You can override the region when you create the instance for an AwsELB by passing the 
# region in the constructor.
#
puts "Using zone #{target_zone} to create ELB"
elb_options = { #:availability_zones => target_zone,
	:listeners => [{
    :port => 80,
    :protocol => :http,
    :instance_port => 80,
    :instance_protocol => :http
  }],
  :subnets => subnetid

}

#
# Create the ELB 
#
puts "Creating ELB ... claudiol-elb ..."
new_elb = elb.create_elb('claudiol-elb', elb_options)
puts "done."

puts "Let's verify that it does exits:"
if (elb.exists?('claudiol-elb'))
	puts "Elastic Load Balancer exists!"
	# now let's get all the details for the Load Balancer:
	puts "Details:"
	puts "Name: #{new_elb.name}"
	puts "DNS Name: #{new_elb.dns_name}"
	puts "Canonical Zone Name: #{new_elb.canonical_hosted_zone_name}"
	puts "Canonical Zone ID: #{new_elb.canonical_hosted_zone_name_id}"
end

#
# List the available instances
#
ec2_instances = []
count = 0
instances = elb.available_instances
instances.each { |instance|
  puts instance.id
  ec2_instances[count] = "#{instance.id}"
  count += 1
}
puts "Available Instances: #{count}"

#
# List the available subnets
#
count = 0
subnets = elb.available_subnets
subnets.each { |subnet|
   count += 1
   puts subnet.subnet_id
}
puts "Available subnets: #{count}"

#
# Add instances AmazonRedHatImage_0003, Test-Amazon-Instance using their ids
#
#ec2_instances = ['i-88318dbc', 'i-2d651019']
puts "Adding instance to new ELB ..."
if elb.add_instances('claudiol-elb', ec2_instances)
	puts "Instance added successfully to the ELB"
end

#
# Verify that the instances are really there ...
#
instances = elb.elb_instances('claudiol-elb')
puts "Number of instances for elb: #{instances.count}"
instances.each { |instance|
  puts "Name: #{instance.id}"
}

#
# Now let's delete it
#

#puts "Deleting ELB claudiol-elb ..."
#elb.delete_elb('claudiol-elb', elb_options)

# Double check that it was deleted ...
#while (elb.exists?('claudiol-elb'))#
#	puts "Wait for it ..."
#	sleep(5)
#end
#puts "Finally deleted."
