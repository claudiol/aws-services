#!/usr/bin/env ruby
require 'qpid_messaging'

# This is your classic Hello World application, written in
# Ruby, that uses Qpid. It demonstrates how to send and
# also receive messages.
#
def connect_to_broker(my_host, broker, options, address, file)
    puts "Connecting to broker: #{broker} options: #{options}." 
    io_error = false
    qpid_options = {}
    options.split(",").each { |pair|
        key, value = pair.split(/=>/) 
        key.delete!('"')
        value.delete!('"')
        qpid_options[key]=value
    }
    #qpid_options = {:tcp_nodelay => true}
    puts qpid_options.inspect
    connection = Qpid::Messaging::Connection.new :url => broker, :options => qpid_options
    connection.open
    puts "Creating a session with broker: #{broker}." 
    session    = connection.create_session
    puts "Using address: #{address} to send messages." 
    sender     = session.create_sender address
  
    pattern = // 
    f = File.open(file,"r")
    f.seek(0,IO::SEEK_END)
    @file_size= File.stat(f).size
    puts "File state returned ... #{@file_stat} #{File.stat(f).inspect}"
    while true do
      io = select([f], nil, nil, 10)
      @file_size_check = File.stat(f).size
      if @file_size_check  < @file_size && @file_size != 0
          puts "An Error Occurred: Original Size: #{@file_size} < Current Size: #{@file_size_check}"
          puts "Looks like file got rotated ... restarting"
          f.close()
          f = File.open(file,"r")
          f.seek(0,IO::SEEK_END)
          @file_size = File.stat(f).size
          @file_size_check = File.stat(f).size
      end
      line = f.gets
      # Send a simple message
      sender.send Qpid::Messaging::Message.new :subject => "automation.log", :content => "#{my_host} ==> #{line}" if line=~pattern
      #puts "Found it! #{line}" if line=~pattern
    end
    connection.close
    return io_error
end 

if __FILE__ == $0
  begin
    my_host = %x[hostname -s]
    my_host.delete!("\n")
    broker  = ARGV[0] || "vpn-225-101.phx2.redhat.com:5672"
    options = ARGV[1] || ""
    #address = ARGV[2] || "cfme-log-service/automation.log/#{my_host}_automation_log_topic;{create: always, node: {type: topic}}"
    address = ARGV[2] || "cfme-log-service/#{my_host}.automation.log;{create: always, node: {type: topic}}"
    file = ARGV[3] || "/var/www/miq/vmdb/log/automation.log"
    connect_to_broker(my_host, broker, options, address, file)
  rescue => error
    puts "Exception: #{error.message}"
    puts "Usage: #{$0} <broker> <queue> <log file>"
    puts "<broker> - Address for the broker with the port"
    puts "<queue> - Name of the queue. To always create it append {create: always}"
    puts "<log file> - Name of the log file to read and send content to the broker."
    puts "Example: #{$0} localhost:5672 my_queue;{create: always} /var/www/miq/vmdb/log/evm.log" 
  end
end
