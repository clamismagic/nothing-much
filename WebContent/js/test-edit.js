function populateMainDiv(hostname, map, hostpos) {
	console.log("start of main div population");
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
				//document.getElementById("missingHost").innerHTML += hostnameArray[i] + "\n";
			}
		}
	}
}

//Pass the checkbox name to the function
function getCheckedBoxes(chkboxName) {
	var checkboxes = document.getElementsByName(chkboxName);
	var checkboxesChecked = "";
	// loop over them all
	for (var i=0; i<checkboxes.length; i++) {
		// And stick the checked ones into the string...
		if (checkboxes[i].checked) {
	    	checkboxesChecked += checkboxes[i].value + ",";
	 	}
		}
		// Return the string if it is non-"", or null
		return checkboxesChecked.length > 0 ? checkboxesChecked : ",";
}

// slider scripts
function passtimestamp(minTime, maxTime) {
	var slider = document.getElementById("myRange");
	var output = document.getElementById("demo");
	
	var metrics = getCheckedBoxes("metrics").slice(0, -1);
	console.log(metrics);
	
	var utcSeconds = Math.floor(slider.value / 1000);
	var timeNow = new Date(utcSeconds * 1000);
	var parsedMonth = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
	var parsedHour = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"];
	var parsedMinSec = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
	var currentTime = timeNow.getFullYear() + "-" + parsedMonth[timeNow.getMonth()] + "-" + parsedHour[timeNow.getDate()] + " " + parsedHour[timeNow.getHours()] + ":" + parsedMinSec[timeNow.getMinutes()] + ":" + parsedMinSec[timeNow.getSeconds()];
	var lowerTime = new Date((utcSeconds - 300) * 1000);
	var fiveMinBefore = lowerTime.getFullYear() + "-" + parsedMonth[lowerTime.getMonth()] + "-" + parsedHour[lowerTime.getDate()] + " " + parsedHour[lowerTime.getHours()] + ":" + parsedMinSec[lowerTime.getMinutes()] + ":" + parsedMinSec[lowerTime.getSeconds()];
	console.log(currentTime);
	console.log(fiveMinBefore);

	// reset main div to blank canvas
	document.getElementById("main").innerHTML = "<div id='centerpoint'><svg width='21' height='10'><circle cx='5' cy='5' r='4' stroke='black' stroke-width='0' fill='red' /></svg></div><div id ='radius09'><svg height='500' width='500'><circle cx='210' cy='210' r='91' stroke='#ff0000' stroke-width='3' stroke-opacity='1' fill='red' fill-opacity='0'/></svg></div><div id ='radius08'><svg height='500' width='500'><circle cx='210' cy='210' r='121' stroke='#ff4000' stroke-width='3' stroke-opacity='1' fill='red' fill-opacity='0'/></svg></div><div id ='radius07'><svg height='500' width='500'><circle cx='210' cy='210' r='144' stroke='#ff8000' stroke-width='3' stroke-opacity='1' fill='red' fill-opacity='0'/></svg></div><div id ='radius05'><svg height='500' width='500'><circle cx='210' cy='210' r='180' stroke='#ffbf00' stroke-width='3' stroke-opacity='1' fill='red' fill-opacity='0'/></svg></div><div id ='radius03'><svg height='500' width='500'><circle cx='210' cy='210' r='209' stroke='#bfff00' stroke-width='3' stroke-opacity='1' fill='red' fill-opacity='0'/></svg></div><div class='slidecontainer' bottom='5px' onmousedown='viewTime()' onmouseup='passtimestamp(" + minTime + ", " + maxTime + ")'><input type='range' min='" + minTime + "' max='" + maxTime + "' value='" + utcSeconds * 1000 + "' class='slider' id='myRange'><p>Value: <span id='demo'>" + timeNow + "</span></p></div>";
	/*var data = {
        currentTime : currentTime,
        fiveMinBefore : fiveMinBefore,
        timelineMetrics : metrics
    }
	$.post("/fyp_TheFourHorsemen_V1/filterServlet", $.param(data), function(responseJson) {
		console.log(responseJson);
	});*/
	$.ajax({
	    url: "/fyp_TheFourHorsemen_V1/filterServlet",
	    data: {
	        "currentTime" : currentTime,
	        "fiveMinBefore" : fiveMinBefore,
	        "timelineMetrics" : metrics
	    },
	    type: 'POST',
	    success: function(response) {
	    	if (response.allHosts.length == 0) {
	    		document.getElementById("main").innerHTML += "<p color=red>Sorry, there are no host results for " + new Date(currentTime);
	    	} else {
	    		var allHosts = JSON.stringify(response.allHosts).replace(/\"/g, '').replace(/\,/g, ', ');
		    	console.log(allHosts);
		    	var allHostRisks = JSON.stringify(response.allHostRisks).replace(/\":\"/g, '=').replace(/\"/g, '').replace(/\s\,/g, ' , ');
		    	console.log(allHostRisks);
		    	var passXYcoords = JSON.stringify(response.toPassXYcoords).replace(/\"\,\"/g, ', ').replace(/\"/g, '');
		    	console.log(passXYcoords);
		    	populateMainDiv(allHosts, allHostRisks, passXYcoords);
	    	}
	    }
	});
}

function viewTime() {
	var slider = document.getElementById("myRange");
	var output = document.getElementById("demo");
	
	slider.oninput = function() {
		var utcSeconds = Math.floor(slider.value / 1000);
		var date = new Date(utcSeconds * 1000);
		output.innerHTML = date;
	}
}