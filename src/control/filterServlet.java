package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class filterServlet
 */
@WebServlet("/filterServlet")
public class filterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public filterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		response.sendRedirect("index.jsp");
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		ServletOutputStream out = response.getOutputStream();
		response.setContentType("text/html");
		// Set selectedMetrics to contain the values sent from form
		String[] selectedMetrics = request.getParameterValues("metrics");
		// Validation for selectedMetrics
		if (selectedMetrics == null) {
			response.sendRedirect("index.jsp?status=error2");
			return;
		} else if (selectedMetrics.length > 5) {
			response.sendRedirect("index.jsp?status=error");
			return;
		}
		for (int i = 0; i < selectedMetrics.length; i++) {
			out.println(selectedMetrics[i]);
		}
		
	}

}
