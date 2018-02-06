package model;

public class ChartTable {
	
	private int noOfPackets;
	private String IP;
	
	public ChartTable() {
		super();
	}
	
	public ChartTable(int noOfPackets, String IP) {
		this.noOfPackets = noOfPackets;
		this.IP = IP;
	}

	public int getNoOfPackets() {
		return noOfPackets;
	}

	public void setNoOfPackets(int noOfPackets) {
		this.noOfPackets = noOfPackets;
	}

	public String getIP() {
		return IP;
	}

	public void setIP(String iP) {
		IP = iP;
	}

}
