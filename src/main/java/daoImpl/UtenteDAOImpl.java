package daoImpl;
import model.Utente;
import dao.UtenteDAO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import util.DriverManagerConnectionPool;
public class UtenteDAOImpl	implements UtenteDAO {
	public Utente doRetrieveByEmailPassword(String email, String password) {
        String query = "SELECT * FROM utente WHERE email = ? AND password_hash = ?";
        
        try (Connection con = DriverManagerConnectionPool.getConnection();
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
        String query = "INSERT INTO utente (nome, cognome, email, password_hash, indirizzo, provincia, paese) VALUES (?, ?, ?, ?, ?,?,?)";
        
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getEmail());
            ps.setString(4, utente.getPassword());
            ps.setString(5, utente.getIndirizzo());
            ps.setString(6, utente.getProvincia());
            ps.setString(7, utente.getPaese());

            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
        	e.printStackTrace();
           return false;
        }
    }
	
	public boolean doUpdate(Utente utente) {
        String query = "UPDATE utente SET nome = ?, cognome = ?, indirizzo = ?, provincia = ?, paese = ? WHERE id = ?";

        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getIndirizzo());
            ps.setString(4, utente.getProvincia());
            ps.setString(5, utente.getPaese());
            ps.setInt(6, utente.getId());

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
        u.setNome(rs.getString("nome"));
        u.setCognome(rs.getString("cognome"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password_hash"));
        u.setIndirizzo(rs.getString("indirizzo"));
        u.setProvincia(rs.getString("provincia"));
        u.setPaese(rs.getString("paese"));
        return u;
    }
	
	public List<Utente> doRetrieveAll(){
		 String query = "SELECT * FROM utente";
	        List<Utente> result= new ArrayList<>();
	        try (Connection con = DriverManagerConnectionPool.getConnection();
	             PreparedStatement ps = con.prepareStatement(query)) {
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                result.add(mapper(rs)); 
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return result;
	}
	public Utente doRetrieveById(int id)throws SQLException{
		String query = "SELECT * FROM utente WHERE id= ?";
        
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapper(rs); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
	}
}
