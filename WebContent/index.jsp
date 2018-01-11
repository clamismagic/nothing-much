<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="model.*"%>

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
				<li class="sidebar-brand"><a href="index.html">The Four
						Horsemen</a></li>
				<li><a href="index.jsp">To the field</a></li>
				<li><a href="search.jsp">To find</a></li>
			</ul>
		</div>
		<!-- /#sidebar-wrapper -->

		<!-- Page Content -->
		<div id="page-content-wrapper">
			<div>
				<a href="#menu-toggle" class="btn btn-secondary menuAlign"
					id="menu-toggle">Menu</a> <img class="logo" alt="The Four Horsemen"
					src="images/logo.jpg" />
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
				%>
				<!-- Meadow Diagram Filter form -->
				<form method="post" action="filterServlet" onSubmit="return">
					<p>
						<input class="filterCheckbox" type="checkbox" name="metrics"
							value="Spike" />Spike<br> <input class="filterCheckbox"
							type="checkbox" name="metrics" value="Periodicity" />Periodicity<br>
						<input class="filterCheckbox" type="checkbox" name="metrics" value="Domain names" />Domain names<br>
						<input class="filterCheckbox" type="checkbox" name="metrics" value="Port access" />Port access<br>
						<input class="filterCheckbox" type="checkbox" name="metrics" value="Parent-Child" />Parent-Child<br>
						<input class="filterCheckbox" type="checkbox" name="metrics" value="Metric1" />Metric1<br>
						<input class="filterCheckbox" type="checkbox" name="metrics" value="Metric2" />Metric2<br>
						<input class="filterCheckbox" type="checkbox" name="metrics" value="Metric3" />Metric3
					</p>
					<input type="submit" value="Filter" />
				</form>
			</div>
			<%
			//list of hostnames
			HostGenSQL hostGenSQL = new HostGenSQL();
			List<QueryData> hostname = (List<QueryData>)hostGenSQL.hostname().executeQuery();
			HashMap<String, HashMap<String, String>> allhostrisks = new HashMap<String, HashMap<String, String>>();	//link hostname to map of risk factors
			int degrees = 0;
			HashMap<String, int[]> posofhostoncanvas = new HashMap<String, int[]>();
			for(QueryData singlehostentry : hostname) {
				HashMap<String,String> riskfactorpos = new HashMap<String,String>();	//link riskname to risk value
				Double AvgRisk;
				//TODO execute query based on checkbox options (probably done below?)
				for (int i=0;i<checkboxes.length;i++) {
					/* Query MySQL -> select __ from __
			        where hostname = "onehost" and
			        riskname = "onecheck" */
					PreparedStatement pstmt = hostGenSQL.riskcheckbyhostandrisk();
					pstmt.setString(1, singlehostentry.toString());
					pstmt.setString(2, checkboxes[i]);
					ResultSet rs = pstmt.executeQuery();
					double risk = (double) rs.getObject(1);
					AvgRisk += risk;
					int x = 10 ,y = 10;
					StringBuilder values = new StringBuilder();
					switch(i) {
					case 0: 	// calculate coords toward top (12 o clock direction)
						y -= (risk*10);
						values.append(x + " , " + y); 
						break;
					case 1:		// calculate coords toward top right (2 o clock direction)
						x += (risk*10);
						values.append(x + " , " + y);
						break;	
					case 2:		// calculate coords toward bottom right (5 o clock direction)
						x += (int) (risk*10*(Math.cos(Math.toRadians(53))));
						y += (int) (risk*10*(Math.sin(Math.toRadians(53))));
						values.append(x + " , " + y);
						break;
					case 3:		 // calculate coords toward bottom left (7 o clock direction)
						x -= (int) (risk*10*(Math.cos(Math.toRadians(53))));
						y += (int) (risk*10*(Math.sin(Math.toRadians(53))));
						values.append(x + " , " + y);
						break;
					case 4:		// calculate coords toward top left (10 o clock direction)
						x -= (risk*10);
						values.append(x + " , " + y);
						break;
					}
					riskfactorpos.put(singlehostentry.getHostName(), values.toString());
				}
				AvgRisk /= checkboxes.length();
				int distance = (int) Math.sqrt((((1-AvgRisk)/2)*800*600/Math.PI));
				int[] currenthostcords = null;
				while (currenthostcords == null) {
					currenthostcords = HostGeneration.generatexypos(degrees, distance, posofhostoncanvas);
					degrees += 3;
				}
				posofhostoncanvas.put(singlehostentry.getHostName(),currenthostcords);
					allhostrisks.put(singlehostentry.getHostName(),riskfactorpos);
			}
			
			
			
			
			
			%>
			
			<div class="col-md-9 align">
				<table>
					<tr>
						<!-- 1 -->
						<!--<td colspan="1">
				<svg width="105" height="105">
					<polygon points="50,5 20,99 95,39 5,39 80,99" style="fill:lime;stroke:purple;stroke-width:1;fill-rule:nonzero;" />
				</svg>
			</td>-->
						<!-- Top -> Mid -> Right -> Left -> Mid -> Bottom-Left -> Mid -> Bottom-Right -> Mid -->
						<td colspan="1">
							<!--<svg height="210">
					<polygon points="100,10 100,99 190,99 10,99 100,99 50,198 100,99 150,198 100,99"
					style="fill-opacity:0;stroke:black;stroke-width:10;fill-rule:nonzero;" />
				</svg>
				<svg width="105" height="105">
					<polygon points="50,5 50,49 95,49 5,49 50,49 25,99 50,49 75,99 50,49" style="fill-opacity:0;stroke:black;stroke-width:10;fill-rule:nonzero;" />
				</svg>--> <!--<svg width="21" height="21">
					<polygon points="10,1 10,10 19,10 1,10 10,10 5,20 10,10 15,20 10,10" style="fill-opacity:0;stroke:black;stroke-width:1;fill-rule:nonzero;" />
				</svg>--> <!-- /host?10.0.1.1 --> 
									</tr>
				</table>
			</div>
		</div>
		<!-- /#page-content-wrapper -->
	</div>

	<!-- Bootstrap core JavaScript -->
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap.bundle.min.js"></script>

	<!-- Menu Toggle Script -->
	<script>
		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});
	</script>

</body>
</html>