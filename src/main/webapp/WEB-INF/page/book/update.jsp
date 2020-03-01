<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
</head>
<body>
	<form id="fm">
		<input type="hidden" name="id" value="${book.id}">
		书名：<input type="text" name="bookName" value="${book.bookName}"><br>
		库存：<input type="text" name="bookCount" value="${book.bookCount}"><br>
		<input type="button" value="修改"  onclick="update()"></td>
	</form>
</body>
<script type="text/javascript">
	function update(){
		var index = layer.load(1,{shade:0.5});
		layer.confirm('确定修改吗?', {icon: 3, title:'提示'}, function(index){
			layer.close(index);
			$.post(
					"<%=request.getContextPath()%>/book/updateById",
					$("#fm").serialize(),
					function(data){
						layer.close(index);
						if(data.code == 200){
							layer.msg(data.msg, {
								icon: 6,
								time: 2000 //2秒关闭（如果不配置，默认是3秒）
							}, function(){
								//do something
								parent.window.location.href = "<%=request.getContextPath()%>/book/toShow";
							});
							return;
						}
						layer.msg(data.msg, {icon: 5});
					}
			)
		});
		layer.close(index);
	}

</script>
</html>