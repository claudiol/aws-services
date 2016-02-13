#!/usr/bin/env ruby
require "aws-sdk"
require "time"


puts Time.now.utc.iso8601
aws_access_key_id='AKIAI3WNG4NZPKRBE2WA'
aws_secret_key='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'

cw = AWS::CloudWatch.new(
  :region => 'us-east-1',
  :access_key_id => aws_access_key_id,
  :secret_access_key => aws_secret_key)

resp = cw.client.describe_alarms
resp[:metric_alarms].each do |alarm|
  puts alarm[:alarm_name]
end

response = cw.client.list_metrics
metrics = response[:metrics]

### {:dimensions=>[{:name=>"ServiceName", :value=>"AmazonEC2"}, {:name=>"Currency", :value=>"USD"}], :metric_name=>"EstimatedCharges", :namespace=>"AWS/Billing"}
the_dimensions = []
metrics.each do | metric |
  the_dimensions = metric[:dimensions] # Get the dimensions
  resp = cw.client.get_metric_statistics({
    namespace: "#{metric[:namespace]}", ### AWS/Billing", # required
    metric_name: "#{metric[:metric_name]}", ### EstimatedCharges", # required
    dimensions: the_dimensions,
    start_time: Time.utc(2016,"jan",1,00,00,00).iso8601,
    end_time:  Time.now.utc.iso8601,
    period: 86400, # required
    statistics: ["Sum"], # required, accepts SampleCount, Average, Sum, Minimum, Maximum
    unit: "Count", # accepts Seconds, Microseconds, Milliseconds, Bytes, Kilobytes, Megabytes, Gigabytes, Terabytes, Bits, Kilobits, Megabits, Gigabits, Terabits, Percent, Count, Bytes/Second, Kilobytes/Second, Megabytes/Second, Gigabytes/Second, Terabytes/Second, Bits/Second, Kilobits/Second, Megabits/Second, Gigabits/Second, Terabits/Second, Count/Second, None
  })
  datapoint = resp[:datapoints]
  if datapoint.empty? == false
    puts metric.inspect
    puts resp.inspect
  end
end
puts Time.now
