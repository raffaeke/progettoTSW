package control;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import daoImpl.UtenteDAOImpl;
import model.Utente;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/ModificaProfilo")
public class ModificaProfiloServlet extends HttpServlet{

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException{
		HttpSession session = request.getSession();
		Utente utente = (Utente) session.getAttribute("utente");
		if (utente == null) {
			response.sendRedirect(request.getContextPath() + "/view/login");
			return;
		}

		String nome = request.getParameter("nome");
		String cognome = request.getParameter("cognome");
		String indirizzo = request.getParameter("indirizzo");
		String provincia = request.getParameter("provincia");
		String paese = request.getParameter("paese");

		RequestDispatcher dispatcherToProfiloPage = request.getRequestDispatcher("/view/profilo");

		List<String> errors = new ArrayList<>();

		if(nome==null || nome.trim().isEmpty()) {
			errors.add("Nome non puo essere vuoto");
		}
		if(cognome==null || cognome.trim().isEmpty()) {
			errors.add("Cognome non puo essere vuoto");
		}
		if(indirizzo==null || indirizzo.trim().isEmpty()) {
			errors.add("Indirizzo non puo essere vuoto");
		}
		if(provincia==null || provincia.trim().isEmpty()) {
			errors.add("Provincia non puo essere vuota");
		}
		if(paese==null || paese.trim().isEmpty()) {
			errors.add("Paese non puo essere vuoto");
		}

		if(!errors.isEmpty()) {
			request.setAttribute("errore", errors);
			request.setAttribute("editMode", true);
			request.setAttribute("nomeInserito", nome);
			request.setAttribute("cognomeInserito", cognome);
			request.setAttribute("indirizzoInserito", indirizzo);
			request.setAttribute("provinciaInserita", provincia);
			request.setAttribute("paeseInserito", paese);
			dispatcherToProfiloPage.forward(request, response);
			return;
		}

		utente.setNome(nome.trim());
		utente.setCognome(cognome.trim());
		utente.setIndirizzo(indirizzo.trim());
		utente.setProvincia(provincia.trim());
		utente.setPaese(paese.trim());

		UtenteDAOImpl dao = new UtenteDAOImpl();
		if(dao.doUpdate(utente)) {
			session.setAttribute("utente", utente);
			response.sendRedirect(request.getContextPath() + "/view/profilo");
		} else {
			request.setAttribute("errore", "Aggiornamento fallito. Riprova");
			request.setAttribute("editMode", true);
			dispatcherToProfiloPage.forward(request, response);
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    response.sendRedirect(request.getContextPath() + "/view/profilo");
	}
}
