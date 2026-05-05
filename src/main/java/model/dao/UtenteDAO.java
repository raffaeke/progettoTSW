package model.dao;

import java.sql.SQLException;
import java.util.List;

import model.beans.Utente;

public interface UtenteDAO {
	
	public Utente doRetrieveByEmailPassword(String email, String password)throws SQLException;
	public List<Utente> doRetrieveAll() throws SQLException;
	public boolean doSave(Utente utente)throws SQLException;
}
