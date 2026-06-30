package model.dao;
import java.sql.SQLException;
import java.util.List;

import model.beans.Categoria;
import model.beans.Spec_prodotto;
public interface Spec_prodottoDAO {
	public int doRetrieveQuantitaBySize(int id, String size) throws SQLException; 
	public boolean doSave(int id, String size,int q) throws SQLException; 
	public boolean doUpdate(int id, String size,int q) throws SQLException; //modifichiamo la quantita
	public List<String> doRetrieveDistinctTaglieByCategoria(Categoria c) throws SQLException;
	public void doDeleteByProductKey(int id)throws SQLException;
	public List<Spec_prodotto> doRetrieveByProductKey(int id)throws SQLException;
}
