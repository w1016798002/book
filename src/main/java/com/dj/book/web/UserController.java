package com.dj.book.web;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.dj.book.common.MessageVerifyUtils;
import com.dj.book.common.ResultModel;
import com.dj.book.common.SystemConstant;
import com.dj.book.pojo.User;
import com.dj.book.service.UserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/user/")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 获取盐
     * @param
     * @return
     */
    @RequestMapping("getSalt")
    public ResultModel<Object> getSalt(String userName){
        try {
            QueryWrapper<User> queryWrapper = new QueryWrapper();
            if (userName != null) {
                queryWrapper.eq("user_name", userName);
                User user = userService.getOne(queryWrapper);
                ResultModel resultModel = new ResultModel();
                resultModel.setData(user.getSalt());
                return resultModel;
            }
            return new ResultModel<>().error(SystemConstant.NOT_USER);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.ERROR + e.getMessage());
        }
    }

    @RequestMapping("login")
    public ResultModel<Object> login (String userName, String userPwd) {
        try {
            if (StringUtils.isEmpty(userName) || StringUtils.isEmpty(userPwd)) {
                return new ResultModel<Object>().error(SystemConstant.NAME_PWD_EMPTY);
            }
            QueryWrapper<User> queryWrapper = new QueryWrapper();
            queryWrapper.eq("user_name", userName);
            queryWrapper.eq("user_pwd", userPwd);
            User user = userService.getOne(queryWrapper);
            if (user == null) {
                return new ResultModel<>().error(SystemConstant.NAME_PWD_ERROR);
            }
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.ERROR + e.getMessage());
        }
    }

    @RequestMapping("findByUserName")
    public Boolean findByUsername (String userName) {
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("user_name", userName);
            queryWrapper.eq("is_del", SystemConstant.NUMBER_TWO);
            User user = userService.getOne(queryWrapper);
            if (user == null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @RequestMapping("findByPhone")
    public Boolean findByPhone (String userPhone) {
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("user_phone", userPhone);
            queryWrapper.eq("is_del", SystemConstant.NUMBER_TWO);
            User user = userService.getOne(queryWrapper);
            if (user == null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    @RequestMapping("findByEmail")
    public Boolean findByEmail (String userEmail) {
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("user_email", userEmail);
            queryWrapper.eq("is_del", SystemConstant.NUMBER_TWO);
            User user = userService.getOne(queryWrapper);
            if (user == null) {
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @RequestMapping("add")
    public ResultModel<Object> add (User user){
        try {
            userService.save(user);
            return new ResultModel<Object>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.ERROR + e.getMessage());
        }

    }

    @RequestMapping("findList")
    public ResultModel<Object> show(String userName, Integer pageNo) {
        HashMap<String, Object> map = new HashMap<>();
        try {
            PageHelper.startPage(pageNo, SystemConstant.NUMBER_TWO);
            QueryWrapper<User> wrapper = new QueryWrapper<>();
            if (!StringUtils.isEmpty(userName)) {
                wrapper.like("user_name", userName);
            }
            wrapper.eq("is_del", SystemConstant.NUMBER_TWO);
            List<User> userList = userService.list(wrapper);
            PageInfo<User> pageInfo = new PageInfo<User>(userList);
            map.put("totalNum", pageInfo.getPages());
            map.put("userList", userList);
            return new ResultModel<>().success(map);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.ERROR + e.getMessage());
        }
    }

    /**
     * 伪删除
     * @param id
     * @return
     */
    @RequestMapping("delById")
    public ResultModel<Object> delById(Integer id) throws Exception {
        try {
            UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
            updateWrapper.set("is_del", SystemConstant.NUMBER_ONE);
            updateWrapper.eq("id", id);
            userService.update(updateWrapper);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.ERROR + e.getMessage());
        }
    }

    /**
     * 根据id修改
     * @param user
     * @return
     */
    @RequestMapping("update")
    public ResultModel<Object> update(User user) {
        try {
            UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
            updateWrapper.set("user_name", user.getUserName())
                    .set("user_phone", user.getUserPhone())
                    .set("user_email", user.getUserEmail());
            updateWrapper.eq("id", user.getId());
            userService.update(updateWrapper);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.ERROR + e.getMessage());
        }
    }

    /**
     * 手机号验证码登录
     * @param user
     * @param
     * @return
     */
    @RequestMapping("codeLogin")
    public ResultModel<Object> codeLogin(User user) {
        try {
            if (StringUtils.isEmpty(user.getUserPhone()) || StringUtils.isEmpty(user.getCode())) {
                return new ResultModel<Object>().error("手机号或验证码不得为空!");
            }
            QueryWrapper<User> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_phone", user.getUserPhone());
            queryWrapper.eq("code", user.getCode());
            User user1 = userService.getOne(queryWrapper);
            if (user1 == null) {
                return new ResultModel<Object>().error("手机号与验证码不匹配!!");
            }
            if (user1.getIsDel() == 1) {
                return new ResultModel<Object>().error("用户已被删除!");
            }
            if (user1.getEndTime().compareTo(new Date()) != 1) {
                return new ResultModel<>().error("验证码已失效");
            }
            return new ResultModel<Object>().success("登陆成功!");
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return new ResultModel<Object>().error("系统正在维修中...");
        }

    }

    /**
     *
     * @param user
     * @return
     */
    @RequestMapping("getCode")
    public ResultModel<Object> getCode(User user) {
        try {
            if (StringUtils.isEmpty(user.getUserPhone())) {
                return new ResultModel<Object>().error("手机号不得为空!");
            }
            QueryWrapper<User> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_phone", user.getUserPhone());
            User user1 = userService.getOne(queryWrapper);
            if (!user1.getIsDel().equals(SystemConstant.NUMBER_ONE) && user1 != null ) {
                Calendar cal = Calendar.getInstance();
                cal.setTime(new Date());
                cal.add(Calendar.MINUTE, 1);
                String newCode = String.valueOf(MessageVerifyUtils.getNewcode());
                UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
                updateWrapper.set("code", newCode).set("end_time", cal.getTime());
                updateWrapper.eq("user_phone",user.getUserPhone());
                userService.update(updateWrapper);
                MessageVerifyUtils.sendSms(user.getUserPhone(), newCode);
            }
            return new ResultModel<Object>().success();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return new ResultModel<Object>().error("系统正在维修中...");
        }
    }


}
