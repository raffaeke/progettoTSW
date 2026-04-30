package util;
import java.sql.*;
public class ConnessioneMySQL {
    private static String url="jdbc:mysql://localhost:3306/kickoff";
    private static String user="root";
    private static String pass="progettoBD2026!";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, pass);
    }
}
