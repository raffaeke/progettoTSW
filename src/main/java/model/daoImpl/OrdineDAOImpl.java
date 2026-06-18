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


private Ordine mapper(ResultSet rs) throws SQLException {
    Ordine o = new Ordine();
    o.setId(rs.getInt("id"));
    java.sql.Date data=rs.getDate("data_ordine");
    o.setData(data.toLocalDate());
    o.setTotale(rs.getFloat("tot"));
    o.setStato(Stato.valueOf(rs.getString("stato")));
    o.setUtenteId(rs.getInt("utente_id"));
    return o;
	}
}
