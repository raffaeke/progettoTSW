package control;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Stato;
import daoImpl.OrdineDAOImpl;

@WebServlet("/GestioneOrdini")
public class GestioneOrdiniServlet extends HttpServlet{
	
	protected void doPost(HttpServletRequest request,HttpServletResponse response ) 
						throws ServletException,IOException{
		HttpSession session = request.getSession();
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (session.getAttribute("utente") == null || isAdmin == null || !isAdmin) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        String idParam = request.getParameter("ordineId");
        String statoParam = request.getParameter("nuovoStato");

        if (idParam != null && statoParam != null) {
            try {
                int idOrdine = Integer.parseInt(idParam);
                Stato nuovoStato = Stato.valueOf(statoParam.trim().toUpperCase());
                
                OrdineDAOImpl dao=new OrdineDAOImpl();
                dao.doUpdateStatoByID(idOrdine, nuovoStato);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/view/admin/ordini"); 
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/view/admin/ordini");
    }
}


	
