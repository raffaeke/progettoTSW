package controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.beans.Prodotto;
import model.beans.ItemCarrello;
import model.dao.ProdottoDAO;
import model.daoImpl.ProdottoDAOImpl;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
	
	
	//Gestiamo aggiunta, rimozione e pulizia
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
				throws ServletException, IOException{
			int id = Integer.parseInt(request.getParameter("id"));
			String action = request.getParameter("action");
			HttpSession session= request.getSession();
			ArrayList<ItemCarrello> carrello = (ArrayList<ItemCarrello>) session.getAttribute("carrello");
			if(carrello == null) {
				carrello= new ArrayList<>();
				session.setAttribute("carrello", carrello);
			}
			ProdottoDAO dao=new ProdottoDAOImpl();
			try {
				boolean trovato = false;
				if(action.equals("add")) {
					
					for(ItemCarrello item : carrello) {
						if(item.getP().getId() == id) {
							item.setQuantita(item.getQuantita()+1);
							trovato=true;
							break;
						}
					}
					if(!trovato) {
						Prodotto p = dao.doRetrieveByKey(id);
						ItemCarrello item = new ItemCarrello();
						item.setProdotto(p);
						item.setQuantita(item.getQuantita()+1);
						carrello.add(item);
					}
					
					
				}else if(action.equals("remove")) {
					
					for(ItemCarrello item : carrello) {
						if(item.getP().getId() == id) {
							item.setQuantita(item.getQuantita()-1);
							if(item.getQuantita() == 0) {
								carrello.remove(item);
							}
							trovato=true;
							break;
						}
					}
					if(!trovato) {

						//ERRORE TODO
						
					}						
					
							}else if(action.equals("clear")) {
								
								carrello.clear();
								
					
							
									}else {
										
										//TODO
					
								}
			} catch (SQLException e) {
				e.printStackTrace();
			}
	
	}					

}
