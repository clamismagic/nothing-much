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

		String column = request.getParameter("column");
		String table = request.getParameter("table");
		String condition = request.getParameter("condition");
		QueryDataManager queryDataManager = new QueryDataManager(request);
		if (column == null) {
			response.sendRedirect("search.jsp?status=error2");
			return;
		} else if (table == null) {
			response.sendRedirect("search.jsp?status=error2");
			return;
		} else if (column != "" && table != "" && condition == null || condition == "") {
			QueryData queryData = new QueryData();
			queryData = queryDataManager.getData(column, table);
			if (queryData != null) {
				request.setAttribute("queryData", queryData);
				request.getRequestDispatcher("search.jsp?status=success1").forward(request, response);
				return;
			} else {
				response.sendRedirect("search.jsp?status=error");
			}
		} else if (column != "" && table != "" && condition != null && condition != "") {
			QueryData queryData = new QueryData();
			queryData = queryDataManager.getData(column, table, condition);
			if (queryData != null) {
				request.setAttribute("queryData", queryData);
				request.getRequestDispatcher("search.jsp?status=success2").forward(request, response);
				return;
			} else {
				response.sendRedirect("search.jsp?status=error");
			}
		} else {
			response.sendRedirect("search.jsp?status=errror");
		}
	}

}