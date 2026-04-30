import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("Logout")
public class Logout extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
						throws ServletException,IOException{
		HttpSession session = request.getSession();
		
		if(session != null) {
			session.invalidate();
		}
		
		response.sendRedirect("index.jsp");
	}

}
