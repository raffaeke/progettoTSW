package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.ItemCarrello;
import model.Prodotto;
import dao.CarrelloDAO;
import util.DriverManagerConnectionPool;

public class CarrelloDAOImpl implements CarrelloDAO{

	public List<ItemCarrello> doRetrieveByUtente(int utenteId) throws SQLException {
		List<ItemCarrello> result = new ArrayList<>();
		String query = "SELECT prodotto_id, quantita FROM carrello_item WHERE utente_id=?";
		ProdottoDAOImpl prodottoDAO = new ProdottoDAOImpl();

		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, utenteId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Prodotto p = prodottoDAO.doRetrieveByKey(rs.getInt("prodotto_id"));
				// Un prodotto rimosso dal catalogo (cancellazione logica) sparisce anche dal carrello salvato
				if (p != null && !p.isEliminato()) {
					ItemCarrello item = new ItemCarrello();
					item.setProdotto(p);
					item.setQuantita(rs.getInt("quantita"));
					result.add(item);
				}
			}
		}
		return result;
	}

	public void doUpsert(int utenteId, int prodottoId, int quantita) throws SQLException {
		String query = "INSERT INTO carrello_item (utente_id, prodotto_id, quantita) VALUES (?, ?, ?) "
				+ "ON DUPLICATE KEY UPDATE quantita=?";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, utenteId);
			ps.setInt(2, prodottoId);
			ps.setInt(3, quantita);
			ps.setInt(4, quantita);
			ps.executeUpdate();
		}
	}

	public void doDelete(int utenteId, int prodottoId) throws SQLException {
		String query = "DELETE FROM carrello_item WHERE utente_id=? AND prodotto_id=?";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, utenteId);
			ps.setInt(2, prodottoId);
			ps.executeUpdate();
		}
	}

	public void doDeleteAll(int utenteId) throws SQLException {
		String query = "DELETE FROM carrello_item WHERE utente_id=?";
		try (Connection con = DriverManagerConnectionPool.getConnection();
				PreparedStatement ps = con.prepareStatement(query)) {
			ps.setInt(1, utenteId);
			ps.executeUpdate();
		}
	}
}
