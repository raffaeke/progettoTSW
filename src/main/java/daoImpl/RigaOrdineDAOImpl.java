package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.RigaOrdine;
import dao.RigaOrdineDAO;
import util.DriverManagerConnectionPool;

public class RigaOrdineDAOImpl implements RigaOrdineDAO{

	public void doSave(RigaOrdine r) throws SQLException {
		String query = "INSERT INTO rigaordine (ordine_id, prodotto_id, quantita, prezzo_acquistato, taglia) VALUES (?, ?, ?, ?, ?)";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, r.getOrdineId());
			ps.setInt(2, r.getProdottoId());
			ps.setInt(3, r.getQuantita());
			ps.setFloat(4, r.getPrezzo());
			ps.setString(5, r.getTaglia());
			ps.executeUpdate();
		}
	}

	public List<RigaOrdine> doRetrieveByOrdine(int ordineId) throws SQLException {
		List<RigaOrdine> result = new ArrayList<>();
		String query = "SELECT * FROM rigaordine WHERE ordine_id=?";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, ordineId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				RigaOrdine r = new RigaOrdine();
				r.setOrdineId(rs.getInt("ordine_id"));
				r.setProdottoId(rs.getInt("prodotto_id"));
				r.setQuantita(rs.getInt("quantita"));
				r.setPrezzo(rs.getFloat("prezzo_acquistato"));
				r.setTaglia(rs.getString("taglia"));
				result.add(r);
			}
		}
		return result;
	}
}
