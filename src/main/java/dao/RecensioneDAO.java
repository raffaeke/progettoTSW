package dao;

import java.sql.SQLException;
import java.util.List;

import model.Recensione;

public interface RecensioneDAO {

	public void doSave(Recensione r)throws SQLException;
	public List<Recensione> doRetrieveByProductId(int id)throws SQLException;
}
