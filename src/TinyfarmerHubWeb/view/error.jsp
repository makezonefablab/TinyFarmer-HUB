<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.opensymphony.xwork2.interceptor.ExceptionHolder" %>
<%@ page import="com.opensymphony.xwork2.ActionContext" %>
<%@ page import="com.opensymphony.xwork2.ActionInvocation" %>

<%
	ActionInvocation invocation = ActionContext.getContext().getActionInvocation();
	Object obj = invocation.getStack().pop();
	ExceptionHolder eh = (ExceptionHolder) obj;
	Exception e = eh.getException();
%>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">

		<!-- <link rel="icon" href="../../favicon.ico"> -->
		<title>Tinyfarmer Configuration ERROR</title>
		<!-- Bootstrap core CSS -->
		<link href="bootstrap-3.3.0/css/bootstrap.min.css" rel="stylesheet">

		<!-- Custom styles for this template -->
		<link href="css/error.css" rel="stylesheet">

	</head>
	
	<body>
		<div class="container">
			<div class="title">Tinyfarmer Configuration ERROR - The application has malfunctioned.</div>
			
			<div class="contact">Please contact technical support with the following information:</div> 
			<div class="company">(주) 미디어플로우 </div>
			<div class="mail">문의 메일 주소 : iot@mediaflow.kr </div>
			<div class="board">문의 게시판 : my.tinyfarmer.com (Q&amp;A 또는 문의 게시판) </div>
			
			<p>
				<%=e %>
			</p>
			<%-- <p>Exception Name: <s:property value="exception" /> </p> --%>
	
			<%-- <p>Exception Details: <s:property value="exceptionStack" /></p> --%>
		</div>
	</body>
</html>