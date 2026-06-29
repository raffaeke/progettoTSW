package model.dao;

import java.sql.SQLException;
import java.util.ArrayList;

public interface ImgDAO {
	public ArrayList<String> doRetrieveByProductKey(int id) throws SQLException;
	public void doSave(String url,int id) throws SQLException;
	public boolean doDeleteByProductKey(int id) throws SQLException;
}
