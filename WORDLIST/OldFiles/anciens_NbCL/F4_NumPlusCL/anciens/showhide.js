// JavaScript Document
function showhide(obj, n, how) {
	if (navigator.appName =="Netscape") {
		if (obj.checked) {
			document.styleSheets[0].cssRules[n].style.display = how; 
		} else {
			document.styleSheets[0].cssRules[n].style.display = 'none'; 
		}
	} else {
		if (obj.checked) {
			document.styleSheets[0].rules[n].style.display = how; 
		} else {
			document.styleSheets[0].rules[n].style.display = 'none'; 
		}
	}
}