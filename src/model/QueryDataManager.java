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

	public QueryData getData(String column, String table) {
		int counter = 1;
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
				if (counter >= 50) {
					break;
				}
				counter++;
			}
			queryData.setColumnName(columnName);
			queryData.setColumnData(columnData);
			return queryData;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public QueryData getData(String column, String table, String[] condition) {
		int counter = 1;
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
			String selectDataSQL = "SELECT " + column + " FROM " + table + " WHERE ";
			for (int i = 0; i < condition.length; i++) {
				if (i == 0) {
					selectDataSQL += condition[i];
				} else {
					selectDataSQL += " AND " + condition[i];
				}
			}
			PreparedStatement selectDataPstmt = conn.prepareStatement(selectDataSQL);
			ResultSet selectDataRs = selectDataPstmt.executeQuery();
			while (selectDataRs.next()) {
				for (int i = 0; i < columnName.size(); i++) {
					columnData.add(selectDataRs.getObject(columnName.get(i)).toString());
				}
				if (counter >= 50) {
					break;
				}
				counter++;
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
