package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Prodotto;
import model.ItemCarrello;
import model.Utente;
import dao.ProdottoDAO;
import daoImpl.CarrelloDAOImpl;
import daoImpl.ProdottoDAOImpl;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {

    private CarrelloDAOImpl carrelloDAO = new CarrelloDAOImpl();

    // Se l'utente è loggato, sincronizza la quantità di un prodotto anche sul DB (carrello persistente)
    private void sincronizzaProdotto(HttpSession session, int prodottoId, int quantita) {
        Utente utente = (Utente) session.getAttribute("utente");
        if (utente == null) return;
        try {
            if (quantita > 0) {
                carrelloDAO.doUpsert(utente.getId(), prodottoId, quantita);
            } else {
                carrelloDAO.doDelete(utente.getId(), prodottoId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gestione preventiva dei parametri per evitare NullPointerException
        String idStr = request.getParameter("id");
        String action = request.getParameter("action");

        if (action == null) action = "";

        HttpSession session = request.getSession();
        ArrayList<ItemCarrello> carrello = (ArrayList<ItemCarrello>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }

        ProdottoDAO dao = new ProdottoDAOImpl();

        try {
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                boolean trovato = false;
                int quantitaFinale = 0;

                if (action.equals("aggiungi")) {
                    for (ItemCarrello item : carrello) {
                        if (item.getP().getId() == id) {
                            item.setQuantita(item.getQuantita() + 1);
                            quantitaFinale = item.getQuantita();
                            trovato = true;
                            break;
                        }
                    }
                    if (!trovato) {
                        Prodotto p = dao.doRetrieveByKey(id);
                        // Un prodotto rimosso dal catalogo (cancellazione logica) non e' piu' acquistabile
                        if (p != null && !p.isEliminato()) {
                            ItemCarrello item = new ItemCarrello();
                            item.setProdotto(p);
                            item.setQuantita(1); // Imposta direttamente a 1
                            carrello.add(item);
                            quantitaFinale = 1;
                        }
                    }
                    sincronizzaProdotto(session, id, quantitaFinale);

                } else if (action.equals("remove")) {
                    // Usiamo l'Iterator per evitare il ConcurrentModificationException
                    Iterator<ItemCarrello> iterator = carrello.iterator();
                    while (iterator.hasNext()) {
                        ItemCarrello item = iterator.next();
                        if (item.getP().getId() == id) {
                            item.setQuantita(item.getQuantita() - 1);
                            quantitaFinale = item.getQuantita();
                            if (item.getQuantita() <= 0) {
                                iterator.remove(); // Rimozione sicura
                            }
                            break;
                        }
                    }
                    sincronizzaProdotto(session, id, quantitaFinale);
                }
            }

            if (action.equals("clear")) {
                carrello.clear();
                Utente utente = (Utente) session.getAttribute("utente");
                if (utente != null) {
                    carrelloDAO.doDeleteAll(utente.getId());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Questo endpoint viene navigato a pagina intera (non via AJAX): senza redirect il browser
        // mostrerebbe una pagina vuota dopo l'aggiunta/rimozione.
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
 // Gestisce i FORM sincroni della pagina carrello.jsp (Aggiorna e Rimuovi)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("prodottoId");
        String action = request.getParameter("action");
        if (action == null) action = "";

        HttpSession session = request.getSession();
        ArrayList<ItemCarrello> carrello = (ArrayList<ItemCarrello>) session.getAttribute("carrello");

        if (carrello != null && idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);

            if (action.equals("update")) {
                String qtyStr = request.getParameter("quantita");
                if (qtyStr != null && !qtyStr.isEmpty()) {
                    int nuovaQty = Integer.parseInt(qtyStr);
                    for (ItemCarrello item : carrello) {
                        if (item.getP().getId() == id) {
                            if (nuovaQty > 0) {
                                item.setQuantita(nuovaQty);
                            } else {
                                // Se la quantità scende a 0 o meno, lo eliminiamo
                                carrello.remove(item);
                            }
                            break;
                        }
                    }
                    sincronizzaProdotto(session, id, Math.max(nuovaQty, 0));
                }

            } else if (action.equals("remove")) {
                // RIMOZIONE TOTALE: Rimuove l'intero elemento dal carrello
                Iterator<ItemCarrello> iterator = carrello.iterator();
                while (iterator.hasNext()) {
                    ItemCarrello item = iterator.next();
                    if (item.getP().getId() == id) {
                        iterator.remove();
                        break;
                    }
                }
                sincronizzaProdotto(session, id, 0);
            }
        }

        // Ricarica la pagina del carrello aggiornando l'interfaccia ed evitando il reinvio dei form
        response.sendRedirect(request.getContextPath() + "/view/carrello");
    }
}
