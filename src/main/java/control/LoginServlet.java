package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import daoImpl.CarrelloDAOImpl;
import daoImpl.UtenteDAOImpl;
import util.PassCrypted;
import model.ItemCarrello;
import model.Utente;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
				throws ServletException, IOException{
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String passwordHashata= PassCrypted.hashPassword(password);
		RequestDispatcher dispatcherToLoginPage=request.getRequestDispatcher("/view/login");
		List<String> errors=new ArrayList<>();

		if(email==null || email.trim().isEmpty()) {
			errors.add("Email non puo essere vuoto");
		}
		if(password==null || password.trim().isEmpty()) {
			errors.add("Password non puo essere vuoto");
		}
		
		if(!errors.isEmpty()) {
			request.setAttribute("errore", errors);
			dispatcherToLoginPage.forward(request, response);
			return;
		}
		
		email = email.trim();
		UtenteDAOImpl dao=new UtenteDAOImpl();
		if(email.equals("admin@admin.it") && passwordHashata.equals(PassCrypted.hashPassword("admin"))) {
			HttpSession session = request.getSession();
			Utente admin= new Utente();
			admin.setId(11);
			admin.setNome("Amministratore");
			admin.setCognome("");
			admin.setEmail(email);
			session.setAttribute("utente", admin);
			session.setAttribute("isAdmin", true);
			session.setAttribute("token", UUID.randomUUID().toString());
			response.sendRedirect(request.getContextPath() + "/view/admin/dashboard");
			return;
		}
		Utente logged= dao.doRetrieveByEmailPassword(email, passwordHashata);
		if(logged != null) {
			HttpSession session = request.getSession();
			caricaCarrelloPersistente(session, logged);
			session.setAttribute("utente", logged);
			session.setAttribute("token", UUID.randomUUID().toString());

			// Whitelist esplicita per evitare open-redirect: solo valori noti, non URL arbitrari
			String redirect = request.getParameter("redirect");
			if ("checkout".equals(redirect)) {
				response.sendRedirect(request.getContextPath() + "/view/client/checkout");
			} else {
				response.sendRedirect(request.getContextPath() + "/view/profilo");
			}
		}	else {
			request.setAttribute("errore","Email e/o password errati");
			dispatcherToLoginPage.forward(request, response);
		}

	}

	// Unisce il carrello ospite (accumulato in sessione prima del login) con quello salvato su DB
	// per l'utente, cosi' il carrello sopravvive a logout/login (session.invalidate() svuota solo la sessione).
	@SuppressWarnings("unchecked")
	private void caricaCarrelloPersistente(HttpSession session, Utente logged) {
		CarrelloDAOImpl carrelloDAO = new CarrelloDAOImpl();
		try {
			List<ItemCarrello> carrelloOspite = (List<ItemCarrello>) session.getAttribute("carrello");
			if (carrelloOspite != null && !carrelloOspite.isEmpty()) {
				List<ItemCarrello> carrelloDb = carrelloDAO.doRetrieveByUtente(logged.getId());
				for (ItemCarrello itemOspite : carrelloOspite) {
					int nuovaQuantita = itemOspite.getQuantita();
					for (ItemCarrello itemDb : carrelloDb) {
						if (itemDb.getSpec().getId() == itemOspite.getSpec().getId()) {
							nuovaQuantita += itemDb.getQuantita();
							break;
						}
					}
					carrelloDAO.doUpsert(logged.getId(), itemOspite.getSpec().getId(), nuovaQuantita);
				}
			}
			session.setAttribute("carrello", new ArrayList<ItemCarrello>(carrelloDAO.doRetrieveByUtente(logged.getId())));
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
