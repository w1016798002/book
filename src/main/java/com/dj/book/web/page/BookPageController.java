package com.dj.book.web.page;

import com.dj.book.common.PasswordSecurityUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/book/")
public class BookPageController {

    @RequestMapping("toAdd")
    private String toAdd() {
        return "book/add";
    }

    @RequestMapping("toShow")
    private String toShow() {
        return "book/show";
    }


}
