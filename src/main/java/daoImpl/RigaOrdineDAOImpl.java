package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.RigaOrdine;
import dao.RigaOrdineDAO;
import util.DriverManagerConnectionPool;

public class RigaOrdineDAOImpl implements RigaOrdineDAO{

	public void doSave(RigaOrdine r) throws SQLException {
		String query = "INSERT INTO rigaordine (ordine_id, prodotto_id, quantita, prezzo_acquistato) VALUES (?, ?, ?, ?)";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, r.getOrdineId());
			ps.setInt(2, r.getProdottoId());
			ps.setInt(3, r.getQuantita());
			ps.setFloat(4, r.getPrezzo());
			ps.executeUpdate();
		}
	}
}
