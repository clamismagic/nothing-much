<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.QueryDataManager"%>
<%@ page import="model.QueryData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />

<title>Search the field - The Four Horsemen</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet" type="text/css"
	href="css/bootstrap/bootstrap.min.css" />

<!-- Custom styles for this template -->
<link rel="stylesheet" href="css/simple-sidebar.css" />

<!-- jQuery for form update -->
<script src="http://code.jquery.com/jquery-1.11.1.js"
	type="text/javascript"></script>
<script type="text/javascript">
	/*$("#table").change(function(data)*/function change(data) {
		//var table = $("select#table").val();
		var idx = data.selectedIndex;
		var table = data.options[idx].value;
		var id = data.id;
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
				var regex = /^(.+?)(\d+)$/i;
				var cloneIndex = $(".searchForm").length;

				$('.search').on('click', 'button.add-more', clone);

				function clone() {
					$(this).parents(".searchForm").clone().appendTo(".search")
							.attr("id", "searchForm" + cloneIndex).find("*")
							.each(function() {
								var id = this.id || "";
								var match = id.match(regex) || [];
								if (match.length == 3) {
									this.id = match[1] + (cloneIndex);
								}
							})
					cloneIndex++;
				}
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
			<div class="col-md-12">
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
				<form method="post" action="searchServlet">
					<div class="search">
						<table id="searchForm1" class="searchForm">
							<tr>
								<td>SELECT TABLE*:</td>
								<td>
									<div class="searchDropdown">
										<%
											int statementCount = 0;
										%>
										<select name="table[]" class="table" id="<%=statementCount%>"
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
										<select name="column[]" id="column<%=statementCount%>">
											<option>---Select Table First---</option>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td>CONDITION:</td>
								<td><input type="text" name="condition[]" id="condition"
									placeholder="Condition" /></td>
								<%
									statementCount++;
								%>
							</tr>
							<tr>
								<td>
									<button class="searchFormBtn add-more" type="button">Add</button>
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
						int resultCount = (Integer) request.getAttribute("statementCount");
						String[] table = request.getParameterValues("table[]");
						String[] column = request.getParameterValues("column[]");
						String[] condition = request.getParameterValues("condition[]");
						System.out.println(statementCount + "," + resultCount);
						int noOfQueriedItems = (Integer) request.getAttribute("noOfQueriedItems");
						if (noOfQueriedItems == 0) {
						} else {
							for (int i = 0; i < noOfQueriedItems; i++) {
								QueryData queryData = (QueryData) request.getAttribute("queryData" + i);
				%>
				<p>
					Query: <strong>SELECT</strong>
					<%=column[i]%>
					<strong>FROM</strong>
					<%=table[i]%>
					<%
						if (condition[i] != "") {
					%>
					<strong>WHERE</strong>
					<%=condition[i]%>
					<%
						}
					%>
				</p>
				<%
					
				%>
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
					}
				%>
			</div>
		</div>
		<!-- /#page-content-wrapper -->

		<!-- Footer -->
		<jsp:include page="footer.html"></jsp:include>

	</div>
	<!-- /#wrapper -->

	<!-- Bootstrap core JavaScript -->
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap/bootstrap.bundle.min.js"></script>

	<!-- Menu Toggle Script -->
	<script>
		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});
	</script>
</body>
</html>