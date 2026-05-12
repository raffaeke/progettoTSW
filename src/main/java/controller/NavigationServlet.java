package controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/view/*")
public class NavigationServlet extends HttpServlet{
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
						throws ServletException,IOException{
		String path = request.getPathInfo();
		
		String pathDir = "/WEB-INF/view/";
		String target = "";
		if (path == null || path.equals("/")) {
			request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;        
            } else {
            target = path.substring(1) + ".jsp"; 
        }
		request.getRequestDispatcher(pathDir+target).forward(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
		    throws ServletException, IOException {
		    doGet(request, response); 
		}
	
}
