package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Categoria;
import model.Ordine;
import model.Prodotto;
import model.Stato;
import dao.OrdineDAO;
import util.DriverManagerConnectionPool;

public class OrdineDAOImpl implements OrdineDAO{

	@Override
	public ArrayList<Ordine> doRetrieveAll() throws SQLException {
		ArrayList<Ordine> result = new ArrayList<>();
		String query="SELECT * FROM ordine";
		
		try(Connection con= DriverManagerConnectionPool.getConnection();
				PreparedStatement ps= con.prepareStatement(query)){
			
			ResultSet rs= ps.executeQuery();
			while(rs.next()) {
				Ordine o = mapper(rs);
				o.setTotale(calcolaTotale(o.getId()));
				result.add(o);
			}
		 } catch (SQLException e) {
	            e.printStackTrace();
	            throw e;
	        }
	        return result;
	}
	
	@Override
	public ArrayList<Ordine> doRetrieveByUtente(int utenteId) throws SQLException {
		ArrayList<Ordine> result = new ArrayList<>();
		String query = "SELECT * FROM ordine WHERE utente_id=? ORDER BY data_ordine DESC, id DESC";

		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, utenteId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Ordine o = mapper(rs);
				o.setTotale(calcolaTotale(o.getId()));
				result.add(o);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
		return result;
	}

	public int doSave(Ordine o) throws SQLException {
		String query = "INSERT INTO ordine (data_ordine, stato, utente_id) VALUES (?, ?, ?)";

		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS)) {

			ps.setDate(1, java.sql.Date.valueOf(o.getData()));
			ps.setString(2, o.getStato().name());
			ps.setInt(3, o.getUtenteId());

			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
		return 0;
	}

	public boolean doUpdateStatoByID(int id, Stato s) throws SQLException {
		
		String query="UPDATE ordine SET stato=? WHERE id=?";
		try(Connection con=DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)){
			ps.setInt(2, id);
			ps.setString(1, s.toString());
			ps.executeUpdate();
			return true;
			
		}catch(SQLException e) {
			return false;
		}
		
	}


	// Il totale non e' una colonna di 'ordine': si calcola sommando le righe dell'ordine
	private float calcolaTotale(int ordineId) throws SQLException {
		String query = "SELECT SUM(quantita * prezzo_acquistato) AS totale FROM rigaordine WHERE ordine_id=?";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, ordineId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getFloat("totale");
			}
		}
		return 0f;
	}

	private Ordine mapper(ResultSet rs) throws SQLException {
	    Ordine o = new Ordine();
	    o.setId(rs.getInt("id"));
	    
	    try {
	        java.sql.Date data = rs.getDate("data_ordine");
	        if (data == null) data = rs.getDate("data"); 
	        if (data != null) o.setData(data.toLocalDate());
	    } catch (Exception e) {
	        // Se fallisce la data, non bloccare il programma
	    }
	    	    
	    try {
	        String statoString = rs.getString("stato");
	        if (statoString != null) {
	            o.setStato(Stato.valueOf(statoString.trim().toUpperCase()));
	        }
	    } catch (Exception e) {
	        // Se l'enum fallisce perché la stringa nel DB non corrisponde, assegniamo il primo valore di default
	        o.setStato(Stato.IN_ELABORAZIONE); 
	    }
	        o.setUtenteId(rs.getInt("utente_id"));

	    return o;
	}
}
