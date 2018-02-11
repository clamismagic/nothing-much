package control;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.HostGenSQL;

/**
 * Servlet implementation class connectBarChartServlet
 */
@WebServlet("/connectBarChartServlet")
public class connectBarChartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public connectBarChartServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HostGenSQL hostSQL;
		try {
			hostSQL = new HostGenSQL(request);
			String hostname = request.getParameter("hostname");
			String time = request.getParameter("time");
			ArrayList<String> plotConnectChart = new ArrayList<>();
			plotConnectChart = hostSQL.popConnectBarChart(hostname, Long.parseLong(time));
			System.out.println(plotConnectChart.size());
			for (String oneConnect : plotConnectChart) {
				System.out.println(oneConnect);
			}
			request.setAttribute("chartData", plotConnectChart);
			request.getRequestDispatcher("host-zoom.jsp?plotting=success").forward(request, response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return;
	}
}
