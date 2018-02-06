<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.QueryDataManager"%>
<%@ page import="model.QueryData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title>Search the field - The Four Horsemen</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!--<link rel="stylesheet" href="bootstrap.css">-->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="css/base.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<!-- Javascript / JQuery / Custom Javascript / Custom JQuery -->
<script src="http://code.jquery.com/jquery-1.11.1.js"
	type="text/javascript"></script>
<script type="text/javascript">
	function change(data) {
		var idx = data.selectedIndex;
		var table = data.options[idx].value;
		var id = data.id.slice(5);
		$.get('searchServlet', {
			tableName : table
		}, function(response) {

			var select = $('#column' + id);
			select.find('option').remove();
			if (table != "---Select Table---") {
				$('<option>').val("*").text("*").appendTo(select);
			}
			$.each(response, function(index, value) {
				$('<option>').val(value).text(value).appendTo(select);
			});
		});
	}
	$(document).ready(
			function() {
				$('.search').on('click', 'button.add-more', clone);
				
				function clone() {
					$(".toAppend").clone().removeClass("toAppend").insertAfter(".toAppend")
				}
				
			});
</script>
<script>
	function downloadCSV(csv, filename) {
		var csvFile;
		var downloadLink;

		csvFile = new Blob([ csv ], {
			type : "text/csv"
		});
		downloadLink = document.createElement("a");
		downloadLink.download = filename;
		downloadLink.href = window.URL.createObjectURL(csvFile);
		downloadLink.style.display = "none";
		document.body.appendChild(downloadLink);
		downloadLink.click();
	}
	function exportTableToCSV(filename) {
		var csv = [];
		var rows = document.querySelectorAll("table tr");

		for (var i = 0; i < rows.length; i++) {
			var row = [], cols = rows[i].querySelectorAll("td");

			for (var j = 0; j < cols.length; j++) {
				row.push(cols[j].innerText);
			}

			csv.push(row.join(","));
		}

		downloadCSV(csv.join("\n"), filename);
	}
</script>
</head>

<body>

	<nav class="navbar navbar-inverse">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#myNavbar">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="logo" href="index.html"><img src="images/logo_main.png"
				alt="Logo"></a>|||
		</div>
		<div class="collapse navbar-collapse" id="myNavbar">
			<ul class="nav navbar-nav">
				<li><a href="index.html">Home</a></li>
				<li><a href="meadow.jsp">Meadow</a></li>
				<li class="active"><a href="search.jsp">Query</a></li>
				<li><a href="#">Contact</a></li>
				<li><a href="#">Guide</a></li>
				<li><a href="credits.html">Credits & Acknowledgements</a></li>
			</ul>
			<!-- <ul class="nav navbar-nav navbar-right">
				<li><a href="#"><span class="glyphicon glyphicon-log-in"></span>
						Login</a></li>
			</ul> -->
		</div>
	</div>
	</nav>

	<div class="container-fluid text-center">
		<div class="row content">
			<div class="col-md-12 sidenav">
				<h1>Find something</h1>
				<%
					String filterStatus = request.getParameter("status");
					if (filterStatus != null && filterStatus.equals("error")) {
				%>
				<p class="errorMessage">We are unable to locate what you are
					finding.</p>
				<%
					} else if (filterStatus != null && filterStatus.equals("error2")) {
				%>
				<p class="errorMessage">Please ensure all compulsory fields are
					filled up.</p>
				<%
					}
				%>
				<%
					int statementCount = 0;
				%>
				<form method="post" action="searchServlet">
					<div class="search">
						<table id="searchForm0" class="searchForm">
							<tr>
								<td>SELECT TABLE*:</td>
								<td>
									<div class="searchDropdown">
										<select name="table[]" class="table" id="table0"
											onchange="change(this);">
											<option>---Select Table---</option>
											<%
												QueryDataManager queryDataManager = new QueryDataManager(request);
												ArrayList<String> tableName = queryDataManager.getTables();
												for (int i = 0; i < tableName.size(); i++) {
											%>
											<option value="<%=tableName.get(i)%>"><%=tableName.get(i)%></option>
											<%
												}
											%>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td>SELECT COLUMN*:</td>
								<td>
									<div class="searchDropdown">
										<select name="column[]" id="column0">
											<option>---Select Table First---</option>
										</select>
									</div>
								</td>
							</tr>
							<tr class="toAppend">
								<td>CONDITION:</td>
								<td><input type="text" name="condition[]" class="condition" id="condition0"
									placeholder="Condition" /></td>
							</tr>
							<tr>
								<td>
									<button class="searchFormBtn add-more" type="button"
										onclick=<%statementCount++;%>>Add Condition</button>
								</td>
							</tr>
						</table>
					</div>
					<%
						request.setAttribute("statementCount", statementCount);
					%>
					<p id="importantNote">*Compulsory fields.</p>
					<p>
						<input id="submitQuery" type="submit" value="Query"
							onclick="generateIds()" />
					</p>
				</form>
			</div>
			<div class="col-md-12">
				<h1>Search result</h1>
				<%
					if (filterStatus != null && filterStatus.equals("success")) {
						String[] table = request.getParameterValues("table[]");
						String[] column = request.getParameterValues("column[]");
						String[] condition = request.getParameterValues("condition[]");
						int noOfQueriedItems = (Integer) request.getAttribute("noOfQueriedItems");
						if (noOfQueriedItems == 0) {
						} else {
							for (int i = 0; i < noOfQueriedItems; i++) {
								QueryData queryData = (QueryData) request.getAttribute("queryData" + i);
				%>
				<p>
					Query: <strong>SELECT</strong>
					<%=column[i].toUpperCase()%>
					<strong>FROM</strong> <span id="table"><%=table[i].toUpperCase()%></span>
					<%
						if (condition[i] != "") {
							for (int j = 0; j < condition.length; j++) {
								if (j == 0) {
									
					%>
					<strong>WHERE</strong>
					<%=condition[j].toUpperCase()%>
					<%
								} else {
					%>
					<strong>AND</strong>
					<%=condition[j].toUpperCase() %>
					<%
								}
							}
						}
					%>
				</p>
				<button class="searchFormBtn" onclick="exportTableToCSV('logs.csv')">Export to
					CSV</button>
				<table class="searchQuery">
					<tr id="searchResultHeader">
						<%
							for (int j = 0; j < queryData.getColumnName().size(); j++) {
						%>
						<td><%=queryData.getColumnName().get(j).toUpperCase()%> <%
 	}
 %></td>
					</tr>
					<%
						int x = 0;
									for (int j = 0; j < queryData.getColumnData().size(); j++) {
										if (j % queryData.getColumnName().size() == 0) {
					%>
					<tr>
						<%
							}
						%>
						<td><%=queryData.getColumnData().get(j)%></td>
						<%
							x++;
											if (x == queryData.getColumnName().size()) {
						%>
					</tr>
					<%
						x = 0;
										}
									}
					%>

				</table>
				<%
					}
						}
					} else if (filterStatus != null && filterStatus.equals("noData")) {
				%>
				<p id="noData">We are unable to find anything that suits your query. Please check your conditions and try again.<br />If you think this
					is a mistake, please contact your system administrator.</p>
				<%
						String[] table = request.getParameterValues("table[]");
						String[] column = request.getParameterValues("column[]");
						String[] condition = request.getParameterValues("condition[]");
						int noOfQueriedItems = (Integer) request.getAttribute("noOfQueriedItems");
						if (noOfQueriedItems == 0) {
						} else {
							for (int i = 0; i < noOfQueriedItems; i++) {
								QueryData queryData = (QueryData) request.getAttribute("queryData" + i);
				%>
				<p>
					Your Query: <strong>SELECT</strong>
					<%=column[i].toUpperCase()%>
					<strong>FROM</strong> <span id="table"><%=table[i].toUpperCase()%></span>
					<%
						if (condition[i] != "") {
							for (int j = 0; j < condition.length; j++) {
								if (j == 0) {
									
					%>
					<strong>WHERE</strong>
					<%=condition[j].toUpperCase()%>
					<%
								} else {
					%>
					<strong>AND</strong>
					<%=condition[j].toUpperCase()%>
					<%
								}
							}
						}
							}
						}
					%>
				</p>
				<%
					}
				%>
			</div>
		</div>
	</div>

	<footer class="container-fluid text-center footer navbar-fixed-bottom">
	<p>Copyright &copy; 2017-2018 by The Four Horsemen, Singapore Polytechnic AY17/18 FYP Group 63 | DSO National
		Laboratories. All Rights Reserved.</p>
	</footer>

</body>

</html>