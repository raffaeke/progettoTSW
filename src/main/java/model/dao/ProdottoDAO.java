package model.dao;
import java.sql.SQLException;

import model.beans.Prodotto;
import java.util.List;

public interface ProdottoDAO {
		
	public Prodotto doRetrieveByKey(int id) throws SQLException;
    public List<Prodotto> doRetrieveAll() throws SQLException;
    public int doSave(Prodotto prodotto) throws SQLException;
    public boolean doDelete(int id) throws SQLException;
    public boolean doUpdate(Prodotto p) throws SQLException;
    
}
