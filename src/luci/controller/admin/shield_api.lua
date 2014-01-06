module("luci.controller.admin.shield_api", package.seeall)

function index()
	entry({"admin", "shield"},template("admin_web/shield_index"))
	--entry({"admin", "shield"},template("admin_web/mainindex"))

	entry({"admin", "shield", "info"}, template("admin_web/info"), nil)
	entry({"admin", "shield", "devices_list"}, template("admin_web/device_list"), nil)

	entry({"admin", "shield" , "settings"}, template("admin_web/index"), nil)
	entry({"admin", "shield" , "settings","lan"}, template("admin_web/lan"), nil)
	entry({"admin", "shield" , "settings", "channel"}, template("admin_web/channel"), nil)
	entry({"admin", "shield" , "settings", "dhcp"}, template("admin_web/dhcp"), nil)
	entry({"admin", "shield" , "settings", "l2tp"}, template("admin_web/l2tp"), nil)
	entry({"admin", "shield" , "settings", "mac"}, template("admin_web/mac"), nil)
	entry({"admin", "shield" , "settings", "mac_filter"}, template("admin_web/mac_filter"), nil)
	entry({"admin", "shield" , "settings", "mtu"}, template("admin_web/mtu"), nil)
	entry({"admin", "shield" , "settings", "ppp_adv"}, template("admin_web/ppp_adv"), nil)
	entry({"admin", "shield" , "settings", "systime"}, template("admin_web/systime"), nil)
	entry({"admin", "shield" , "settings", "upnp"}, template("admin_web/upnp"), nil)
	entry({"admin", "shield" , "settings", "update_manger"}, template("admin_web/update_manger"), nil)
	entry({"admin", "shield" , "settings", "reset"}, template("admin_web/reset"), nil)
	entry({"admin", "shield" , "settings", "diagnose"}, template("admin_web/diagnose"), nil)

	entry({"admin", "shield" , "modify_password"}, template("admin_web/modify_password"), nil)
	entry({"admin", "shield" , "net_detect"}, template("admin_web/net_detect"), nil)
	entry({"admin", "shield" , "network"}, template("admin_web/network"), nil)
	entry({"admin", "shield" , "set_wifi"}, template("admin_web/set_wifi"), nil)
	entry({"admin", "shield" , "web_status"}, template("admin_web/web_status"), nil)

	entry({"admin", "shield" , "lansetup1"}, call("lansetup1"),nil)
	entry({"admin", "shield","get_lan_info"}, call("send_lan_info"))
	entry({"admin", "shield","lansetup_ip"}, call("lansetup_ip"))
	entry({"admin", "shield","set_systime"}, call("set_systime"))
	entry({"admin", "shield","wansetup"},call("wansetup"))
	entry({"admin", "shield","set_sys_password"},call("set_sys_password"))
	entry({"admin", "shield","modify_password"},template("admin_web/modify_password"))
	entry({"admin", "shield", "logout"}, call("action_logout"), _("Logout"), 90)
	entry({"admin", "shield", "reboot"}, call("action_reboot"), _("reboot"), 90)

	entry({"admin", "shield", "wifiinfo"}, call("wifiStatus"))

	entry({"admin", "shield", "usbinfo"},call('usbopt'),nil)
	entry({"admin", "shield", "usbtimer"},call('usbtimer'),nil)
	entry({"admin", "shield", "usbadd"},call('usbadd'),nil)
	entry({"admin", "shield", "usbremove"},call('usbremove'),nil)
	entry({"admin", "shield", "usbaddmain"},call('usbaddmain'),nil)
	entry({"admin", "shield", "usbremovemain"},call('usbremovemain'),nil)

	entry({"admin", "shield", "fileview"}, call("file_view"),nil)
	entry({"admin", "shield", "fileview", "fileviewlist"}, call("fileviewlist"),nil)
	entry({"admin", "shield", "fileview", "downloadfile"}, call("downloadfile"),nil)
	entry({"admin", "shield", "fileview", "lanipaddrcheck"}, call("landownloadcheck"),nil)

	entry({"admin", "shield", "wifiinfo", "get_channel"}, call("get_channel"),nil)
	entry({"admin", "shield", "wifiinfo", "get_txpwr"}, call("get_txpwr"),nil)
	--entry({"admin", "shield", "wifiinfo", "get_channel"}, call("get_channel"),nil)
	entry({"admin", "shield", "wiresetup"},call("wiresetup"),nil)
	entry({"admin", "shield", "get_wifi_networks"}, call("get_wifi_networks"), nil)
	entry({"admin", "shield", "iface_status"}, call("iface_status"), nil)
	entry({"admin", "shield", "network_connection_status"}, call("network_connection_status"), nil)
	entry({"admin", "shield", "internet_connection_status"}, call("internet_connection_status"), nil)
	entry({"admin", "shield", "flashops"}, call("action_flashops"), _("Backup / Flash Firmware"), 70)
	entry({"admin", "shield", "get_wifi_list"}, call("get_wifi_list"), _("get_wifi_list"), nil)
	entry({"admin", "shield", "get_bridge"}, call("get_bridge"), _("get_bridge"), nil)
end

function get_channel()
	require "luci.fs"
	require "luci.tools.status"

	local has_wifi = luci.fs.stat("/etc/config/wireless")
	      has_wifi = has_wifi and has_wifi.size > 0

	local wifinets

	if has_wifi then
		wifinets   = luci.tools.status.wifi_networks()
	else
		wifinets = {}
	end
	local o = {}
	o["code"] = 0
	o["channel"] = wifinets[1].networks[1].channel
	luci.http.prepare_content("application/json")
	luci.http.write_json(o)
end

function get_txpwr()
	require "luci.fs"
	require "luci.tools.status"

	local has_wifi = luci.fs.stat("/etc/config/wireless")
	      has_wifi = has_wifi and has_wifi.size > 0

	local wifinets

	if has_wifi then
		wifinets   = luci.tools.status.wifi_networks()
	else
		wifinets = {}
	end
	local o = {}
	o["code"] = 0
	o["txpower"] = wifinets[1].networks[1].txpower
	luci.http.prepare_content("application/json")
	luci.http.write_json(o)
end

function Split(szFullString, szSeparator)  
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}
	while true do  
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
	   if not nFindLastIndex then  
	    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
	    break  
	   end  
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	   nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end

function action_logout()
	local dsp = require "luci.dispatcher"
	local sauth = require "luci.sauth"
	if dsp.context.authsession then
		sauth.kill(dsp.context.authsession)
		dsp.context.urltoken.stok = nil
	end

	luci.http.header("Set-Cookie", "sysauth=; path=" .. dsp.build_url())
	luci.http.redirect(luci.dispatcher.build_url())
end

function action_reboot()
	require "luci.http"
	local o = {}
	o['code'] = 0
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
	luci.sys.reboot()
end

function send_lan_info()
	local uci = require "luci.model.uci".cursor()
	local mac = uci.get('network','lan','macaddr')
	local ipaddr = uci.get('network','lan','ipaddr')
	local netmask = uci.get('network','lan','netmask')
	local o={}
	o['ipv4'] = ipaddr
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function lansetup_ip()
	require "luci.http"
	local uci = require "luci.model.uci".cursor()
	local ipaddr 	= luci.http.formvalue('ip')
	local o_ipaddr 	= uci.get('network','lan','ipaddr')

	if ipaddr ~= o_ipaddr then
		luci.sys.exec('uci set network.lan.ipaddr='..ipaddr)
		luci.sys.exec('uci commit')
		luci.sys.exec('/usr/local/localshell/updatehostip '..ipaddr)
		luci.sys.exec('reboot')
	end

	local o = {}
	o['result'] = o_ipaddr
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function set_systime()
	require "luci.http"
	require "luci.sys"
	local data_ = luci.http.formvalue("date")
	local pattern = "(%d+)-(%d+)-(%d+)"
	year_,month_,day_ = data_:match(pattern)
	local h_ = tonumber(luci.http.formvalue("h"))
	local m_ = tonumber(luci.http.formvalue("mi"))
	local s_ = tonumber(luci.http.formvalue("s"))
	if data_ ~= nil then
		local date = os.date("*t",  os.time{year=year_,month=month_,day=day_,hour=h_,min=m_,sec=s_})
		if date then
			luci.sys.call("date -s '%04d-%02d-%02d %02d:%02d:%02d'" %{
				date.year, date.month, date.day, date.hour, date.min, date.sec
			})
		end
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({ timestring = os.date("%c"),code=0})
end

function wifiStatus()
	local uci = require "luci.model.uci".cursor()
	local ntm = require "luci.model.network"
	ntm.init(uci)

	local devices  = ntm:get_wifidevs()
	local devs
	local netlist = {}
	for _, dev in ipairs(devices) do local nets = dev:get_wifinets()
		local nets = dev:get_wifinets()
		for _, net in ipairs(nets) do
			netlist[#netlist+1] = net:id()
		end
	end

	local netmd = require "luci.model.network".init()
	local net = netmd:get_wifinet(netlist[1])
	local dev = net:get_device()

	local result = nil
	if dev and net then
		result = net:get("disabled")
	end

	local o = {}
	if result then
		o['test'] = "close"
	else
		o['test'] = "open"
	end

	luci.http.prepare_content('application/json')
	luci.http.write_json(o)
end

function wansetup()

	local h = require "luci.http"
	local uci = require "luci.model.uci".cursor()

	local type = h.formvalue("network_type")
	if type == "ip" then
		type = h.formvalue("ip_type")
	end	
	
	local o = {}

	local network_tb = uci:get_all("network","wan")

	for k,v in pairs (network_tb) do
		if k ~= '.name' and k ~= 'ifname' and k ~= '.anonymous' then
			luci.sys.exec('uci del network.wan.'..k)
		end
	end

	if type == "dhcp" then
		luci.sys.exec('uci set network.wan.proto=dhcp')
	elseif type == "pppoe" then
		local name 	 = 	h.formvalue("pppoe_name")
		local passwd = 	h.formvalue("pppoe_passwd")
		luci.sys.exec('uci set network.wan.proto=pppoe')
		luci.sys.exec('uci set network.wan.username='..name)
		luci.sys.exec('uci set network.wan.password='..passwd)
	elseif type == "static" then
		local ip = h.formvalue("static_ip")
		local netmask = h.formvalue("static_mask")
		local gateway = h.formvalue("static_gw")
		local dns = h.formvalue("static_dns")

		luci.sys.exec('uci set network.wan.proto=static')
		luci.sys.exec('uci set network.wan.ipaddr='..ip)
		luci.sys.exec('uci set network.wan.netmask='..netmask)
		luci.sys.exec('uci set network.wan.gateway='..gateway)
		luci.sys.exec('uci set network.wan.dns='..dns)
	end

	luci.sys.exec('uci commit')
	luci.sys.exec('/etc/init.d/network restart')

	o['code'] = '0'
	
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function set_sys_password()
	local h = require "luci.http"
	local v0 = h.formvalue("old_password")
	local v1 = h.formvalue("password")
	local v2 = h.formvalue("password2")
	local o = {}

	if not luci.sys.user.checkpasswd(luci.dispatcher.context.authuser, v0) then
		 o["code"]=1
		 o["msg"]="wrong password"
	elseif v1 and v2 and #v1 > 0 and #v2 > 0 then
		if v1 == v2 then
			if luci.sys.user.setpasswd(luci.dispatcher.context.authuser, v1) == 0 then
				o["code"]=0
				o["msg"]= "Password successfully changed!"
			else
				o["code"]=1
			end
		else
			o["code"] = 2
			o["msg"]= "Given password confirmation did not match, password not changed!"
		end
	end
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function usbremovemain()
	require 'luci.http'

	local device=luci.http.formvalue('dev')

	local res=luci.sys.exec('/usr/local/localshell/usb-mount remove '..device)
	local len=string.len(res)

	local o = {}
	o['result'] = len
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function usbaddmain()
	require 'luci.http'
	require 'luci.sys'

	local res1=luci.sys.exec('/usr/local/localshell/usbdevice')
	local len=0
	--如果有挂载分区 就删除上一个分区
	local tmp=Split(res1,"/////")
	if tmp[3] ~= 'NULL' then
		luci.sys.exec('/usr/local/localshell/usb-mount remove '..tmp[3])
	end

	local device=luci.http.formvalue('dev')

	local res=luci.sys.exec('/usr/local/localshell/usb-mount add '..device)
	len=string.len(res)

	local o = {}
	o['result'] = len
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function usbadd()
	require 'luci.sys'
	require 'luci.http'

	luci.sys.exec('/usr/local/localshell/usb-mount add')

	local n = {}

	luci.http.prepare_content("application/json")
    luci.http.write_json(n)
end

function usbremove()
	require 'luci.sys'
	require 'luci.http'

	local n = {}

	luci.sys.exec('/usr/local/localshell/usb-mount remove')

	luci.http.prepare_content("application/json")
    luci.http.write_json(n)
end

function usbopt()
	require 'luci.template'
	require 'luci.sys'

	local content = luci.sys.exec('/usr/local/localshell/usbdevice')
	local o = Split(content,'/////')


	luci.template.render("admin_web/usbopt",{dev_name=o[1],status=string.len(content)},nil)
end

function usbtimer()
	require 'luci.template'
	require 'luci.sys'
	require 'luci.http'

	local content = luci.sys.exec('/usr/local/localshell/usbdevice')
	local n = {}

	if content ~= "" then
		local o = Split(content,'////')
		n['optname'] = o[1]
		n['status'] = string.sub(o[2],1,string.len(o[2])-1)
	else
		n['optname'] = ""
	end

	luci.http.prepare_content("application/json")
    luci.http.write_json(n)
end

function file_view()
	require "luci.template"
	require 'luci.sys'
	require 'luci.http'

	local files = ""
	local filesName = ""
	local status = ""

	local content = luci.sys.exec('/usr/local/localshell/usbdevice')

	if content ~= "" then
	
		local o = Split(content,'/////')

		if "NULL" ~= o[3] then
			status = 'Mounted'
			filesName = o[1]

			files = luci.sys.exec('/usr/local/localshell/usbdir BASE')
			local fileall ={}
			fileall = Split(files,"||||")
			table.remove(fileall)
			files = fileall
		end
	end

	luci.template.render("admin_web/fileview",{filecontent=files,flag=status,filename=filesName},nil)
end

function fileviewlist()
	require "luci.template"
	require "luci.http"
	require "luci.sys"

	local path = luci.http.formvalue("path")
	local files = ""

	if path == "" then
		files = luci.sys.exec('/usr/local/localshell/usbdir BASE')
	else
		files = luci.sys.exec('/usr/local/localshell/usbdir DIR '..path)
	end

	local fileall ={}
	fileall = Split(files,"||||")
	table.remove(fileall)
	files = fileall	

	luci.template.render("admin_web/fileviewlist",{filecontent=files})
end

function wiresetup()
	local h = require "luci.http"
	local wire_status 	= h.formvalue("w_status")
	local wire_ssid		= h.formvalue("w_ssid")
	local wire_type		= h.formvalue("w_type")
	local wire_pwd		= h.formvalue("w_pwd")
	local wire_code_type= h.formvalue("w_code_t")
	local wire_code 	= h.formvalue("w_code")

	local o = {}

	if wire_status == "open" then
		luci.sys.exec('uci del wireless.@wifi-iface[0].disabled')
		--luci.sys.exec('uci set wireless.@wifi-iface[0].disabled=0')
		--luci.sys.exec('wifi up')
		--luci.sys.exec('gpioctl dirout 72')
		--luci.sys.exec('/etc/init.d/wifi.sh start')
	else
		luci.sys.exec('uci set wireless.@wifi-iface[0].disabled=1')
		--luci.sys.exec('wifi down')
		--luci.sys.exec('gpioctl dirin 72')
		--luci.sys.exec('/etc/init.d/wifi.sh stop')
	end

	if wire_ssid ~= "" then
		luci.sys.exec('uci set wireless.@wifi-iface[0].ssid='..wire_ssid)
	end

	if wire_code_type ~= "none" then
		luci.sys.exec('uci set wireless.@wifi-iface[0].encryption='..wire_code_type)
		luci.sys.exec('uci set wireless.@wifi-iface[0].key='..wire_code)
	else
		luci.sys.exec('uci set wireless.@wifi-iface[0].encryption='..wire_code_type)
		luci.sys.exec('uci del wireless.@wifi-iface[0].key')
	end
  
	luci.sys.exec('uci commit')
	luci.sys.exec('/etc/init.d/network restart')

	if wire_status == "open" then
		luci.sys.exec('wifi up')
		luci.sys.exec('gpioctl dirout 72')
	else
		luci.sys.exec('wifi down')
		luci.sys.exec('gpioctl dirin 72')
		luci.sys.exec('uci set wireless.@wifi-iface[0].disabled=1')
	end 
	luci.sys.exec('uci commit')

	o['result'] = "success"
	
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function get_wifi_networks()
	require "luci.fs"
	require "luci.tools.status"

	local has_wifi = luci.fs.stat("/etc/config/wireless")
	      has_wifi = has_wifi and has_wifi.size > 0

	local wifinets

	if has_wifi then
		wifinets   = luci.tools.status.wifi_networks()
	else
		wifinets = {}
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(wifinets)
end


function iface_status()
	local ifaces = luci.http.formvalue("ifaces")

	local netm = require "luci.model.network".init()
	local rv   = { }

	local iface
	for iface in ifaces:gmatch("[%w%.%-_]+") do
		local net = netm:get_network(iface)
		local device = net and net:get_interface()
		if device then
			local data = {
				id         = iface,
				proto      = net:proto(),
				uptime     = net:uptime(),
				gwaddr     = net:gwaddr(),
				dnsaddrs   = net:dnsaddrs(),
				name       = device:shortname(),
				type       = device:type(),
				ifname     = device:name(),
				macaddr    = device:mac(),
				is_up      = device:is_up(),
				rx_bytes   = device:rx_bytes(),
				tx_bytes   = device:tx_bytes(),
				rx_packets = device:rx_packets(),
				tx_packets = device:tx_packets(),

				ipaddrs    = { },
				ip6addrs   = { },
				subdevices = { }
			}

			local _, a
			for _, a in ipairs(device:ipaddrs()) do
				data.ipaddrs[#data.ipaddrs+1] = {
					addr      = a:host():string(),
					netmask   = a:mask():string(),
					prefix    = a:prefix()
				}
			end
			for _, a in ipairs(device:ip6addrs()) do
				if not a:is6linklocal() then
					data.ip6addrs[#data.ip6addrs+1] = {
						addr      = a:host():string(),
						netmask   = a:mask():string(),
						prefix    = a:prefix()
					}
				end
			end

			for _, device in ipairs(net:get_interfaces() or {}) do
				data.subdevices[#data.subdevices+1] = {
					name       = device:shortname(),
					type       = device:type(),
					ifname     = device:name(),
					macaddr    = device:mac(),
					macaddr    = device:mac(),
					is_up      = device:is_up(),
					rx_bytes   = device:rx_bytes(),
					tx_bytes   = device:tx_bytes(),
					rx_packets = device:rx_packets(),
					tx_packets = device:tx_packets(),
				}
			end

			rv[#rv+1] = data
		else
			rv[#rv+1] = {
				id   = iface,
				name = iface,
				type = "ethernet"
			}
		end
	end

	if #rv > 0 then
		luci.http.prepare_content("application/json")
		luci.http.write_json(rv)
		return
	end

	luci.http.status(404, "No such device")
end

function get_wifi_devices()
	local uci = require("luci.model.uci").cursor()
	local ntm = require "luci.model.network".init(uci)

	local devices  = ntm:get_wifidevs()
	local devs
	local netlist = {}
	for _, dev in ipairs(devices) do local nets = dev:get_wifinets()
		local nets = dev:get_wifinets()
		for _, net in ipairs(nets) do
			netlist[#netlist+1] = net:id()
		end
	end

	local netmd = require "luci.model.network".init()
	local net = netmd:get_wifinet(netlist[1])
	local dev = net:get_device()

	local result = nil
	if dev and net then
		result = net:get("disabled")
	end

	local o = {}
	if result then
		o['status'] = "close"
	else
		o['status'] = "open"
	end

	o['device'] = dev.sid

	luci.http.prepare_content("application/json")
	luci.http.write_json(o)
end

function get_interface_status(connection_type, rv)
	local iface
	local netm = require "luci.model.network".init()

	for iface in connection_type:gmatch("[%w%.%-_]+") do
		local net = netm:get_network(iface)
		local device = net and net:get_interface()
		if device then
			local data = {
				id         = iface,
				type       = device:type(),
				ifname     = device:name(),
				subdevices = { },
				isconn     = #device:ipaddrs() > 0 or #device:ip6addrs() > 0
			}

			for _, device in ipairs(net:get_interfaces() or {}) do
				data.subdevices[#data.subdevices+1] = {
					name       = device:shortname(),
					type       = device:type(),
					ifname     = device:name(),
				}
			end

			rv[#rv+1] = data
		else
			rv[#rv+1] = {
				id   = iface,
				name = iface,
				type = "ethernet"
			}
		end
	end
end

function network_connection_status()
	local s = require "luci.tools.status"

	local rvs = {}
	local ret_data = {
						wifi_status = false,
						isconn_lan1 = false,
						isconn      = false,
						devices_cnt = s.dhcp_leases(),
						devices = {}
					}

	get_interface_status("lan", rvs)
	get_interface_status("wan", rvs)

	ret_data.devices = rvs

	if #rvs == 0 then
		luci.http.status(404, "No such device")
		return
	end

	for _, rv in ipairs(rvs) do
		local id = rv.id

		if id == "wan" then
			ret_data.isconn = rv.isconn
		end

		if id == "lan" then
			for _,sub in ipairs(rv.subdevices) do
				if string.find(sub.ifname, "wlan") ~= nil then
					ret_data.wifi_status = true
				end

				if string.find(sub.type, "wifi") ~= nil then
					ret_data.wifi_status = true
				end

				if string.find(sub.ifname, "eth") ~= nil then
					ret_data.isconn_lan1 = true
				end
			end
		end
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(ret_data)
end

function internet_connection_status()
	local ret = {}
	get_interface_status("wan", ret)

	if #ret == 0 then
		luci.http.status(404, "No such device")
		return
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(ret[0])
end


function action_flashops()
	local sys = require "luci.sys"
	local fs  = require "luci.fs"

	local restore_cmd = "tar -xzC/ >/dev/null 2>&1"
	local backup_cmd  = "sysupgrade --create-backup - 2>/dev/null"
	local image_tmp   = "/tmp/firmware.img"

	if luci.http.formvalue("backup") then
		--
		-- Assemble file list, generate backup
		--
		local reader = ltn12_popen(backup_cmd)
		luci.http.header('Content-Disposition', 'attachment; filename="backup-%s-%s.tar.gz"' % {
			luci.sys.hostname(), os.date("%Y-%m-%d")})
		luci.http.prepare_content("application/x-targz")
		luci.ltn12.pump.all(reader, luci.http.write)
	elseif luci.http.formvalue("restore") then
		--
		-- Unpack received .tar.gz
		--
		local upload = luci.http.formvalue("archive")
		if upload and #upload > 0 then
			--uncompress the archive files

			--luci.template.render("admin_system/applyreboot")
			luci.sys.reboot()
		end
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json({rsp = 0})
end

function get_wifi_list()
	require 'luci.template' 
	require 'luci.sys'
	require 'io'

	function Split(szFullString, szSeparator)  
		local nFindStartIndex = 1  
		local nSplitIndex = 1  
		local nSplitArray = {}
		while true do  
		   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
		   if not nFindLastIndex then  
		    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
		    break  
		   end  
		   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		   nSplitIndex = nSplitIndex + 1  
		end  
		return nSplitArray  
	end

	-- 先执行连接 创建文件
	luci.sys.exec('/usr/local/localshell/wds scan')

	local f=io.open('/tmp/wds_scan_result.txt','r')

	local num=0
	local tmp={}
	local tmp1={}
	local tmp2={}

	function formatstr(str)
		local i=string.gsub(str,"(%s%s+)","//////")
		local tmp=Split(i,"//////")

		if tmp[2] ~= nil then
			return tmp
		end
		
		return false
	end

	local data = {}

	for i in f:lines() do
		num = num + 1
		if num > 2 then
			tmp=formatstr(i)
			if type(tmp) == 'table' then
				tmp1 = {}
				if tonumber(tmp[5]) == nil then
					tmp2 = {}
					tmp2 = Split(tmp[4]," ")
					tmp[4] = tmp2[1]
					tmp[5] = tmp2[2]
				end

				table.insert(tmp1,tmp[1])
				table.insert(tmp1,tmp[2])
				table.insert(tmp1,tmp[3])
				table.insert(tmp1,tmp[4])
				table.insert(tmp1,tmp[5])

				table.insert(data,tmp1)
			end
		end
	end

	f:close()

	local ret_data = { data = data, code = #data > 0 }
	luci.http.prepare_content("application/json")
	luci.http.write_json(ret_data)
end


function get_bridge()
	require "luci.sys"
	luci.sys.exec('/usr/local/localshell/wds stat')
	local uci = require "luci.model.uci".cursor()

	local stat = uci.get('wireless','wds','stat') or ''
	
	local ssid,bssid=''
	local chanel = '11'
	local encryp = 'none'
	local status = 0

	if tostring(stat) ==  '1' then
		ssid = uci.get('wireless','wds','ssid') or ''
		bssid= uci.get('wireless','wds','bssid') or ''

		chanel= uci.get('wireless','wds','channel') or 11
		encryp= uci.get('wireless','wds','encryptype') or 'none'

		status = 1
	end

	local ret_data ={step  = '0',
					 ssid   = ssid,
					 bssid  = bssid,
					 singal = '',
					 channel = chanel,
					 encryption = encryp,
					 status = status
					}

	luci.http.prepare_content("application/json")
	luci.http.write_json(ret_data)
end