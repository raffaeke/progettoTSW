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
import model.daoImpl.RecensioneDAOImpl;
import model.daoImpl.ImgDAOImpl;            // Il tuo DAO per le immagini
import model.daoImpl.Spec_prodottoDAOImpl;  // Il tuo DAO per le specifiche/taglie
//import model.daoImpl.RecensioneDAOImpl;     // Il tuo DAO per le recensioni (se presente)

@WebServlet("/prodotto")
public class ProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ProdottoDAOImpl prodottoDAO;
    private ImgDAOImpl imgDAO;
    private Spec_prodottoDAOImpl specDAO;
    private RecensioneDAOImpl recensioneDAO;

    @Override
    public void init() throws ServletException {
        // Inizializzazione dei DAO
        prodottoDAO = new ProdottoDAOImpl();
        imgDAO = new ImgDAOImpl();
        specDAO = new Spec_prodottoDAOImpl();
        recensioneDAO = new RecensioneDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                
                Prodotto prodotto = prodottoDAO.doRetrieveByKey(id);
                
                if (prodotto != null) {
                    List<String> listaImmagini = imgDAO.doRetrieveByProductKey(id);
                    List<Spec_prodotto> listaSpecifiche = specDAO.doRetrieveByProductKey(id); 
                    List<Recensione> listaRecensioni = recensioneDAO.doRetrieveByProductId(id);
                    
                   
                    request.setAttribute("prodotto", prodotto);
                    request.setAttribute("immagini", listaImmagini);
                    request.setAttribute("specs", listaSpecifiche);
                    request.setAttribute("recensioni", listaRecensioni);
                    
                   
                    request.getRequestDispatcher("/WEB-INF/view/prodotto.jsp").forward(request, response);
                    return;
                }
                
            } catch (NumberFormatException e) {
                // L'ID passato non è un numero valido
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/Catalogo");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}