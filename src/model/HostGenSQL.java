package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import theFourHorsemen.dbConnection;
import model.*;


public class HostGenSQL {
	private Connection conn;

	public HostGenSQL() {
		super();
	}

	public HostGenSQL(HttpServletRequest request) {
		try {
			dbConnection db = new dbConnection(request);
			conn = db.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public PreparedStatement listdata() {
	      PreparedStatement alldata = null;
	      try {
			alldata = conn.prepareStatement("select * from test");
	  	} catch (SQLException e) {
	  		// TODO Auto-generated catch block
	  		e.printStackTrace();
	  	}
	      return alldata;
	   }


	public PreparedStatement riskcheckbyhostandrisk() throws SQLException {
		PreparedStatement checkriskbyhostandrisk = conn.prepareStatement("select riskfactor from test where hostname = '?' and riskname = '?'");

		return checkriskbyhostandrisk;
	}

	public PreparedStatement riskcheckbyhost() throws SQLException {
		PreparedStatement checkriskbyhost = conn.prepareStatement("select riskfactor from test where hostname = '?'");

		return checkriskbyhost;
	}

	public PreparedStatement hostname() throws SQLException {
		PreparedStatement hostname = null;
		try {
			hostname = conn.prepareStatement("select distinct hostname from test");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return hostname;
		
	}

	   
}
