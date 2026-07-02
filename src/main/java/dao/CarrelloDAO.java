package dao;
import model.ItemCarrello;

import java.sql.SQLException;
import java.util.List;
public interface CarrelloDAO {

	public List<ItemCarrello> doRetrieveByUtente(int utenteId) throws SQLException;
	public void doUpsert(int utenteId, int prodottoId, int quantita) throws SQLException;
	public void doDelete(int utenteId, int prodottoId) throws SQLException;
	public void doDeleteAll(int utenteId) throws SQLException;
}
