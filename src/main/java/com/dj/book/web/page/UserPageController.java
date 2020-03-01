package com.dj.book.web.page;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.dj.book.common.PasswordSecurityUtil;
import com.dj.book.pojo.User;
import com.dj.book.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user/")
public class UserPageController {

    @Autowired
    private UserService userService;

    @RequestMapping("toLogin")
    private String toLogin() {
        return "user/login";
    }

    @RequestMapping("toAdd")
    private String toAdd(Model model) throws Exception {
        String salt = PasswordSecurityUtil.generateSalt();
        model.addAttribute("salt", salt);
        return "user/add";
    }

    @RequestMapping("toShow")
    private String toShow() {
        return "user/show";
    }

    /**
     * 去修改页面
     */
    @RequestMapping("toUpdate/{id}")
    public String toUpdate(@PathVariable Integer id, Model model) {
        User user = userService.getById(id);
        model.addAttribute("user", user);
        return "user/update";
    }

}
