
function IElessThan9() {
	if (navigator.appName == 'Microsoft Internet Explorer') {
		//get version:
		var rv;
		var ua = navigator.userAgent;
      	var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
      	if (re.exec(ua) != null)
        rv = parseFloat( RegExp.$1 ); //rv is the version!!
        if(rv < 9.0) {return true;}
		else {return false;}
	} else {
		return false;
	}
}

function returnBrowser() {
	var is_chrome = navigator.userAgent.indexOf('Chrome') > -1;
	var is_explorer = navigator.userAgent.indexOf('MSIE') > -1;
	var is_firefox = navigator.userAgent.indexOf('Firefox') > -1;
	var is_safari = navigator.userAgent.indexOf("Safari") > -1;
	if ((is_chrome)&&(is_safari)) {is_safari=false;}
	
	if(is_chrome) {return 'Chrome';}
	if(is_explorer) {return 'Explorer';}
	if(is_firefox) {return 'Firefox';}
	if(is_safari) {return 'Safari';}
}

function is_int(value){ 
	if((parseFloat(value) == parseInt(value)) && !isNaN(value)){
	    return true;
	} else { 
	    return false;
	} 
}

function windowKeyPressedFunc(e)  {
    if (typeof e == 'undefined' && window.event) { e = window.event; }
    if (e.keyCode == 13) {
        document.getElementById('findButtonId').click();
        return false;
    }
}

function isMobile() {
    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
	return true;
    } else {
	return false;
    }
}