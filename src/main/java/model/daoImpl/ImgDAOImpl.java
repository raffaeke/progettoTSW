package model.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

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
public ArrayList<String> doRetrieveByProductKey(int id) throws SQLException {
		
		String query="SELECT url FROM immagini_prodotto WHERE prodotto_id=?";
		ArrayList<String> result = new ArrayList<>();
		 try (Connection con = DriverManagerConnectionPool.getConnection();
	             PreparedStatement ps = con.prepareStatement(query)) {
	            
	            ps.setInt(1, id);
	            ResultSet rs = ps.executeQuery();


	            while(rs.next()) {
	            	result.add(rs.getString("url"));
	            }
	            return result;
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return null;
	}
public boolean doDeleteByProductKey(int id) throws SQLException {
	String query=" DELETE FROM immagini_prodotto WHERE prodotto_id=?";
	try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
				
				ps.setInt(1, id);
				ps.executeUpdate();
				return true;	
		
		}catch(SQLException e) {
			e.printStackTrace();
            return false;
		}
}

}
