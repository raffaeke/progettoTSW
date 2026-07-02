package control;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Protegge il pannello e le servlet di amministrazione: richiede token di sessione + flag isAdmin.
@WebFilter(urlPatterns = {
		"/GestioneProdotti",
		"/GestioneOrdini",
		"/ConcludiChat",
		"/InviaMessaggioAssistenza",
		"/view/admin/*"
})
public class AdminFilter implements Filter {

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		HttpSession session = request.getSession(false);

		boolean isAdmin = session != null
				&& session.getAttribute("token") != null
				&& Boolean.TRUE.equals(session.getAttribute("isAdmin"));

		if (!isAdmin) {
			response.sendRedirect(request.getContextPath() + "/view/login");
			return;
		}
		chain.doFilter(req, res);
	}
}
