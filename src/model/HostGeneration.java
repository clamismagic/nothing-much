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

		public static int[] calcCoords (int degrees, int distance) {
			int[] changexy = null;
			int angle = 0;
			if (degrees<90) {
				angle = 90-degrees;
				changexy = new int[]{1,-1};
				/*changexy[0] = 1;
				changexy[1] = -1;*/
			} else if (degrees<180) {
				angle = degrees-90;
				changexy = new int[]{1,1};
			} else if (degrees<270) {
				angle = 270-degrees;
				changexy = new int[]{-1,1}; 
			} else {
				angle = degrees-270;
				changexy = new int[]{-1,-1};
			}
			
			return new int[] {(int)(400+(distance*Math.cos(Math.toRadians(angle))*changexy[0])),
			        (int)(300+(distance*Math.sin(Math.toRadians(degrees))*changexy[1]))};
			
		}
		
		public static int[] generatexypos(int degrees, int distance, HashMap<String,int[]> hostcoords) {
			int[] tocheck = calcCoords(degrees, distance);
			for(HashMap.Entry<String, int[]> currentcoords: hostcoords.entrySet()) {
				int[] existingcoords = currentcoords.getValue();
				if (Math.abs(tocheck[0]-existingcoords[0])<20 && Math.abs(tocheck[1]-existingcoords[1])<20) {
					return null;
				}
			}
			return tocheck;
			
		}
}
