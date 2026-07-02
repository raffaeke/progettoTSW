package dao;

import java.sql.SQLException;
import java.util.List;

import model.Utente;

public interface UtenteDAO {
	
	public Utente doRetrieveByEmailPassword(String email, String password)throws SQLException;
	public List<Utente> doRetrieveAll() throws SQLException;
	public boolean doSave(Utente utente)throws SQLException;
	public Utente doRetrieveById(int id)throws SQLException;
	public boolean doUpdate(Utente utente)throws SQLException;
}
