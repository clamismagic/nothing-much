<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.QueryDataManager"%>
<%@ page import="model.QueryData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title>Query - Laminae</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Favicon -->
<link rel="icon" type="image/png" href="images/favicon-196x196.png"
	sizes="196x196" />
<link rel="icon" type="image/png" href="images/favicon-96x96.png"
	sizes="96x96" />
<link rel="icon" type="image/png" href="images/favicon-32x32.png"
	sizes="32x32" />
<link rel="icon" type="image/png" href="images/favicon-16x16.png"
	sizes="16x16" />
<link rel="icon" type="image/png" href="images/favicon-128.png"
	sizes="128x128" />

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

<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    
 <!--   <script>
  $( function() {
    $( ".widget input[type=submit], .widget a, .widget button" ).button();
    $( "button, input, a" ).click( function( event ) {
      event.preventDefault();
    } );
  } );
  </script> -->
</head>

<body>

	<jsp:include page="header.html"></jsp:include>

	<div class="container-fluid text-center">
		<div class="row content">
			<div class="col-md-12">
				<h1>
					Find something
				</h1>
				<%
					String filterStatus = request.getParameter("status");
					if (filterStatus != null && filterStatus.equals("error")) {
				%>
				<p class="errorMessage">We are unable to locate anything that
					suits your query, please ensure that all your entries are valid.</p>
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
					<div class="search" id="queryForm">
						<table id="searchForm0" class="searchForm">
						<p><button class="ui-button ui-widget ui-corner-all searchFormBtn add-more" type="button" onclick=<%statementCount++;%>>Add Condition</button></p>
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
								<td><input type="text" name="condition[]" class="condition"
									id="condition0" placeholder="Condition" /></td>
							</tr>
						</table>
					</div>
					<%
						request.setAttribute("statementCount", statementCount);
					%>
					<p id="importantNote">*Compulsory fields.</p>
					<p>
						<input id="submitQuery" type="submit" value="Query" />
					</p>
				</form>
			</div>
			<div class="col-md-12" id="results">
			<%
				if (filterStatus != null) {
			%>
				<h1>Search result</h1>
				<%
					if (filterStatus.equals("success")) {
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
					<%=condition[j].toUpperCase()%>
					<%
						}
										}
									}
					%>
				</p>
				<form action="exportServlet" method="post">
					<input type="hidden" value="<%=table[i] %>" name="table" />
					<input type="hidden" value="<%=column[i] %>" name="column" />
					<%
						if (condition[i] != "") {
							for (int j = 0; j < condition.length; j++) {
					%>
					<input type="hidden" value="<%=condition[j] %>" name="condition[]" />
					<%
							}
						}
					%>
					<input type="submit" class="searchFormBtn" value="Export to CSV" />
				</form>
				<!-- <button class="searchFormBtn" onclick="exportTableToCSV('logs.csv')">Export
					to CSV</button> -->
				<table class="search">
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
				<p id="noData">
					We are unable to find anything that suits your query. Please check
					your conditions and try again.<br />If you think this is a
					mistake, please contact your system administrator.
				</p>
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
					}}
				%>
			</div>
		</div>
	</div>

	<jsp:include page="footer.html"></jsp:include>

</body>

</html>