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

@WebServlet("/Login")
public class LoginServlet extends HttpServlet{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
				throws ServletException, IOException{
		String email = request.getParameter("email");
		String password = request.getParameter("password");
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
		password = password.trim();
		UtenteDAO dao=new UtenteDAO();
		
		Utente logged= dao.doRetrieveByEmailPassword(email, password);
		if(logged != null) {
			HttpSession session = request.getSession();
			session.setAttribute("utente", logged);
			if(logged.getRuolo().equals(Ruolo.admin)) {
				/*TODO*/response.sendRedirect("");
			}	else {
				response.sendRedirect("index.jsp");
			}
			
		}	else {
			request.setAttribute("errors","Accesso fallita. Riprova");
			dispatcherToLoginPage.forward(request, response);
		}
				
	}

}
