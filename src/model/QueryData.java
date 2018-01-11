package model;

public class QueryData {

	private String columnName;
	private int id;
	private String hostName;
	private String timeStamp;
	private double riskFactor;
	private String riskName;
	
	public QueryData() {
		super();
	}
	
	public QueryData(int id, String hostName, String timeStamp, double riskFactor, String riskName) {
		this.id = id;
		this.hostName = hostName;
		this.timeStamp = timeStamp;
		this.riskFactor = riskFactor;
		this.riskName = riskName;
	}

	public String getColumnName() {
		return columnName;
	}

	public int getId() {
		return id;
	}

	public String getHostName() {
		return hostName;
	}

	public String getTimeStamp() {
		return timeStamp;
	}

	public double getRiskFactor() {
		return riskFactor;
	}

	public String getRiskName() {
		return riskName;
	}

}
