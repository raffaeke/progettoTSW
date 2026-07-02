package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.beans.Prodotto;
import model.beans.ItemCarrello;
import model.dao.ProdottoDAO;
import model.daoImpl.ProdottoDAOImpl;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
    
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
                
                if (action.equals("aggiungi")) {
                    for (ItemCarrello item : carrello) {
                        if (item.getP().getId() == id) {
                            item.setQuantita(item.getQuantita() + 1);
                            trovato = true;
                            break;
                        }
                    }
                    if (!trovato) {
                        Prodotto p = dao.doRetrieveByKey(id);
                        if (p != null) {
                            ItemCarrello item = new ItemCarrello();
                            item.setProdotto(p);
                            item.setQuantita(1); // Imposta direttamente a 1
                            carrello.add(item);
                        }
                    }
                    
                } else if (action.equals("remove")) {
                    // Usiamo l'Iterator per evitare il ConcurrentModificationException
                    Iterator<ItemCarrello> iterator = carrello.iterator();
                    while (iterator.hasNext()) {
                        ItemCarrello item = iterator.next();
                        if (item.getP().getId() == id) {
                            item.setQuantita(item.getQuantita() - 1);
                            if (item.getQuantita() <= 0) {
                                iterator.remove(); // Rimozione sicura
                            }
                            break;
                        }
                    }
                }
            }
            
            if (action.equals("clear")) {
                carrello.clear();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
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
            }
        }
        
        // Ricarica la pagina del carrello aggiornando l'interfaccia ed evitando il reinvio dei form
        response.sendRedirect(request.getContextPath() + "/view/carrello");
    }
}