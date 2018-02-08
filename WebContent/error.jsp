<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.QueryDataManager"%>
<%@ page import="model.QueryData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title>Error - Laminae</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

	<!-- Favicon -->
    <link rel="icon" type="image/png" href="images/favicon-196x196.png" sizes="196x196" />
	<link rel="icon" type="image/png" href="images/favicon-96x96.png" sizes="96x96" />
	<link rel="icon" type="image/png" href="images/favicon-32x32.png" sizes="32x32" />
	<link rel="icon" type="image/png" href="images/favicon-16x16.png" sizes="16x16" />
	<link rel="icon" type="image/png" href="images/favicon-128.png" sizes="128x128" />

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
</head>

<body>

	<jsp:include page="header.html"></jsp:include>

	<div class="container-fluid text-center">
		<div class="row content">
			<div class="col-md-12 alignMiddle">
				<h1 id="errortitle">OOPS :&#40</h1>
				<p class="errorcontent">It seems that we met a problem while
					processing your request. If the issue persists, please inform the
					web administrator.</p>
				<p class="errorcontent" id="errorthankyou">Sorry for any
					inconvenience caused.</p>
			</div>
		</div>
	</div>

	<jsp:include page="footer.html"></jsp:include>

</body>

</html>