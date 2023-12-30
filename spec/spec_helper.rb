require 'zabbixapi'

MIN_ROLE_VERSION = Gem::Version.new('5.2')
APPLICATION_REMOVED_VERSION = Gem::Version.new('5.4')
VALUEMAP_HOSTID_REQUIRED_VERSION = Gem::Version.new('5.4')

def zbx
  # settings
  @api_url = ENV['ZABBIX_HOST_URL'] || 'http://localhost:8080/api_jsonrpc.php'
  @api_login = ENV['ZABBIX_USERNAME'] || 'Admin'
  @api_password = ENV['ZABBIX_PASSWORD'] || 'zabbix'

  @zbx ||= ZabbixApi.connect(
    url: @api_url,
    user: @api_login,
    password: @api_password,
    debug: ENV['ZABBIX_DEBUG'] ? true : false
  )
end

def gen_id
  rand(1_000_000_000)
end

def gen_name(prefix)
  suffix = rand(1_000_000_000)
  "#{prefix}_#{suffix}"
end
