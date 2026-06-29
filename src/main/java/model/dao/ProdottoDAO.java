package model.dao;
import java.sql.SQLException;

import model.beans.Categoria;
import model.beans.Prodotto;

import java.util.List;

public interface ProdottoDAO {
		
	public Prodotto doRetrieveByKey(int id) throws SQLException;
    public List<Prodotto> doRetrieveAll() throws SQLException;
    public List<Prodotto> doRetrieveByCategoria(Categoria c) throws SQLException;
    public List<Prodotto> doRetrieveInEvidenzaByCategoria(Categoria c) throws SQLException;
    public List<Prodotto> doRetrievePiuScontatiByCategoria(Categoria c)throws SQLException;
    public List<String> doRetrieveDistinctMarcheByCategoria(Categoria c)throws SQLException;
    public int doSave(Prodotto prodotto) throws SQLException;
    public boolean doDelete(int id) throws SQLException;
    public boolean doUpdate(Prodotto p) throws SQLException;
    
}
