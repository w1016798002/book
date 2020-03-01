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
<body align="center">
	<form id="fm">
		图书名<input type="text" name="bookName" id="bookName">
		<input type="hidden" value="1" id="pageNo" name ="pageNo">
		<input type="button" value="搜寻" onclick="find()">
	</form>
		<input type="button" value="上/下架" onclick="updateBookStatusById()">
		<input type="button" value="新增" onclick="addBook()">
		<input type="button" value="删除" onclick="delBookById()">
		<input type="button" value="修改" onclick="updateBookById()">
		<table border = "1px" align="center" >
			<tr align='center'>
				<td>上下架</td>
				<td>书名</td>
				<td>状态</td>
			</tr>
			<tbody id="tbd">
			
			</tbody>
		</table>
	
	<div id="pageInfo">
		
	</div>
</body>
<script type="text/javascript">

	var totalNum = 0;

	//頁面加載
	$(function(){
		search();
	})

	//商品信息展示
	function search(){
		$.post(
				"<%=request.getContextPath()%>/book/show",
				$("#fm").serialize(),
				function(data){
					if (data.code != 200) {
						alert(data.msg);
						return;
					}
					totalNum = data.data.totalNum;
					var html = "";
					for(var i = 0; i < data.data.bookList.length; i++){
						html += "<tr>";
						html += "<input type = 'hidden' id = '"+data.data.bookList[i].id+"' value = '"+data.data.bookList[i].status+"'>";
						html += "<td><input type = 'checkbox' name = 'id' value = '"+data.data.bookList[i].id+"'></td>";
						html += "<td>"+data.data.bookList[i].bookName+"</td>";
						html += "<td>"+data.data.bookList[i].bookCount+"</td>";
						if (data.data.bookList[i].status == 1) {
                            html += "<td>下架</td>";
                        }else{
						    html += "<td>上架</td>";
                        }
						html += "</tr>";
					}
					$("#tbd").html(html);
					var pageNo = $("#pageNo").val();
					var pageHtml = "<input type = 'button' value = '上一页' onclick = 'page("+(parseInt(pageNo) - 1)+")' />";
					pageHtml += "<input type = 'button' value = '下一页' onclick = 'page("+(parseInt(pageNo) + 1)+")' />";
					$("#pageInfo").html(pageHtml);
				})
	}

	//分页
	function page(page){
		if (page < 1) {
			layer.msg('已经到首页了!', {icon:0});
			return;
		}
		if (page > totalNum) {
			layer.msg('已经到尾页了!', {icon:0});
			return;
		}
		$("#pageNo").val(page);
		search();
	}


	//上/下架
	function updateBookStatusById(){
		var length = $("input[name='id']:checked").length;

		if(length == 0){
			layer.msg('请至少选择一个!', {icon:0});
			return;
		}
		if(length > 1){
			layer.msg('只能选择一个!', {icon:0});
			return;
		}
		var id = $("input[name='id']:checked").val();
		var status = $("#"+id).val();
		var a = "";
		var b = 0;
		if (status == 0) {
			a = "你确定要把它下架吗？";
			b = 1;
		}else{
			a = "你确定要把它上架吗？"
			b = 0;
		}
		var id = $("input[name='id']:checked").val();
		layer.confirm(a, {icon: 3, title:'提示'}, function(index){

			layer.close(index);
			$.post("<%=request.getContextPath()%>/book/updateBookStatusById",
					{"id":id, "bookStatus":b},
					function(data){

						if(data.code == 200){
							layer.msg(data.msg, {
								icon: 6,
								time: 2000 //2秒关闭（如果不配置，默认是3秒）
							}, function(){
								//do something
								window.location.href="<%=request.getContextPath()%>/book/toBookShow";
							});
							return;
						}
						layer.msg(data.msg, {icon: 5});
					})
		});
	}

	//增加新的商品信息 去增加商品信息頁面
	function addBook(){
		layer.confirm('确定新增吗？', {icon: 3, title:'提示'}, function(index){
			//do something

			layer.close(index);
			layer.open({
				type: 2,
				title: '添加页面',
				shadeClose: true,
				shade: 0.8,
				area: ['380px', '90%'],
				content: '<%=request.getContextPath()%>/book/toAdd'
			});
		});
	}

	//刪除

	function delBookById(){

		var length = $("input[name='id']:checked").length;

		if(length <= 0){
			layer.msg('请至少选择一个!', {icon:0});
			return;
		}

		var str = "";
		$("input[name='id']:checked").each(function (index, item) {

			if ($("input[name='id']:checked").length-1==index) {
				str += $(this).val();
			} else {
				str += $(this).val() + ",";
			}
		});

		/*  alert(str) */
		layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
			//do something

			layer.close(index);

			$.post("<%=request.getContextPath()%>/book/delBookById",

					{"ids":str,"isDel":1},

					function(data){

						if(data.code == 200){
							layer.msg(data.msg, {
								icon: 6,
								time: 2000 //2秒关闭（如果不配置，默认是3秒）
							}, function(){
								//do something
								window.location.href = "<%=request.getContextPath()%>/book/toBookShow";
							});
							return;
						}
						layer.msg(data.msg, {icon:5});
					});
		});
	}

	//去修改
	function updateBookById(){
		var length = $("input[name='id']:checked").length;

		if(length <= 0){
			alert("至少选择一项");
			return;
		}
		if(length > 1){
			alert("只能选择一个");
			return;
		}

		var id = $("input[name='id']:checked").val();
		layer.confirm('确定修改吗?', {icon: 3, title:'提示'}, function(index){
			//do something

			layer.close(index);

			layer.open({
				type: 2,
				title: '修改页面',
				shadeClose: true,
				shade: 0.8,
				area: ['380px', '90%'],
				content: '<%=request.getContextPath()%>/book/updateBookById/'+id
			});
		});
	}

	function find(){
		$("#pageNo").val(1);
		search();
	}

</script>
</html>