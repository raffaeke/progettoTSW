package control;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import daoImpl.UtenteDAOImpl;
import util.PassCrypted;
import model.Utente;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;



@WebServlet("/RegistrazioneServlet")
public class RegistrazioneServlet extends HttpServlet{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException{
		String nome = request.getParameter("nome");
		String cognome = request.getParameter("cognome");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String indirizzo = request.getParameter("indirizzo");
		String provincia = request.getParameter("provincia");
		String paese = request.getParameter("paese");
		RequestDispatcher dispatcherToRegPage = request.getRequestDispatcher("/view/registrazione");
		
		List<String> errors=new ArrayList<>();
		
		if(nome==null || nome.trim().isEmpty()) {
			errors.add("nome non puo essere vuoto");
		}
		if(cognome==null || cognome.trim().isEmpty()) {
			errors.add("Username non puo essere vuoto");
		}
		if(email==null || email.trim().isEmpty()) {
			errors.add("Email non puo essere vuoto");
		}
		if(password==null || password.trim().isEmpty()) {
			errors.add("Password non puo essere vuoto");
		}
		if(indirizzo==null || indirizzo.trim().isEmpty()) {
			errors.add("indirizzo non puo essere vuoto");
		}
		if(provincia==null || provincia.trim().isEmpty()) {
			errors.add("provincia non puo essere vuoto");
		}
		if(paese==null || paese.trim().isEmpty()) {
			errors.add("paese non puo essere vuoto");
		}
		
		if(!errors.isEmpty()) {
			request.setAttribute("errore", errors);
			dispatcherToRegPage.forward(request, response);
			return;
		}
		
		String passwordHashata = PassCrypted.hashPassword(password);
		Utente user = new Utente();
		user.setNome(nome.trim()); 
		user.setCognome(cognome.trim());
		user.setEmail(email.trim());
		user.setPassword(passwordHashata);
		user.setIndirizzo(indirizzo);
		user.setProvincia(provincia);
		user.setPaese(paese);
		
		UtenteDAOImpl dao= new UtenteDAOImpl();
		if(dao.doSave(user)) {
			response.sendRedirect(request.getContextPath() + "/view/login");
		}	else {
			request.setAttribute("errore","Registrazione fallita. Riprova");
			dispatcherToRegPage.forward(request, response);
		}
		
		
	}

}
