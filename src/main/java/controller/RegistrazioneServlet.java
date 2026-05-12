package controller;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.daoImpl.UtenteDAOImpl;
import util.PassCrypted;
import model.beans.Utente;
import model.beans.Ruolo;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;



@WebServlet("/RegistrazioneServlet")
public class RegistrazioneServlet extends HttpServlet{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException{
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String indirizzo = request.getParameter("indirizzo");
		RequestDispatcher dispatcherToRegPage = request.getRequestDispatcher("/view/registrazione");
		
		List<String> errors=new ArrayList<>();
		
		if(username==null || username.trim().isEmpty()) {
			errors.add("Username non puo essere vuoto");
		}
		if(email==null || email.trim().isEmpty()) {
			errors.add("Email non puo essere vuoto");
		}
		if(password==null || password.trim().isEmpty()) {
			errors.add("Password non puo essere vuoto");
		}
		
		if(!errors.isEmpty()) {
			request.setAttribute("errore", errors);
			dispatcherToRegPage.forward(request, response);
			return;
		}
		
		String passwordHashata = PassCrypted.hashPassword(password);
		Utente user = new Utente();
		user.setUsername(username.trim()); 
		user.setEmail(email.trim());
		user.setPassword(passwordHashata);
		user.setIndirizzo(indirizzo);
		user.setRuolo(Ruolo.customer);
		
		UtenteDAOImpl dao= new UtenteDAOImpl();
		if(dao.doSave(user)) {
			response.sendRedirect(request.getContextPath() + "/view/login");
		}	else {
			request.setAttribute("errore","Registrazione fallita. Riprova");
			dispatcherToRegPage.forward(request, response);
		}
		
		
	}

}
