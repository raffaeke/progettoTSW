package model.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.beans.Categoria;
import model.beans.Ordine;
import model.beans.Prodotto;
import model.beans.Stato;
import model.dao.OrdineDAO;
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
				result.add(mapper(rs));
			}
		 } catch (SQLException e) {
	            e.printStackTrace();
	            throw e;
	        }
	        return result;
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
