package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Meadow;
import model.MeadowManager;

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
		// Get currentTime and fiveMinBefore
		String currentTime = request.getParameter("currentTime");
		System.out.println(currentTime);
		String fiveMinBefore = request.getParameter("fiveMinBefore");
		System.out.println(fiveMinBefore);
		// Get selectedMetrics
		String[] selectedMetrics = request.getParameterValues("metrics");
		System.out.println(selectedMetrics);
		String timelineMetrics = request.getParameter("timelineMetrics");
		System.out.println(timelineMetrics);
		System.out.println("debug");
		// Declare manager
		Meadow meadow = new Meadow();
		MeadowManager meadowManager = new MeadowManager();
		meadow = meadowManager.genHost(request, fiveMinBefore, currentTime, selectedMetrics);
		// Validation for selectedMetrics
		if (selectedMetrics == null) {
			response.sendRedirect("index.jsp?status=error2");
			return;
		} else if (selectedMetrics.length > 5) {
			response.sendRedirect("index.jsp?status=error");
			return;
		} else {
			request.setAttribute("meadow", meadow);
			request.getRequestDispatcher("index.jsp?status=working").forward(request, response);
		}
	}	

}
