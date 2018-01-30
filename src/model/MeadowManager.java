package model;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import theFourHorsemen.dbConnection;

public class MeadowManager {
	
	private Connection conn;
	
	public MeadowManager() {
		super();
	}
	
	public MeadowManager(HttpServletRequest request) {
		try {
			dbConnection db = new dbConnection(request);
			conn = db.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Meadow genHost(HttpServletRequest request, String fiveMinBefore, String currentTime, String[] checkboxes) {
		Meadow meadow = new Meadow();
		List<String> allHosts = new ArrayList<String>();
		HashMap<String, String> allhostrisks = new HashMap<String, String>(); //link hostname to all risk factors
		List<String> toPassXYcoords = new ArrayList<>();
		try {
			HostGenSQL hostGenSQL = new HostGenSQL(request);
			allHosts = hostGenSQL.hostname(fiveMinBefore, currentTime);
			int degrees = 0, count = 0;
			HashMap<String, int[]> posofhostoncanvas = new HashMap<String, int[]>();
			for (String risk : checkboxes) {
				System.out.println("Servlet: " + risk);
			}
			//String[] checkboxes = {"Periodic Start Process", "Unusual Host-Internal IP"}; // TODO
			for (String singlehostentry : allHosts) {
				StringBuilder allvalues = new StringBuilder();
				HashMap<String, String> riskfactorpos = new HashMap<String, String>(); //link riskname to risk value (petal)
				Double avgRisk = 0.0;
				//TODO execute query based on checkbox options (probably done below?)
				for (int i = 0; i < checkboxes.length; i++) {
					double risk = hostGenSQL.popRisk(checkboxes[i], singlehostentry);
					System.out.println(risk);
					avgRisk += risk;
					String values = ""; // store coordinates for petal
					values = HostGeneration.calcRiskFactor(risk, i);
					riskfactorpos.put(checkboxes[i], values);
					}
				System.out.println(checkboxes.length);
				// fill in missing petals with dummy coords for SVG generation
				for (int i = 0; i < 5 - checkboxes.length; i++) {
					riskfactorpos.put("dummy" + i, "10,10");
				}

				int curIndex = 0;
				for (Map.Entry<String, String> entry : riskfactorpos.entrySet()) {
					switch(curIndex) {
					case 0:
					case 3:
					case 5:
					case 7:
						allvalues.append(entry.getValue() + " ");
					case 1:
					case 4:
					case 6:
					case 8:
						allvalues.append("10,10 ");
						curIndex += 2;
						break;
					case 2:
						allvalues.append(entry.getValue() + " ");
						curIndex++;
					}
				}
				avgRisk /= checkboxes.length;
				int distance = (int) Math.sqrt((((1 - avgRisk) / 2) * 800 * 400 / Math.PI)) + 20;
				int[] currenthostcords = null;
				int attemptCoord = 0;
				while (currenthostcords == null) {
					if (attemptCoord++ >= 3) {
						break;
					}
					currenthostcords = HostGeneration.generatexypos(degrees % 360, distance, posofhostoncanvas);
					degrees += 5;
				}
				if (currenthostcords != null) {
					toPassXYcoords.add(singlehostentry + "=" + currenthostcords[0] + "," + currenthostcords[1]);
					posofhostoncanvas.put(singlehostentry, currenthostcords);
					allhostrisks.put(singlehostentry, allvalues.toString());
					System.out.println("End of host " + singlehostentry);
					System.out.println();
				}
			}
			
		/*	toPassXYcoords.add("centre=400,200");
			allhostrisks.put("centre", "10,0 10,10 20,10 0,10 10,10 4,18 10,10 16,18 10,10");
			allHosts.add("centre"); */
		} catch (Exception e) {
			e.printStackTrace();
		}
		meadow.setToPassXYcoords(toPassXYcoords);
		meadow.setAllHostRisks(allhostrisks);
		meadow.setAllHosts(allHosts);
		return meadow;
	}

}
