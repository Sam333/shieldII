
module("luci.controller.admin.xcloud", package.seeall) 

function index()
	entry({"admin", "xcloud"},template("admin_xcloud/xcloud"))

	entry({"admin","xcloud","showimg"},call("showimg"),nil)
	entry({"admin","xcloud","appsbanner"},call("appsbanner"),nil)
	entry({"admin","xcloud","mask"},call("mask"),nil)

	entry({"admin", "xcloud", "xcloudstatus"},template("admin_xcloud/xcloudstatus"))

	entry({"admin", "xcloud","firmware"},template("admin_xcloud/firmware"),nil)
	entry({"admin", "xcloud","firmware","upload"},call("uploadfirmware"),nil)
	entry({"admin", "xcloud","firmware","uploading"},call("uploading"),nil)

	entry({"admin", "xcloud", "wifi"},call("wifisetup"),nil)	
	entry({"admin", "xcloud", "setupreturn"},template("admin_xcloud/setup"),nil)	
	entry({"admin", "xcloud", "wifinfo"},template("admin_xcloud/wireless"),nil)
	
	entry({"admin", "xcloud", "usbinfo"},call('usbopt'),nil)
	entry({"admin", "xcloud", "usbinfo", "usbtimer"},call('usbtimer'),nil)
	entry({"admin", "xcloud", "usbinfo", "usbadd"},call('usbadd'),nil)
	entry({"admin", "xcloud", "usbinfo", "usbremove"},call('usbremove'),nil)
	entry({"admin", "xcloud", "usbinfo", "usbaddmain"},call('usbaddmain'),nil)
	entry({"admin", "xcloud", "usbinfo", "usbremovemain"},call('usbremovemain'),nil)
	
	entry({"admin", "xcloud", "wdsopt"},call('wdsopt'),nil)
	entry({"admin", "xcloud", "wdslist"},call('wdslist'),nil)
	entry({"admin", "xcloud", "wdsstart"},call('wdsstart'),nil)
	entry({"admin", "xcloud", "wdsturns"},call('wdsturns'),nil)
	entry({"admin", "xcloud", "wdstop"},call('wdstop'),nil)

	entry({"admin", "xcloud", "lan"},template("admin_xcloud/lansetup"),nil)
	entry({"admin", "xcloud", "appsetup"},template("admin_xcloud/appsetup"),nil)
	entry({"admin", "xcloud", "appsetupselect"},call('appselect'),nil)
	entry({"admin", "xcloud", "appsetup", "appupload"},call("appupload"),nil)
	entry({"admin", "xcloud", "appsetup", "startinstall"},call("appstartinstall"),nil)
	entry({"admin", "xcloud", "appsetup", "appuninstall"},call("appuninstall"),nil)

	entry({"admin", "xcloud", "app_xcloud"},template("admin_xcloud/app_xcloud"))

	entry({"admin", "xcloud", "fastsetup"},template("admin_xcloud/fast_setup"))	

	entry({"admin", "xcloud", "fileview"}, call("file_view"),nil)
	entry({"admin", "xcloud", "fileview", "fileviewlist"}, call("fileviewlist"),nil)
	entry({"admin", "xcloud", "fileview", "downloadfile"}, call("downloadfile"),nil)
	entry({"admin", "xcloud", "fileview", "lanipaddrcheck"}, call("landownloadcheck"),nil)

	entry({"admin", "xcloud", "lansetup1"}, call("lansetup1"),nil)
	entry({"admin", "xcloud", "lansetupselect"}, call("lanselect"),nil)

	entry({"admin", "xcloud", "lansetup2dhcp"}, call("landhcp"),nil)

	entry({"admin", "xcloud", "lanipaddrsetup"}, call("lansetup"),nil)

	entry({"admin", "xcloud", "wifisafe"},call("wifiSafe"),nil)
	entry({"admin", "xcloud", "testSocket"},call("testSocket"),nil)
	entry({"admin", "xcloud", "loginout"},call("loginout"),nil)
	entry({"admin", "xcloud", "loginin"},call("loginin"),nil)
	entry({"admin", "xcloud", "wantypechange"},call("wanchange"),nil)
	entry({"admin", "xcloud", "wiresetup"},call("wiresetup"),nil)
	entry({"admin", "xcloud", "orderTest"},call("orderTests"),nil)

	entry({"admin", "xcloud", "pluginssetup"},call("pluginssetup"),nil)

	------------------------通用插件
	entry({"admin", "xcloud", "jqscripts"},call("jqscripts"),nil)
	entry({"admin", "xcloud", "jsscripts"},call("jsscripts"),nil)
	entry({"admin", "xcloud", "comcss"},call("comcss"),nil)
	entry({"admin", "xcloud", "comimg"},call("comimg"),nil)
	entry({"admin", "xcloud", "comskip"},call("comskip"),nil)
	entry({"admin", "xcloud", "comreturn"},alias("admin", "xcloud"),nil)
	entry({"admin", "xcloud", "comcmd"},call("comcmd"),nil)
	entry({"admin", "xcloud", "baidupan"},call("baidupan"),nil)

	----------------------插件 * arias
	entry({"admin", "xcloud", "arias"},call("arias"),nil)
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

function comskip()
	require "luci.http"

	local path = luci.http.formvalue('page')
	local file = nixio.fs.readfile(path)
	luci.http.write(file)
end

function comcmd()
	require  "luci.http"

	local vars = luci.http.formvalue()
	local command = ""
	local comm_para = " "

	for k,v in pairs(vars) do
		if k ~= 'cmd' then
			comm_para = comm_para .. v .. " "
		else
			command = v
		end
	end

	local data = luci.sys.exec(command..comm_para)

	local o = {}
	o['result'] = 'success'
	o['resdata'] = data or 'success'

	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function arias()
	require "luci.http"
	require "luci.sys"

	local flag = luci.http.formvalue('flag')
	local o = {}
	if flag == 'init' then
		local data = luci.sys.exec('/opt/app/aria2/script/confshell current')
		o['total'] = data
	elseif flag == 'default' then
		luci.sys.exec('/opt/app/aria2/script/confshell load')
		o['result'] = 'success'
	elseif flag == 'save' then
		local dirname = luci.http.formvalue('d_dir')
		local downnum = luci.http.formvalue('d_num')
		local upspeed = luci.http.formvalue('uspeed')
		local downspeed = luci.http.formvalue('dspeed')

		luci.sys.exec('/opt/app/aria2/script/setconf '..dirname..' '..downnum..' '..upspeed..' '..downspeed)
		o['result'] = 'success'
	elseif flag == 'checkstatus' then
		local res=luci.sys.exec('/opt/app/aria2/script/confshell state')
		local tmpword = string.len(res)

		if tmpword == 3 then
			o['result'] = 'failed'
		else
			o['result'] = 'success'
		end
	elseif flag == 'stopserve' then
		local res=luci.sys.exec('/opt/app/aria2/appshell stop')

		o['result'] = 'success'
	end

	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function baidupan()
	require "luci.http"
	require "luci.sys"

	local flag = luci.http.formvalue('flag')
	local path = ""
	local o = {}

	if flag == 'sync' then
		local file = ""
		
		path = "/opt/app/baidu_pan/html/sync.htm"
		file = nixio.fs.readfile(path)
		luci.http.prepare_content("text/html")
		luci.http.write(file)
	elseif flag == 'home' then
		local file = ""
		
		path = "/opt/app/baidu_pan/html/home.htm"
		file = nixio.fs.readfile(path)
		luci.http.prepare_content("text/html")
		luci.http.write(file)
	elseif flag == 'access' then
		local code = luci.http.formvalue('code')
		local res = ""

		if code ~= "" then
			-- 执行accesstoken生成命令
			res = luci.sys.exec("/opt/app/baidu_pan/bin/getaccess.sh "..code)
			res = string.sub(res,1,string.len(res)-1)

			if res == '0' then
				o['result'] = 'success'
			end
		else
			res = luci.sys.exec("/opt/app/baidu_pan/bin/check_token.sh")
			res = string.sub(res,1,string.len(res)-1)

			if res == '0' then
				o['result'] = 'success'
			else
				o['result'] = 'failed'
			end
		end
		luci.http.prepare_content("application/json")
    	luci.http.write_json(o)
	elseif flag == 'logout' then
		path = "/opt/app/baidu_pan/html/index.htm"
	
		luci.http.prepare_content("text/html")
		file = nixio.fs.readfile(path)
		luci.http.write(file)
	elseif flag =='upload' then
		local uploaddata = luci.http.formvalue('dir')
		local t = Split(uploaddata,"////")
		
		table.remove(t)
		local str = ""
		for _,v in pairs(t) do
			luci.sys.exec('/opt/app/baidu_pan/bin/xcloudpan.sh ./xcloud_pan \"cmd=\'upload\';remotedir=\'\';localdir=\''..v..'\'\"')
		end

		local returnstr = luci.sys.exec('/opt/app/baidu_pan/bin/getuploadfiles')

		luci.sys.exec('/opt/app/baidu_pan/bin/clearuploadfiles')
		o['result'] = returnstr
		luci.http.prepare_content("application/json")
    	luci.http.write_json(o)
	elseif flag == 'download' then
		luci.sys.exec('/opt/app/baidu_pan/bin/xcloudpan.sh ./xcloud_pan \"cmd=\'down\';remotedir=\'xcloud\';localdir=\'\'\"')
		o['result'] = 'success'
		luci.http.prepare_content("application/json")
    	luci.http.write_json(o)
	end
end

function comimg()
	require "luci.http"

	local getpath = luci.http.formvalue('path')
	local path = "/www/luci-static/bootstrap/"..getpath

	local file = nixio.fs.readfile(path)
	luci.http.write(file)
end

function comcss()
	require "luci.http"

	local getpath = luci.http.formvalue('path')
	local path = "/opt/app/"..getpath

	local file = nixio.fs.readfile(path)
	luci.http.write(file)
end

function jsscripts()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"

	local path = "/www/luci-static/resources/xcloud.js"

	local file = nixio.fs.readfile(path)
	luci.http.write(file)	
end

function jqscripts()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"

	local path = "/www/luci-static/resources/jquery-1.8.2.min.js"

	local file = nixio.fs.readfile(path)
	luci.http.write(file)
end

function pluginssetup()
	require "luci.http"

	local sys = require "luci.sys"
	local fs  = require "luci.fs"	

	local path = luci.http.formvalue('path')

	path = string.sub(path,1,string.len(path)-1)

	path = path .. '/html/index.htm'

	luci.http.header("Accept-Ranges","bytes")
	luci.http.header("Content-type","text/html; charset=UTF-8")

	local file = nixio.fs.readfile(path)
	luci.http.prepare_content('text/html')

	luci.http.write(file)
end

function mask()
	require "luci.http"
	require "luci.template"
	
	local word = luci.http.formvalue('str')

	luci.template.render('admin_xcloud/mask',{content=word})
end

function optshowimg(id)
	require "luci.sys"
	local appsetup = luci.sys.exec('/usr/local/app/ReadInstallPlugin NEED ID IntallPath')

	local applength = string.len(appsetup)

	local appsetupdata = {}
	
	if applength ~= 3 then
		appsetupdata = Split(appsetup,"////")
	
		local tmp = {}
		local tmpimg
		for i,v in pairs (appsetupdata) do
			tmp = Split(v,",")

			if id == tmp[1] then
				tmpimg = string.sub(tmp[2],1,string.len(tmp[2])-1)
				return tmpimg
			end	
		end
	end

	return ''
end

function showimg()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"		

	local id = luci.http.formvalue('id')
    local path = optshowimg(id)

	local flag = luci.http.formvalue('small') or ''

	if (flag ~= "") then
		path = path ..  '/icon/small.png'
	else
		path = path ..  '/icon/large.jpg'
	end

	local name = fs.basename(path)
	local size = nixio.fs.stat(path).size

	luci.http.header("Accept-Ranges","bytes")
	luci.http.header("Content-type","application/octet-stream")
	luci.http.header("Content-Length",size)
	luci.http.header("Content-Disposition","attachment;filename='"..name.."';")

	local file = nixio.fs.readfile(path)
	luci.http.write(file)
end

function appstartinstall()
	require "luci.sys"
	require "luci.http"

	local flag = luci.http.formvalue('type')
	local res = ""
	local path = ""

	if flag == '1' then
		path = luci.http.formvalue('dir') or ''
		res = luci.sys.exec("/usr/local/app/xipk update ".. path)
	elseif flag == '2' then
		path = '/opt/plugins.ipkg'
		res = luci.sys.exec("/usr/local/app/xipk install ".. path)
	end 

	local o = {}
	o['result'] = res
	luci.http.write_json(o)
	--luci.sys.exec("mtd -r write /tmp/firmware.img firmware")
end

function appuninstall()
	require "luci.sys"
	require "luci.http"

	local unid = luci.http.formvalue('uid')
	local res = ""

	res = luci.sys.exec("/usr/local/app/xipk uninstall "..unid)

	local o = {}
	o['result'] = res
	--o['result'] = unid
	luci.http.prepare_content("application/json")
	luci.http.write_json(o)
end

function appupload()
	local sys = require "luci.sys"
	local fs  = require "luci.fs"

	local image_tmp   = "/opt/plugins.ipkg"

	local fp
	luci.http.setfilehandler(
		function(meta, chunk, eof)
			if not fp then
				if meta and meta.name == "installplug" then
					fp = io.open(image_tmp, "w")
				else
					fp = io.popen(restore_cmd, "w")
				end
			end
			if chunk then
				fp:write(chunk)
			end
			if eof then
				fp:close()
			end
		end
	)

	if luci.http.formvalue("installplug") then
		nixio.fs.stat(image_tmp)
	end

	luci.http.write("success")
end

function appselect()
	require "luci.http"
	require "luci.template"
	local flag = luci.http.formvalue('choose')

	if flag == 'install' then
		luci.template.render('admin_xcloud/appsetuppart1')
	else
		luci.template.render('admin_xcloud/appsetuppart2')
	end
end

function lansetup()
	require "luci.http"
	local uci = require "luci.model.uci".cursor()
	local data = luci.http.formvalue('data')
	local o = {}

	o = Split(data,"|||")
	table.remove(o)

	uci:delete_all('dhcp','host')

	local n = {}
	for _,v in pairs(o) do
		n = Split(v,"||")

		uci:section('dhcp','host',nil,{
				name 	=n[1],
				mac 	=n[2],
				ip 		=n[3]
			})
	end
	uci:save('dhcp')
	uci:commit('dhcp')

	luci.sys.exec('/etc/init.d/network restart')

	local a = {}
	a['result'] = 'success'
	luci.http.prepare_content("application/json")
    luci.http.write_json(a)
end

function landhcp()
	require "luci.http"
	require "luci.sys"
	local uci = require "luci.model.uci".cursor()
	local flag = luci.http.formvalue('flag')
	local o = {}

	if flag == 'stop' then
		luci.sys.exec('uci del dhcp.lan.start')
		luci.sys.exec('uci del dhcp.lan.limit')
		luci.sys.exec('uci del dhcp.lan.leasetime')

		luci.sys.exec("uci set dhcp.lan.ignore='1'")
	else
		luci.sys.exec("uci set dhcp.lan.start='100'")
		luci.sys.exec("uci set dhcp.lan.limit='150'")
		luci.sys.exec("uci set dhcp.lan.leasetime='12h'")	
		
		luci.sys.exec('uci del dhcp.lan.ignore')
	end

	--luci.sys.exec('uci commit')
	--luci.sys.exec('/etc/init.d/network restart')

	local args = 'network,wireless,firewall,dhcp'
	local service
	local services = { }

	for service in args:gmatch("[%w_-]+") do
		services[#services+1] = service
	end

	local command = uci:apply(services, true)	
	nixio.exec("/bin/sh", unpack(command))

	o['result'] = 'success'
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function lanselect()
	require "luci.http"
	require "luci.template"
	local flag = luci.http.formvalue('select')

	if flag == 'static' then
		luci.template.render('admin_xcloud/lansetuppart1')
	else
		luci.template.render('admin_xcloud/lansetuppart2')
	end
end

function lansetup1()
	require "luci.http"
	local uci = require "luci.model.uci".cursor()

	local ipaddr 	= luci.http.formvalue('ipaddr')
	local netmask 	= luci.http.formvalue('net')


	local o_ipaddr 	= uci.get('network','lan','ipaddr')
	local o_netmask = uci.get('network','lan','netmask')

--[[
	local o = {}
	o['result'] = o_ipaddr
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
]]
	if ipaddr ~= o_ipaddr or netmask ~= o_netmask then
		luci.sys.exec('uci set network.lan.ipaddr='..ipaddr)
		luci.sys.exec('uci set network.lan.netmask='..netmask)

		luci.sys.exec('uci commit')
		luci.sys.exec('/usr/local/localshell/updatehostip '..ipaddr)
		luci.sys.exec('reboot')
	end

	local o = {}
	o['result'] = o_ipaddr
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function uploading()
	require "luci.sys"

	luci.sys.exec("mtd -r write /tmp/firmware.img firmware")
end

function uploadfirmware()
	local sys = require "luci.sys"
	local fs  = require "luci.fs"

	local upgrade_avail = nixio.fs.access("/lib/upgrade/platform.sh")
	local reset_avail   = os.execute([[grep '"rootfs_data"' /proc/mtd >/dev/null 2>&1]]) == 0

	local restore_cmd = "tar -xzC/ >/dev/null 2>&1"
	local backup_cmd  = "sysupgrade --create-backup - 2>/dev/null"
	local image_tmp   = "/tmp/firmware.img"

	local function image_supported()
		-- XXX: yay...
		return ( 0 == os.execute(
			". /lib/functions.sh; " ..
			"include /lib/upgrade; " ..
			"platform_check_image %q >/dev/null"
				% image_tmp
		) )
	end

		local function image_checksum()
		return (luci.sys.exec("md5sum %q" % image_tmp):match("^([^%s]+)"))
	end

	local function storage_size()
		local size = 0
		if nixio.fs.access("/proc/mtd") then
			for l in io.lines("/proc/mtd") do
				local d, s, e, n = l:match('^([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+"([^%s]+)"')
				if n == "linux" or n == "firmware" then
					size = tonumber(s, 16)
					break
				end
			end
		elseif nixio.fs.access("/proc/partitions") then
			for l in io.lines("/proc/partitions") do
				local x, y, b, n = l:match('^%s*(%d+)%s+(%d+)%s+([^%s]+)%s+([^%s]+)')
				if b and n and not n:match('[0-9]') then
					size = tonumber(b) * 1024
					break
				end
			end
		end
		return size
	end

	local fp
	luci.http.setfilehandler(
		function(meta, chunk, eof)
			if not fp then
				if meta and meta.name == "image" then
					fp = io.open(image_tmp, "w")
				else
					fp = io.popen(restore_cmd, "w")
				end
			end
			if chunk then
				fp:write(chunk)
			end
			if eof then
				fp:close()
			end
		end
	)

	if luci.http.formvalue("image") then
		if image_supported() then
			image_checksum()
			storage_size()
			nixio.fs.stat(image_tmp)
		end
	end
	
	luci.http.write("success")
end

function wifisetup()
	require "luci.template"

	luci.template.render("admin_xcloud/wansetup")
end

function DelS(s)
        assert(type(s)=="string")
        return s:match("^%s+(.-)%s+$")
end

function wdstop()
	require 'luci.http'
	require 'luci.sys'

	luci.sys.exec('/usr/local/localshell/wds stop')

	local o = {}
	o['result'] = 'success'
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function wdsturns()
	require 'luci.http'
	require 'luci.template'
	local flag = luci.http.formvalue('type')

	if tostring(flag) == 'start' then
		luci.template.render('admin_xcloud/wdson')
	else
		luci.template.render('admin_xcloud/wdsoff')
	end
end

function wdsstart()
	require 'luci.http'
	require 'luci.sys'

	local ssid 	=luci.http.formvalue('ss') or ''
	local bssid	=luci.http.formvalue('bs') or ''
	local chanel=luci.http.formvalue('ch') or ''
	local auth	=luci.http.formvalue('au') or ''
	local entry	=luci.http.formvalue('en') or ''
	local code  =luci.http.formvalue('code') or ''

	luci.sys.exec('/usr/local/localshell/wds start '..ssid..' '..bssid..' '..chanel..' '..auth..' '..entry..' '..code)
	luci.sys.exec('sleep 1')
	luci.sys.exec('/usr/local/localshell/wds stat')

	local uci = require "luci.model.uci".cursor()
	local flag = uci.get('wireless','wds','stat') or '0'

	local o = {}
	o['result'] = flag

	luci.http.prepare_content("application/json")
    luci.http.write_json(o)	
end

function wdslist()
	require 'luci.template'

	luci.template.render("admin_xcloud/wdslist")
end

function wdsopt()
	require 'luci.http'
	require 'luci.template'

	local step = luci.http.formvalue('type') or '0'
	local data ={}
	if step == '1' then
		data['step']  = step
		data['ssid']  = luci.http.formvalue('ss') or ''
		data['bssid'] = luci.http.formvalue('bs') or ''
		data['singal']= luci.http.formvalue('si') or ''
		data['chanel']= luci.http.formvalue('ch') or ''
		data['encypt']= luci.http.formvalue('en') or ''
	end

	luci.template.render("admin_xcloud/wdsopt",{datas=data})
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


	luci.template.render("admin_xcloud/usbopt",{dev_name=o[1],status=string.len(content)},nil)
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

	luci.template.render("admin_xcloud/fileview",{filecontent=files,flag=status,filename=filesName},nil)
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

	luci.template.render("admin_xcloud/fileviewlist",{filecontent=files})
end

function landownloadcheck()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"

	local path = luci.http.formvalue('npath') or ""
	local rootpath = luci.sys.exec('/usr/local/localshell/usbdir ROOTER')
	rootpath = string.sub(rootpath,1,string.len(rootpath)-1)	
	path = rootpath.."/"..path
	local name = fs.basename(path)
	local size = nixio.fs.stat(path).size

	local o ={}
	if size <= 5242880 then
		o['result'] = "yes"
	else
		o['result'] = "no"
	end
	
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function downloadfile()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"

	local path = luci.http.formvalue('npath') or ""
	local rootpath = luci.sys.exec('/usr/local/localshell/usbdir ROOTER')
	rootpath = string.sub(rootpath,1,string.len(rootpath)-1)	
	path = rootpath.."/"..path
	local name = fs.basename(path)
	local size = nixio.fs.stat(path).size

	if size <= 5242880 then
		luci.http.header("Accept-Ranges","bytes")
		luci.http.header("Content-type","application/octet-stream")
		luci.http.header("Content-Length",size)
		luci.http.header("Content-Disposition","attachment;filename='"..name.."';")

		local file = nixio.fs.readfile(path)
		luci.http.write(file)
	else
		luci.http.write("文件过大，请用SAMBA下载")
	end
--[[
	local o = {}

	o['result'] = "success"
	
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)	]]
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

function wanchange()
	local h = require "luci.http"
	local uci = require "luci.model.uci".cursor()
	local type = h.formvalue("type")
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
		local name 	 = 	h.formvalue("name")
		local passwd = 	h.formvalue("pwd")

		luci.sys.exec('uci set network.wan.proto=pppoe')
		luci.sys.exec('uci set network.wan.username='..name)
		luci.sys.exec('uci set network.wan.password='..passwd)
	elseif type == "static" then
		local ip = h.formvalue("ipads")
		local netmask = h.formvalue("netmask")
		local gateway = h.formvalue("gateway")
		local dns = h.formvalue("dns")

		luci.sys.exec('uci set network.wan.proto=static')
		luci.sys.exec('uci set network.wan.ipaddr='..ip)
		luci.sys.exec('uci set network.wan.netmask='..netmask)
		luci.sys.exec('uci set network.wan.gateway='..gateway)
		luci.sys.exec('uci set network.wan.dns='..dns)
	end

	luci.sys.exec('uci commit')
	luci.sys.exec('/etc/init.d/network restart')

	o['result'] = 'success'
	
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function orderTests()
	local h = require "luci.http"
	local o = {}
	--luci.sys.exec('uci set network.wan.proto=dhcp')
	luci.sys.exec('uci set network.wan.proto=pppoe')
	luci.sys.exec('uci set network.wan.username=myk1')
	luci.sys.exec('uci set network.wan.password=12311')
	luci.sys.exec('uci commit')
	luci.sys.exec('/etc/init.d/network restart')

	o['test'] = "1231312"
	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function loginin()
	local h = require "luci.http"
	local c = require "luci.socket"

	local uname  = h.formvalue("uname")
	local passwd = h.formvalue("passwd")

	local result = c.send('loginin',uname,passwd)

	local r = Split(result,"||")
	local res = ""

	if r[3] == "0" then
		res = "success"
	else
		res = "failed"
	end

	local o = {}
	o['loginstatus'] = res

	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function loginout()
	local h = require "luci.http"
	local c = require "luci.socket"

	local uname = h.formvalue("uname")
	local result = c.send('loginout',uname)

	local r = Split(result,"||")
	local res = ""

	if r[3] == "0" then
		res = "success"
	else
		res = "failed"
	end

	local o = {}
	o['logoutstatus'] = res

	luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function testSocket()
	local h = require "luci.http"
    local c = require "luci.socket"
    
    -- 和获取登录状态
	local result = c.send('getStatus')

	local r = Split(result,"||")

	local res = ""
	local username = ""

	if r[3] == "1" then
		res = "nologing"
	else
		res = "hasloging"
		username = r[4]
	end 

    local o = {}
    o['result'] = r[3]
    o['username'] = username

    luci.http.prepare_content("application/json")
    luci.http.write_json(o)
end

function wifiSafe()
    local o = {}
    o['test'] = "asdasdad"

    luci.http.prepare_content("application/json")
    luci.http.write_json(o)
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

function appsbanner()
	require "luci.template"

	luci.template.render("admin_xcloud/appsbanner")
end