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
import util.DriverManagerConnectionPool;

public class ProdottoDAOImpl implements ProdottoDAO{

	public Prodotto doRetrieveByKey(int id) throws SQLException {
		String query = "SELECT * FROM prodotto WHERE id = ?";
        
        try (Connection con = DriverManagerConnectionPool.getConnection();
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
        try (Connection con = DriverManagerConnectionPool.getConnection();
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
		String query = "INSERT INTO prodotto (nome, descr, prezzo, categoria, sconto, in_evidenza) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DriverManagerConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getDesc());
            ps.setFloat(3, prodotto.getPrezzo());
            ps.setString(4, prodotto.getCat().name());
            ps.setInt(5, prodotto.getSconto());
            if(prodotto.isInEvidenza()) {
            	ps.setInt(6, 1);
            }else {
            	ps.setInt(6, 0);
            }

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
        String catString = rs.getString("categoria");
        p.setCat(Categoria.valueOf(catString.trim().toUpperCase()));
        p.setSconto(rs.getInt("sconto"));
        if(rs.getInt("in_evidenza") == 1) {
        	p.setInEvidenza(true);
        }else {
        	p.setInEvidenza(false);
        }
        return p;
    }
	
	public boolean doDelete(int id) throws SQLException{
		String query="DELETE FROM prodotto WHERE id=?";
		try(Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)){
			ps.setInt(1, id);
			ps.executeUpdate();
			return true;
		}catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean doUpdate(Prodotto prodotto) throws SQLException{
		String query = "UPDATE prodotto SET nome = ?, descr = ?, prezzo = ?, "
                + "categoria = ?, sconto = ?, in_evidenza = ? WHERE id = ?";
   
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
       
					ps.setString(1, prodotto.getNome());
					ps.setString(2, prodotto.getDesc());
					ps.setFloat(3, prodotto.getPrezzo());
					ps.setString(4, prodotto.getCat().name());
					ps.setInt(5, prodotto.getSconto());
					if(prodotto.isInEvidenza()) {
		            	ps.setInt(6, 1);
		            }else {
		            	ps.setInt(6, 0);
		            }
					ps.setInt(7, prodotto.getId());

					ps.executeUpdate();
					return true;
       
		} catch (SQLException e) {
				e.printStackTrace();
				return false;
			}
	}
}
