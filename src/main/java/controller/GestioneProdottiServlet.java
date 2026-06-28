package controller;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.beans.Categoria;
import model.beans.Prodotto;
import model.dao.ProdottoDAO;
import model.daoImpl.ImgDAOImpl;
import model.daoImpl.ProdottoDAOImpl;

@WebServlet("/GestioneProdotti")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
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
		
		// 1. Recupero dei parametri testuali del prodotto
	    String nome = request.getParameter("nome");
	    String marca = request.getParameter("marca");
	    String descr = request.getParameter("desc");
	    float prezzo = Float.parseFloat(request.getParameter("prezzo"));
	    String categoria = request.getParameter("categoria");
	    int sconto = Integer.parseInt(request.getParameter("sconto"));
	    boolean inEvidenza = request.getParameter("inEvidenza") != null;

	    // Crea l'oggetto Prodotto (senza ID se è un nuovo inserimento)
	    Prodotto prod = new Prodotto();
	    prod.setNome(nome);prod.setMarca(marca);prod.setDesc(descr);prod.setPrezzo(prezzo);prod.setCat(Categoria.valueOf(categoria));prod.setSconto(sconto);
	    prod.setInEvidenza(inEvidenza);
	    ProdottoDAOImpl prodottoDao = new ProdottoDAOImpl();

	    try {
	        // 2. Salva il prodotto principale nel DB e ottieni l'ID autogenerato
	        int nuovoProdottoId = prodottoDao.doSave(prod); 

	        // 3. Gestione del File Upload (Foto)
	        Part filePart = request.getPart("foto"); // Corrisponde a name="foto" nella JSP
	        
	        if (filePart != null && filePart.getSize() > 0) {
	            // Estrae il nome originale del file (es: "mercurial.png")
	            String fileOriginalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
	            
	            // Per evitare conflitti di nomi (es. due utenti caricano "foto.png"), 
	            // conviene rinominare il file usando l'ID del prodotto (es: "prod_37.png")
	            String estensione = fileOriginalName.substring(fileOriginalName.lastIndexOf("."));
	            String nomeFileFinale = "prod_" + nuovoProdottoId + estensione;

	            // Definisci dove salvare il file fisicamente sul server.
	            // getServletContext().getRealPath("") punta alla cartella 'webapp' o 'WebContent' distribuita sul server Tomcat
	            String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "prodotti";
	            
	            File uploadDir = new File(uploadPath);
	            if (!uploadDir.exists()) {
	                uploadDir.mkdirs(); // Crea la cartella images/prodotti se non esiste
	            }

	            // Scrive fisicamente il file sul server
	            String percorsoCompletoFile = uploadPath + File.separator + nomeFileFinale;
	            filePart.write(percorsoCompletoFile);

	            // 4. Salva il riferimento nel Database nella tabella `img_prodotto`
	            // Passiamo il nome del file (es: "prod_37.png") e l'ID del prodotto a cui appartiene
	            ImgDAOImpl imgDao = new ImgDAOImpl();
	            imgDao.doSave(nomeFileFinale, nuovoProdottoId);
	        }
	        
	        // Gestisci qui l'inserimento in spec_prodotto (taglia e quantità)...

	        response.sendRedirect(request.getContextPath() + "/view/admin/prodotti?success=true");

	    } catch (SQLException e) {
	        e.printStackTrace();
	        request.setAttribute("errore", "Errore nel salvataggio del prodotto.");
	        // forward alla pagina di errore o alla stessa JSP...
	    }
	}

}
