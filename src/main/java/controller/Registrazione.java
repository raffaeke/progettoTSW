package controller;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.UtenteDAO;
import model.Utente;
import model.Ruolo;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;



@WebServlet("/Registrazione")
public class Registrazione extends HttpServlet{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException{
		String username = request.getAttribute("username").toString();
		String email = request.getAttribute("email").toString();
		String password = request.getAttribute("password").toString();
		String indirizzo = request.getAttribute("indirizzo").toString();
		RequestDispatcher dispatcherToRegPage=request.getRequestDispatcher("registrazione.jsp");
		
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
			request.setAttribute("errors", errors);
			dispatcherToRegPage.forward(request, response);
			return;
		}
		
		Utente user = new Utente();
		user.setUsername(username.trim()); 
		user.setEmail(email.trim());
		user.setPassword(password.trim());
		user.setIndirizzo(indirizzo);
		user.setRuolo(Ruolo.UTENTE);
		
		UtenteDAO dao= new UtenteDAO();
		if(dao.doSave(user)) {
			response.sendRedirect("login.jsp");
		}	else {
			request.setAttribute("errors","Registrazione fallita. Riprova");
			dispatcherToRegPage.forward(request, response);
		}
		
		
	}

}
