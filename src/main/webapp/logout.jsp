<%--
  Created by IntelliJ IDEA.
  User: arielsyal
  Date: 2026-04-10
  Time: 7:09 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  session.invalidate();
  response.sendRedirect("index.jsp");
%>