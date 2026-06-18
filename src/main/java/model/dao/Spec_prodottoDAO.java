package model.dao;
import java.sql.SQLException;
public interface Spec_prodottoDAO {
	public int doRetrieveQuantitaBySize(int id, String size) throws SQLException; 
	public boolean doSave(int id, String size,int q) throws SQLException; 
	public boolean doUpdate(int id, String size,int q) throws SQLException; //modifichiamo la quantita
}
