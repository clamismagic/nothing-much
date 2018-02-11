package model;

import theFourHorsemen.dbConnection;

import javax.servlet.http.HttpServletRequest;

import java.io.FileWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
		List<String> columns = new ArrayList<String>();
		try {
			DatabaseMetaData metaData = conn.getMetaData();
			ResultSet metaDataRs = metaData.getColumns(null, null, table, null);

			while (metaDataRs.next()) {
				String columnName = metaDataRs.getString("COLUMN_NAME");
				columns.add(columnName);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return columns;
	}

	public QueryData getData(String column, String table) {
		int counter = 1;
		QueryData queryData = new QueryData();
		ArrayList<String> allTables = new ArrayList<String>();
		ArrayList<String> columnName = new ArrayList<String>();
		ArrayList<String> columnData = new ArrayList<String>();
		try {
			boolean validateStatus = validation(table, column);
			if (validateStatus == false) {
				return null;
			}
			allTables = getTables();
			for (int i = 0; i < allTables.size(); i++) {
				if (table.equals(allTables.get(i))) {
					break;
				} else if (i == allTables.size()-1) {
					return null;
				}
			}
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
			boolean validateStatus = validation(table, column, condition);
			if (validateStatus == false) {
				return null;
			}
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
	
	public String exportAllData(String column, String table) {
		String output = "";
		ArrayList<String> allTables = new ArrayList<String>();
		ArrayList<String> columnName = new ArrayList<String>();
		try {
			boolean validateStatus = validation(table, column);
			if (validateStatus == false) {
				return null;
			}
			allTables = getTables();
			for (int i = 0; i < allTables.size(); i++) {
				if (table.equals(allTables.get(i))) {
					break;
				} else if (i == allTables.size()-1) {
					return null;
				}
			}
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
			for (int i = 0; i < columnName.size(); i++) {
				if (i == columnName.size()-1) {
					output += columnName.get(i).toString().toUpperCase() + "\n";
				} else {
					output += columnName.get(i).toString().toUpperCase() + ",";
				}
			}
			String selectDataSQL = "SELECT " + column + " FROM " + table;
			PreparedStatement selectDataPstmt = conn.prepareStatement(selectDataSQL);
			ResultSet selectDataRs = selectDataPstmt.executeQuery();
			while (selectDataRs.next()) {
				for (int i = 0; i < columnName.size(); i++) {
					if (i == columnName.size()-1) {
						output += selectDataRs.getObject(columnName.get(i).toString()) + "\n";
					} else {
						output += selectDataRs.getObject(columnName.get(i).toString()) + ",";
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return output;
	}

	public String exportAllData(String column, String table, String[] condition) {
		String output = "";
		ArrayList<String> columnName = new ArrayList<String>();
		ArrayList<String> columnData = new ArrayList<String>();
		try {
			boolean validateStatus = validation(table, column, condition);
			if (validateStatus == false) {
				return null;
			}
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
			for (int i = 0; i < columnName.size(); i++) {
				if (i == columnName.size()-1) {
					output += columnName.get(i).toString().toUpperCase() + "\n";
				} else {
					output += columnName.get(i).toString().toUpperCase() + ",";
				}
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
					if (i == columnName.size()-1) {
						output += selectDataRs.getObject(columnName.get(i).toString()) + "\n";
					} else {
						output += selectDataRs.getObject(columnName.get(i).toString()) + ",";
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return output;
	}
	
	private boolean validation(String table, String column) {
		ArrayList<String> allTables = new ArrayList<String>();
		List<String> allColumns = new ArrayList<String>();
		allTables = getTables();
		for (int i = 0; i < allTables.size(); i++) {
			if (table.equals(allTables.get(i))) {
				allColumns = getColumns(table);
				if (column.equals("*")) {
					return true;
				} else {
					for (int j = 0; j < allColumns.size(); j++) {
						if (column.equals(allColumns.get(j))) {
							return true;
						}
					}
					return false;
				}
			} else if (i == allTables.size()-1) {
				return false;
			}
		}
		return false;
	}
	
	private boolean validation(String table, String column, String[] condition) {
		ArrayList<String> allTables = new ArrayList<String>();
		List<String> allColumns = new ArrayList<String>();
		allTables = getTables();
		for (int i = 0; i < allTables.size(); i++) {
			if (table.equals(allTables.get(i))) {
				allColumns = getColumns(table);
				if (column.equals("*")) {
					for (int k = 0; k < condition.length; k++) {
						if (condition[k] == null || condition[k].trim().isEmpty()) {
					         return false;
					     }
					     Pattern pattern = Pattern.compile("[^A-Za-z0-9\\_<>=+!*'\".\\- ]");
					     Matcher matcher = pattern.matcher(condition[k]);
					    // boolean b = m.matches();
					     boolean status = matcher.find();
					     if (status == true) {
					    	 return false;
					     } else {
					         return true;
					     }
					}
				} else {
					for (int j = 0; j < allColumns.size(); j++) {
						if (column.equals(allColumns.get(j))) {
							for (int k = 0; k < condition.length; k++) {
								if (condition[k] == null || condition[k].trim().isEmpty()) {
							         return false;
							     }
							     Pattern pattern = Pattern.compile("[^A-Za-z0-9\\_<>=+!*'\".\\- ]");
							     Matcher matcher = pattern.matcher(condition[k]);
							    // boolean b = m.matches();
							     boolean status = matcher.find();
							     if (status == true) {
							    	 return false;
							     } else {
							         return true;
							     }
							}
						}
					}
					return false;
				}
			} else if (i == allTables.size()-1) {
				return false;
			}
		}
		return false;
	}

}
