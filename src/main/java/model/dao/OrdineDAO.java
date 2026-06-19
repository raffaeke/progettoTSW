package model.dao;
import model.beans.Ordine;
import model.beans.Stato;

import java.sql.SQLException;
import java.util.ArrayList;
public interface OrdineDAO {

	public ArrayList<Ordine> doRetrieveAll() throws SQLException;
	public boolean doUpdateStatoByID(int id,Stato s) throws SQLException;
}
