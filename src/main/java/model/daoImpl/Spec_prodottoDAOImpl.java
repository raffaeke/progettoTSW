package model.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.beans.Categoria;
import model.dao.Spec_prodottoDAO;
import util.DriverManagerConnectionPool;

public class Spec_prodottoDAOImpl implements Spec_prodottoDAO{
	
	public List<String> doRetrieveDistinctTaglieByCategoria(Categoria c) throws SQLException{
		String query="SELECT DISTINCT s.taglia FROM spec_prodotto s JOIN prodotto p ON s.prodotto_id = p.id WHERE p.categoria = ? ORDER BY s.taglia";
		 List<String> result= new ArrayList<>();
	        try (Connection con = DriverManagerConnectionPool.getConnection();
	             PreparedStatement ps = con.prepareStatement(query)) {
	            ps.setString(1,c.toString());
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	                result.add(rs.getString("taglia")); 
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return result;
	}

	@Override
	public int doRetrieveQuantitaBySize(int id, String size) throws SQLException {
		String query="SELECT quantita FROM spec_prodotto WHERE prodotto_id=? AND taglia=?";
		
		try(Connection con= DriverManagerConnectionPool.getConnection();
				PreparedStatement ps= con.prepareStatement(query)){
			
			ps.setInt(1, id);
			ps.setString(2, size);
			ResultSet rs=ps.executeQuery();
			if(rs.next()) {
				return rs.getInt("quantita");
			}
			else return -1;
		}catch(SQLException e ) {
			e.printStackTrace();
			return -1;
		}
	}
	public void doDeleteByProductKey(int id)throws SQLException{
		String query="Delete from spec_prodotto where prodotto_id=?";
		try(Connection con= DriverManagerConnectionPool.getConnection();
				PreparedStatement ps= con.prepareStatement(query)){
			
			ps.setInt(1, id);
			ps.executeUpdate();
			
		}catch(SQLException e ) {
			e.printStackTrace();
		}
	}
	@Override
	public boolean doSave(int id, String size, int q) throws SQLException {
	    if (this.doRetrieveQuantitaBySize(id, size) != -1) {
	        return this.doUpdate(id, size, q);
	    } else {
	        String query = "INSERT INTO spec_prodotto(taglia, quantita, prodotto_id) VALUES(?, ?, ?)";
	        
	        // Lasciamo che le risorse si chiudano da sole e NON catturiamo l'eccezione qui,
	        // la rilanciamo alla Servlet così sa se l'operazione è fallita davvero.
	        try (Connection con = DriverManagerConnectionPool.getConnection();
	             PreparedStatement ps = con.prepareStatement(query)) {
	            
	            ps.setString(1, size);
	            ps.setInt(2, q);
	            ps.setInt(3, id);
	            
	            int rows = ps.executeUpdate();
	            return rows > 0;
	        }
	    }
	}

	@Override
	public boolean doUpdate(int id, String size, int q) throws SQLException {
		Spec_prodottoDAOImpl dao= new Spec_prodottoDAOImpl();
		int q_attuale=dao.doRetrieveQuantitaBySize(id, size);
		if(q_attuale+q < 0) {
			return false;
		}else {
			String query="UPDATE spec_prodotto SET quantita=? WHERE prodotto_id=? AND taglia=?";
			try(Connection con= DriverManagerConnectionPool.getConnection();
					PreparedStatement ps= con.prepareStatement(query)){
				
				ps.setInt(2, id);
				ps.setString(3, size);
				ps.setInt(1, q_attuale+q);
				
				ps.executeUpdate();
				return true;
				
			}catch(SQLException e ) {
				e.printStackTrace();
				return false;
			}
		}
	}

}
