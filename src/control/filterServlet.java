package control;

import com.google.gson.Gson;

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
	
		response.sendRedirect("meadow.jsp");
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get currentTime and fiveMinBefore
		String currentTime = request.getParameter("currentTime");
		String fiveMinBefore = request.getParameter("fiveMinBefore");
		// Get selectedMetrics
		String[] selectedMetrics = request.getParameterValues("metrics");
		String timelineMetrics = request.getParameter("timelineMetrics");
		if (timelineMetrics != null && selectedMetrics == null) {
			System.out.println(timelineMetrics);
			selectedMetrics = timelineMetrics.split(",");
		}
		// Declare manager
		Meadow meadow = new Meadow();
		MeadowManager meadowManager = new MeadowManager();
		meadow = meadowManager.genHost(request, fiveMinBefore, currentTime, selectedMetrics);
		// Validation for selectedMetrics
		if (selectedMetrics == null) {
			request.getRequestDispatcher("meadow.jsp?status=error2").forward(request, response);
			return;
		} else if (selectedMetrics.length > 5) {
			request.getRequestDispatcher("meadow.jsp?status=error").forward(request, response);
			return;
		} else {
			if (timelineMetrics != null) {
				// request originates from ajax, parse meadow object to JSON and forward back to AJAX
				Gson gson = new Gson();
				String jsonMeadow = gson.toJson(meadow);
				System.out.println(jsonMeadow);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(jsonMeadow);
			} else {
				request.setAttribute("meadow", meadow);
				request.getRequestDispatcher("meadow.jsp?status=working").forward(request, response);
			}
		}
	}	

}
