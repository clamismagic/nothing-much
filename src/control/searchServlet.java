package control;

import java.io.IOException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import model.QueryDataManager;
import model.QueryData;

/**
 * Servlet implementation class searchServlet
 */
@WebServlet("/searchServlet")
public class searchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public searchServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String tableName = request.getParameter("tableName");
		String json = null;
		if (tableName.equals("---Select Table---")) {
			List<String> list = new ArrayList<String>();
			list.add("---Select Table---");
			json = new Gson().toJson(list);
		} else {
			QueryDataManager queryDataManager = new QueryDataManager(request);
			List<String> queryData = queryDataManager.getColumns(tableName);
			queryData.toString();
			json = new Gson().toJson(queryData);
		}
		response.setContentType("application/json");
		response.getWriter().write(json);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		/*
		 * ServletOutputStream out = response.getOutputStream();
		 * response.setContentType("text/html"); String column =
		 * request.getParameter("column"); if (column == null) {
		 * response.sendRedirect("search.jsp?status=error2"); return; } String table =
		 * request.getParameter("table"); if (table == null) {
		 * response.sendRedirect("search.jsp?status=error2"); return; } String condition
		 * = request.getParameter("condition"); if (condition == null || condition ==
		 * "") { response.sendRedirect("search.jsp?status=error2"); return; }
		 * out.println(column); out.println(table); out.println(condition);
		 */

	}

}