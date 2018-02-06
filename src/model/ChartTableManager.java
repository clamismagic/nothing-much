package model;

import theFourHorsemen.dbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

public class ChartTableManager {
	
	private static Connection conn;
	
	public ChartTableManager() {
		super();
	}
	
	public ChartTableManager(HttpServletRequest request) {
		try {
			dbConnection db = new dbConnection(request);
			conn = db.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static ArrayList<ChartTable> countAllPackets(String table) {
		ArrayList<ChartTable> chartTableList = new ArrayList<ChartTable>();
		try {
			System.out.println(table);
			String countPacketSql = "SELECT REMOTE_IP, COUNT(REMOTE_IP) AS noOfPackets FROM " + table;
			PreparedStatement countPacketPstmt = conn.prepareStatement(countPacketSql);
			ResultSet countPacketRs = countPacketPstmt.executeQuery();
			while (countPacketRs.next()) {
				ChartTable chartTable = new ChartTable();
				chartTable.setIP(countPacketRs.getString("REMOTE_IP"));
				chartTable.setNoOfPackets(countPacketRs.getInt("noOfPackets"));
				chartTableList.add(chartTable);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return chartTableList;
	}

}
