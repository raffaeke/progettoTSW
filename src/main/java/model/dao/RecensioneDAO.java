package model.dao;

import java.sql.SQLException;
import java.util.List;

import model.beans.Recensione;

public interface RecensioneDAO {

	public void doSave(Recensione r)throws SQLException;
	public List<Recensione> doRetrieveByProductId(int id)throws SQLException;
}
