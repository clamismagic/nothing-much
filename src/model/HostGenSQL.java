package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import theFourHorsemen.dbConnection;


public class HostGenSQL {
	private Connection conn;

	public HostGenSQL() {
		super();
	}

	public HostGenSQL(HttpServletRequest request) throws Exception {
		dbConnection db = new dbConnection(request);
		conn = db.getConnection();
	}
	
	public PreparedStatement listdata() throws SQLException {
		return conn.prepareStatement("select * from test");
	}


	public PreparedStatement riskcheckbyhostandrisk() throws SQLException {
		return conn.prepareStatement("select riskfactor from riskoutput where hostname = ? and riskname = ? and timestamp between ? and ? order by timestamp");
		// select riskfactor from test where hostname = ? and riskname = ? and timestamp >= <insert 5 min before current time> order by timestamp
	}

	public List<String> hostname(String startTime, String endTime) {
		// actual implementation will use startTime and endTime
		List<String> allHosts = new ArrayList<String>();
		int count = 0;
		try {
			PreparedStatement pstmt = conn.prepareStatement("select distinct hostname from riskoutput where timestamp between ? and ? order by riskfactor desc");
			pstmt.setString(1, "2016-11-01 00:00:00");
			pstmt.setString(2, "2016-11-01 00:05:00");
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()) {
				if (count++ >= 90) {
					break;
				}
				allHosts.add(rs.getString(1));
			}
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return allHosts;
		
	}   
	public Double popRisk(String riskname, String singlehostentry) throws SQLException {
			PreparedStatement pstmt = riskcheckbyhostandrisk();
			pstmt.setString(1, singlehostentry);
			pstmt.setString(2, riskname);
			/*
			 * pstmt.setString(3, df.format(fiveMinBefore)); pstmt.setString(4,
			 * df.format(currentTime));
			 */
			pstmt.setString(3, "2016-11-01 00:00:00");
			pstmt.setString(4, "2016-11-01 00:05:00");
			ResultSet rsRiskFactor = pstmt.executeQuery();
			
			if (rsRiskFactor.next()) { // only take the latest result in the table
				return rsRiskFactor.getDouble("riskfactor");
			}
			return 0.0;
	}
	
	public ArrayList<String> distinctRiskname() throws SQLException {
		ArrayList<String> riskName = new ArrayList<>();
		PreparedStatement pstmt = conn.prepareStatement("select distinct riskname from riskoutput");
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
		riskName.add(rs.getString(1));
		}
		return riskName;
		
	}
}
