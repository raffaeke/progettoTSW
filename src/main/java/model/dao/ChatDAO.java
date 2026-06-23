package model.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import model.beans.Chat;

public interface ChatDAO {
    public ArrayList<Chat> doRetrieveAll() throws SQLException;
    
    public Chat doRetrieveByKey(int id) throws SQLException;

    public void doDelete(int id) throws SQLException;
}
