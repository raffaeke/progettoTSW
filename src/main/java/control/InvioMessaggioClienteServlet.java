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

@WebServlet("/InviaMessaggioCliente")
public class InvioMessaggioClienteServlet extends HttpServlet{

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
							throws ServletException, IOException{
		HttpSession session = request.getSession();
		Utente utente = (Utente) session.getAttribute("utente");
		Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
		if (utente == null || (isAdmin != null && isAdmin)) {
			response.sendRedirect(request.getContextPath() + "/view/login");
			return;
		}

		String chatIdParam = request.getParameter("chatId");
		String testoMessaggio = request.getParameter("testoMessaggio");

		if (chatIdParam != null && testoMessaggio != null && !testoMessaggio.trim().isEmpty()) {
			try {
				int chatId = Integer.parseInt(chatIdParam);

				// La chat indicata deve appartenere effettivamente al cliente loggato
				ChatDAOImpl chatDao = new ChatDAOImpl();
				Chat chatDelCliente = chatDao.doRetrieveByCliente(utente.getId());

				if (chatDelCliente != null && chatDelCliente.getId() == chatId) {
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
		}

		response.sendRedirect(request.getContextPath() + "/view/client/assistenzaClienti");
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    response.sendRedirect(request.getContextPath() + "/view/client/assistenzaClienti");
	}
}
