package dao;
import model.Ordine;
import model.Stato;

import java.sql.SQLException;
import java.util.ArrayList;
public interface OrdineDAO {

	public ArrayList<Ordine> doRetrieveAll() throws SQLException;
	public ArrayList<Ordine> doRetrieveByUtente(int utenteId) throws SQLException;
	public boolean doUpdateStatoByID(int id,Stato s) throws SQLException;
	public int doSave(Ordine o) throws SQLException;
}
