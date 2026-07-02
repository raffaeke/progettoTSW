package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Prodotto;
import daoImpl.ImgDAOImpl;
import daoImpl.ProdottoDAOImpl;

// Endpoint AJAX per il dropdown di ricerca nell'index: restituisce JSON, non una view.
@WebServlet("/CercaProdotti")
public class CercaProdottiServlet extends HttpServlet {

	private static final int LIMITE_RISULTATI = 8;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json;charset=UTF-8");

		String query = request.getParameter("q");
		StringBuilder json = new StringBuilder("[");

		if (query != null && !query.trim().isEmpty()) {
			try {
				ProdottoDAOImpl prodottoDao = new ProdottoDAOImpl();
				ImgDAOImpl imgDao = new ImgDAOImpl();
				List<Prodotto> risultati = prodottoDao.doRetrieveByNome(query.trim());

				int max = Math.min(risultati.size(), LIMITE_RISULTATI);
				for (int i = 0; i < max; i++) {
					Prodotto p = risultati.get(i);
					List<String> immagini = imgDao.doRetrieveByProductKey(p.getId());
					String img = (immagini != null && !immagini.isEmpty()) ? immagini.get(0) : "";

					if (i > 0) json.append(",");
					json.append("{");
					json.append("\"id\":").append(p.getId()).append(",");
					json.append("\"nome\":\"").append(escapeJson(p.getNome())).append("\",");
					json.append("\"marca\":\"").append(escapeJson(p.getMarca())).append("\",");
					json.append("\"prezzo\":").append(p.getPrezzoScontato()).append(",");
					json.append("\"immagine\":\"").append(escapeJson(img)).append("\"");
					json.append("}");
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		json.append("]");

		PrintWriter out = response.getWriter();
		out.write(json.toString());
	}

	private String escapeJson(String s) {
		if (s == null) return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
