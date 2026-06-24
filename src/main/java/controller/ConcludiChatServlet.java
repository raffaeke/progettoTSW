package controller;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.beans.Utente;
import model.daoImpl.ChatDAOImpl;
@WebServlet("/ConcludiChat")
public class ConcludiChatServlet extends HttpServlet{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
							throws ServletException,IOException{
		
			HttpSession session= request.getSession();
			Utente adminLoggato= (Utente)session.getAttribute("utente");
			if (adminLoggato == null || session.getAttribute("isAdmin") == null || !(Boolean)session.getAttribute("isAdmin")) {
				response.sendRedirect(request.getContextPath() + "/index.jsp");
				return;
			}
			String chatIdParam = request.getParameter("chatId");
			if (chatIdParam != null && !chatIdParam.isEmpty()) {
	            int chatId = Integer.parseInt(chatIdParam);
	            try {
	            	ChatDAOImpl dao= new ChatDAOImpl();
	            	dao.doDelete(chatId);
	            }catch(SQLException e) {
	            	e.printStackTrace();
	            }
			}
			response.sendRedirect(request.getContextPath() + "/view/admin/assistenza");
	}

}
