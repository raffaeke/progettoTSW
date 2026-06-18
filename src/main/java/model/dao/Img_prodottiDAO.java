package model.dao;
import java.sql.SQLException;
import java.util.ArrayList;

public interface Img_prodottiDAO {
	
	public ArrayList<String> doRetrieveByProductKey(int id) throws SQLException;
	public boolean doSave(String url,int id) throws SQLException;
	public boolean doDeleteByProductKey(int id) throws SQLException;
}
