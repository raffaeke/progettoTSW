package model;
import java.sql.*;
import util.ConnessioneMySQL;
public class UtenteDAO {
	public Utente doRetrieveByEmailPassword(String email, String password) {
        String query = "SELECT * FROM utente WHERE email = ? AND password_hash = ?";
        
        try (Connection con = ConnessioneMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapper(rs); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
	
	public boolean doSave(Utente utente) {
        String query = "INSERT INTO utente (username, email, password_hash, indirizzo, ruolo) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = ConnessioneMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, utente.getUsername());
            ps.setString(2, utente.getEmail());
            ps.setString(3, utente.getPassword());
            ps.setString(4, utente.getIndirizzo());
            ps.setString(5, utente.getRuolo().name());

            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
        	e.printStackTrace();
           return false;
        }
    }
	
	private Utente mapper(ResultSet rs) throws SQLException {
        Utente u = new Utente();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password_hash"));
        u.setIndirizzo(rs.getString("indirizzo"));
        u.setRuolo(Ruolo.valueOf(rs.getString("ruolo")));
        return u;
    }
}
