package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Importa i tuoi modelli e DAO corretti
import model.beans.Prodotto;
import model.beans.Spec_prodotto;
import model.beans.Recensione;
import model.daoImpl.ProdottoDAOImpl;       // Sostituisci con il tuo pacchetto/nome reale del DAO prodotti
import model.daoImpl.ImgDAOImpl;            // Il tuo DAO per le immagini
import model.daoImpl.Spec_prodottoDAOImpl;  // Il tuo DAO per le specifiche/taglie
//import model.daoImpl.RecensioneDAOImpl;     // Il tuo DAO per le recensioni (se presente)

@WebServlet("/prodotto")
public class ProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ProdottoDAOImpl prodottoDAO;
    private ImgDAOImpl imgDAO;
    private Spec_prodottoDAOImpl specDAO;
   // private RecensioneDAOImpl recensioneDAO;

    @Override
    public void init() throws ServletException {
        // Inizializzazione dei DAO
        prodottoDAO = new ProdottoDAOImpl();
        imgDAO = new ImgDAOImpl();
        specDAO = new Spec_prodottoDAOImpl();
        //recensioneDAO = new RecensioneDAOImpl(); // Se non hai ancora l'impl, puoi istanziarlo o commentarlo
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                
                // 1. Recuperiamo il prodotto dal DB tramite ID
                Prodotto prodotto = prodottoDAO.doRetrieveByKey(id);
                
                if (prodotto != null) {
                    // 2. Recuperiamo le immagini associate al prodotto
                    List<String> listaImmagini = imgDAO.doRetrieveByProductKey(id);
                    
                    // 3. Recuperiamo le specifiche (taglie e quantità) del prodotto
                    List<Spec_prodotto> listaSpecifiche = specDAO.doRetrieveByProductKey(id); 
                    
                    // 4. Recuperiamo le recensioni associate al prodotto
                   // List<Recensione> listaRecensioni = recensioneDAO.doRetrieveByProductKey(id);
                    
                    // Settiamo gli attributi nella request per renderli disponibili alla JSP
                    request.setAttribute("prodotto", prodotto);
                    request.setAttribute("immagini", listaImmagini);
                    request.setAttribute("specs", listaSpecifiche);
                  //  request.setAttribute("recensioni", listaRecensioni);
                    
                    // Inoltriamo la richiesta alla pagina di dettaglio del prodotto
                    request.getRequestDispatcher("/WEB-INF/view/prodotto.jsp").forward(request, response);
                    return;
                }
                
            } catch (NumberFormatException e) {
                // L'ID passato non è un numero valido
                e.printStackTrace();
            } catch (Exception e) {
                // Gestione generica eccezioni SQL/DAO
                e.printStackTrace();
            }
        }
        
        // Se l'ID manca, non è valido o il prodotto non esiste, rimandiamo al catalogo o mostriamo un errore
        response.sendRedirect(request.getContextPath() + "/Catalogo");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}