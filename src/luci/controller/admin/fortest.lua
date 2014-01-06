
module("luci.controller.admin.fortest", package.seeall)

function index()
	entry({"admin","fortest"},call("txtxt"),nil)

	entry({"admin","fortest","download"},call("download"),nil)

	entry({"admin","fortest","uploadtest"},call('upload_test'),nil)

	entry({"admin","fortest","routertest"},call('router_test'),nil)

	entry({"admin","fortest","dhcptest"},template('admin_fortest/fortest1'),nil)

	entry({"admin","fortest","showimg"},call("showimg"),nil)

	entry({"admin","fortest","showhtml"},call("showhtml"),nil)

	entry({"admin","fortest","ntest"},call("ntest"),nil)	

	entry({"admin","fortest","test1"},call("test1"),nil)

	entry({"admin","fortest","image"},call("img"),nil)

	entry({"admin","fortest","txtxt"},call("txtxt"),nil)

	--entry({"admin","fortest","skydrive"},template('admin_xcloud/skydrive'),nil)
end

function txtxt()
	require "luci.http"
	require "luci.template"

	local o = luci.http.formvaluetable();
	luci.template.render('admin_fortest/fortest2',{content=o})
end

function img()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"		

	--local path = "/opt/app/helloworld006/icon/"..luci.http.formvalue('flag');
	local path = luci.http.formvalue('img');

	local name = fs.basename(path)
	local size = nixio.fs.stat(path).size

	luci.http.header("Accept-Ranges","bytes")
	luci.http.header("Content-type","application/octet-stream")
	luci.http.header("Content-Length",size)
	luci.http.header("Content-Disposition","attachment;filename='"..name.."';")

	local file = nixio.fs.readfile(path)
	luci.http.write(file)
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

function test1()
	--[[
	require "luci.http"
	require "luci.sys"
	local res=luci.sys.exec("echo huaqiangge")

	local o = {}
	o['result'] = res

	luci.http.write_json(o)]]
	--[[
	require 'io'
	local f=io.open('/usr/lib/lua/luci/controller/admin/test.txt','w')
	f:write('asdas')
	f:close()
	return
	]]

	--require "luci.http"
	--local uci = require "luci.model.uci".cursor()
	
	--require "luci.template"
	--require "luci.sys"
--[[
	luci.sys.exec('/usr/local/localshell/wds scan')
	require "io"
	local f=io.open('/tmp/wds_scan_result.txt','r')
	
	local line = ''
	local num=0
	local datas={}

	for i in f:lines() do
		num = num+1
		if num > 2 then
			table.insert(datas,i)
		end
	end
	f:close()]]

	luci.template.render('admin_fortest/fortest2')
	--luci.sys.exec('/etc/init.d/network restart')
end

function ntest()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"		

	--local path = "/opt/app/helloworld006/icon/"..luci.http.formvalue('flag');
	local path = "/www/luci-static/resources/jquery-1.8.2.min.js";

	local name = fs.basename(path)
	local size = nixio.fs.stat(path).size

	luci.http.header("Accept-Ranges","bytes")
	luci.http.header("Content-type","application/octet-stream")
	luci.http.header("Content-Length",size)
	luci.http.header("Content-Disposition","attachment;filename='"..name.."';")

	local file = nixio.fs.readfile(path)
	luci.http.write(file)
end

function showhtml()
	require "luci.http"

	local sys = require "luci.sys"
	local fs  = require "luci.fs"		

	local path = "/opt/app/helloworld006/html/index.htm";
	
	--local name = fs.basename(path)
	--local size = nixio.fs.stat(path).size

	luci.http.header("Accept-Ranges","bytes")
	luci.http.header("Content-type","text/html; charset=UTF-8")

	local file = nixio.fs.readfile(path)
	luci.http.prepare_content('text/html')

	luci.http.write(file)
end

function showimg()
	require "luci.http"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"		

	local path = "/opt/app/helloworld006/icon/large.jpg";
	
	local name = fs.basename(path)
	local size = nixio.fs.stat(path).size

	luci.http.header("Accept-Ranges","bytes")
	luci.http.header("Content-type","application/octet-stream")
	luci.http.header("Content-Length",size)
	luci.http.header("Content-Disposition","attachment;filename='"..name.."';")

	local file = nixio.fs.readfile(path)
	luci.http.write(file)
end

function download()
	require "luci.http"
	require "io"
	require "luci.template"
	local sys = require "luci.sys"
	local fs  = require "luci.fs"
	--local image_tmp = "/www/test.conf"
	local image_tmp = "/www/test.bin"

	local name = fs.basename(image_tmp)

	--luci.http.header("Pargma","public")
	--luci.http.header("Expires","0")
	--luci.http.header("Cache-Control","private")
	luci.http.header("Accept-Ranges","bytes")
	luci.http.header("Content-type","application/force-download")
	--luci.http.header("Content-Transfer-Encoding","binary")
	luci.http.header("Content-Length",nixio.fs.stat(image_tmp).size)
	luci.http.header("Content-Disposition","attachment;filename='"..name.."';")

	--io.output(image_tmp)
	local file = nixio.fs.readfile(image_tmp)

	--luci.template.render("admin_fortest/fortest2",{o=file},nil)
	luci.http.write(file)
end

function upload_test()
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
end

function router_test()
	require("luci.sys")

	local arptable = luci.sys.net.arptable() or {}
	--local s = require "luci.tools.status"
	--[[
		获取文件跟路径

		/usr/lib/fortest/usbdir.sh BASE

		指定打开文件路径 以/区分文件夹 文件
		/usr/lib/fortest/usbdir.sh DIR sda4/xcloud/
	]]

	--require "luci.sys"

	--local result = luci.sys.exec("/usr/lib/fortest/usbdir.sh BASE")

	luci.template.render("admin_fortest/fortest",{word=arptable},nil)
end
