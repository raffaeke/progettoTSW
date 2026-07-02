package dao;
import model.Messaggio;

import java.sql.SQLException;
import java.util.ArrayList;
public interface MessaggioDAO {

	public ArrayList<Messaggio> doRetrieveByChat(int chat_id)throws SQLException;
	public void doDeleteByChat(int id) throws SQLException;
	public void doSave(Messaggio m) throws SQLException;
}
