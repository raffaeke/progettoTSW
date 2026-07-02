package dao;

import java.sql.SQLException;
import java.util.ArrayList;
import model.Chat;

public interface ChatDAO {
    public ArrayList<Chat> doRetrieveAll() throws SQLException;

    public Chat doRetrieveByKey(int id) throws SQLException;

    public Chat doRetrieveByCliente(int clienteId) throws SQLException;

    public int doSave(Chat c) throws SQLException;

    public void doDelete(int id) throws SQLException;
}
