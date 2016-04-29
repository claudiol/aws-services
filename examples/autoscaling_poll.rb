#!/usr/bin/env ruby
require "aws-sdk"
require 'optparse'
require 'yaml'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{opts.program_name} -q|--queue <SQS Queue Name>"

  opts.on('-q', '--queue NAME', 'SQS Queue name') { |v| options[:queue_name] = v }
  opts.on('-h', '--help', '') { puts "#{opts.banner}"; exit}

end.parse!


def pollQueue(sqs_instance, queue_name)
  queue = sqs_instance.queues.named(queue_name)
  puts "Polling on queue ARN: #{queue.arn}"
  queue.poll do |msg|
     puts "Got message: #{msg.body}"
  end
end

def listAvailableTopics(sns_instance)
  topics = sns_instance.topics
  puts "Available topics:"
  topics.each do | topic |
     puts "\tTopic ARN: #{topic.arn}"
     puts "\tTopic: #{topic.display_name}"
  end
end

def listLaunchConfigurations( autoscaling )
  launch_configs = auto_scaling.launch_configurations

  puts "Available Launch Configurations:"
  launch_configs.each do | lc |
     puts "\tLaunch Config Name: #{lc.name} \tARN: #{lc.arn}"
  end
end

def listSNSTopics( sns_instance )
   topics = sns_instance.topics
   topics.each do | topic |
      puts topic.arn
   end
end

def deleteSNSTopics( sns_instance )
   topics = sns_instance.topics
   topics.each do | topic |
      puts "Deleting: #{topic.arn}"
      topic.delete
   end
end

def listSQSQueues(sqs_instance)
  queues = sqs_instance.queues
  count = 0
  queues.each do | queue |
     puts "Queue ARN: #{queue.arn}"
  end
end

def deleteSQSQueues(sqs_instance)
  queues = sqs_instance.queues
  queues.each do | queue |
     puts "Deleting Queue ARN: #{queue.arn}"
     queue.delete
  end
end

def createSQSQueue(sqs_instance, name)
  queue = nil
  begin
    queue = sqs_instance.queues.create("notify-me")
    puts queue.inspect
  rescue Exception => ex
  end
  queue
end

## Personal account claudiol@redhat.com
##aws_access_key_id='AKIAI3WNG4NZPKRBE2WA'
##aws_secret_key='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'
aws_access_key_id='AKIAJEQRFNOZNTY4BBFQ'
aws_secret_key='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'

auto_scaling = AWS::AutoScaling.new(
  :region => 'us-west-1',
  :access_key_id => aws_access_key_id,
  :secret_access_key => aws_secret_key)

sns = AWS::SNS.new(
  :region => 'us-west-1',
  :access_key_id => aws_access_key_id,
  :secret_access_key => aws_secret_key)


sqs = AWS::SQS.new(
  :region => 'us-west-1',
  :access_key_id => aws_access_key_id,
  :secret_access_key => aws_secret_key)


if options.count > 0
   pollQueue(sqs, options[:queue_name])
end

