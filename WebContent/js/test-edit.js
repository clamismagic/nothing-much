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

var svgPointsDefault = "10,0 10,10 20,10 0,10 10,10 4,18 10,10 16,18 10,10"; // Default coordinates, assuming all risks 1.0

//coordinates for midpoint
mainDiv.innerHTML += "<div id='centerpoint' width='10px' height='10px' z-index='1'>&nbsp;</div>";
var centerpoint = document.getElementById("centerpoint");
centerpoint.style.position = "absolute";
centerpoint.style.top = "250px";
centerpoint.style.left = "400px";
centerpoint.style.borderRadius = "50%";
centerpoint.style.color = "red";
centerpoint.style.backgroundColor = "red";

for (i = 0; i < hostnameArray.length; i++) {
/*	if (coords[1] > 400) {
		ttposition = "top";
	} else {
		ttposition = "bottom";
	} */
	var idname = "";
	var correctCoords = "10,10 10,10 10,10 10,10 10,10 10,10 10,10 10,10 10,10"; // print default coordinates if host not found
	if (petalCoords) {
		petalCoords.forEach(function(oneHostEntry) {
			var splittedHostCoords = oneHostEntry.split("=");
			if (hostnameArray[i].localeCompare(splittedHostCoords[0]) == 0) {
				idname = "box-" + hostnameArray[i];
				correctCoords = splittedHostCoords[1];
				//break;
			}
		});
		
		if (idname.localeCompare("") != 0) {
			var htmlStr = '<a href="index-host.html" target="_blank" data-toggle="tooltip" data-html="true" data-placement="' + ttposition + '" title="" data-original-title="<h5>Host Name / Host ID / IP address</h5><hr><p>IP address: 10.0.1.1</p><p>Host name: Corporate-Web-Server</p><p>Host Owner: Ben</p><p>Location: Level 2-1</p>"><svg width="20" height="20"><polygon points="' + correctCoords + '" style="fill-opacity:0;stroke:white;stroke-width:1;fill-rule:nonzero;" /></svg></a></div>';
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
			//document.getElementById("missingHost").innerHTML += hostnameArray[i] + "\n";
		}
	}
}