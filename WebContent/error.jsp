<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.QueryDataManager"%>
<%@ page import="model.QueryData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title>Error - The Four Horsemen</title>
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
			<a class="logo" href="index.html"><img src="images/logo_navbar.png"
				alt="Logo"></a>|||
		</div>
		<div class="collapse navbar-collapse" id="myNavbar">
			<ul class="nav navbar-nav">
				<li><a href="index.html">Home</a></li>
				<li><a href="meadow.jsp">Meadow</a></li>
				<li><a href="search.jsp">Query</a></li>
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

	<footer class="container-fluid text-center footer navbar-fixed-bottom">
	<p>Copyright &copy; 2017-2018 by The Four Horsemen, Singapore Polytechnic AY17/18 FYP Group 63 | DSO National
		Laboratories. All Rights Reserved.</p>
	</footer>

</body>

</html>