package model;

import theFourHorsemen.dbConnection;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class QueryDataManager {

	private Connection conn;

	public QueryDataManager() {
		super();
	}

	public QueryDataManager(HttpServletRequest request) {
		try {
			dbConnection db = new dbConnection(request);
			conn = db.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<String> getColumns(String table) {
		List<String> queryData = new ArrayList<String>();
		try {
			DatabaseMetaData metaData = conn.getMetaData();
			ResultSet metaDataRs = metaData.getColumns(null, null, table, null);

			while (metaDataRs.next()) {
				String columnName = metaDataRs.getString("COLUMN_NAME");
				queryData.add(columnName);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return queryData;
	}

	public ArrayList<QueryData> selectData(String host) {
		ArrayList<QueryData> queryData = new ArrayList<QueryData>();
		try {
			String selectDataSQL = "SELECT ? from test";
			PreparedStatement selectDataPstmt = conn.prepareStatement(selectDataSQL);
			selectDataPstmt.setString(1, host);
			ResultSet selectDataRs = selectDataPstmt.executeQuery();
			while (selectDataRs.next()) {
				int id = selectDataRs.getInt("id");
				String hostName = selectDataRs.getString("hostname");
				String timeStamp = selectDataRs.getString("timestamp");
				double riskFactor = selectDataRs.getDouble("riskfactor");
				String riskName = selectDataRs.getString("riskName");

				QueryData data = new QueryData(id, hostName, timeStamp, riskFactor, riskName);
				queryData.add(data);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return queryData;
	}

}
