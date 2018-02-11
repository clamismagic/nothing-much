<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Host Zoom - Laminae</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="images/favicon-196x196.png" sizes="196x196" />
	<link rel="icon" type="image/png" href="images/favicon-96x96.png" sizes="96x96" />
	<link rel="icon" type="image/png" href="images/favicon-32x32.png" sizes="32x32" />
	<link rel="icon" type="image/png" href="images/favicon-16x16.png" sizes="16x16" />
	<link rel="icon" type="image/png" href="images/favicon-128.png" sizes="128x128" />
    
    <!--<link rel="stylesheet" href="bootstrap.css">-->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/base.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <!-- CSS Files -->
    <link type="text/css" href="host-zoom-dumps/base.css" rel="stylesheet" />
    <link type="text/css" href="host-zoom-dumps/BarChart.css" rel="stylesheet" />

    <!--[if IE]><script language="javascript" type="text/javascript" src="../../Extras/excanvas.js"></script><![endif]-->

    <!-- JIT Library File -->
    <script language="javascript" type="text/javascript" src="host-zoom-dumps/jit-yc.js"></script>

    <!-- Example File -->
    <script language="javascript" type="text/javascript" src="host-zoom-dumps/example1.js"></script>
</head>
	<%
		String[] allExtHosts = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};
		int[] countConn = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
		String[] allTraffic = {"0,0","0,0","0,0","0,0","0,0","0,0","0,0","0,0","0,0","0,0"};
		int i = 0;
		String toPlot = request.getParameter("plotting");
		String extHosts = "", freqConn = "", trafficFlow = "";
		if (toPlot != null && toPlot.equals("success")) {
			ArrayList<String> plottingValues = (ArrayList<String>) request.getAttribute("chartData");
			for (String oneExtHost : plottingValues) {
				String[] splitFields = oneExtHost.split(", ");
				allExtHosts[i] = splitFields[0];
				countConn[i] = Integer.parseInt(splitFields[1]);
				allTraffic[i++] = splitFields[2];
			}
			for (int j = 0; j < allExtHosts.length; j++) {
				extHosts += allExtHosts[j] + ", ";
				freqConn += countConn[j] + ", ";
				trafficFlow += allTraffic[j] + ", ";
			}
		}
		String hostname = request.getParameter("hostname");
		String time = request.getParameter("time");
					%>
<body onload="init('<%=extHosts %>', '<%=trafficFlow %>', '<%=hostname %>');">
    <jsp:include page="header.html"></jsp:include>
    <div class="container-fluid text-center">
        <hr>
        <div class="row content">
            <div class="col-sm-8 text-left col-md-offset-2">

                <div id="container">

                    <div id="left-container">
                        <div class="text">
                            <h4>
                                Host Details
                            </h4>

                            <p>IP address:</p>
                            <p>MAC address:</p>

                        </div>
                        <ul id="id-list"></ul>
                        <div id="update"></div>
                        <form action="connectBarChartServlet" method="post">
						<input type="hidden" name="hostname" value="<%=hostname %>" />
						<input type="hidden" name="time" value="<%=time %>" />
						<input type="submit" value="Generate Chart" />
					</form>
                    </div>

                    <div id="center-container">
                        <div id="infovis"></div>

                        <canvas id="Canvas" width="800" height="200">Your browser does not support the HTML5 canvas tag.</canvas>

                    <!-- <script language="javascript" type="text/javascript" src="host-zoom-dumps/freq.js"></script> -->

						<script type="text/javascript">
							var unparsedAmp = "<%=freqConn %>";
							var arrAmp = unparsedAmp.split(",");
							var lineTo = [];
							for (var i = 0; i < arrAmp.length; i++) {
								lineTo.push(parseInt(arrAmp[i]) * 10);
							}
							console.log(lineTo);
							// var lineTo = [100, 50, 90, 150, 133, 80, 40, 10, 190, 86];// length of amplitude
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
						</script>
                    </div>

                    <div id="right-container">

                        <div id="inner-details"></div>

                    </div>

                    <div id="log"></div>
                </div>

            </div>

        </div>
    </div>

    <jsp:include page="footer.html"></jsp:include>
</body>

</html>