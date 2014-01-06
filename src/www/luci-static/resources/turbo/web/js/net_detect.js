
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=device-width, initial-scale=0.7,  minimum-scale=0.5, maximum-scale=2.0"/>
<title>路由器网络诊断</title>
<style type="text/css">
body, h1, h2, ul, li, table{margin: 0; padding: 0;}
body{  text-align: center; font-family: Verdana, Arial, Sans-Serif; color: #333;}
.box{ width: 90%; margin: 80px auto; text-align: left;}
h1{ font-size: 30px; margin-bottom: 10px; border-bottom: 1px solid #ddd; padding-bottom: 15px; color: #006DD9;}
h1 a{ font-size: 12px; font-weight: normal;}
h2{ font-size: 16px; margin: 15px 0;font-weight: bold;}
.err{color:red}
#detect #goback{font-size:14px;font-weight: bold;margin-top:20px}
.result_box{}
p span {color:#008ec7;}
a {
	color: #36AAD6;
	text-decoration: none;
}

.continue_a {
	height: 36px;
	line-height: 36px;
	border: none;
	background: #0099D2;
	font-size: 14px;
	font-family: Microsoft Yahei;
	font-weight: 700;
	color: #fff;
	padding: 5px 10px;
	cursor: pointer;
}
#pppoe_box{display: none}
table{width:450px}
table .title{width:220px;}
</style>
<script type="text/javascript" src="/turbo-static/turbo/web/js/jquery-1.8.1.min.js?v=1003"></script>
</head>
<body>
	<div class="box">
	    <h1><b id="h1_title">无法连接互联网 </b> &nbsp;&nbsp; <input type="button" id="detect" value="重新诊断"> <input type="button" id="goback" onclick="window.open('http://4006024680.com');" value="路由器后台"></h1>
	    <h2>诊断结果：</h2>
		<div id="fixed_box" style="line-height: 25px;">
		等待结果...		
		</div>	
		
		<div id="url_box_main" style="display:none;">
			<br>
			<h2>来源页：</h2>
			<div id="url_box_url"></div>
			<div id="url_box_info">
				<p>IP: <span id="website_ip_url" class="website_err"></span>
				<br>PING: <span id="website_ping_url" class="website_err"></span>
				<br>HTTP: <span id="website_http_url" class="website_err"></span></p>
			</div>
		</div>
		<br/>
		
		<h2>检测以下状态：</h2>
		<div class="result_box">
			<table cellpadding="0" cellspacing="0" >
				
				<tr>
					<td class="title">路由器WAN口设置类型</td>
					<td><p><span id="uciwantype"></span></p></td>
				</tr>
				<tr id="pppoe_box">
					<td class="title">PPPoE 诊断信息</td>
					<td>
						<p><b id="pppoe_info_msg">诊断中...</b></p>
						<p><div id="remote_message_box" style="color:red;height:auto;"></div></p>
					</td>
				</tr>
				<tr>
					<td class="title">路由器 DNS</td>
					<td><p><span id="dns"></span></p></td>
				</tr>
			</table>
		</div>
		<br/><br/>
		<h2>路由器尝试连接以下网站：</h2>
		<div class="result_box">
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td class="title">百度 (www.baidu.com)</td>
					<td width="*">
						<p>PING: <span id="website_ping_baidu" class="website_err"></span>
						<br>HTTP: <span id="website_http_baidu" class="website_err"></span></p>
					</td>
				</tr>
				<tr>
					<td class="title">腾讯 (www.qq.com)</td>
					<td>
						<p>PING: <span id="website_ping_qq" class="website_err"></span>
						<br>HTTP: <span id="website_http_qq" class="website_err"></span></p>
					</td>
				</tr>
				<tr>
					<td class="title">应用中心 (app.hiwifi.com)</td>
					<td>
						<p>PING: <span id="website_ping_hiwifi_app" class="website_err"></span>
						<br>HTTP: <span id="website_http_hiwifi_app" class="website_err"></span></p>
					</td>
				</tr>
			</table>
		</div>
		
	</div>

	<script type="text/javascript">
	var back_url = '';
	if(back_url.indexOf('://')==-1){
		back_url = "http://"+back_url;
	}
	
	if(back_url!="" && back_url!="http://"){
		do_detect_url(back_url);
	}

	var timer1;
	var net_setup_url = '进行 <a href="/cgi-bin/turbo/;stok=17bbd66c326e9cb77a563fc87d8a4137/admin_web?act=set_network" target="_blank">网络设置</a>';
	var msg_result_wait = '正在诊断互联网连接问题，等待结果...';
	var net_detect_result = new Array();
	var is_eth_link_s = new Array(); 
	is_eth_link_s[1] = "已连接";
	is_eth_link_s[0] = "<span class='err'>未连接</span>";
	
	var uciwantype_s = new Array(); 
	uciwantype_s['pppoe'] = "PPPoE";
	uciwantype_s['dhcp'] = "DHCP";
	uciwantype_s['static'] = "静态IP";
	uciwantype_s['wisp'] = "无线中继";
	
	var autowantype_s = new Array(); 
	autowantype_s[1] = "PPPoE";
	autowantype_s[2] = "DHCP";
	autowantype_s[3] = "静态IP";
	autowantype_s[99] = "<span class='err'>未插网线</span>";
	autowantype_s[100] = "未插网线 (无线中继 无需连接)";
	
	$(function(){
		$("#detect").click(function(){
			window.location.reload();
		});
		do_detect();
		
	});
	
	function do_detect(){
		$("p span").html("诊断中...");
		$("#fixed_box").html(msg_result_wait);
		$("#pppoe_box").hide();
		$("#remote_message_box").html("");
		
		var request_date = {}; 
		
		request_date = {'dnotcheckwan':1}; 
		
		$.getJSON("/cgi-bin/turbo/;stok=17bbd66c326e9cb77a563fc87d8a4137/api/network/net_detect",request_date,function(rsp) 
		{ 
			//$("p span").html("");
			do_detect_show(rsp.is_eth_link,rsp.uciwantype,rsp.autowantype,rsp.dns);
			//do_detect_fixed(rsp.is_eth_link,rsp.uciwantype,rsp.autowantype);
			
		})
	}
	
	function do_detect_url(url){
		$("#url_box_main").show();
		$("#url_box_url").html("<a target='_blank' href='"+url+"'>"+url+"</a> <a target='_blank' class='continue_a' href='"+url+"'>继续访问</a>");
	
		var request_date = {'url':url}; 
		$.getJSON("/cgi-bin/turbo/;stok=17bbd66c326e9cb77a563fc87d8a4137/api/network/net_detect_byurl",request_date,function(rsp) 
		{ 
			if(rsp.ping){
				$("#website_ping_url").html("成功。 ");
			}else{
				$("#website_ping_url").html("<span class='err'>失败</a>");
			}
			if(rsp.http){
				$("#website_http_url").html("成功。 ");
			}else{
				$("#website_http_url").html("<span class='err'>失败</a>");
			}
			$("#website_ip_url").html(rsp.ip);
		})
	}
	
	function do_detect_show(is_eth_link,uciwantype,autowantype,dns){
		//$("#is_eth_link").html(is_eth_link_s[is_eth_link]);
		$("#uciwantype").html(uciwantype_s[uciwantype]);
		$("#autowantype").html(autowantype_s[autowantype]);
		
		if(uciwantype == "pppoe"){
			if(is_eth_link==1){
				if (autowantype) {
					if(uciwantype_s[uciwantype]!=autowantype_s[autowantype]){
						fixed_info_msg("可能宽带接入商设备故障，无法提供PPPoE拨号服务。或者上网类型设置错误! "+net_setup_url)	
					}
				}
				check_pppoe_status();				
			}else{
				fixed_info_msg("请检查WAN网线，ADSL设备或者宽带接入商设备不正常也会造成WAN口未连接。"+net_setup_url)
			}
		}else{
			if(is_eth_link==1){
				check_website();				
			}else{
				fixed_info_msg("请检查WAN网线，上联设备不正常也会造成WAN口未连接。"+net_setup_url)
			}
		}
		if(dns.length > 0){
			$("#dns").html("");
			for(var i=0;i<dns.length;i++){
				$("#dns").append(dns[i]+"<br>");
			}
		} else {
			$("#dns").css("color","red").html("无");
		}
		if(is_eth_link==0){
			$(".website_err").html("网络不通无法诊断");
		}
		
	}
	
	function fixed_info_msg(msg_new){
		var msg = $("#fixed_box").html();
		if(msg==msg_result_wait){
			msg = '';
		}
		if(msg!=""){
			msg +='<br/>';
		}
		$("#fixed_box").html(msg+msg_new);
	}
	function pppoe_info_msg(msg,is_error,is_loading_icon){
		if (is_error && is_error == 1){
			$("#pppoe_info_msg").css("color","red");
		} else {
			$("#pppoe_info_msg").css("color","#000000");
			$("#remote_message_box").hide();
		}
		if (is_loading_icon && is_loading_icon == 1){
			//msg = msg + ' <img src="/turbo-static/turbo/web/js/artDialog/skins/icons/loading.gif" /> ';
		}
		$("#pppoe_info_msg").html(msg);
	}
	
	function check_pppoe_status(){
		$("#pppoe_box").show();
		$("#remote_message_box").hide();
		$(".website_err").html("PPPoE拨号成功后诊断");
		$.ajax({
			  url: "/cgi-bin/turbo/;stok=17bbd66c326e9cb77a563fc87d8a4137/api/network/get_pppoe_status",
			  cache: false,
			  dataType: "json",
			  success: function(rsp){
					if(rsp.code == 0){
						if (rsp.status_code == -1){
							pppoe_info_msg("未知状态...",0,1);
							fixed_info_msg("建议重新诊断,PPPoE可能还在拨号中。")
						} else if (rsp.status_code == 0) {
							pppoe_info_msg("已连接 .");
							check_website();//开始检查互联网
						} else {
							var error_msg = "错误 "+rsp.status_code+" "+rsp.status_msg;
							pppoe_info_msg(error_msg,1);
							if (rsp.remote_message){
								$("#remote_message_box").html(rsp.remote_message).show();
							}
							fixed_info_msg("建议检查PPPoE设置是否正常，密码是否正确，是否为月初欠费。")
						}
					} else {
						pppoe_info_msg("错误 "+rsp.msg,1);
					}
			  },
			  error :function(){
				  pppoe_info_msg("无法连接到路由器，请检查线路是否正常。 "+rsp.msg,1);
			  }
		});
	}
	
	function check_website(){
		$.ajax({
			  url: "/cgi-bin/turbo/;stok=17bbd66c326e9cb77a563fc87d8a4137/api/network/net_detect_website",
			  cache: false,
			  dataType: "json",
			  success: function(rsp){
				  	var allok = true;
				  	var errnum = 0;
					for(var x in rsp){
						if(rsp[x].ping){
							var msg = "成功。 ";
							$("#website_ping_"+x).html(msg);
						}else{
							errnum++;
							allok = false;
							$("#website_ping_"+x).html("<span class='err'>失败</a>");
						}
						
						if(rsp[x].http){
							var msg = "成功。 ";
							$("#website_http_"+x).html(msg);
						}else{
							errnum++;
							allok = false;
							$("#website_http_"+x).html("<span class='err'>失败</a>");
						}
					}
					if(allok){
						fixed_info_msg("网站诊断连接正常，如有问题请关闭浏览器重新访问。"+net_setup_url);
						$("#h1_title").html('互联网连接正常');
					}else{
						if(errnum==1){
							fixed_info_msg("网站诊断有失败，建议你重新诊断，或者重新打开浏览器，访问网站。"+net_setup_url);
						}else{
							fixed_info_msg("本地网络状态正常，但是无法访问互联网，可以尝试重启路由器与电脑设备。");
							fixed_info_msg("网站连接诊断失败，可能是运营商网络故障，稍后请再次打开浏览器，重新访问网站。"+net_setup_url);
						}
						
					}
			  },
			  error :function(){
				  $(".website_err").html("<span class='err'>诊断失败</a>");
				  fixed_info_msg("访问路由器失败，请检查是否正确连接了路由器。");
			  }
		});
	}
	</script>
</body>
</html>
