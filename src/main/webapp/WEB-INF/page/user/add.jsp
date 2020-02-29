<%--
  Created by IntelliJ IDEA.
  User: 86150
  Date: 2020/2/29
  Time: 21:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/jquery.validate.js"></script>
<script src="https://static.runoob.com/assets/jquery-validation-1.14.0/dist/localization/messages_zh.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/layer-v3.1.1/layer/layer.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/md5/md5-min.js"></script>
<body>
    <form id="fm">
        用户名:<input type="text" name="userName" id="userName"><br />
        密码:<input type="text" name="userPwd" id="pwd"><br />
        确认密码:<input type="text" name="userPwd2"><br />
        手机号:<input type="text" name="userPhone" id="phone"><br />
        邮箱:<input type="text" name="userEmail" id="email"><br />
        角色:
        普通用户<input type="radio" name="role" value="1" checked>
        图书管理员<input type="radio" name="role" value="2">
        <input type="hidden" name="isDel" value="2">
        <input type="hidden" name="salt" value="${salt}" id="salt">
        <a href="<%=request.getContextPath()%>/user/toLogin">返回登录页面</a>
        <input type="submit" value="注册">
    </form>
</body>
<script>

    $(function(){
        $("#fm").validate({
            //效验规则
            rules: {
                userName:{
                    required:true,
                    minlength:2,
                    remote: {
                        type: 'POST',
                        url: "<%=request.getContextPath()%>/user/findByUserName",
                        data:{
                            userName:function() {
                                return $("#userName").val();
                            },
                            dataType:"json",
                            dataFilter:function(data,type){
                                if (data == 'true'){
                                    return true;
                                }else {
                                    return false	;
                                }
                            }
                        }
                    }
                },
                userPwd:{
                    required:true,
                    minlength:1,
                    digits:true
                },
                userPwd2:{
                    required:true,
                    minlength:1,
                    digits:true,
                    equalTo:"#pwd"
                },
                phone:{
                    required:true,
                    phone:true,
                    digits:true,
                    remote: {
                        type: 'POST',
                        url: "<%=request.getContextPath()%>/user/findByPhone",
                        data:{
                            phone:function() {
                                return $("#phone").val();
                            },
                            dataType:"json",
                            dataFilter:function(data,type){
                                if (data == 'true'){
                                    return true;
                                }else {
                                    return false	;
                                }
                            }
                        }
                    }
                },
                email:{
                    required:true,
                    email:5,
                    remote: {
                        type: 'POST',
                        url: "<%=request.getContextPath()%>/user/findByEmail",
                        data:{
                            email:function() {
                                return $("#email").val();
                            },
                            dataType:"json",
                            dataFilter:function(data,type){
                                if (data == 'true'){
                                    return true;
                                }else {
                                    return false	;
                                }
                            }
                        }
                    }
                },
                levelId:{
                    required:true
                }
            },
            messages:{
                userName:{
                    required:"必填",
                    minlength:"最少两个字"
                },
                userPwd:{
                    required:"必填",
                    minlength:"最少5个字",
                    digits:"只能是数字"
                },
                userPwd2:{
                    required:"请确认密码",
                    minlength:"最少5个字",
                    digits:"只能是数字",
                    equalTo:"两次输入密码不同"
                },
                phone:{
                    required:"请填写手机号",
                    rangelength:"11位",
                    digits:"只能是数字"
                },
                email:{
                    required:"请填写你的邮箱",
                    email:"邮箱格式不对"
                },
                levelId:{
                    required:"选一个"
                }
            },
            errorPlacement: function (error, element) {
                if (element.is("[name='levelId']")){ //如果需要验证的元素名为userHobby
                    error.appendTo($("#levelId"));   //错误增加在id为'checkbox-lang'中
                } else {
                    error.insertAfter(element);//其他的就显示在添加框后
                }
            }
        })
    })

    $.validator.setDefaults({
        submitHandler: function() {
            var index = layer.load(1,{shade:0.5});
            var pwd = md5($("#pwd").val());
            var salt = $("#salt").val();
            var md5pwd = md5(pwd + salt);
            $("#pwd").val(md5pwd);
            $.post("<%=request.getContextPath()%>/user/add",
                $("#fm").serialize(),
                function(data){
                    if(data.code == -1){
                        layer.close(index);
                        layer.msg(data.msg, {icon: 5});
                        return
                    }
                    layer.msg(data.msg, {
                        icon: 6,
                        time: 2000
                    }, function(){
                        parent.window.location.href = "<%=request.getContextPath()%>/user/toLogin";
                    });
                }
            )
        }
    });

    jQuery.validator.addMethod("phone",
        function(value, element) {
            var tel = /^1[3456789]\d{9}$/;
            return tel.test(value)
        }, "请正确填写您的手机号");

</script>
<style>
    .error{
        color:red;
    }
</style>
</html>
