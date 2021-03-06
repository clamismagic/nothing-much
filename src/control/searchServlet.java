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
		try {
			if (tableName.equals("---Select Table---")) {
				List<String> list = new ArrayList<String>();
				list.add("---Select Table First---");
				json = new Gson().toJson(list);
			} else {
				QueryDataManager queryDataManager = new QueryDataManager(request);
				List<String> queryData = queryDataManager.getColumns(tableName);
				queryData.toString();
				json = new Gson().toJson(queryData);
			}
			response.setContentType("application/json");
			response.getWriter().write(json);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		String[] column = request.getParameterValues("column[]");
		String[] table = request.getParameterValues("table[]");
		String[] condition = request.getParameterValues("condition[]");
		QueryDataManager queryDataManager = new QueryDataManager(request);
		if (column == null || table == null) {
			request.getRequestDispatcher("search.jsp?status=error2").forward(request, response);
			return;
		} else {
			int i;
			for (i = 0; i < column.length; i++) {
				if (column[i] != "" && table[i] != "" && column[i] != null && table[i] != null
						&& !column[i].toLowerCase().trim().equals("---select table first---")
						&& !table[i].toLowerCase().trim().equals("---select table---")) {
					QueryData queryData = new QueryData();
					if (condition[i] == "") {
						queryData = queryDataManager.getData(column[i], table[i]);
						if (queryData != null) {
							if (queryData.getColumnData().size() != 0) {
								request.setAttribute("queryData" + i, queryData);
							} else {
								request.setAttribute("noOfQueriedItems", column.length);
								request.getRequestDispatcher("search.jsp?status=noData").forward(request, response);
								return;
							}
						} else {
							request.getRequestDispatcher("search.jsp?status=error").forward(request, response);
							return;
						}
					} else {
						queryData = queryDataManager.getData(column[i], table[i], condition);
						if (queryData != null) {
							if (queryData.getColumnData().size() != 0) {
								request.setAttribute("queryData" + i, queryData);
							} else {
								request.setAttribute("noOfQueriedItems", column.length);
								request.getRequestDispatcher("search.jsp?status=noData").forward(request, response);
								return;
							}
						} else {
							request.getRequestDispatcher("search.jsp?status=error").forward(request, response);
							return;
						}
					}
				} else {
					request.getRequestDispatcher("search.jsp?status=error2").forward(request, response);
					return;
				}
			}
			request.setAttribute("noOfQueriedItems", column.length);
			request.getRequestDispatcher("search.jsp?status=success").forward(request, response);
			return;
		}

	}

}