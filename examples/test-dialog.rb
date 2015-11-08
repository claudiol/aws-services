---
:buttons:
    - :submit
- :cancel
:dialogs:
    :requester:
    :description: Request
:fields:
    :owner_phone:
    :description: Phone
:required: false
:display: :hide
:data_type: :string
:owner_country:
    :description: Country/Region
:required: false
:display: :hide
:data_type: :string
:owner_phone_mobile:
    :description: Mobile
:required: false
:display: :hide
:data_type: :string
:owner_title:
    :description: Title
:required: false
:display: :hide
:data_type: :string
:owner_first_name:
    :description: First Name
:required: true
:display: :edit
:data_type: :string
:owner_manager:
    :description: Name
:required: false
:display: :edit
:data_type: :string
:owner_address:
    :description: Address
:required: false
:display: :hide
:data_type: :string
:owner_company:
    :description: Company
:required: false
:display: :hide
:data_type: :string
:owner_last_name:
    :description: Last Name
:required: true
:display: :edit
:data_type: :string
:owner_manager_mail:
    :description: E-Mail
:required: false
:display: :hide
:data_type: :string
:owner_city:
    :description: City
:required: false
:display: :hide
:data_type: :string
:owner_department:
    :description: Department
:required: false
:display: :hide
:data_type: :string
:owner_load_ldap:
    :pressed:
    :method: :retrieve_ldap
:description: Look Up LDAP Email
:required: false
:display: :show
:data_type: :button
:owner_manager_phone:
    :description: Phone
:required: false
:display: :hide
:data_type: :string
:owner_state:
    :description: State
:required: false
:display: :hide
:data_type: :string
:owner_office:
    :description: Office
:required: false
:display: :hide
:data_type: :string
:owner_zip:
    :description: Zip code
:required: false
:display: :hide
:data_type: :string
:owner_email:
    :description: E-Mail
:required: true
:display: :edit
:data_type: :string
:request_notes:
    :description: Notes
:required: false
:display: :edit
:data_type: :string
:display: :show
:field_order:
    :purpose:
    :description: Purpose
:fields:
    :vm_tags:
    :required_method: :validate_tags
:description: Tags
:required: false
:options:
    :include: []
:order: []
:single_select: []
:exclude: []
:display: :edit
:required_tags: []
:data_type: :integer
:display: :show
:field_order:
    :customize:
    :description: Customize
:fields:
    :dns_servers:
    :description: DNS Server list
:required: false
:display: :edit
:data_type: :string
:sysprep_organization:
    :description: Organization
:required_method: :validate_sysprep_field
:required: true
:display: :edit
:data_type: :string
:sysprep_password:
    :description: New Administrator Password
:required: false
:display: :edit
:data_type: :string
:sysprep_custom_spec:
    :values_from:
    :method: :allowed_customization_specs
:auto_select_single: false
:description: Name
:required: false
:display: :edit
:data_type: :string
:sysprep_server_license_mode:
    :values:
    perServer: Per server
perSeat: Per seat
:description: Identification
:required: false
:display: :edit
:default: perServer
:data_type: :string
:ldap_ous:
    :values_from:
    :method: :allowed_ous_tree
:auto_select_single: false
:description: LDAP Group
:required: false
:display: :edit
:data_type: :string
:sysprep_timezone:
    :values_from:
    :method: :get_timezones
:description: Timezone
:required_method: :validate_sysprep_field
:required: true
:display: :edit
:data_type: :string
:dns_suffixes:
    :description: DNS Suffix list
:required: false
:display: :edit
:data_type: :string
:sysprep_product_id:
    :description: ProductID
:required_method: :validate_sysprep_field
:required: true
:display: :edit
:data_type: :string
:sysprep_identification:
    :values:
    domain: Domain
workgroup: Workgroup
:description: Identification
:required: false
:display: :edit
:default: domain
:data_type: :string
:sysprep_per_server_max_connections:
    :description: Maximum Connections
:required: false
:display: :edit
:default: '5'
:data_type: :string
:sysprep_computer_name:
    :description: Computer Name
:required: false
:display: :edit
:data_type: :string
:sysprep_workgroup_name:
    :description: Workgroup Name
:required: false
:display: :edit
:default: WORKGROUP
:data_type: :string
:sysprep_spec_override:
    :values:
    false: 0
true: 1
:description: Override Specification Values
:required: false
:display: :edit
:default: false
:data_type: :boolean
:addr_mode:
    :values:
    static: Static
dhcp: DHCP
:description: Address Mode
:required: false
:display: :edit
:default: dhcp
:data_type: :string
:linux_host_name:
    :description: Computer Name
:required: false
:display: :edit
:data_type: :string
:sysprep_domain_admin:
    :description: Domain Admin
:required: false
:display: :edit
:data_type: :string
:sysprep_change_sid:
    :values:
    false: 0
true: 1
:description: Change SID
:required: false
:display: :edit
:default: true
:data_type: :boolean
:sysprep_domain_name:
    :values_from:
    :options:
    :active_proxy:
    :platform:
    :method: :allowed_domains
:auto_select_single: false
:description: Domain Name
:required: false
:display: :edit
:data_type: :string
:sysprep_upload_file:
    :description: Upload
:required: false
:display: :edit
:data_type: :string
:gateway:
    :description: Gateway
:required: false
:display: :edit
:data_type: :string
:ip_addr:
    :description: IP Address
:required: false
:notes: (Enter starting IP address)
:display: :edit
:data_type: :string
:notes_display: :hide
:linux_domain_name:
    :description: Domain Name
:required: false
:display: :edit
:data_type: :string
:sysprep_domain_password:
    :description: Domain Password
:required: false
:display: :edit
:data_type: :string
:sysprep_auto_logon:
    :values:
    false: 0
true: 1
:description: Auto Logon
:required: false
:display: :edit
:default: true
:data_type: :boolean
:sysprep_enabled:
    :values_from:
    :method: :allowed_customization
:description: Customize
:required: false
:display: :edit
:default: disabled
:data_type: :string
:sysprep_delete_accounts:
    :display_override: :hide
:values:
    false: 0
true: 1
:description: Delete Accounts
:required: false
:display: :hide
:default: false
:data_type: :boolean
:sysprep_upload_text:
    :description: Sysprep Text
:required_method: :validate_sysprep_upload
:required: true
:display: :edit
:data_type: :string
:wins_servers:
    :description: WINS Server list
:required: false
:display: :edit
:data_type: :string
:subnet_mask:
    :description: Subnet Mask
:required: false
:display: :edit
:data_type: :string
:sysprep_full_name:
    :description: Full Name
:required_method: :validate_sysprep_field
:required: true
:display: :edit
:data_type: :string
:sysprep_auto_logon_count:
    :values:
    1: '1'
2: '2'
3: '3'
:description: Auto Logon Count
:required: false
:display: :edit
:default: 1
:data_type: :integer
:customization_template_id:
    :values_from:
    :method: :allowed_customization_templates
:auto_select_single: false
:description: Script Name
:required: false
:display: :edit
:data_type: :integer
:root_password:
    :description: Root Password
:required: false
:display: :edit
:data_type: :string
:hostname:
    :description: Host Name
:required: false
:display: :edit
:data_type: :string
:customization_template_script:
    :description: Script Text
:required: false
:display: :edit
:data_type: :string
:display: :show
:environment:
    :description: Environment
:fields:
    :new_datastore_grow_increment:
    :description: Grow Increment (GB)
:required: false
:display: :hide
:data_type: :integer
:new_datastore_create:
    :values:
    false: 0
true: 1
:description: Create Datastore
:required: false
:display: :hide
:default: false
:data_type: :boolean
:placement_cluster_name:
    :values_from:
    :method: :allowed_clusters
:auto_select_single: false
:description: Name
:required: false
:display: :edit
:data_type: :integer
:new_datastore_aggregate:
    :values_from:
    :method: :allowed_datastore_aggregate
:description: Aggregate
:required: false
:display: :edit
:data_type: :string
:new_datastore_max_size:
    :description: Max Size (GB)
:required: false
:display: :hide
:data_type: :integer
:new_datastore_storage_controller:
    :values_from:
    :method: :allowed_datastore_storage_controller
:description: Controller
:required: false
:display: :edit
:data_type: :string
:cluster_filter:
    :values_from:
    :options:
    :category: :EmsCluster
:method: :allowed_filters
:auto_select_single: false
:description: Filter
:required: false
:display: :edit
:data_type: :integer
:host_filter:
    :values_from:
    :options:
    :category: :Host
:method: :allowed_filters
:auto_select_single: false
:description: Filter
:required: false
:display: :edit
:data_type: :integer
:ds_filter:
    :values_from:
    :options:
    :category: :Storage
:method: :allowed_filters
:auto_select_single: false
:description: Filter
:required: false
:display: :edit
:data_type: :integer
:new_datastore_volume:
    :values_from:
    :method: :allowed_datastore_aggregate
:description: Volume
:required: false
:display: :hide
:data_type: :string
:placement_host_name:
    :values_from:
    :method: :allowed_hosts
:auto_select_single: false
:description: Name
:required_method: :validate_placement
:required: true
:display: :edit
:data_type: :integer
:required_description: Host Name
:placement_ds_name:
    :values_from:
    :method: :allowed_storages
:auto_select_single: false
:description: Name
:required_method: :validate_placement
:required: true
:display: :edit
:data_type: :integer
:required_description: Datastore Name
:new_datastore_fs_type:
    :values:
    NFS: NFS
VMFS: VMFS
:description: FS Type
:required: false
:display: :hide
:default: NFS
:data_type: :string
:rp_filter:
    :values_from:
    :options:
    :category: :ResourcePool
:method: :allowed_filters
:auto_select_single: false
:description: Filter
:required: false
:display: :edit
:data_type: :integer
:new_datastore_thin_provision:
    :description: Thin Provision
:required: false
:display: :hide
:data_type: :string
:placement_auto:
    :values:
    false: 0
true: 1
:description: Choose Automatically
:required: false
:display: :edit
:default: false
:data_type: :boolean
:new_datastore_size:
    :description: Size (GB)
:required: false
:display: :hide
:data_type: :integer
:new_datastore_autogrow:
    :values:
    false: 0
true: 1
:description: Autogrow
:required: false
:display: :hide
:default: false
:data_type: :string
:placement_folder_name:
    :values_from:
    :method: :allowed_folders
:auto_select_single: false
:description: Name
:required: false
:display: :edit
:data_type: :integer
:new_datastore_name:
    :description: Name
:required: false
:display: :hide
:data_type: :string
:placement_rp_name:
    :values_from:
    :method: :allowed_respools
:auto_select_single: false
:description: Name
:required: false
:display: :edit
:data_type: :integer
:placement_dc_name:
    :values_from:
    :method: :allowed_datacenters
:auto_select_single: false
:description: Name
:required: false
:display: :edit
:data_type: :integer
:display: :show
:service:
    :description: Catalog
:fields:
    :number_of_vms:
    :values_from:
    :options:
    :max: 50
:method: :allowed_number_of_vms
:description: Count
:required: false
:display: :edit
:default: 1
:data_type: :integer
:vm_description:
    :description: VM Description
:required: false
:display: :edit
:data_type: :string
:min_length:
    :max_length: 100
:vm_prefix:
    :description: VM Name Prefix/Suffix
:required_method: :validate_vm_name
:required: false
:display: :hide
:data_type: :string
:src_vm_id:
    :values_from:
    :options:
    :tag_filters: []
:method: :allowed_templates
:description: Name
:required: true
:notes:
    :display: :edit
:data_type: :integer
:notes_display: :show
:vm_name:
    :description: VM Name
:required_method: :validate_vm_name
:required: true
:notes:
    :display: :edit
:data_type: :string
:notes_display: :show
:min_length:
    :max_length:
    :pxe_image_id:
    :values_from:
    :method: :allowed_images
:auto_select_single: false
:description: Image
:required: true
:required_method: :validate_pxe_image_id
:display: :edit
:data_type: :string
:pxe_server_id:
    :values_from:
    :method: :allowed_pxe_servers
:auto_select_single: false
:description: Server
:required: true
:required_method: :validate_pxe_server_id
:display: :edit
:data_type: :integer
:host_name:
    :description: Host Name
:required: false
:display: :hide
:data_type: :string
:provision_type:
    :values_from:
    :method: :allowed_provision_types
:description: Provision Type
:required: true
:display: :edit
:default: vmware
:data_type: :string
:linked_clone:
    :values:
    false: 0
true: 1
:description: Linked Clone
:required: false
:display: :edit
:default: false
:data_type: :boolean
:notes: VM requires a snapshot
:notes_display: :show
:snapshot:
    :values_from:
    :method: :allowed_snapshots
:description: Snapshot
:required: false
:display: :edit
:data_type: :string
:auto_select_single: false
:vm_filter:
    :values_from:
    :options:
    :category: :Vm
:method: :allowed_filters
:description: Filter
:required: false
:display: :edit
:data_type: :integer
:display: :show
:schedule:
    :description: Schedule
:fields:
    :schedule_type:
    :values:
    schedule: Schedule
immediately: Immediately on Approval
:description: When to Provision
:required: false
:display: :edit
:default: immediately
:data_type: :string
:vm_auto_start:
    :values:
    false: 0
true: 1
:description: Power on virtual machines after creation
:required: false
:display: :edit
:default: true
:data_type: :boolean
:schedule_time:
    :values_from:
    :options:
    :offset: 1.day
:method: :default_schedule_time
:description: Provision on
:required: false
:display: :edit
:data_type: :time
:retirement:
    :values:
    0: Indefinite
1.month: 1 Month
3.months: 3 Months
6.months: 6 Months
:description: Time until Retirement
:required: false
:display: :edit
:default: 0
:data_type: :integer
:retirement_warn:
    :values_from:
    :options:
    :values:
    1.week: 1 Week
2.weeks: 2 Weeks
30.days: 30 Days
:include_equals: false
:field: :retirement
:method: :values_less_then
:description: Retirement Warning
:required: true
:display: :edit
:default: 1.week
:data_type: :integer
:display: :show
:vdi:
    :description: Desktop
:fields:
    :vdi_new_desktop_pool_name:
    :description: Name
:required: false
:display: :hide
:data_type: :string
:vdi_farm:
    :values_from:
    :method: :allowed_vdi_farms
:description: Farm
:required: false
:display: :hide
:data_type: :string
:vdi_new_desktop_pool_assignment:
    :values_from:
    :method: :allowed_vdi_desktop_pool_assignments
:description: Desktop Pools Assignment
:required: false
:display: :hide
:data_type: :string
:vdi_desktop_pool_create:
    :values:
    false: 0
true: 1
:description: Create Desktop Pool
:required: false
:display: :hide
:default: false
:data_type: :boolean
:vdi_desktop_pool:
    :values_from:
    :method: :allowed_vdi_desktop_pools
:description: Desktop Pools
:required: false
:display: :hide
:data_type: :string
:vdi_enabled:
    :values:
    false: 0
true: 1
:description: Enabled
:required: false
:display: :edit
:default: false
:data_type: :boolean
:vdi_desktop_pool_user_list:
    :description: User List
:required: true
:required_method: :validate_vdi_user_list
:display: :hide
:data_type: :string
:display: :hide
:network:
    :description: Network
:fields:
    :vlan:
    :values_from:
    :options:
    :dvs: true
:vlans: true
:method: :allowed_vlans
:description: vLan
:required: true
:display: :edit
:data_type: :string
:mac_address:
    :description: MAC Address
:required: false
:display: :hide
:data_type: :string
:display: :show
:hardware:
    :description: Hardware
:fields:
    :disk_format:
    :values:
    thick: Thick
thin: Thin
unchanged: Default
:description: Disk Format
:required: false
:display: :edit
:default: unchanged
:data_type: :string
:cpu_limit:
    :description: CPU (MHz)
:required: false
:notes: (-1 = Unlimited)
:display: :edit
:data_type: :integer
:notes_display: :show
:memory_limit:
    :description: Memory (MB)
:required: false
:notes: (-1 = Unlimited)
:display: :edit
:data_type: :integer
:notes_display: :show
:number_of_sockets:
    :values:
    1: '1'
2: '2'
4: '4'
8: '8'
:description: Number of Sockets
:required: false
:display: :edit
:default: 1
:data_type: :integer
:cores_per_socket:
    :values:
    1: '1'
2: '2'
4: '4'
8: '8'
:description: Cores per Socket
:required: false
:display: :edit
:default: 1
:data_type: :integer
:cpu_reserve:
    :description: CPU (MHz)
:required: false
:display: :edit
:data_type: :integer
:vm_memory:
    :values:
    '2048': '2048'
'4096': '4096'
'1024': '1024'
:description: Memory (MB)
:required: false
:display: :edit
:default: '1024'
:data_type: :string
:memory_reserve:
    :description: Memory (MB)
:required: false
:display: :edit
:data_type: :integer
:network_adapters:
    :values:
    1: '1'
2: '2'
3: '3'
4: '4'
:description: Network Adapters
:required: false
:display: :hide
:default: 1
:data_type: :integer
:display: :show
:dialog_order:
    - :requester
- :purpose
- :service
- :environment
- :vdi
- :hardware
- :network
- :customize
- :schedule
