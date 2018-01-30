<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />

<title>Error - The Four Horsemen</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet" type="text/css"
	href="css/bootstrap/bootstrap.min.css" />

<!-- Custom styles for this template -->
<link rel="stylesheet" href="css/simple-sidebar.css" />

<!-- jQuery for form update -->
<script src="http://code.jquery.com/jquery-1.11.1.js"
	type="text/javascript"></script>
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
				<h1 id="errortitle">OOPS :&#40</h1>
				<p class="errorcontent">It seems that we met a problem while
					processing your request. If the issue persists, please inform the
					web administrator.</p>
				<p class="errorcontent" id="errorthankyou">Sorry for any
					inconvenience caused.</p>
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