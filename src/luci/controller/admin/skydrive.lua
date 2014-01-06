
module("luci.controller.admin.skydrive", package.seeall)

function index()
	entry({"admin", "skydrive"},template("admin_xcloud/skydrive"))
	--entry({"admin", "skydrive","skydrivecode"},call("skydrivecode"),nil)
end

function skydrivecode()
	require "luci.http"
	require "luci.sys"
	require "io"

	local code = luci.http.formvalue('code')
	local fh = io.open('/etc/config/skydrive','w+')
	fh:write(code)
	fh:close()
	-- 执行PHP命令
	--local result = luci.sys.call('sh /opt/php/test.sh')
	--local result = luci.sys.exec('/opt/bin/php-cli /opt/php/getaccess.php >/opt/php/test.txt')
	local result = luci.sys.exec('php-cli /opt/php/getaccess.php')
	local o ={}
	o['result'] = result

	--local result = luci.sys.exec('echo "testsdfgsdfsdf">/opt/php/test.txt')
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end