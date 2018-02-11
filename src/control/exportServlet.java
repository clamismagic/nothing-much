package control;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
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
		String column = request.getParameter("column");
		String table = request.getParameter("table");
		String[] condition = request.getParameterValues("condition[]");
		QueryDataManager queryDataManager = new QueryDataManager(request);
		response.setContentType("application/csv");
		response.setHeader("Content-Disposition", "attachment; filename=logs.csv");
		OutputStream outputStream = response.getOutputStream();
		if (condition == null || condition != null && condition[0] == "") {
			outputStream.write(queryDataManager.exportAllData(column, table).getBytes());
		} else {
			outputStream.write(queryDataManager.exportAllData(column, table, condition).getBytes());
		}
		outputStream.flush();
		outputStream.close();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
