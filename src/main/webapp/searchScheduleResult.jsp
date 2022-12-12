<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Sche.Schedule" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
<link href="css/main.css" rel="stylesheet" type="text/css">
</head>
<script>
		$(function () {	    
	    $('.navbar-toggler').on('click', function(event) {
			event.preventDefault();
			$(this).closest('.navbar-minimal').toggleClass('open');
		})
		});
</script>
<body>
<%@ include file="dbconn.jsp" %>
<%
	String user_id = null;
	if( session.getAttribute("user_id") != null) {
		user_id = (String)session.getAttribute("user_id");
	}
	
	request.setCharacterEncoding("utf-8");
	
	PreparedStatement pstat1 = null;
	ResultSet rs1 = null;
	String sql4 = "select * from User where id=?";
	
	pstat1 = conn.prepareStatement(sql4);
	pstat1.setString(1, user_id);
	rs1 = pstat1.executeQuery();
	
	String user_nickName = null;
	user_nickName = (String)session.getAttribute("user_nickName");
%>
<!-- 왼쪽 메뉴 바 -->
<nav class="navbar navbar-fixed-left navbar-minimal animate" role="navigation">
		<div class="navbar-toggler animate">
			<span class="menu-icon"></span>
		</div>
		<ul class="navbar-menu animate">
			<li>
				<a href="main.jsp" class="animate">
					<span class="desc animate"> 홈 </span>
					<span class="glyphicon glyphicon-home"></span>
				</a>
			</li>
			<li>
				<a href="myPage.jsp" class="animate">
					<span class="desc animate"> 마이페이지</span>
					<span class="glyphicon glyphicon-user"></span>
				</a>
			</li>
			<li>
				<a href="inputScheduleForm.jsp" class="animate">
					<span class="desc animate"> 일정 생성 </span>
					<span class="glyphicon glyphicon-pencil"></span>
				</a>
			</li>
			<li>
				<a href="searchScheduleForm.jsp" class="animate">
					<span class="desc animate"> 일정 조회 </span>
					<span class="glyphicon glyphicon-search"></span>
				</a>
			</li>
			<li>
				<a href="logout.jsp" class="animate">
					<span class="desc animate"> 로그아웃 </span>
					<span class="glyphicon glyphicon-log-out"></span>
				</a>
			</li>
		</ul>
</nav>
<!-- 오른쪽 아이디 -->
<nav class="navbar-fixed-id">
	<div class="navbar-menu animate" style="text-align: center;">
		<h4 style="color:white;"><%= user_nickName %></h4>			
	</div>
</nav>
<!-- 중앙 -->
<div class="container">
<!-- 중앙 상단 -->
	<div class="row" style="text-align: center;">
		<div class="col-sm-offset-3 col-sm-6 col-md-offset-4 col-md-4">
			<h1 class="title"> 일정 조회 </h1>
		</div>
	</div>
<!-- 중앙 내용 -->
	<div class="row">
			<div class="[ col-xs-12 col-sm-offset-2 col-sm-8 ]">
				<ul class="event-list">
<%
	request.setCharacterEncoding("utf-8");
	
	Schedule schedule = new Schedule();
	
	schedule.setId((String)session.getAttribute("user_id"));
	schedule.setMonth(request.getParameter("Month"));
	schedule.setTitle(request.getParameter("Title"));
	
	String id = schedule.getId();
	String month = schedule.getMonth();
	String title = schedule.getTitle();
	
	PreparedStatement pstat = null;
	ResultSet rs = null;
	
	ArrayList<Schedule> list = new ArrayList<>();
	if(month.equals("--") && !title.equals("")) { //month는 안고르고 title로 찾겠다.
		String sql1 = "Select * From Schedule Where id=? and title like '%" + title + "%'";
		pstat = conn.prepareStatement(sql1);
		pstat.setString(1, id);
		/* pstat.setString(2, title); */
		rs = pstat.executeQuery();
		
		while(rs.next()) {
			schedule.setMonth(rs.getString("month"));
			schedule.setDay(rs.getString("day"));
			schedule.setTitle(rs.getString("title"));
			schedule.setContent(rs.getString("content"));
			list.add(schedule);
			
			int i = 0;
%>
			<li class="menubar">
				<time datetime>
					<span class="day"><%= list.get(i).getDay() %></span>
					<span class="month"><%= list.get(i).getMonth() %></span>
				</time>
				<div class="info">
					<h2 class="title"><a href="selectSchedule.jsp?Month=<%=list.get(i).getMonth() %>&Title=<%=list.get(i).getTitle()%>" style="color:black;"><%= list.get(i).getTitle() %></a></h2>
					<p class="desc"><%= list.get(i).getContent() %></p>
				</div>
			</li> <%
				i++; }
	} else if(!month.equals("--") && title.equals("")) {//month 고르고 title 안고르고 찾겠다.
		String sql2 = "Select * From Schedule Where id=? and month=?"; 
		pstat = conn.prepareStatement(sql2);
		pstat.setString(1, id);
		pstat.setString(2, month);
		rs = pstat.executeQuery();
		
		while(rs.next()) {
			schedule.setMonth(rs.getString("month"));
			schedule.setDay(rs.getString("day"));
			schedule.setTitle(rs.getString("title"));
			schedule.setContent(rs.getString("content"));
			list.add(schedule);
			int i = 0;
		%>
		<li class="menubar">
			<time datetime>
				<span class="day"><%= list.get(i).getDay() %></span>
				<span class="month"><%= list.get(i).getMonth() %></span>
			</time>
			<div class="info">
				<h2 class="title"><a href="selectSchedule.jsp?Month=<%=list.get(i).getMonth() %>&Title=<%=list.get(i).getTitle()%>" style="color:black;"><%= list.get(i).getTitle() %></a></h2>
				<p class="desc"><%= list.get(i).getContent() %></p>
			</div>
		</li> <%
			i++; 
			}
		} else {
			String sql3 = "Select * From Schedule Where id=? and month=? and title like '%" + title + "%'";
			pstat = conn.prepareStatement(sql3);
			pstat.setString(1, id);
			pstat.setString(2, month);
			/* pstat.setString(3, title); */
			rs = pstat.executeQuery();
			
			while(rs.next()) {
				schedule.setMonth(rs.getString("month"));
				schedule.setDay(rs.getString("day"));
				schedule.setTitle(rs.getString("title"));
				schedule.setContent(rs.getString("content"));
				list.add(schedule);
				int i = 0;
		%>
		<li class="menubar">
			<time datetime>
				<span class="day"><%= list.get(i).getDay() %></span>
				<span class="month"><%= list.get(i).getMonth() %></span>
			</time>
			<div class="info">
				<h2 class="title"><a href="selectSchedule.jsp?Month=<%=list.get(i).getMonth() %>&Title=<%=list.get(i).getTitle()%>" style="color:black;"><%= list.get(i).getTitle() %></a></h2>
				<p class="desc"><%= list.get(i).getContent() %></p>
			</div>
		</li> <%
			i++;
			}
		}
		%>
		</ul>
			<div class="col-sm-offset-5 col-sm-5">
           		<button onclick="location.href='searchScheduleForm.jsp'" class="btn btn-success" style="width: 120px;">돌아가기</button>
        	</div>
		</div>
	</div>
</div>
</body>
</html>