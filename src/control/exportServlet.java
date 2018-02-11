package control;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.QueryData;
import model.QueryDataManager;

/**
 * Servlet implementation class exportServlet
 */
@WebServlet("/exportServlet")
public class exportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public exportServlet() {
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
		String column = request.getParameter("column");
		String table = request.getParameter("table");
		String[] condition = request.getParameterValues("condition[]");
		QueryDataManager queryDataManager = new QueryDataManager(request);
		response.setContentType("application/csv");
		PrintWriter printWriter = new PrintWriter("logs.csv");
		if (condition[0] == "") {
			printWriter.println(queryDataManager.exportAllData(column, table));
		} else {
			printWriter.println(queryDataManager.exportAllData(column, table, condition));
		}
		printWriter.flush();
		printWriter.close();
	}

}
