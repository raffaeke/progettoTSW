package controller;
import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.beans.Prodotto;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
	
	
	//Gestiamo aggiunta, rimozione e pulizia
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
				throws ServletException, IOException{
			int id = Integer.parseInt(request.getParameter("id"));
			String action = request.getParameter("action");
			HttpSession session= request.getSession();
			ArrayList<Prodotto> carrello = (ArrayList<Prodotto>) session.getAttribute("carrello");
			if(carrello == null) {
				carrello= new ArrayList<>();
				session.setAttribute("carrello", carrello);
			}
			if(action.equals("add")) {
				//TODO ProdottoDAO dao=new ProdottoDAO();
				
				}else if(action.equals("remove")) {
					
				
						}else if(action.equals("clear")) {
				
							
								}else {
									
									//ERRORE
				
							}
	}					

}
