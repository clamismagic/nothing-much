var i;
var j;
var mainDiv = document.getElementById("main");

// parse hostname array from jsp
var splitHost = hostname.substr(1).slice(0, -1); // to remove first and last '[]' from string
var hostnameArray = splitHost.split(", ");

// parse host 'petal' coordinates from jsp
var splitPetalCoords = map.substr(1).slice(0, -1); // to remove first and last '{}' from string
petalCoords = splitPetalCoords.match(/(\w+(?:\W\w+)?\=(?:\d+\,\d+\s?){9})/g);

// parse host position coordinates from jsp
var splitHostPos = hostpos.substr(1).slice(0, -1); // to remove first and last '[]' from string
var hostPosString = splitHostPos.split(", ");

var ttposition;

var svgPointsDefault = "10,0 10,10 20,10 0,10 10,10 4,18 10,10 16,18 10,10";// Default
// Top -> Mid -> Right -> Left -> Mid -> Bottom-Left -> Mid -> Bottom-Right -> Mid
//  0  ->  D  ->  1    ->  4   ->  D  ->   3         ->  D  ->    2         ->  D
var svgPoints = ["10,0", "10,10", "20,10", "0,10", "10,10", "4,18", "10,10", "16,18", "10,10"];
// "arr[0]", "arr[1]", "arr[2]", "arr[3]", "arr[4]", "arr[5]", "arr[6]", "arr[7]", "arr[8]"

var hostid = "10.0.1.1";//???

for (i = 0; i < hostnameArray.length; i++) {
/*	if (coords[1] > 400) {
		ttposition = "top";
	} else {
		ttposition = "bottom";
	} */
	var idname = "";
	var correctCoords = "10,10 10,10 10,10 10,10 10,10 10,10 10,10 10,10 10,10"; // print default coordinates if host not found
	petalCoords.forEach(function(oneHostEntry) {
		var splittedHostCoords = oneHostEntry.split("=");
		if (hostnameArray[i].localeCompare(splittedHostCoords[0]) == 0) {
			idname = "box-" + hostnameArray[i];
			correctCoords = splittedHostCoords[1];
			console.log(idname + " -> " + correctCoords);
			//break;
		}
	});
	if (idname.localeCompare("") != 0) {
		var htmlStr = '<a href="index-host.html" target="_blank" data-toggle="tooltip" data-html="true" data-placement="' + ttposition + '" title="" data-original-title="<h5>Host Name / Host ID / IP address</h5><hr><p>IP address: 10.0.1.1</p><p>Host name: Corporate-Web-Server</p><p>Host Owner: Ben</p><p>Location: Level 2-1</p>"><svg width="20" height="20"><polygon points="' + correctCoords + '" style="fill-opacity:0;stroke:black;stroke-width:1;fill-rule:nonzero;" /></svg></a></div>';
		mainDiv.innerHTML += '<div id="' + idname + '">' + htmlStr;
		
		//Styling code
		var currentBox = document.getElementById(idname);
		currentBox.style.position = "absolute";
		var XYPos = ["0","0"];
		hostPosString.forEach(function(oneSetHostPos) {
			var splittedHostPos = oneSetHostPos.split("=");
			if (hostnameArray[i].localeCompare(splittedHostPos[0]) == 0) {
				XYPos = splittedHostPos[1].split(",");
			}
		});
		currentBox.style.top = XYPos[1] + "px";
		currentBox.style.left = XYPos[0] + "px";
	} else {
		document.getElementById("missingHost").innerHTML += hostnameArray[i] + "\n";
	}
}