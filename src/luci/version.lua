local pcall, dofile, _G = pcall, dofile, _G

module "luci.version"

if pcall(dofile, "/etc/openwrt_release") and _G.DISTRIB_DESCRIPTION then
	distname    = ""
	distversion = _G.DISTRIB_DESCRIPTION
	xcloud_update = _G.DISTRIB_UPDATE
	xcloud_show	= _G.DISTRIB_SHOW
else
	distname    = "OpenWrt Firmware"
	distversion = "Attitude Adjustment (unknown)"
	xcloud_update = "Xcloud update (unknown)"
	xcloud_show	= "xcloud version (unknown)"
end

luciname    = "LuCI 0.11.1 Release"
luciversion = "0.11.1"
