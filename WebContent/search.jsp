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
				
			</div>
			<p id="importantNote">*Compulsory fields.</p>
			<p>
				<input id="submitQuery" type="submit" value="Query"
					onclick="generateIds()" />
			</p>
			</form>
			<div class="col-md-12">
				<h1>Search result</h1>
				<%
					int resultCount = (Integer) request.getAttribute("statementCount");
					String table = request.getParameter("table");
					String column = request.getParameter("column");
					String condition = request.getParameter("condition");
					System.out.println(statementCount + "," + resultCount);
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
 %></td>
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
 %></td>
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
				</table>
			</div>
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

	<script type="text/javascript">
		document.getElementById("submitQuery").addEventListener("click",
				function(event) {
					event.preventDefault();
				});

		function generateIds() {
			var divArray = document.getElementsByTagName("div"), iterate;
			console.log(divArray.length);
			for (var i = 0; i < divArray.length; i++) {
				//if (divArray[i] && /searchForm/.test(divArray[i].className) == 0) {
				console.log(divArray[i].className);
				//}
			}
		}
	</script>
</body>
</html>