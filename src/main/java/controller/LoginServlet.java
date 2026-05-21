package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.daoImpl.UtenteDAOImpl;
import util.PassCrypted;
import model.beans.Utente;
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
		RequestDispatcher dispatcherToLoginPage=request.getRequestDispatcher("login.jsp");
		List<String> errors=new ArrayList<>();

		if(email==null || email.trim().isEmpty()) {
			errors.add("Email non puo essere vuoto");
		}
		if(password==null || password.trim().isEmpty()) {
			errors.add("Password non puo essere vuoto");
		}
		
		if(!errors.isEmpty()) {
			request.setAttribute("errors", errors);
			dispatcherToLoginPage.forward(request, response);
			return;
		}
		
		email = email.trim();
		UtenteDAOImpl dao=new UtenteDAOImpl();
		if(email.equals("admin@admin.it") && passwordHashata.equals(PassCrypted.hashPassword("admin"))) {
			HttpSession session = request.getSession();
			Utente admin= new Utente();
			admin.setNome("Amministratore");
			admin.setCognome("");
			admin.setEmail(email);
			session.setAttribute("utente", admin);
			session.setAttribute("isAdmin", true);
			response.sendRedirect(request.getContextPath() + "/view/admin/dashboard");
			return;
		}
		Utente logged= dao.doRetrieveByEmailPassword(email, passwordHashata);
		if(logged != null) {
			HttpSession session = request.getSession();
			session.setAttribute("utente", logged);
			response.sendRedirect(request.getContextPath() + "/view/profilo");		
		}	else {
			request.setAttribute("errors","Accesso fallita. Riprova");
			dispatcherToLoginPage.forward(request, response);
		}
				
	}

}
