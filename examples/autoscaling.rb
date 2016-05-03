#!/usr/bin/env ruby
require "aws-sdk"

def listLaunchConfigurations( autoscaling )
  launch_configs = auto_scaling.launch_configurations

  puts "Available Launch Configurations:"
  launch_configs.each do | lc |
     puts "\tLaunch Config Name: #{lc.name} \tARN: #{lc.arn}"
  end
end

def listSNSTopics( topics )
   topics.each do | topic |
      puts topic.arn
   end
end

def deleteSNSTopics( topics )
   topics.each do | topic |
      puts "Deleting: #{topic.arn}"
      topic.delete
   end
end

def listSQSQueues(queues)
  count = 0
  queues.each do | queue |
     puts "Queue ARN: #{queue.arn}"
  end
end

def deleteSQSQueues(queues)
  count = 0
  queues.each do | queue |
     puts "Deleting Queue ARN: #{queue.arn}"
     queue.delete
  end
end

def createSQSQueue(name)
  queue = nil
  begin
    queue = sqs.queues.create("notify-me")
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

### :region => 'us-east-1',
auto_scaling = AWS::AutoScaling.new(
  :region => 'us-west-1',
  :access_key_id => aws_access_key_id,
  :secret_access_key => aws_secret_key)

sns = AWS::SNS.new(
  :region => 'us-west-1',
  :access_key_id => aws_access_key_id,
  :secret_access_key => aws_secret_key)

topics = sns.topics
listSNSTopics(topics)
#deleteSNSTopics(topics)

sqs = AWS::SQS.new(
  :region => 'us-west-1',
  :access_key_id => aws_access_key_id,
  :secret_access_key => aws_secret_key)

queues = sqs.queues

if queues.count > 0
  listSQSQueues(queues)
#  deleteSQSQueues(queues)
end

puts "Available topics:"
topics.each do | topic |
   puts "\tTopic ARN: #{topic.arn}"
   puts "\tTopic: #{topic.display_name}"
end

queue = sqs.queues.named('cpu-high-mark')
count = 0
queues.each do | queue |
     puts "Polling on queue ARN: #{queue.arn}"
     queue.poll do |msg|
       puts "Got message: #{msg.body}"
     end
end

