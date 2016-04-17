What is this AWSServices?
--

This is a helper class library in Ruby to create AWS Elastic Load Balancers (ELBs), S3 Buckets.  The idea is to  
create an abstraction layer to the AWS SDK to create ELBs via a Ruby script inside of Cloudforms.

Yes you can use the AWS SDK directly within Cloudforms but there are some other functionality that we would
add to the methods withing this GEM.  We would like for some of our code to eventually be added to the
Cloudforms CFME engine but for now our focus is to have it be part of the Automate methods and used via
Buttons or Service Dialogs.

Current version functionality
---
- AWS S3 bucket support
- AWS Elastic Load Balancer support


Library Files
--
lib/aws-s3.rb - AwsS3 class definition for AWS S3 support
lib/aws-elb.rb - AwsELB class definition for AWS Elastic Load Balancer support.

Documentation Files
--
The doc directory contains all the class documentation.  It was generated using YARDOC from yardoc.org.

Example files provided
--
examples/elb-main.rb - Shows how to use the AwsELB class.
examples/s3-main.rb  - Shows how to use the AwsS3 class.

Environment
--
Make sure you set the RUBYLIB to the full path where the Aws support classes are located.

export RUBYLIB=/Users/lesterclaudio/work/ruby-project/aws-elb/lib
