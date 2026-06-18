package util;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DriverManagerConnectionPool {
	private static DataSource ds;

    static {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            ds = (DataSource) envCtx.lookup("jdbc/MyDB"); 
        } catch (NamingException e) {
            System.err.println("Errore nella configurazione del DataSource JNDI: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        if (ds == null) {
            throw new SQLException("DataSource non inizializzato correttamente.");
        }
        return ds.getConnection();
    }
}

