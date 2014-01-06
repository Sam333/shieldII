function getVersion(version){
	var n_url = "";
	$.getJSON("http://r.xcloud.cc/router/index.php?m=Index&a=updateVersion&callback=?",{Ver:version},function(json){
		n_url = json[0].url;
		
		if (n_url != ""){
			$('.updatewords').html('发现新固件，点击');
			$('.prompt').css('display','block');
			$('#getupdate').html('下载');
			$('#getupdate').attr("href",n_url);
			$('.firmware1').css('display','block');
		}
	});
}

function changeVersion(version){
	var n_url = "";

	$.getJSON("http://r.xcloud.cc/router/index.php?m=Index&a=updateVersion&callback=?",{Ver:version},function(json){
		n_url = json[0].url;
		
		if (n_url != ""){
			$('.check_firmware span').show();
			$('.check_firmware a').show().attr('href',n_url);
		}else{
			$('.firmware_newast').show();
			$('.check_firmware span').hide();
			$('.check_firmware a').hide()
		}
	});
}

function IsPC() 
{ 
	var userAgentInfo = navigator.userAgent; 

	var Agents = new Array("Android", "iPhone", "SymbianOS", "Windows Phone", "iPad", "iPod"); 
	var flag = true; 
	for (var v = 0; v < Agents.length; v++) { 
		if (userAgentInfo.indexOf(Agents[v]) > 0) { flag = false; break; } 
	} 
	return flag; 
}

function include_css(path){
	var fileref = document.createElement("link");
	fileref.rel = "stylesheet";
	fileref.type = "text/css";
	fileref.href = path;
	var headobj = document.getElementsByTagName('head')[0];
	headobj.appendChild(fileref);

	var fileo = document.createElement("meta");
	fileo.name = "viewport";
	fileo.content = "user-scalable=no,width=device-width";
	headobj.appendChild(fileo);
}

		/**************************************************************/

$('.dhcpserv').live('click',function(){
	var dhcp = $(this).val();

	$('.dhcpserv').attr('disabled','disabled');

	$.ajax({
		url:landhcpurl,
		dataType:'json',
		data:{flag:dhcp},
		method:'post',
		timeOut:30000,
		success:function(r){
			if (r.result == 'success'){
				$('.dhcpserv').removeAttr('disabled');
			}
		},
		error:function(o,i,j,k){
			$('.dhcpserv').removeAttr('disabled');
		}
	})
})

$('.lan_edit').live('click',function(){
	$(this).hide();
	$('.addstatic').css('display','block');
	$('.savestatic').css('display','block');
	$('.delete').css('display','block');

	$('.static_name').css({'border':'1px solid #ccc','background':'white'});
	$('.static_name').removeAttr('disabled');

	$('.static_ip').css({'border':'1px solid #ccc','background':'white'});
	$('.static_ip').removeAttr('disabled');

	$('.macusual').hide();
	$('.macadds').show();
})

function checkRepeat(data){
	var nary = data.sort();
	for(var i = 0; i < nary.length - 1; i++)
	{
	    if (nary[i] == nary[i+1])
	    {
	        return false;
	    }
	}

	return true;
}

function lansetup2mention(word){
	//$('.lansetuppart2_mention').html(word).stop().fadeIn(1000).fadeOut(3000);
	$('.lansetuppart2_mention').html(word).stop().animate({'opacity':1},1000,"",function(){
		$('.lansetuppart2_mention').stop().animate({'opacity':0},1000);
	});
}

// 验证相同网段
function checkSamenet(ipstd,ipdata){
	//alert(ipstd + ' '+ipdata);
	var stdArr = new Array();
	stdArr = ipstd.split(".");

	var ipArr = new Array();
	ipArr = ipdata.split(".");

	if (stdArr[0] == ipArr[0] && stdArr[1] == ipArr[1] && stdArr[2] == ipArr[2]){
		return true;
	}

	return false;
}

function savestaticshow(o){
	$('.lan_edit').show();
	$('.addstatic').css('display','none');
	$('.savestatic').css('display','none');
	$('.delete').css('display','none');
	$('.static_name').attr('disabled','disabled').css({'border':'none','background':'none'});

	$('.static_ip').attr('disabled','disabled').css({'border':'none','background':'none'});	

	$('.macusual').show();
	$('.macadds').hide();
	$('.ads_default').hide();

	o.attr('rel','0');
}

$('.savestatic').live('click',function(){
	var curname = "";
	var curselectmac = "";
	var curinputmac = "";
	var curmac	= "";
	var curip	= "";

	var cansave = 0;

	var allstr = "";

	var tmpmac	= new Array();
	var tmpip	= new Array();

	var ipstd = netipaddr;

	// 获取点击状态
	var clickstus = $(this).attr('rel');

	var curobj = $(this);
	if (clickstus == '1'){
		lansetup2mention('请不要重复点击');
		return false;
	}

	// 查找所有数据
	$('.lan_static_dev .lan_data').each(function(idx,o){
		curname = $(o).children("td:eq(0)").children('input').val();
		curselectmac = $(o).children("td:eq(1)").children("select").val();
		curinputmac = $(o).children("td:eq(1)").children('.ads_default').children("input").val();
		
		// 获取当前名字
		if (curname == ""){
			cansave = -1;
		}

		// 获取当前mac
		if (curinputmac == "" && curselectmac == ""){
			cansave = -1;
		}

		if (!curselectmac){
			curmac = curinputmac;
		}else{
			curmac = curselectmac;
		}

		$(o).children("td:eq(1)").children("select").children('option:eq(0)').val(curmac).html(curmac);

		$(o).children("td:eq(1)").children('.macusual').html(curmac);

		var temp = /[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}/;
		if (!temp.test(curmac)) 
		{
		     cansave = -1;
		}

		// 获取当前ip
		curip = $(o).children("td:eq(2)").children('input').val();

		if (curip == ""){
			cansave = -1;
		}

		var exp=/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
		var reg = curip.match(exp);

		if(reg==null){
			cansave = -1;
		}

		if (!checkSamenet(ipstd,curip)){
			cansave = -3;
		}

		allstr += curname+"||"+curmac+"||"+curip+"|||";

		tmpmac.push(curmac);
		tmpip.push(curip);
	})

	// 验证重复
	if(!checkRepeat(tmpmac) || !checkRepeat(tmpip)){
		cansave = -2;
	}

	if (cansave == -1){
		lansetup2mention('请填写完整信息');
		return false;
	}else if(cansave == -2){
		lansetup2mention('部分信息重复');
		return false;
	}else if(cansave == -3){
		lansetup2mention('IP需在同一网段');
		return false;
	}

	$(this).attr('rel','1');

	//lansetup2mention('正在保存...');
	$('.lansetuppart2_mention').html('正在保存...').stop().fadeIn(1000);

	$.ajax({
		url:lanipaddrurl,
		dataType:'json',
		data:{data:allstr},
		method:'post',
		success:function(r){
			savestaticshow(curobj);
			$('.lansetuppart2_mention').html('已保存').stop().fadeOut(3000);
		},
		error:function(){
			savestaticshow(curobj);
			$('.lansetuppart2_mention').html('已保存').stop().fadeOut(3000);
		}
	})


})

$('.delete').live('click',function(){
	var node = $(this).parent();
	node.remove();
})

$('.addword').live('click',function(){
	var nod = $('.addnode').html();
	$('.lan_static_dev').append(nod);
})

$('.macadds').live('change',function(){
	var flag = $(this).val();

	if (flag == 'custom'){
		var par = $(this).parent();
		$(this).val('');
		$(this).hide();
		par.children('.ads_default').show();
	}
})