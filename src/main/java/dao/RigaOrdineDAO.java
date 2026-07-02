package dao;
import model.RigaOrdine;

import java.sql.SQLException;
public interface RigaOrdineDAO {

	public void doSave(RigaOrdine r) throws SQLException;
}
