package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import theFourHorsemen.dbConnection;

public class HostGeneration {

	public static String calcRiskFactor(double risk, int i) {
		int x = 10, y = 10;
		StringBuilder values = new StringBuilder();
		switch (i) {
		case 0: // calculate coords toward top (12 o clock direction)
			y -= Math.round((risk * 10));
			values.append(x + "," + y);
			break;
		case 1: // calculate coords toward top right (2 o clock direction)
			x += Math.round(risk * 10);
			values.append(x + "," + y);
			break;
		case 2: // calculate coords toward bottom right (5 o clock direction)
			x += Math.round(risk * 10 * (Math.cos(Math.toRadians(53))));
			y += Math.round(risk * 10 * (Math.sin(Math.toRadians(53))));
			values.append(x + "," + y);
			break;
		case 3: // calculate coords toward bottom left (7 o clock direction)
			x -= Math.round(risk * 10 * (Math.cos(Math.toRadians(53))));
			y += Math.round(risk * 10 * (Math.sin(Math.toRadians(53))));
			values.append(x + "," + y);
			break;
		case 4: // calculate coords toward top left (10 o clock direction)
			x -= Math.round(risk * 10);
			values.append(x + "," + y);
			break;
		}
		return values.toString();
	}

	public static int[] calcCoords(int degrees, int distance) {
		int[] changexy = null;
		int angle = 0;
		if (degrees < 90) {
			angle = 90 - degrees;
			changexy = new int[] { 1, -1 };
		} else if (degrees < 180) {
			angle = degrees - 90;
			changexy = new int[] { 1, 1 };
		} else if (degrees < 270) {
			angle = 270 - degrees;
			changexy = new int[] { -1, 1 };
		} else {
			angle = degrees - 270;
			changexy = new int[] { -1, -1 };
		}

		return new int[] { (int) (400 + (distance * Math.cos(Math.toRadians(angle)) * changexy[0])),
				(int) (300 + (distance * Math.sin(Math.toRadians(angle)) * changexy[1])) };

	}

	public static int[] generatexypos(int degrees, int distance, HashMap<String, int[]> hostcoords) {
		int[] tocheck = calcCoords(degrees, distance);
		for (HashMap.Entry<String, int[]> currentcoords : hostcoords.entrySet()) {
			int[] existingcoords = currentcoords.getValue();
			if (Math.abs(tocheck[0] - existingcoords[0]) < 30 && Math.abs(tocheck[1] - existingcoords[1]) < 30) {
				return null;
			}
		}
		return tocheck;

	}

	
}
