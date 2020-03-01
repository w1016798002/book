<%--
  Created by IntelliJ IDEA.
  User: 86150
  Date: 2020/3/1
  Time: 12:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
</head>
<body>

<form id = "fm">
    <input type="hidden" name="id" value="${user.id}"><br />
    用户名:<input type="text" name="userName" value="${user.userName}"><br />
    手机号:<input type="text" name="userPhone" value="${user.userPhone}"><br />
    邮箱:<input type="text" name="userEmail" value="${user.userEmail}"><br />
    <input type="button" value="修改" onclick="update()"><br />
</form>
</body>
<script type="text/javascript">

    function update (){
        var index = layer.load(1,{shade:0.5});
        $.post(
            "<%=request.getContextPath()%>/user/update",
            $("#fm").serialize(),
            function(data){
                if (data.code != -1) {
                    layer.msg(data.msg, {icon: 6}, function(){
                        parent.window.location.href = "<%=request.getContextPath()%>/user/toShow";
                    });
                    return;
                }
                layer.msg(data.msg, {icon: 5})
                layer.close(index);

            }
        )
    }

</script>
</html>