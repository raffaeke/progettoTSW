package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Chat;
import model.Messaggio;
import dao.ChatDAO;
import util.DriverManagerConnectionPool;

public class ChatDAOImpl implements ChatDAO{

	@Override
	public ArrayList<Chat> doRetrieveAll() throws SQLException {
		ArrayList<Chat> result = new ArrayList<>();
		String query="SELECT * FROM chat";
		try(Connection con= DriverManagerConnectionPool.getConnection();
				PreparedStatement ps= con.prepareStatement(query)){
			ResultSet rs= ps.executeQuery();
			while(rs.next()) {
				result.add(mapper(rs));
			}
		}catch(SQLException e) {
			
		}
		return result;
	}

	@Override
	public Chat doRetrieveByKey(int id) throws SQLException {
		Chat result= new Chat();
		String query="SELECT * FROM chat WHERE id=?";
		try(Connection con= DriverManagerConnectionPool.getConnection();
				PreparedStatement ps= con.prepareStatement(query)){
			ps.setInt(1, id);
			ResultSet rs= ps.executeQuery();
			if(rs.next()) {
				result=mapper(rs);
				return result;
			}else return null;
		}catch(SQLException e) {
			return null;
		}
	}

	@Override
	public Chat doRetrieveByCliente(int clienteId) throws SQLException {
		String query = "SELECT * FROM chat WHERE cliente_id=?";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, clienteId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return mapper(rs);
			}
		}
		return null;
	}

	@Override
	public int doSave(Chat c) throws SQLException {
		String query = "INSERT INTO chat (cliente_id, creata_il) VALUES (?, ?)";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, c.getCliente());
			ps.setDate(2, java.sql.Date.valueOf(c.getDataCreazione()));
			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		}
		return 0;
	}

	@Override
	public void doDelete(int id) throws SQLException {
	    String queryMessaggi = "DELETE FROM messaggio WHERE chat_id = ?";
	    String queryChat = "DELETE FROM chat WHERE id = ?";
	    
	    try (Connection con = DriverManagerConnectionPool.getConnection()) {
	        // Disattiviamo l'autocommit per fare un'operazione atomica (Transazione)
	        con.setAutoCommit(false);
	        
	        try (PreparedStatement psMsg = con.prepareStatement(queryMessaggi);
	             PreparedStatement psChat = con.prepareStatement(queryChat)) {
	            
	            psMsg.setInt(1, id);
	            psMsg.executeUpdate();
	            
	            psChat.setInt(1, id);
	            psChat.executeUpdate();
	            
	            con.commit();
	            
	        } catch (SQLException e) {
	            con.rollback(); // Se uno dei due fallisce, annulla tutto
	            throw e; // Rilancia l'eccezione
	        } finally {
	            con.setAutoCommit(true);
	        }
	    }
	}
	
	private Chat mapper(ResultSet rs) throws SQLException {
        Chat c= new Chat();
        c.setId(rs.getInt("id"));
        c.setCliente(rs.getInt("cliente_id"));
        try {
	        java.sql.Date data = rs.getDate("creata_il");
	        if (data == null) data = rs.getDate("data"); 
	        if (data != null) c.setDataCreazione(data.toLocalDate());
	    } catch (Exception e) {
	        // Se fallisce la data, non bloccare il programma
	    }
        return c;
    }
}
