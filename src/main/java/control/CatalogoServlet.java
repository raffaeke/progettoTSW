package control;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Categoria;
import model.Prodotto;
import daoImpl.ImgDAOImpl;
import daoImpl.ProdottoDAOImpl;
import daoImpl.Spec_prodottoDAOImpl;

@WebServlet("/Catalogo")
public class CatalogoServlet extends HttpServlet{

		protected void doGet(HttpServletRequest request, HttpServletResponse response)
					throws ServletException,IOException{
			ProdottoDAOImpl prodottoDao = new ProdottoDAOImpl();
		    Spec_prodottoDAOImpl specDao = new Spec_prodottoDAOImpl();

		    String query = request.getParameter("q");
		    boolean modalitaRicerca = (query != null && !query.trim().isEmpty());

		    try {
		        if (modalitaRicerca) {
		            // Ricerca testuale su tutte le categorie: niente sezioni "in evidenza"/"più scontati" ne' filtro taglie
		            query = query.trim();
		            request.setAttribute("query", query);

		            List<Prodotto> risultati = prodottoDao.doRetrieveByNome(query);
		            request.setAttribute("prodotti", risultati);

		            TreeSet<String> marcheSet = new TreeSet<>();
		            for (Prodotto p : risultati) {
		                marcheSet.add(p.getMarca());
		            }
		            request.setAttribute("marche", new ArrayList<String>(marcheSet));

		        } else {
		            String tipoParam = request.getParameter("tipo");
		            if (tipoParam == null || tipoParam.isEmpty()) {
		                tipoParam = "maglie"; // Categoria di default se manca
		            }
		            request.setAttribute("tipo", tipoParam);
		            List<Prodotto> listaProdotti = prodottoDao.doRetrieveByCategoria(Categoria.valueOf(tipoParam));
		            request.setAttribute("prodotti", listaProdotti);

		            List<Prodotto> listaInEvidenza = prodottoDao.doRetrieveInEvidenzaByCategoria(Categoria.valueOf(tipoParam));
		            request.setAttribute("inEvidenza", listaInEvidenza);

		            List<Prodotto> listaPiuScontati = prodottoDao.doRetrievePiuScontatiByCategoria(Categoria.valueOf(tipoParam));
		            request.setAttribute("piuScontati", listaPiuScontati);

		            List<String> listaMarche = prodottoDao.doRetrieveDistinctMarcheByCategoria(Categoria.valueOf(tipoParam));
		            request.setAttribute("marche", listaMarche);

		            List<String> listaTaglie = specDao.doRetrieveDistinctTaglieByCategoria(Categoria.valueOf(tipoParam));
		            request.setAttribute("taglie", listaTaglie);
		        }

		} catch (SQLException e) {
	        e.printStackTrace();
	        request.setAttribute("errore", "Errore nel caricamento del catalogo dal database.");
	    }

	    request.getRequestDispatcher("/view/Catalogo").forward(request, response);
}
}
