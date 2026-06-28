package model.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.dao.ImgDAO;
import util.DriverManagerConnectionPool;

public class ImgDAOImpl implements ImgDAO{

	public void doSave(String url, int id) {
		String query="insert INTO immagini_prodotto(url,prodotto_id) values(?,?)";
		try (Connection con = DriverManagerConnectionPool.getConnection();
	             PreparedStatement ps = con.prepareStatement(query)){
			
			ps.setString(1, url);
			ps.setInt(2, id);
			ps.executeUpdate();
			
		}catch(SQLException e) {
			
		}
		
	}

}
