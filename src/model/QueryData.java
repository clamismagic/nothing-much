package model;

import java.util.ArrayList;

public class QueryData {

	private ArrayList<String> columnName;
	private ArrayList<String> columnData;
	
	public QueryData() {
		super();
	}
	
	public QueryData(ArrayList<String> columnName, ArrayList<String> columnData) {
		this.columnName = columnName;
		this.columnData = columnData;
	}

	public ArrayList<String> getColumnName() {
		return columnName;
	}

	public void setColumnName(ArrayList<String> columnName) {
		this.columnName = columnName;
	}

	public ArrayList<String> getColumnData() {
		return columnData;
	}

	public void setColumnData(ArrayList<String> columnData) {
		this.columnData = columnData;
	}

}