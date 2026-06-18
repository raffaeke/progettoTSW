package model.dao;
import model.beans.Ordine;
import java.sql.SQLException;
import java.util.ArrayList;
public interface OrdineDAO {

	public ArrayList<Ordine> doRetrieveAll() throws SQLException;
}
