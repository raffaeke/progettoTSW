package util;
import java.sql.*;
public class ConnessioneMySQL {
    private static String url="jdbc:mysql://localhost:3306/kickoff";
    private static String user="kickoff_user";
    private static String pass="1234";

    public static Connection getConnection() throws SQLException {
    	 try {
    	        Class.forName("com.mysql.cj.jdbc.Driver");
    	    } catch (ClassNotFoundException e) {
    	        e.printStackTrace();
    	    }

    	    return DriverManager.getConnection(url, user, pass);
    }
}
