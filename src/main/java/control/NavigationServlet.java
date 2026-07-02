package control;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet({"/view/*", ""})
public class NavigationServlet extends HttpServlet{

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String path = request.getPathInfo();

	    if (path == null || path.equals("/")) {
	        // Copre sia "/" (home, mappata su url-pattern "") sia "/view" senza sotto-percorso
	        request.getRequestDispatcher("/WEB-INF/view/index.jsp").forward(request, response);
	        return;
	    }

	    if (path.startsWith("/")) {
	        path = path.substring(1);
	    }

	    String pathDir = "/WEB-INF/view/";
	    String target = pathDir + path + ".jsp"; 

	    request.getRequestDispatcher(target).forward(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
		    throws ServletException, IOException {
		    doGet(request, response); 
		}
	
}
