package daoImpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;

import model.Categoria;
import model.Messaggio;
import model.Prodotto;
import dao.MessaggioDAO;
import util.DriverManagerConnectionPool;

public class MessaggioDAOImpl implements MessaggioDAO{

	public ArrayList<Messaggio> doRetrieveByChat(int chat_id) throws SQLException {
		ArrayList<Messaggio> result= new ArrayList<>();
		String query="SELECT * FROM messaggio WHERE chat_id=?";
		try(Connection con= DriverManagerConnectionPool.getConnection();
				PreparedStatement ps= con.prepareStatement(query)){
				ps.setInt(1, chat_id);
				ResultSet rs= ps.executeQuery();
				while(rs.next()) {
					result.add(mapper(rs));
				}
		}
		return result;
	}
	
	private Messaggio mapper(ResultSet rs) throws SQLException {
        Messaggio m= new Messaggio();
        m.setId(rs.getInt("id"));
        m.setChat(rs.getInt("chat_id"));
        m.setMittente(rs.getInt("mittente_id"));
        m.setTesto(rs.getString("testo"));
        try {
	        java.sql.Date data = rs.getDate("inviato_il");
	        if (data == null) data = rs.getDate("data"); 
	        if (data != null) m.setDataInvio(data.toLocalDate());
	    } catch (Exception e) {
	        // Se fallisce la data, non bloccare il programma
	    }
        return m;
    }
	public void doDeleteByChat(int id) throws SQLException{
		MessaggioDAOImpl dao= new MessaggioDAOImpl();
		dao.doDeleteByChat(id);
		String query="DELETE FROM messaggio WHERE chat_id=?";
		try(Connection con= DriverManagerConnectionPool.getConnection();
				PreparedStatement ps= con.prepareStatement(query)){
			ps.setInt(1, id);
			ps.executeUpdate();
		}catch(SQLException e) {
			
		}
	}
	public void doSave(Messaggio m) throws SQLException{
		
		String query = "INSERT INTO messaggio (chat_id, mittente_id, testo, inviato_il) VALUES (?, ?, ?, ?)";
		try (Connection con = DriverManagerConnectionPool.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {
               
               ps.setInt(1, m.getChat());
               ps.setInt(2, m.getMittente()); 
               ps.setString(3, m.getTesto());
               ps.setDate(4,Date.valueOf(m.getDataInvio())); 
               ps.executeUpdate();
           }catch(SQLException e) {
        	   e.printStackTrace();
           }
		
	}
}
