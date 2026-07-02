package dao;
import model.RigaOrdine;

import java.sql.SQLException;
import java.util.List;
public interface RigaOrdineDAO {

	public void doSave(RigaOrdine r) throws SQLException;
	public List<RigaOrdine> doRetrieveByOrdine(int ordineId) throws SQLException;
}
