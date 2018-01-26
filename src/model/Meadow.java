package model;

import java.util.HashMap;
import java.util.List;

public class Meadow {
	
	private HashMap<String, String> allHostRisks;
	
	private List<String> toPassXYcoords;
	
	private List<String> allHosts;
	
	public Meadow() {
		super();
	}
	
	public Meadow(HashMap<String, String> allHostRisks, List<String> toPassXYcoords, List<String>allHosts) {
		
	}

	public HashMap<String, String> getAllHostRisks() {
		return allHostRisks;
	}

	public void setAllHostRisks(HashMap<String, String> allHostRisks) {
		this.allHostRisks = allHostRisks;
	}

	public List<String> getToPassXYcoords() {
		return toPassXYcoords;
	}

	public void setToPassXYcoords(List<String> toPassXYcoords) {
		this.toPassXYcoords = toPassXYcoords;
	}

	public List<String> getAllHosts() {
		return allHosts;
	}

	public void setAllHosts(List<String> allHosts) {
		this.allHosts = allHosts;
	}

}
