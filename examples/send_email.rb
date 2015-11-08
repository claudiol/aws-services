###################################
#
# EVM Automate Method: MiqProvision_Complete
#
# Notes: This method sends an e-mail when the following event is raised:
#
# Events: vm_provisioned
#
# Model Notes:
# 1. to_email_address - used to specify an email address in the case where the
#    vm's owner does not have an  email address. To specify more than one email
#    address separate email address with commas. (I.e. admin@company.com,user@company.com)
# 2. from_email_address - used to specify an email address in the event the
#    requester replies to the email
# 3. signature - used to stamp the email with a custom signature
#
###################################
begin
  @method = 'MiqProvision_Complete'
  $evm.log("info", "#{@method} - EVM Automate Method Started")

  # Turn of verbose logging
  @debug = true

  # Get vm from miq_provision object
  prov = $evm.root['miq_provision']
  vm = prov.vm
  raise "#{@method} - VM not found" if vm.nil?


  ###################################
  #
  # Method: get_variables
  #
  ###################################
  send_to_admins = nil
  send_to_admins ||= $evm.object['send_to_admins'] || false

  # Override the default appliance IP Address below
  #appliance ||= 'evmserver.company.com'
  appliance ||= $evm.root['miq_server'].ipaddress

  # Get from_email_address from model unless specified below
  from = nil
  from ||= $evm.object['from_email_address']

  # Get signature from model unless specified below
  signature = nil
  signature ||= $evm.object['signature']

  ###################################
  #
  # Method: boolean
  #
  ###################################
  def boolean(string)
    return true if string == true || string =~ (/(true|t|yes|y|1)$/i)
    return false if string == false || string.nil? || string =~ (/(false|f|no|n|0)$/i)

    # Return false if string does not match any of the above
    $evm.log("info","Invalid boolean string:<#{string}> detected. Returning false") if @debug
    return false
  end

  def email_enduser(appliance, from, signature, prov, vm)
    #
    # Get VM Owner Name and Email
    #
    evm_owner_id = vm.attributes['evm_owner_id']
    owner = nil
    owner = $evm.vmdb('user', evm_owner_id) unless evm_owner_id.nil?
    $evm.log("info", "#{@method} - VM Owner: #{owner.inspect}") if @debug

    to = nil
    to = owner.email unless owner.nil?
    to ||= prov.get_option(:owner_email) || $evm.object['to_email_address']
    if to.nil?
      $evm.log("info", "#{@method} Email not sent because no recipient specified.")
      exit MIQ_OK
    end

    # Assign original to_email_Address to orig_to for later use
    orig_to = to

    # Set email Subject
    subject = "Your virtual machine request has Completed - VM: #{vm['name']}"


    # Set the opening body to Hello
    body = "Hello, "

    # Override email to VM owner and send email to a different email address
    # if the template provisioned contains 'xx'
    #
    if prov.vm_template.name.downcase.include?('_xx_')
      $evm.log("info", "#{@method} - Setup of special email for DBMS VM") if @debug


      # Specify special email address below
      to      = 'evmadmin@company.com'

      body += "This email was sent by EVM to inform you of the provisioning of a new DBMS VM.<br>"
      body += "This new VM requires changes to DNS and DHCP to function correctly.<br>"
      body += "Please set the IP Address to static.<br>"
      body += "Once that has been completed, use this message to inform the "
      body += "requester that their new VM is ready.<br><br>"
      body += "-------------------------------- <br>"
      body += "Forward the message below to <br>"
      body += "#{orig_to}<br>"
      body += "-------------------------------- <br><br>"
      body += "<br>"
    end

    # VM Provisioned Email Body
    body += "<br><br>Your request to provision a virtual machine was approved and completed on #{Time.now.strftime('%A, %B %d, %Y at %I:%M%p')}. "
    body += "<br><br><b>VM Name:</b> #{vm['name']}"
    body += "<br><b>Hostname:</b> #{prov.get_option(:host_name)}.#{prov.get_option(:dns_suffixes)}"
    body += "<br><b>IP Address:</b> #{prov.get_option(:ip_addr)}"
    body += "<br><br>For Windows VM access is available via RDP and for Linux VM access is available via putty/ssh, etc. Or you can use the Console Access feature found in the detail view of your VM. "
    body += "<br><br>This VM will automatically be retired on #{vm['retires_on'].strftime('%A, %B %d, %Y')}, unless you request an extension. " if vm['retires_on'].respond_to?('strftime')
    body += " You will receive a warning #{vm['reserved'][:retirement][:warn]} days before #{vm['name']} set retirement date." if vm['reserved'] && vm['reserved'][:retirement] && vm['reserved'][:retirement][:warn]
    body += " As the designated owner you will receive expiration warnings at this email address: #{orig_to}"
    #body += "<br><br>If you are not already logged in, you can access and manage your virtual machine here <a href='https://#{appliance}/vm_or_template/show/#{vm['id']}'>https://#{appliance}/vm_or_template/show/#{vm['id']}'</a>"
    body += "<br><br> If you have any issues with your new virtual machine please contact Support."
    body += "<br><br> Thank you,"
    body += "<br> #{signature}"

    prov.set_option(:ws_values, 'owner_email'=>"#{to}")
    #
    # Send email to user
    #
    $evm.log("info", "#{@method} - Sending email to <#{to}> from <#{from}> subject: <#{subject}>") if @debug
    $evm.execute('send_email', to, from, subject, body)
  end

  def email_admins(appliance, from, signature, prov, vm)
    #
    # Get VM Owner Name and Email
    #
    evm_owner_id = vm.attributes['evm_owner_id']
    owner = nil
    owner = $evm.vmdb('user', evm_owner_id) unless evm_owner_id.nil?
    $evm.log("info", "#{@method} - VM Owner: #{owner.inspect}") if @debug

    to = nil
    to ||= $evm.object['to_email_address']
    if to.nil?
      $evm.log("info", "#{@method} Email not sent because no recipient specified.")
      exit MIQ_OK
    end

    # Assign original to_email_Address to orig_to for later use
    orig_to = to

    # Set email Subject
    subject = "Initialize Post Provisioning Steps for VM: #{vm['name']}"

    # Set the opening body to Hello
    body = "Hello, "

    # Override email to VM owner and send email to a different email address
    # if the template provisioned contains 'xx'
    #
    if prov.vm_template.name.downcase.include?('_xx_')
      $evm.log("info", "#{@method} - Setup of special email for DBMS VM") if @debug


      # Specify special email address below
      to      = 'evmadmin@company.com'

      body += "This email was sent by EVM to inform you of the provisioning of a new DBMS VM.<br>"
      body += "This new VM requires changes to DNS and DHCP to function correctly.<br>"
      body += "Please set the IP Address to static.<br>"
      body += "Once that has been completed, use this message to inform the "
      body += "requester that their new VM is ready.<br><br>"
      body += "-------------------------------- <br>"
      body += "Forward the message below to <br>"
      body += "#{orig_to}<br>"
      body += "-------------------------------- <br><br>"
      body += "<br>"
    end

    # VM Provisioned Email Body
    body += "<br><br>The following system has been completed on #{Time.now.strftime('%A, %B %d, %Y at %I:%M%p')}. You will now need to complete the post-provisioning steps"
    body += "<br><br><b>Virtualization Provider:</b> #{prov.options[:src_ems_id][1]}"
    body += "<br><br><b>Virtualization Datacenter:</b> #{prov.options[:placement_dc_name][1]}"
    body += "<br><b>Virtualization Cluster:</b> #{prov.options[:placement_cluster_name][1]}"
    body += "<br><b>Virtualization Host:</b> #{prov.options[:placement_host_name][1]}"
    body += "<br><b>Virtualization Datastore:</b> #{prov.options[:placement_ds_name][1]}"
    body += "<br><br><b>VM Name:</b> #{vm['name']}"
    body += "<br><b>VM CPU Sockets:</b> #{prov.options[:number_of_sockets][1]}"
    body += "<br><b>VM CPU Cores:</b> #{prov.options[:cores_per_socket][1]}"
    body += "<br><b>VM Memory:</b> #{prov.options[:vm_memory][1]} MB"
    body += "<br><b>VM Hostname:</b> #{prov.get_option(:host_name)}.#{prov.get_option(:dns_suffixes)}"
    body += "<br><b>VM IP Address:</b> #{prov.get_option(:ip_addr)}"
    body += "<br><b>VM Networks:</b> #{prov.get_option(:vlan)}"
    body += "<br><br><b>Owner Name:</b> #{prov.get_option(:owner_first_name)} #{prov.get_option(:owner_last_name)} "
    body += "<br><b>Owner E-mail:</b> #{prov.get_option(:owner_email)}"
    body += "<br><br>For Windows VM access is available via RDP and for Linux VM access is available via putty/ssh, etc. Or you can use the Console Access feature found in the detail view of your VM. "
    body += "<br><br>This VM will automatically be retired on #{vm['retires_on'].strftime('%A, %B %d, %Y')}, unless you request an extension. " if vm['retires_on'].respond_to?('strftime')
    body += " You will receive a warning #{vm['reserved'][:retirement][:warn]} days before #{vm['name']} set retirement date." if vm['reserved'] && vm['reserved'][:retirement] && vm['reserved'][:retirement][:warn]
    body += " As the designated owner you will receive expiration warnings at this email address: #{orig_to}"
    #body += "<br><br>If you are not already logged in, you can access and manage your virtual machine here <a href='https://#{appliance}/vm_or_template/show/#{vm['id']}'>https://#{appliance}/vm_or_template/show/#{vm['id']}'</a>"
    body += "<br><br> If you have any issues with your new virtual machine please contact Support."
    body += "<br><br> Thank you,"
    body += "<br> #{signature}"


    #
    # Send email to user
    #
    $evm.log("info", "#{@method} - Sending email to <#{to}> from <#{from}> subject: <#{subject}>") if @debug
    $evm.execute('send_email', to, from, subject, body)
  end

  email_enduser(appliance, from, signature, prov, vm)

  # Execute HTTP Export
  if boolean(send_to_admins)
    email_admins(appliance, from, signature, prov, vm)
  end

  #
  # Exit method
  #
  $evm.log("info", "#{@method} - EVM Automate Method Ended")
  exit MIQ_OK

    #
    # Set Ruby rescue behavior
    #
rescue => err
  $evm.log("error", "#{@method} - [#{err}]\n#{err.backtrace.join("\n")}")
  exit MIQ_STOP
end