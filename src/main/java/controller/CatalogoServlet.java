package controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.beans.Categoria;
import model.beans.Prodotto;
import model.daoImpl.ProdottoDAOImpl;
import model.daoImpl.Spec_prodottoDAOImpl;

@WebServlet("/Catalogo")
public class CatalogoServlet extends HttpServlet{

		protected void doGet(HttpServletRequest request, HttpServletResponse response) 
					throws ServletException,IOException{
			ProdottoDAOImpl prodottoDao = new ProdottoDAOImpl();
		    Spec_prodottoDAOImpl specDao = new Spec_prodottoDAOImpl();
		    try {
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
		        
		} catch (SQLException e) {
	        e.printStackTrace();
	        request.setAttribute("errore", "Errore nel caricamento del catalogo dal database.");
	    }

	    request.getRequestDispatcher("/view/catalogo.jsp").forward(request, response);
}
}
