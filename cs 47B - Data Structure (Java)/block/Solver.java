import java.io.*;
import java.util.*;

public class Solver {
	public static void main(String[] args){
		
		System.out.println();
		
		String initFile = args[0];
		String goalFile = args[1];
		
		Tray tray = new Tray(initFile, -1, -1);
		//System.out.println(tray);
		
		Tray targetTray = new Tray(goalFile, tray.getRows(), tray.getCols());
		//System.out.println(targetTray);
		
		long initTime = System.currentTimeMillis();
		try{
			tray.solve(targetTray);
		}
		catch(IllegalStateException e){
			;
		}
		long endTime = System.currentTimeMillis();
		
		long delta = endTime - initTime;
		System.out.println("Time Required: " + Double.toString(delta) + "ms.");
	}
	
}
