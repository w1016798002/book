<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登陆页面</title>
	<script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
</head>
<body>
<form id="frm">
	手机号:<input type = "text" name = "userPhone" id="userPhone"><br/>
		<input type = "text" name = "code" id="code" placeholder="请输入验证码">
		<input id="btnSendCode" type="button" value="获取验证码"  onclick="get()" />
		<input type = "button" value = "登陆" onclick = "codeLogin()">
	
</form>
</body>
<script type="text/javascript">
	function get(){
		$.post(
				"<%=request.getContextPath()%>/user/getCode",
				{"userPhone":$("#userPhone").val()},
				function (data) {
					if (data.code==200){
						layer.msg(data.msg, {icon: 5});
					} else {
						layer.msg(data.msg, {icon: 5});
					}
				})
	}

	function codeLogin(){
		var index = layer.load(1,{shade:0.5});
		$.post(
				"<%=request.getContextPath()%>/user/codeLogin",
				{"userPhone":$("#userPhone").val(),"code":$("#code").val()},
				function (data){
					layer.close(index);
					if (data.code != 200) {
						layer.msg(data.msg, {icon: 5});
						return;
					}
					layer.msg(data.msg, {
						icon: 6,
						time: 2000 //2秒关闭（如果不配置，默认是3秒）
					}, function(){
						//do something
						parent.window.location.href = "<%=request.getContextPath()%>/index/toIndex";
					});
				})
	}
</script>
</html>
