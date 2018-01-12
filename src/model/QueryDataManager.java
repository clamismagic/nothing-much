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

	public ArrayList<String> getTables() {
		ArrayList<String> tables = new ArrayList<String>();
		try {
			DatabaseMetaData tableStmt = conn.getMetaData();
			ResultSet tableRs = tableStmt.getTables(null, null, "%", null);

			while (tableRs.next()) {
				String tableName = tableRs.getString(3);
				tables.add(tableName);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return tables;
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

	/*
	 * public ArrayList<QueryData> selectData(String host) { ArrayList<QueryData>
	 * queryData = new ArrayList<QueryData>(); try { String selectDataSQL =
	 * "SELECT ? from test"; PreparedStatement selectDataPstmt =
	 * conn.prepareStatement(selectDataSQL); selectDataPstmt.setString(1, host);
	 * ResultSet selectDataRs = selectDataPstmt.executeQuery(); while
	 * (selectDataRs.next()) { int id = selectDataRs.getInt("id"); String hostName =
	 * selectDataRs.getString("hostname"); String timeStamp =
	 * selectDataRs.getString("timestamp"); double riskFactor =
	 * selectDataRs.getDouble("riskfactor"); String riskName =
	 * selectDataRs.getString("riskName");
	 * 
	 * QueryData data = new QueryData(id, hostName, timeStamp, riskFactor,
	 * riskName); queryData.add(data); } } catch (Exception e) {
	 * e.printStackTrace(); }
	 * 
	 * return queryData; }
	 */

	public QueryData getData(String column, String table) {
		QueryData queryData = new QueryData();
		ArrayList<String> columnName = new ArrayList<String>();
		ArrayList<String> columnData = new ArrayList<String>();
		try {
			DatabaseMetaData metaData = conn.getMetaData();
			ResultSet metaDataRs;
			if (column.equals("*")) {
				metaDataRs = metaData.getColumns(null, null, table, null);
			} else {
				metaDataRs = metaData.getColumns(null, null, table, column);
			}

			while (metaDataRs.next()) {
				columnName.add(metaDataRs.getString("COLUMN_NAME"));
			}
			String selectDataSQL = "SELECT " + column + " FROM " + table;
			PreparedStatement selectDataPstmt = conn.prepareStatement(selectDataSQL);
			ResultSet selectDataRs = selectDataPstmt.executeQuery();
			while (selectDataRs.next()) {
				for (int i = 0; i < columnName.size(); i++) {
					columnData.add(selectDataRs.getObject(columnName.get(i)).toString());
				}
			}
			queryData.setColumnName(columnName);
			queryData.setColumnData(columnData);
			return queryData;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public QueryData getData(String column, String table, String condition) {
		QueryData queryData = new QueryData();
		ArrayList<String> columnName = new ArrayList<String>();
		ArrayList<String> columnData = new ArrayList<String>();
		try {
			DatabaseMetaData metaData = conn.getMetaData();
			ResultSet metaDataRs;
			if (column.equals("*")) {
				metaDataRs = metaData.getColumns(null, null, table, null);
			} else {
				metaDataRs = metaData.getColumns(null, null, table, column);
			}

			while (metaDataRs.next()) {
				columnName.add(metaDataRs.getString("COLUMN_NAME"));
			}
			String selectDataSQL = "SELECT " + column + " FROM " + table + " WHERE " + condition;
			PreparedStatement selectDataPstmt = conn.prepareStatement(selectDataSQL);
			ResultSet selectDataRs = selectDataPstmt.executeQuery();
			while (selectDataRs.next()) {
				for (int i = 0; i < columnName.size(); i++) {
					columnData.add(selectDataRs.getObject(columnName.get(i)).toString());
				}
			}
			queryData.setColumnName(columnName);
			queryData.setColumnData(columnData);
			return queryData;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

}
