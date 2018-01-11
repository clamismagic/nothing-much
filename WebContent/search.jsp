<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="theFourHorsemen.dbConnection" %>
<%
	// Create db connection
	dbConnection db = new dbConnection(request);
	Connection conn = db.getConnection();
%>
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
<script src="http://code.jquery.com/jquery-1.11.1.js" type="text/javascript"></script>
<script type = "text/javascript">
$(document).ready(function(){

	$("#table").change(function(data){
		var table = $("select#table").val();
		$.get('searchServlet', {
			tableName : table
		}, function(response){
			
			var select = $('#column');
			select.find('option').remove();
			if (table != "---Select Table---") {
				$('<option>').val("*").text("*").appendTo(select);
			}
			$.each(response, function(index, value) {
				$('<option>').val(value).text(value).appendTo(select);
			});
		});
	});
});
</script>
</head>
<body>

	<div id="wrapper">

		<!-- Sidebar -->
		<div id="sidebar-wrapper">
			<ul class="sidebar-nav">
				<li class="sidebar-brand"><a href="index.jsp"> The Four
						Horsemen </a></li>
				<li><a href="index.jsp">To the field</a></li>
				<li><a href="search.jsp">To find</a></li>
			</ul>
		</div>
		<!-- /#sidebar-wrapper -->

		<!-- Page Content -->
		<div id="page-content-wrapper">
			<div>
				<a href="#menu-toggle" class="btn btn-secondary menuAlign" id="menu-toggle">Menu</a>
				<img class="logo" alt="The Four Horsemen" src="images/logo.jpg" />
				<hr />
			</div>
			<div class="col-md-12">
				<h1>Find something</h1>
				<%
					String filterStatus = request.getParameter("status");
					if (filterStatus != null && filterStatus.equals("error")) {
				%>
				<p class="errorMessage">We are unable to locate what you are finding.</p>
				<%
					}else if (filterStatus != null && filterStatus.equals("error2")) {
				%>
				<p class="errorMessage">Please ensure all fills are filled up.</p>
				<%
					}
				%>
				<form method="post" action="search.jsp">
					<p>
						SELECT
						<select name="column" id="column">
							<option>---Select Table First---</option>
						</select>
						FROM <select name="table" id="table">
							<option>---Select Table---</option>
							<%
								String table = request.getParameter("table");
								DatabaseMetaData tableStmt = conn.getMetaData();
								ResultSet tableRs = tableStmt.getTables(null, null, "%", null);
								
								while (tableRs.next()) {
									String tableName = tableRs.getString(3);
							%>
							<option><%=tableName %></option>
							<%
								}
							%>
						</select>
						WHERE <input type="text" name="condition" placeholder="Condition"
						<%
							String condition = request.getParameter("condition");
						%>
						>
						<input type="submit" value="Query" />
					</p>
				</form>
				<hr />
			</div>
			<div class="col-md-12">
				<h1>Search result</h1>
				<%
					String column = request.getParameter("column");
					if (column == null || table == null) {
						out.println("Please enter your search query.");
					}
					else if (column != "" && table != "" && condition == null || condition == "") {
				%>
				<p>Query: <strong>SELECT</strong> <%=column %> <strong>FROM</strong> <%=table %></p>
				<table class="searchQuery">
				<%
					try {
					DatabaseMetaData metaData = conn.getMetaData();
					ResultSet metaDataRs = metaData.getColumns(null, null, table, null);
					ArrayList<String> columnName = new ArrayList<String>();
					ArrayList<String> col = new ArrayList<String>();

					while (metaDataRs.next()) {
						columnName.add(metaDataRs.getString("COLUMN_NAME"));
					}
					String selectDataSQL = "SELECT " + column +" FROM " + table;
					PreparedStatement selectDataPstmt = conn.prepareStatement(selectDataSQL);
					ResultSet selectDataRs = selectDataPstmt.executeQuery();
					while (selectDataRs.next()) {
						for (int i = 0; i < columnName.size(); i++) {
							col.add(selectDataRs.getObject(columnName.get(i)).toString());
						}
					}
				%>
					<tr>
					<%
						for (int i = 0; i < columnName.size(); i++) {
					%>
						<td><%=columnName.get(i) %>
					<%
						}
					%>
					</tr>
					<%
						int x = 0;
						for (int i = 0; i < col.size(); i++) {
							if (i % columnName.size() == 0) {
							%>
							<tr>
							<%
							}
					%>
						<td><%=col.get(i) %></td>
					<%
							x++;
							if (x == columnName.size()) {
							%>
							</tr>
							<%
								x = 0;
							}
						}
					} catch (Exception e) {
					%>
					<p class="errorMessage">No data found or the query entered is wrong.</p>
					<%
					}
					%>

				</table>
				<%
				} else {
				%>
				<p>Query: SELECT <%=column %> FROM <%=table %> WHERE <%=condition %></p>
				<table>
				<%
					try {
					DatabaseMetaData metaData = conn.getMetaData();
					ResultSet metaDataRs = metaData.getColumns(null, null, table, null);
					ArrayList<String> columnName = new ArrayList<String>();
					ArrayList<String> col = new ArrayList<String>();

					while (metaDataRs.next()) {
						columnName.add(metaDataRs.getString("COLUMN_NAME"));
					}
					String selectDataSQL = "SELECT " + column + " FROM " + table + " WHERE " + condition;
					PreparedStatement selectDataPstmt = conn.prepareStatement(selectDataSQL);
					ResultSet selectDataRs = selectDataPstmt.executeQuery();
					while (selectDataRs.next()) {
						for (int i = 0; i < columnName.size(); i++) {
							col.add(selectDataRs.getObject(columnName.get(i)).toString());
						}
					}
				%>
					<tr>
					<%
						for (int i = 0; i < columnName.size(); i++) {
					%>
						<td><%=columnName.get(i) %>
					<%
						}
					%>
					</tr>
					<%
						int x = 0;
						for (int i = 0; i < col.size(); i++) {
							if (i % columnName.size() == 0) {
							%>
							<tr>
							<%
							}
					%>
						<td><%=col.get(i) %></td>
					<%
							x++;
							if (x == columnName.size()) {
							%>
							</tr>
							<%
								x = 0;
							}
						}
					} catch (Exception e) {
					%>
					<p class="errorMessage">Please try again.</p>
					<%
					}
					%>
				<%
				}
				%>
				</table>
			</div>
		</div>
		<!-- /#page-content-wrapper -->

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
	
	<%
		conn.close();
	%>

</body>
</html>