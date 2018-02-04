var hostArray = ["Hello","World"];//
var arrayLength = hostArray.length;

var lineTo = [100, 50, 90, 150, 133, 80, 40, 10, 190, 86];// length of amplitude
var hostXcoords = [165, 230, 300, 365, 435, 500, 570, 635, 705, 775]; // TODO fill up rest
var xSpecifiedHost = 25; // origin of specified host
var origin = 0; // beginning of relevant canvas

//var Canvas = document.getElementById("Canvas");// Redundant?

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

/* var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 100);//
ctx.lineTo(165, 100);
ctx.lineTo(165, 0);
ctx.strokeStyle = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 110);//
ctx.lineTo(230, 110);
ctx.lineTo(230, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 120);//
ctx.lineTo(300, 120);
ctx.lineTo(300, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 130);//
ctx.lineTo(365, 130);
ctx.lineTo(365, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 140);//
ctx.lineTo(435, 140);
ctx.lineTo(435, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 150);//
ctx.lineTo(500, 150);
ctx.lineTo(500, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 160);//
ctx.lineTo(570, 160);
ctx.lineTo(570, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 170);//
ctx.lineTo(635, 170);
ctx.lineTo(635, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 180);//
ctx.lineTo(705, 180);
ctx.lineTo(705, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke();

var c = document.getElementById("Canvas");
var ctx = c.getContext("2d");
ctx.beginPath();
ctx.moveTo(25, 0);
ctx.lineTo(25, 190);//
ctx.lineTo(775, 190);
ctx.lineTo(775, 0);
ctx.strokeStye = "red";
ctx.lineWidth="3";
ctx.stroke(); */