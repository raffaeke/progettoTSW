package model.daoImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.beans.Categoria;
import model.beans.Prodotto;
import model.dao.ProdottoDAO;
import util.ConnessioneMySQL;

public class ProdottoDAOImpl implements ProdottoDAO{

	public Prodotto doRetrieveByKey(int id) throws SQLException {
		String query = "SELECT * FROM prodotto WHERE id = ?";
        
        try (Connection con = ConnessioneMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapper(rs); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
	}

	public List<Prodotto> doRetrieveAll() throws SQLException {
		String query = "SELECT * FROM prodotto";
        List<Prodotto> result= new ArrayList<>();
        try (Connection con = ConnessioneMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                result.add(mapper(rs)); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
	}

	public boolean doSave(Prodotto prodotto) throws SQLException {
		String query = "INSERT INTO prodotto (nome, descr, prezzo, categoria) VALUES (?, ?, ?, ?)";
        
        try (Connection con = ConnessioneMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getDesc());
            ps.setFloat(3, prodotto.getPrezzo());
            ps.setString(5, prodotto.getCat().name());

            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
        	e.printStackTrace();
           return false;
        }
	}

	private Prodotto mapper(ResultSet rs) throws SQLException {
        Prodotto p = new Prodotto();
        p.setId(rs.getInt("id"));
        p.setNome(rs.getString("nome"));
        p.setDesc(rs.getString("descr"));
        p.setPrezzo(rs.getFloat("prezzo"));
        p.setCat(Categoria.valueOf(rs.getString("categoria")));
        return p;
    }
}
