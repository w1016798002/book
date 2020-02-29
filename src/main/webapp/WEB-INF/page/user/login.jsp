<%--
  Created by IntelliJ IDEA.
  User: 86150
  Date: 2020/2/29
  Time: 19:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/static/md5/md5-min.js"></script>
</head>
<body>
    <form id="fm">
        <input type="hidden" name="salt" id="salt">
        用户名/邮箱：<input type="text" name="userName" onblur="getSalt(this)"><br>
        密码：<input type="text" name="userPwd" id="pwd"><br>
        <input type="button" value="登录" onclick="login()">
        <a href="<%=request.getContextPath()%>/user/toAdd">去注册</a><br/>
    </form>
</body>
<script>

    function getSalt(obj) {
        $.post(
            "<%=request.getContextPath()%>/user/getSalt",
            {"userName": obj.value},
            function(data){
                if (data.code == 200) {
                    $("#salt").val(data.data);
                }
            }
        )
    }

    //判断当前窗口路径与加载路径是否一致。
    if(window.top.document.URL != document.URL){
        //将窗口路径与加载路径同步
        window.top.location = document.URL;
    }

    function login() {
        var index = layer.load(1, {shade: 0.5});
        var pwd = md5($("#pwd").val());
        var salt = $("#salt").val();
        var md5pwd = md5(pwd + salt);
        $("#pwd").val(md5pwd);
        $.post(
            "<%=request.getContextPath()%>/user/login",
            $("#fm").serialize(),
            function (data) {
                if (data.code != -1) {
                    layer.msg(data.msg, {icon: 6}, function(){
                        window.location.href = "<%=request.getContextPath()%>/index/toIndex";
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
