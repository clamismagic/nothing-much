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
						<input class="filterCheckbox" type="checkbox" name="metrics"
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

			<div class="col-md-9 align" id="main"></div>
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

	<!-- Bootstrap core JavaScript -->
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap.bundle.min.js"></script>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

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
			
			var selectedMetrics = [];
			
			
			
			var utcSeconds = Math.floor(slider.value / 1000);
			var currentTime = new Date(utcSeconds * 1000);
			var fiveMinBefore = new Date((utcSeconds - 300) * 1000);
			
			$.ajax({
			    url: "/control/filterServlet.java",
			    data: {
			        postVariableName: currentTime,
			        postVariableName: fiveMinBefore
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