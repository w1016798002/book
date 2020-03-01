<%--
  Created by IntelliJ IDEA.
  User: 86150
  Date: 2020/3/1
  Time: 1:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
</head>
<body>
<form id="fm">
    <input type="hidden" value="1" id="pageNo" name="pageNo">
    请输入用户名:<input type="text" name="userName" value="" ><br />
    <input type="button" value="查询" onclick="search()"><br />
</form>

    <input type="button" value="修改" onclick="updateById()">

    <input type="button" value="注销账号" onclick="del()">

<table border="1px">
    <tr>
        <th></th>
        <th>用户名</th>
        <th>密码</th>
        <th>手机号</th>
        <th>邮箱</th>
        <th>角色</th>
    </tr>
    <tbody id="tbd">

    </tbody>
</table>

<div id="pageInfo">

</div>
</body>
<script type="text/javascript">

    var totalNum = 0;

    $(function(){
        search();
    })

    function search() {
        $.post(
            "<%=request.getContextPath()%>/user/findList",
            $("#fm").serialize(),
            function(data){
                totalNum = data.data.totalNum;
                var html = "";
                for (var i = 0; i < data.data.userList.length; i++) {
                    var u = data.data.userList[i];
                    html += "<tr>"
                    html += "<td><input type = 'checkbox' name = 'id' value = '"+u.id+"'>";
                    html += "<td>"+u.userName+"</td>"
                    html += "<td>"+u.userPwd+"</td>"
                    html += "<td>"+u.userPhone+"</td>"
                    html += "<td>"+u.userEmail+"</td>"
                    if (u.role == 1) {
                        html += "<td>用户</td>"
                    } else {
                        html += "<td>图书管理员</td>"
                    }
                    html += "</tr>"
                }
                $("#tbd").html(html);
                var pageNo = $("#pageNo").val();
                var pageHtml = "<input type='button' value='上一页' onclick='page("+(parseInt(pageNo) - 1)+")'>";
                pageHtml += "<input type='button' value='下一页' onclick='page("+(parseInt(pageNo) + 1)+")')'>";
                $("#pageInfo").html(pageHtml);
            }
        )
    }

    function page(page) {

        if (page < 1) {
            layer.msg('首页啦!', {icon:0});
            return;
        }
        if (page > totalNum) {
            layer.msg('已经到尾页啦!!', {icon:0});
            return;
        }
        $("#pageNo").val(page);
        search();

    }

    //去修改
    function updateById(){
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
                content: '<%=request.getContextPath()%>/user/toUpdate/'+id
            });
        });
    }


    //删除
    function del(){
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
        var index = layer.load(1,{shade:0.5});
        layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
            //do something
            $.post(
                "<%=request.getContextPath()%>/user/delById",
                {"id": id},
                function(data){
                    if (data.code != -1) {
                        layer.msg(data.msg, {icon: 6}, function(){
                            window.location.href = "<%=request.getContextPath()%>/user/toShow";
                        });
                        return;
                    }
                    layer.msg(data.msg, {icon: 5})
                    layer.close(index);
                }
            )
        });
    }


</script>
</html>

