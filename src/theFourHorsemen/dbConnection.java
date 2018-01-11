package theFourHorsemen;

import javax.servlet.http.HttpServletRequest;
import java.sql.*;

public class dbConnection {

	Connection conn;

	public dbConnection(HttpServletRequest request) throws ClassNotFoundException, SQLException {
		super();
		// Step 1: Load JDBC Driver
		Class.forName("com.mysql.jdbc.Driver");
		// Step 2: Define Connection URL
		String connURL = request.getServletContext().getInitParameter("jdbcURL");
		String connUser = request.getServletContext().getInitParameter("mysqlUser");
		String connPassword = request.getServletContext().getInitParameter("mysqlPassword");
		// Step 3: Establish connection to URL
		conn = DriverManager.getConnection(connURL + "?user=" + connUser + "&password=" + connPassword);
	}

	public Connection getConnection() {
		return conn;
	}

}
