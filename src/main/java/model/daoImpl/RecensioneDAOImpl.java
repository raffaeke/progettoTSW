package model.daoImpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.beans.Recensione;
import model.dao.RecensioneDAO;
import util.DriverManagerConnectionPool;

public class RecensioneDAOImpl implements RecensioneDAO{
	public void doSave(Recensione r)throws SQLException{
		String query="INSERT INTO recensione (prodotto_id,utente_id,voto,commento,r_data) values(?,?,?,?,?)";
		 try (Connection con = DriverManagerConnectionPool.getConnection();
	             PreparedStatement ps = con.prepareStatement(query)) {
			 
			 ps.setInt(1, r.getProdottoId());
			 ps.setInt(2, r.getUtenteId());
			 ps.setInt(3, r.getVoto());
			 ps.setString(4, r.getCommento());
			 ps.setDate(5, Date.valueOf(r.getData()));
			 ps.executeUpdate();
			 
		 }catch(SQLException e) {
			 e.printStackTrace();
			 }
	}
	
	public List<Recensione> doRetrieveByProductId(int id) throws SQLException{
		List<Recensione> result = new ArrayList<>();
		String query="SELECT * FROM recensione WHERE prodotto_id=?";
		 try (Connection con = DriverManagerConnectionPool.getConnection();
	             PreparedStatement ps = con.prepareStatement(query)){
			 	ps.setInt(1, id);
			 	ResultSet rs=ps.executeQuery();
			 	while(rs.next()) {
			 		result.add(mapper(rs));
			 	}
		 }catch(SQLException e) {
			 e.printStackTrace();
		 }
		 return result;
	}
	private Recensione mapper(ResultSet rs) throws SQLException {
		Recensione r=new Recensione();
		r.setId(rs.getInt("id"));
		r.setProdottoId(rs.getInt("prodotto_id"));
		r.setUtenteId(rs.getInt("utente_id"));
		r.setVoto(rs.getInt("voto"));
		r.setCommento(rs.getString("commento"));
		try {
	        java.sql.Date data = rs.getDate("r_data");
	        if (data != null) r.setData(data.toLocalDate());
	    } catch (Exception e) {
	        // Se fallisce la data, non bloccare il programma
	    }
		return r;
	}
}
