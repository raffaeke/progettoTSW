package control;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Messaggio;
import model.Utente;
import daoImpl.MessaggioDAOImpl;

@WebServlet("/InviaMessaggioAssistenza")

public class InvioMessaggioAssistenzaServlet extends HttpServlet{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
							throws ServletException, IOException{
		HttpSession session= request.getSession();
		Utente adminLoggato= (Utente)session.getAttribute("utente");
		if (adminLoggato == null || session.getAttribute("isAdmin") == null || !(Boolean)session.getAttribute("isAdmin")) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
		String chatIdParam = request.getParameter("chatId");
        String testoMessaggio = request.getParameter("testoMessaggio");
        String redirectUrl = request.getParameter("redirectUrl");
        
        if (chatIdParam != null && testoMessaggio != null && !testoMessaggio.trim().isEmpty()) {
            try {
            	Messaggio m= new Messaggio();
            	m.setChat(Integer.parseInt(chatIdParam));
            	m.setTesto(testoMessaggio);
            	m.setMittente(adminLoggato.getId());
            	m.setDataInvio(LocalDate.now());
            	MessaggioDAOImpl dao= new MessaggioDAOImpl();
                dao.doSave(m);               
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/" + redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/view/admin/assistenza.jsp");
        }
	}

}
