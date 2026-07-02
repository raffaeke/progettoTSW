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

// Protegge le risorse che richiedono un utente autenticato: controlla il token di sessione
// generato da LoginServlet al login (non solo la presenza dell'oggetto "utente").
@WebFilter(urlPatterns = {
		"/CheckoutServlet",
		"/ModificaProfilo",
		"/IniziaChat",
		"/InviaMessaggioCliente",
		"/Recensione",
		"/view/client/*",
		"/view/profilo"
})
public class AuthFilter implements Filter {

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		HttpSession session = request.getSession(false);

		boolean autenticato = session != null
				&& session.getAttribute("token") != null
				&& session.getAttribute("utente") != null;

		if (!autenticato) {
			String uri = request.getRequestURI();
			// Preserva l'intento di checkout: dopo il login l'utente torna dove voleva arrivare
			if (uri.contains("checkout") || uri.contains("Checkout")) {
				response.sendRedirect(request.getContextPath() + "/view/login?redirect=checkout");
			} else {
				response.sendRedirect(request.getContextPath() + "/view/login");
			}
			return;
		}
		chain.doFilter(req, res);
	}
}
