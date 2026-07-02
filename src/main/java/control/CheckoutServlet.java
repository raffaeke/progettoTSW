package control;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ItemCarrello;
import model.Ordine;
import model.RigaOrdine;
import model.Stato;
import model.Utente;
import daoImpl.CarrelloDAOImpl;
import daoImpl.OrdineDAOImpl;
import daoImpl.RigaOrdineDAOImpl;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    private OrdineDAOImpl ordineDAO = new OrdineDAOImpl();
    private RigaOrdineDAOImpl rigaOrdineDAO = new RigaOrdineDAOImpl();
    private CarrelloDAOImpl carrelloDAO = new CarrelloDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/view/client/checkout");
    }

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utente");
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/view/login?redirect=checkout");
            return;
        }

        List<ItemCarrello> carrello = (List<ItemCarrello>) session.getAttribute("carrello");
        if (carrello == null || carrello.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/carrello");
            return;
        }

        String indirizzo = request.getParameter("indirizzo");
        String provincia = request.getParameter("provincia");
        String paese = request.getParameter("paese");
        String titolare = request.getParameter("titolare");
        String numeroCarta = request.getParameter("numeroCarta");
        String scadenza = request.getParameter("scadenza");
        String cvv = request.getParameter("cvv");

        List<String> errors = new ArrayList<>();

        if (indirizzo == null || indirizzo.trim().isEmpty()) {
            errors.add("Indirizzo non puo essere vuoto");
        }
        if (provincia == null || provincia.trim().isEmpty()) {
            errors.add("Provincia non puo essere vuota");
        }
        if (paese == null || paese.trim().isEmpty()) {
            errors.add("Paese non puo essere vuoto");
        }
        if (titolare == null || titolare.trim().isEmpty()) {
            errors.add("Il nome del titolare della carta non puo essere vuoto");
        }
        if (numeroCarta == null || numeroCarta.trim().isEmpty()) {
            errors.add("Il numero della carta non puo essere vuoto");
        }
        if (scadenza == null || scadenza.trim().isEmpty()) {
            errors.add("La scadenza della carta non puo essere vuota");
        }
        if (cvv == null || cvv.trim().isEmpty()) {
            errors.add("Il CVV non puo essere vuoto");
        }

        RequestDispatcher dispatcherToCheckoutPage = request.getRequestDispatcher("/WEB-INF/view/client/checkout.jsp");

        if (!errors.isEmpty()) {
            request.setAttribute("errore", errors);
            request.setAttribute("indirizzoInserito", indirizzo);
            request.setAttribute("provinciaInserita", provincia);
            request.setAttribute("paeseInserito", paese);
            request.setAttribute("titolareInserito", titolare);
            dispatcherToCheckoutPage.forward(request, response);
            return;
        }

        try {
            Ordine ordine = new Ordine();
            ordine.setUtenteId(utente.getId());
            ordine.setData(LocalDate.now());
            ordine.setStato(Stato.IN_ELABORAZIONE);
            int ordineId = ordineDAO.doSave(ordine);

            for (ItemCarrello item : carrello) {
                RigaOrdine riga = new RigaOrdine();
                riga.setOrdineId(ordineId);
                riga.setProdottoId(item.getP().getId());
                riga.setQuantita(item.getQuantita());
                riga.setPrezzo(item.getP().getPrezzoScontato());
                rigaOrdineDAO.doSave(riga);
            }

            session.setAttribute("carrello", new ArrayList<ItemCarrello>());
            carrelloDAO.doDeleteAll(utente.getId());

            response.sendRedirect(request.getContextPath() + "/view/profilo?ordine=ok");
        } catch (SQLException e) {
            e.printStackTrace();
            errors.add("Si e verificato un errore durante la conferma dell'ordine. Riprova.");
            request.setAttribute("errore", errors);
            dispatcherToCheckoutPage.forward(request, response);
        }
    }
}
