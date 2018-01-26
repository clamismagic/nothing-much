<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="model.*"%>
<%@ page import="model.Meadow" %>

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
		<div id="sidebar-wrapper">
			<ul class="sidebar-nav">
				<li class="sidebar-brand"><a href="index.jsp"><img
						class="logoSidebar" alt="The Four Horsemen"
						src="images/logo_Sidebar.png" /></a></li>
				<li><a href="index.jsp">To the field</a></li>
				<li><a href="search.jsp">To find</a></li>
			</ul>
		</div>
		<!-- /#sidebar-wrapper -->

		<!-- Page Content -->
		<div id="page-content-wrapper">
			<div>
				<a href="#menu-toggle" class="menuBtn menuAlign" id="menu-toggle">Menu</a>
				<img class="logo" alt="The Four Horsemen" src="images/logo_hive.png" />
				<hr />
			</div>
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
					for(String singlerisk : risk) {
					%>
					<input class="filterCheckbox" type="checkbox" name="metrics"
							value="<%=singlerisk %>"><%=singlerisk%></input><br>
							<%
							}
							%>
							
					<!-- 
						<input class="filterCheckbox" type="checkbox" name="metrics"
							value="Spike">Spike</input><br> <input
							class="filterCheckbox" type="checkbox" name="metrics"
							value="Periodicity">Periodicity</input><br> <input
							class="filterCheckbox" type="checkbox" name="metrics"
							value="Domain names">Domain names</input><br> <input
							class="filterCheckbox" type="checkbox" name="metrics"
							value="Port access">Port access</input><br> <input
							class="filterCheckbox" type="checkbox" name="metrics"
							value="Parent-Child">Parent-Child</input><br> <input
							class="filterCheckbox" type="checkbox" name="metrics"
							value="Metric1">Metric1</input><br> <input
							class="filterCheckbox" type="checkbox" name="metrics"
							value="Metric2">Metric2</input><br> <input
							class="filterCheckbox" type="checkbox" name="metrics"
							value="Metric3">Metric3</input>
							-->
							<%
							Meadow meadow = new Meadow();
							if (filterStatus != null && filterStatus.equals("working")) {
								meadow = (Meadow) request.getAttribute("meadow");
							}
							DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							java.util.Date currentTime = new java.util.Date(); // use currentTime if risk factors are updated to current datetime
							java.util.Date fiveMinBefore = new java.util.Date(System.currentTimeMillis() - 3600 * 1000);
							%>
							<input type="hidden" name="currentTime" value="<%=df.format(currentTime) %>" />
							<input type="hidden" name="fiveMinBefore" value="<%=df.format(fiveMinBefore) %>" />
					</p>
					<input type="submit" value="Filter" />
				</form>
			</div>
			<%
				//list of hostnames 
				//calvin is useful hs is useless piece of shit!!
				

				/* for (Map.Entry<String, HashMap<String,String>> test : allhostrisks.entrySet()) {
				String key = test.getKey();
				StringBuilder allvalues = new StringBuilder();
				   HashMap<String,String> value = test.getValue();
				   for (Map.Entry<String, String> testing : value.entrySet()) {
				   	String keys = testing.getKey();
				   	String values = testing.getValue();
				   	allvalues.append(values +" ");
				       System.out.println("Hostname : " + key + " checkbox: " + keys + " inside value: " + values);
				   }
				   System.out.println(allvalues);
				}  */
				Date date = new Date();
			%>

			<div class="col-md-9 align" id="main"></div>
			<div id="missingHost"></div>
			<div class="slidecontainer" bottom:5px>
				<input type="range" min="<%=date.getTime() - 1514829136%>"
					max="<%=date.getTime()%>" value="<%=date.getTime()%>"
					class="slider" id="myRange">
				<p>
					Value: <span id="demo"></span>
				</p>
			</div>

		</div>
		<!-- /#page-content-wrapper -->
	</div>

	<!-- Bootstrap core JavaScript -->
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap.bundle.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>-->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	
	<script type="text/javascript">
		var map = "<%=meadow.getAllHostRisks()%>"; 
		var hostname = "<%=meadow.getAllHosts()%>";
		var hostpos = "<%=meadow.getToPassXYcoords()%>";
	</script>
	<script type="text/javascript" src="js/test-edit.js"></script>
	<!--  Slider script -->
	<script>
		var slider = document.getElementById("myRange");
		var output = document.getElementById("demo");
		output.innerHTML = "Now";

		slider.oninput = function() {
			var utcSeconds = Math.floor(this.value / 1000);
			console.log(utcSeconds);
			var date = new Date(utcSeconds * 1000);
			output.innerHTML = date;
		}
	</script>
	<!-- Menu Toggle Script -->
	<script>
		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});
	</script>

</body>
</html>