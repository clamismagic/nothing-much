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
	$(document).ready(function() {

		$("#table").change(function(data) {
			var table = $("select#table").val();
			$.get('searchServlet', {
				tableName : table
			}, function(response) {

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
		
		//here first get the contents of the div with name class copy-fields and add it to after "after-add-more" div class.
	      $(".add-more").click(function(){ 
	          var html = $(".copy-fields").html();
	          $(".after-add-more").after(html);
	      });
		//here it will remove the current value of the remove button which has been pressed
	      $("body").on("click",".remove",function(){ 
	          $(this).parents(".control-group").remove();
	      });

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
					<table id="searchForm" class="after-add-more">
						<tr>
							<td>SELECT TABLE*:</td>
							<td>
								<div class="searchDropdown">
									<select name="table" id="table">
										<option>---Select Table---</option>
										<%
											QueryDataManager queryDataManager = new QueryDataManager(request);
											ArrayList<String> tableName = queryDataManager.getTables();
											for (int i = 0; i < tableName.size(); i++) {
										%>
										<option><%=tableName.get(i)%></option>
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
									<select name="column" id="column">
										<option>---Select Table First---</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>CONDITION:</td>
							<td><input type="text" name="condition" id="condition"
								placeholder="Condition" /></td>
						</tr>
					</table>
					<button class="searchFormBtn add-more" type="button">Add</button>
					<p id="importantNote">*Compulsory fields.</p>
					<p>
						<input id="submitQuery" type="submit" value="Query" />
					</p>
				</form>
				<!-- Copy Fields-These are the fields which we get through jquery and then add after the above input as required-->
				<div class="copy-fields hide"><div class="control-group"><table id="searchForm">
					<tr>
						<td>SELECT TABLE*:</td>
						<td>
							<div class="searchDropdown">
								<select name="table" id="table">
									<option>---Select Table---</option>
									<%
										for (int i = 0; i < tableName.size(); i++) {
									%>
									<option><%=tableName.get(i)%></option>
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
								<select name="column" id="column">
									<option>---Select Table First---</option>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<td>CONDITION:</td>
						<td><input type="text" name="condition" id="condition"
							placeholder="Condition" /></td>
					</tr>
				</table>
				<button class="searchFormBtn remove" type="button">Remove</button>
				</div>
			</div>
			<div class="col-md-12">
				<h1>Search result</h1>
				<%
					String table = request.getParameter("table");
					String column = request.getParameter("column");
					String condition = request.getParameter("condition");
					if (filterStatus != null && filterStatus.equals("success1")) {
				%>
				<p>
					Query: <strong>SELECT</strong>
					<%=column%>
					<strong>FROM</strong>
					<%=table%></p>
				<table class="searchQuery">
					<%
						QueryData queryData = (QueryData) request.getAttribute("queryData");
					%>
					<tr id="searchResultHeader">
						<%
							for (int i = 0; i < queryData.getColumnName().size(); i++) {
						%>
						<td><%=queryData.getColumnName().get(i).toUpperCase()%> <%
 	}
 %>
					</tr>
					<%
						int x = 0;
							for (int i = 0; i < queryData.getColumnData().size(); i++) {
								if (i % queryData.getColumnName().size() == 0) {
					%>
					<tr>
						<%
							}
						%>
						<td><%=queryData.getColumnData().get(i)%></td>
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
					} else if (filterStatus != null && filterStatus.equals("success2")) {
				%>
				<p>
					Query: <strong>SELECT</strong>
					<%=column%>
					<strong>FROM</strong>
					<%=table%>
					<strong>WHERE</strong>
					<%=condition%></p>
				<table>
					<%
						QueryData queryData = (QueryData) request.getAttribute("queryData");
					%>
					<tr id="searchResultHeader">
						<%
							for (int i = 0; i < queryData.getColumnName().size(); i++) {
						%>
						<td><%=queryData.getColumnName().get(i).toUpperCase()%> <%
 	}
 %>
					</tr>
					<%
						int x = 0;
							for (int i = 0; i < queryData.getColumnData().size(); i++) {
								if (i % queryData.getColumnName().size() == 0) {
					%>
					<tr>
						<%
							}
						%>
						<td><%=queryData.getColumnData().get(i)%></td>
						<%
							x++;
									if (x == queryData.getColumnName().size()) {
						%>
					</tr>
					<%
						x = 0;
								}
							}
						}
					%>
				</table></div>
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

</body>
</html>