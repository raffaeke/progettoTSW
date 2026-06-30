package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.beans.Recensione;
import model.beans.Utente;
import model.daoImpl.RecensioneDAOImpl;

import java.io.IOException;

@WebServlet("/Recensione")
public class RecensioneServlet extends HttpServlet {

     private RecensioneDAOImpl recensioneDAO = new RecensioneDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utente") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        
        String prodottoIdStr = request.getParameter("prodottoId");
        String votoStr = request.getParameter("voto");
        String testo = request.getParameter("testo");

        Utente utente = (Utente) session.getAttribute("utente"); 
        int utenteId = utente.getId(); // o come recuperi l'ID utente

        // 3. Validazione dei dati
        if (prodottoIdStr == null || votoStr == null || testo == null || testo.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/errore.jsp?msg=Dati+mancanti");
            return;
        }

        try {
            int prodottoId = Integer.parseInt(prodottoIdStr);
            int voto = Integer.parseInt(votoStr);

            // Validazione del voto (deve essere tra 1 e 5)
            if (voto < 1 || voto > 5) {
                response.sendRedirect(request.getContextPath() + "/prodotto?id=" + prodottoId);
                return;
            }

            testo = pulisciTesto(testo);
             Recensione recensione = new Recensione();
             recensione.setVoto(voto);
             recensione.setCommento(testo);
             recensione.setProdottoId(prodottoId);
             recensione.setUtenteId(utenteId);
             recensioneDAO.doSave(recensione); 

            // 5. Redirezione (Pattern Redirect-After-Post per evitare doppi invii col refresh)
            // Reindirizziamo l'utente alla pagina del prodotto appena recensito
            response.sendRedirect(request.getContextPath() + "/prodotto?id=" + prodottoId);

        } catch (NumberFormatException e) {
            // Gestione errore nel caso i parametri ID o Voto non siano numeri validi
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=dati_corrotti");
        } catch (Exception e) {
            
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/errore.jsp");
        }
    }

    private String pulisciTesto(String input) {
        if (input == null) return "";
        return input.replaceAll("&", "&amp;")
                    .replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll("\"", "&quot;")
                    .replaceAll("'", "&#x27;");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}