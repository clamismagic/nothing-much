<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="model.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
	<title>Meadow Diagram - Laminae</title>
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
	<link rel="stylesheet" href="css/meadow.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

	<script>
		$(document).ready(function(){
			$('[data-toggle="tooltip"]').tooltip();   
		});
	</script>
	
</head>
<body>

<jsp:include page="header.html"></jsp:include>
	
<div class="container-fluid text-center">	
	<div class="row content">
	<div class="col-sm-2 sidenav">
		<h3 id="METRICS-HEADER">METRICS</h3>
		<hr>
		
		<!-- Error messages -->
				<%
					String filterStatus = request.getParameter("status");
					if (filterStatus != null && filterStatus.equals("error")) {
				%>
				<p class="errorMessage">You can only select up to 5 metrics to show.</p>
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
						<input class="filterCheckbox" type="checkbox" name="metrics" id="filterMetrics" value="<%=singlerisk%>"
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
							java.util.Date maxTime = new java.util.Date(1505779200000L); // update maxTime according to relevant timestamp
							java.util.Date fiveMinBefore = new java.util.Date(maxTime.getTime() - 3600 * 1000);
						%>
						<input type="hidden" name="currentTime" value="<%=df.format(maxTime)%>" /> <input type="hidden" name="fiveMinBefore" value="<%=df.format(fiveMinBefore)%>" />
					</p>
					<input id="submitQuery" type="submit" value="Filter" />
				</form>
	</div>
	
	<%
		Date date = new Date();
	%>
		
	<div class="col-sm-10 text-left" id="main"> 
		
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
		<div class="slidecontainer" bottom="5px" onmousedown="viewTime()" onmouseup="passtimestamp(<%=fiveMinBefore.getTime() - 86400000 %>, <%=maxTime.getTime() %>)">
			<input type="range" min="<%=fiveMinBefore.getTime() - 86400000 %>" max="<%=maxTime.getTime() %>" value="<%=maxTime.getTime() %>" class="slider" id="myRange">
			<p>
				Value: <span id="demo">Now</span>
			</p>
		</div>
		<!-- https://www.w3schools.com/colors/colors_picker.asp -->
	</div>
	<div id="missingHost"></div>
			
	
	</div>
</div>
	<script type="text/javascript" src="js/test-edit.js"></script>
	<%
		if (meadow.getAllHosts() != null) {
	%>
	<script type="text/javascript">
			populateMainDiv("<%=meadow.getAllHosts()%>", "<%=meadow.getAllHostRisks()%>", "<%=meadow.getToPassXYcoords()%>");
	</script>
	<%
		}
	%>
<jsp:include page="footer.html"></jsp:include>

</body>
</html>
