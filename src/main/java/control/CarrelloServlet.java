package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Prodotto;
import model.Spec_prodotto;
import model.ItemCarrello;
import model.Utente;
import dao.ProdottoDAO;
import dao.Spec_prodottoDAO;
import daoImpl.CarrelloDAOImpl;
import daoImpl.ProdottoDAOImpl;
import daoImpl.Spec_prodottoDAOImpl;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {

    private CarrelloDAOImpl carrelloDAO = new CarrelloDAOImpl();

    // Se l'utente è loggato, sincronizza la quantità di una taglia anche sul DB (carrello persistente)
    private void sincronizzaSpec(HttpSession session, int specId, int quantita) {
        Utente utente = (Utente) session.getAttribute("utente");
        if (utente == null) return;
        try {
            if (quantita > 0) {
                carrelloDAO.doUpsert(utente.getId(), specId, quantita);
            } else {
                carrelloDAO.doDelete(utente.getId(), specId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gestione preventiva dei parametri per evitare NullPointerException
        String specIdStr = request.getParameter("specId");
        String action = request.getParameter("action");

        if (action == null) action = "";

        HttpSession session = request.getSession();
        ArrayList<ItemCarrello> carrello = (ArrayList<ItemCarrello>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }

        ProdottoDAO prodottoDao = new ProdottoDAOImpl();
        Spec_prodottoDAO specDao = new Spec_prodottoDAOImpl();

        try {
            if (specIdStr != null && !specIdStr.isEmpty()) {
                int specId = Integer.parseInt(specIdStr);
                boolean trovato = false;
                int quantitaFinale = 0;

                if (action.equals("aggiungi")) {
                    for (ItemCarrello item : carrello) {
                        if (item.getSpec().getId() == specId) {
                            // Non si puo' mettere in carrello piu' di quanto disponibile in magazzino per questa taglia
                            int nuovaQty = Math.min(item.getQuantita() + 1, item.getSpec().getQuantita());
                            item.setQuantita(nuovaQty);
                            quantitaFinale = nuovaQty;
                            trovato = true;
                            break;
                        }
                    }
                    if (!trovato) {
                        Spec_prodotto spec = specDao.doRetrieveByKey(specId);
                        if (spec != null && spec.getQuantita() > 0) {
                            Prodotto p = prodottoDao.doRetrieveByKey(spec.getProdottoId());
                            // Un prodotto rimosso dal catalogo (cancellazione logica) non e' piu' acquistabile
                            if (p != null && !p.isEliminato()) {
                                ItemCarrello item = new ItemCarrello();
                                item.setProdotto(p);
                                item.setSpec(spec);
                                item.setQuantita(1);
                                carrello.add(item);
                                quantitaFinale = 1;
                            }
                        }
                    }
                    sincronizzaSpec(session, specId, quantitaFinale);

                } else if (action.equals("remove")) {
                    // Usiamo l'Iterator per evitare il ConcurrentModificationException
                    Iterator<ItemCarrello> iterator = carrello.iterator();
                    while (iterator.hasNext()) {
                        ItemCarrello item = iterator.next();
                        if (item.getSpec().getId() == specId) {
                            item.setQuantita(item.getQuantita() - 1);
                            quantitaFinale = item.getQuantita();
                            if (item.getQuantita() <= 0) {
                                iterator.remove(); // Rimozione sicura
                            }
                            break;
                        }
                    }
                    sincronizzaSpec(session, specId, quantitaFinale);
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

        String specIdStr = request.getParameter("specId");
        String action = request.getParameter("action");
        if (action == null) action = "";

        HttpSession session = request.getSession();
        ArrayList<ItemCarrello> carrello = (ArrayList<ItemCarrello>) session.getAttribute("carrello");

        if (carrello != null && specIdStr != null && !specIdStr.isEmpty()) {
            int specId = Integer.parseInt(specIdStr);

            if (action.equals("update")) {
                String qtyStr = request.getParameter("quantita");
                if (qtyStr != null && !qtyStr.isEmpty()) {
                    int nuovaQty = Integer.parseInt(qtyStr);
                    for (ItemCarrello item : carrello) {
                        if (item.getSpec().getId() == specId) {
                            // Non si puo' impostare una quantita' superiore allo stock disponibile per la taglia
                            nuovaQty = Math.min(nuovaQty, item.getSpec().getQuantita());
                            if (nuovaQty > 0) {
                                item.setQuantita(nuovaQty);
                            } else {
                                // Se la quantità scende a 0 o meno, lo eliminiamo
                                carrello.remove(item);
                            }
                            break;
                        }
                    }
                    sincronizzaSpec(session, specId, Math.max(nuovaQty, 0));
                }

            } else if (action.equals("remove")) {
                // RIMOZIONE TOTALE: Rimuove l'intero elemento dal carrello
                Iterator<ItemCarrello> iterator = carrello.iterator();
                while (iterator.hasNext()) {
                    ItemCarrello item = iterator.next();
                    if (item.getSpec().getId() == specId) {
                        iterator.remove();
                        break;
                    }
                }
                sincronizzaSpec(session, specId, 0);
            }
        }

        // Ricarica la pagina del carrello aggiornando l'interfaccia ed evitando il reinvio dei form
        response.sendRedirect(request.getContextPath() + "/view/carrello");
    }
}
