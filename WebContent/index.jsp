<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="model.*"%>
<%@ page import="model.Meadow"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description"
	content="Singapore Polytechnic Diploma in Infocomm Security Management AY2017/18 FYP Group 63" />
<meta name="author" content="The Four Horsemen --- FYP Group 63" />

<title>Field - The Four Horsemen</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet" type="text/css"
	href="css/bootstrap/bootstrap.min.css" />

<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="css/simple-sidebar.css" />
<link rel="stylesheet" href="css/meadow/base.css" />
<link rel="stylesheet" href="css/meadow/meadow.css" />
<link rel="stylesheet" href="css/meadow/meadowTest.css" />

<!-- Bootstrap core JavaScript -->
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	
<!-- Script -->
<script>
	$(document).ready(function(){
		$('[data-toggle="tooltip"]').tooltip();   
	});
</script>

</head>
<body>

	<div id="wrapper">

		<!-- Sidebar -->
		<jsp:include page="sidebar.html"></jsp:include>
		<!-- /#sidebar-wrapper -->

		<!-- Page Content -->
		<div id="page-content-wrapper">
			<jsp:include page="header.html"></jsp:include>
			<div class="col-md-3 align metric-border">
				<h1>Metrics</h1>
				<!-- Error messages -->
				<%
					String filterStatus = request.getParameter("status");
					if (filterStatus != null && filterStatus.equals("error")) {
				%>
				<p class="errorMessage">You can only select up to 5 metrics to
					show.</p>
				<%
					} else if (filterStatus != null && filterStatus.equals("error2")) {
				%>
				<p class="errorMessage">Please select at least 1 metric to show.</p>
				<%
					}
					HostGenSQL hostgensql = new HostGenSQL(request);
					ArrayList<String> risk = hostgensql.distinctRiskname();
				%>
				<!-- Meadow Diagram Filter form -->
				<form method="post" action="filterServlet" onSubmit="return">
					<p>
						<%
							// Get selectedMetrics
							String[] selectedMetrics = request.getParameterValues("metrics");
							for (String singlerisk : risk) {
						%>
						<input class="filterCheckbox" type="checkbox" name="metrics" id="filterMetrics"
							value="<%=singlerisk%>"
							<%
								if (selectedMetrics != null) {
								for (int i=0; i < selectedMetrics.length; i++) {
									if (singlerisk.equals(selectedMetrics[i])) {
										out.print("checked");
									}
								}}
							%>
							><%=singlerisk%></input><br>
						<%
							}
							Meadow meadow = new Meadow();
							if (filterStatus != null && filterStatus.equals("working")) {
								meadow = (Meadow) request.getAttribute("meadow");
							}
							DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							java.util.Date currentTime = new java.util.Date(); // use currentTime if risk factors are updated to current datetime
							java.util.Date fiveMinBefore = new java.util.Date(System.currentTimeMillis() - 3600 * 1000);
						%>
						<input type="hidden" name="currentTime"
							value="<%=df.format(currentTime)%>" /> <input type="hidden"
							name="fiveMinBefore" value="<%=df.format(fiveMinBefore)%>" />
					</p>
					<input type="submit" value="Filter" />
				</form>
			</div>
			<%
				Date date = new Date();
			%>

			<div class="col-md-9 align" id="main">
				<div id="centerpoint">
					<svg width="21" height="10"><circle cx="5" cy="5" r="4" stroke="black" stroke-width="0" fill="red" /></svg>
				</div>
				<div id ="radius09">
					<svg height="500" width="500"><circle cx="210" cy="210" r="91" stroke="#ff0000" stroke-width="3" stroke-opacity="1" fill="red" fill-opacity="0"/></svg>
				</div>
				<div id ="radius08">
					<svg height="500" width="500"><circle cx="210" cy="210" r="121" stroke="#ff4000" stroke-width="3" stroke-opacity="1" fill="red" fill-opacity="0"/></svg>
				</div>
				<div id ="radius07">
					<svg height="500" width="500"><circle cx="210" cy="210" r="144" stroke="#ff8000" stroke-width="3" stroke-opacity="1" fill="red" fill-opacity="0"/></svg>
				</div>
				<div id ="radius05">
					<svg height="500" width="500"><circle cx="210" cy="210" r="180" stroke="#ffbf00" stroke-width="3" stroke-opacity="1" fill="red" fill-opacity="0"/></svg>
				</div>
				<div id ="radius03">
					<svg height="500" width="500"><circle cx="210" cy="210" r="209" stroke="#bfff00" stroke-width="3" stroke-opacity="1" fill="red" fill-opacity="0"/></svg>
				</div>
				<!-- https://www.w3schools.com/colors/colors_picker.asp -->
			</div>
			 <div id="missingHost"></div>
			<div class="slidecontainer" bottom="5px" onmousedown="viewTime()" onmouseup="passtimestamp()">
				<input type="range" min="<%=date.getTime() - 1514829136%>"
					max="<%=date.getTime()%>" value="<%=date.getTime()%>"
					class="slider" id="myRange">
				<p>
					Value: <span id="demo">Now</span>
				</p>
			</div>

		</div>
		<!-- /#page-content-wrapper -->

		<!-- Footer -->
		<jsp:include page="footer.html"></jsp:include>

	</div>

	<script type="text/javascript">
		var map = "<%=meadow.getAllHostRisks()%>"; 
		var hostname = "<%=meadow.getAllHosts()%>";
		var hostpos = "<%=meadow.getToPassXYcoords()%>";
	</script>
	<!--  Slider script -->
	<script>
		function passtimestamp() {
			var slider = document.getElementById("myRange");
			var output = document.getElementById("demo");
			
			var metrics = [];
			$("input:checkbox[name=metrics]:checked").each(function(){
			    metrics.push($(this).val());
			});
			
			console.log(metrics);
			
			var utcSeconds = Math.floor(slider.value / 1000);
			var timeNow = new Date(utcSeconds * 1000);
			var parsedMonth = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
			var parsedHour = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"];
			var parsedMinSec = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
			var currentTime = timeNow.getFullYear() + "-" + parsedMonth[timeNow.getMonth()] + "-" + timeNow.getDate() + " " + parsedHour[timeNow.getHours()] + ":" + parsedMinSec[timeNow.getMinutes()] + ":" + parsedMinSec[timeNow.getSeconds()];
			var lowerTime = new Date((utcSeconds - 300) * 1000);
			var fiveMinBefore = lowerTime.getFullYear() + "-" + parsedMonth[lowerTime.getMonth()] + "-" + lowerTime.getDate() + " " + parsedHour[lowerTime.getHours()] + ":" + parsedMinSec[lowerTime.getMinutes()] + ":" + parsedMinSec[lowerTime.getSeconds()];
			console.log(currentTime);
			console.log(fiveMinBefore);
			$.ajax({
			    url: "/fyp_TheFourHorsemen_V1/filterServlet",
			    data: {
			        "currentTime" : currentTime,
			        "fiveMinBefore" : fiveMinBefore,
			        "timelineMetrics" : metrics
			    },
			    type: 'POST'
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
	</script>
	<script type="text/javascript" src="js/test-edit.js"></script>
	<!-- Menu Toggle Script -->
	<script>
		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});
	</script>

</body>
</html>