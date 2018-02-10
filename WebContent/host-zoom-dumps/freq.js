var lineTo = [100, 50, 90, 150, 133, 80, 40, 10, 190, 86];// length of amplitude
var hostXcoords = [165, 230, 300, 365, 435, 500, 570, 635, 705, 775]; // TODO fill up rest
var xSpecifiedHost = 25; // origin of specified host
var origin = 0; // beginning of relevant canvas

for (var i = 0; i < hostXcoords.length; i++) {

	var c = document.getElementById("Canvas");
	var ctx = c.getContext("2d");
	ctx.beginPath();
	ctx.moveTo(xSpecifiedHost, origin); // specified host coord point
	ctx.lineTo(25, lineTo[i]); // specified host coord down to amplitude
	ctx.lineTo(hostXcoords[i], lineTo[i]); 
	ctx.lineTo(hostXcoords[i], origin);
	ctx.strokeStyle = "red";
	ctx.lineWidth="3";
	ctx.stroke();

}