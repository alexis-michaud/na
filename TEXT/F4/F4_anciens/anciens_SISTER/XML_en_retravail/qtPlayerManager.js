/* ***** BEGIN LICENSE BLOCK *****
 *    Copyright 2002 Michel Jacobson jacobson@idf.ext.jussieu.fr
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * ***** END LICENSE BLOCK ***** */





//-----------------------------------------------> you do not have to change these parameters
var timer      = 0;
var stackStart = new Array();
var stackEnd   = new Array();
var fin        = 0;
var before     = 0;

//----------------------------------------------> playback functions
function boutonStop() {
	document.player.Stop();
	clearTimeout(timer);
	emptyStack();
}
function stopplay() {
	//document.player.Stop();
	clearTimeout(timer);
	emptyStack();
}
function playOne(id) {
	stopplay();
	var i = 0;
	while ((i<IDS.length) && (IDS[i] != id)) {
		i++;
	}
	if(i<IDS.length) {
		var timeScale = document.player.GetTimeScale();
		document.player.SetStartTime(STARTS[i]*timeScale);
		document.player.SetTime(STARTS[i]*timeScale);
		document.player.SetEndTime(ENDS[i]*timeScale);
		fin = ENDS[i]*1000;
		loadStack(i);
		document.player.Play();
		timer = setTimeout("loop()", 250);
	}
}
function playFrom(id) {
	var node = document.getElementById('karaoke');
	if (node && node.checked) {
		stopplay();
		var i=0;
		while ((i<IDS.length) && (IDS[i] != id)) {
			i++;
		}
		if(i<IDS.length) {
			var timeScale = document.player.GetTimeScale();
			document.player.SetStartTime(STARTS[i]*timeScale);
			document.player.SetTime(STARTS[i]*timeScale);
			document.player.SetEndTime(getMaxEnd()*timeScale);
			fin = getMaxEnd()*1000;
			loadStack(i);
			document.player.Play();
			timer = setTimeout("loop()", 400);
		}
	} else {
		playOne(id);
	}
}
//--------------------------------------------> managing a stack and a loop for quicktime player
function getMaxEnd() {
	var myFin = 0;
	for (var i=0;i<ENDS.length;i++) {
		if (ENDS[i]*1.0 > myFin) {
			myFin = ENDS[i];
		}
	}
	return myFin;
}
function loadStack(num) {
	stackStart = new Array();
	stackEnd = new Array();
	for (var i=0;i<STARTS.length;i++) {
		if ((STARTS[i]*1000 >= STARTS[num]*1000) && (STARTS[i]*1000 < fin)) {
			stackStart[stackStart.length] = i;
		}
	}
}
function emptyStack() {
	for (var i=0;i<stackEnd.length;i++) {
		endplay(IDS[stackEnd[i]]);
	}
	stackStart = new Array();
	stackEnd   = new Array();
}
function loop() {
	var timeScale = document.player.GetTimeScale();
	var now = document.player.GetTime();
	testStack((now/timeScale)*1000);
	window.status = fin+" "+(now/timeScale)*1000;
	if ((now == before) || (now == 0)) {
		before = -1;
		stopplay();
		window.status = "fin";
	} else {
		before = now;
		timer = setTimeout("loop()", 20);
	}
}
function testStack(time) {
	for (var i=0;i<stackStart.length;i++) {
		var n = stackStart[i];
		if ((n >= 0) && (time >= STARTS[n]*1000)) {
			var provi = new Array();
			for (var j=0;j<stackStart.length;j++) {
				if (j != i) {
					provi[j] = stackStart[j];
				}
			}
			stackStart = provi;
			startplay(IDS[n]);
			stackEnd[stackEnd.length] = n;
			return;
		}
	}
	for (var i=0;i<stackEnd.length;i++) {
		var n = stackEnd[i];
		if ((n >= 0) && (time >= ENDS[n]*1000)) {
			var provi = new Array();
			for (var j=0;j<stackEnd.length;j++) {
				if (j != i) {
					provi[j] = stackEnd[j];
				}
			}
			stackEnd = provi;
			endplay(IDS[n]);
			return;
		}
	}
}