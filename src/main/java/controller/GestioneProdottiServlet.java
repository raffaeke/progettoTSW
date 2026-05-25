package controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.beans.Categoria;
import model.beans.Prodotto;
import model.dao.ProdottoDAO;
import model.daoImpl.ProdottoDAOImpl;

@WebServlet("/GestioneProdotti")

public class GestioneProdottiServlet extends HttpServlet{
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException{
		HttpSession session= request.getSession();
		if(! (boolean)session.getAttribute("isAdmin")) {
			response.sendRedirect("index.jsp");
			return;
		}
		ProdottoDAO dao= new ProdottoDAOImpl();
		String action = request.getParameter("action");
	    String idParam = request.getParameter("id");
	    try {
	        //"Modifica"
	        if ("modifica".equals(action) && idParam != null) {
	            int id = Integer.parseInt(idParam);
	            Prodotto p = dao.doRetrieveByKey(id);
	            // Salvo il prodotto nella request: il form nella JSP si riempirà da solo
	            request.setAttribute("prodottoDaModificare", p);
	        } 
	        
	        //"Elimina"
	        else if ("elimina".equals(action) && idParam != null) {
	            int id = Integer.parseInt(idParam);
	            dao.doDelete(id);
	            response.sendRedirect(request.getContextPath()+"/GestioneProdotti");
	            return; 
	        }
	        
	        // CASO C: L'action è null (l'utente ha solo aperto la pagina)
	        // Non facciamo nulla di speciale, andiamo direttamente al punto 3
	        
	        List<Prodotto> lista = dao.doRetrieveAll();
		    request.setAttribute("listaProdotti", lista);
	    } catch (NumberFormatException e) {
	        // Gestione errore se l'ID nell'URL non è un numero valido
	        request.setAttribute("errore", "ID Prodotto non valido.");
	    }
	    catch(SQLException e2) {
	    	request.setAttribute("errore","Errore nell'esecuzione della query");
	    }
	    
	    request.getRequestDispatcher("/WEB-INF/view/admin/prodotti.jsp").forward(request, response);
	    
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException{
		HttpSession session= request.getSession();
		if(! (boolean)session.getAttribute("isAdmin")) {
			response.sendRedirect("index.jsp");
			return;
		}
		
		String idParam = request.getParameter("id");
	    String nome = request.getParameter("nome");
	    String desc = request.getParameter("desc");
	    String prezzoParam = request.getParameter("prezzo");
	    String catParam = request.getParameter("categoria");
	    String scontoParam = request.getParameter("sconto");
	    String inEvidenzaParam = request.getParameter("inEvidenza");
	    boolean inEvidenza = (inEvidenzaParam != null); 

	    ProdottoDAO dao = new ProdottoDAOImpl();
	    try {
	    	float prezzo=Float.parseFloat(prezzoParam);
	    	Categoria cat = Categoria.valueOf(catParam.trim().toUpperCase());
	    	int sconto = (scontoParam != null && !scontoParam.isEmpty()) ? Integer.parseInt(scontoParam) : 0;
	    	Prodotto p = new Prodotto();
	        p.setNome(nome);
	        p.setDesc(desc);
	        p.setPrezzo(prezzo);
	        p.setSconto(sconto);
	        p.setInEvidenza(inEvidenza);
	        p.setCat(cat);
	        if (idParam == null || idParam.isEmpty() || "0".equals(idParam)) {
	            // ID assente o zero -> NUOVO PRODOTTO
	            dao.doSave(p);
	        } else {
	            //ID presente -> MODIFICA PRODOTTO ESISTENTE
	            int id = Integer.parseInt(idParam);
	            p.setId(id); 
	            dao.doUpdate(p);
	        }
	    }catch(NumberFormatException e) {
	    	e.printStackTrace();
	    }
	    catch(SQLException e) {
	    	e.printStackTrace();
	    }
	    
	    response.sendRedirect(request.getContextPath()+"/GestioneProdotti");
	}

}
