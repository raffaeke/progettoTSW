package control;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Chat;
import model.Messaggio;
import model.Utente;
import daoImpl.ChatDAOImpl;
import daoImpl.MessaggioDAOImpl;

@WebServlet("/IniziaChat")
public class IniziaChatServlet extends HttpServlet{

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
							throws ServletException, IOException{
		HttpSession session = request.getSession();
		Utente utente = (Utente) session.getAttribute("utente");
		Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
		if (utente == null || (isAdmin != null && isAdmin)) {
			response.sendRedirect(request.getContextPath() + "/view/login");
			return;
		}

		String testoMessaggio = request.getParameter("testoMessaggio");

		try {
			ChatDAOImpl chatDao = new ChatDAOImpl();
			Chat chatEsistente = chatDao.doRetrieveByCliente(utente.getId());

			if (chatEsistente == null && testoMessaggio != null && !testoMessaggio.trim().isEmpty()) {
				Chat nuovaChat = new Chat();
				nuovaChat.setCliente(utente.getId());
				nuovaChat.setDataCreazione(LocalDate.now());
				int chatId = chatDao.doSave(nuovaChat);

				Messaggio m = new Messaggio();
				m.setChat(chatId);
				m.setMittente(utente.getId());
				m.setTesto(testoMessaggio);
				m.setDataInvio(LocalDate.now());

				MessaggioDAOImpl msgDao = new MessaggioDAOImpl();
				msgDao.doSave(m);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		response.sendRedirect(request.getContextPath() + "/view/client/assistenzaClienti");
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    response.sendRedirect(request.getContextPath() + "/view/client/assistenzaClienti");
	}
}
