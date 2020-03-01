package com.dj.book.web;

import com.dj.book.common.ResultModel;
import com.dj.book.common.SystemConstant;
import com.dj.book.pojo.Book;
import com.dj.book.pojo.User;
import com.dj.book.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author 86150
 */
@RestController
@RequestMapping("/book/")
public class BookController {

    @Autowired
    private BookService bookService;

    /**
     * 添加
     * @param book
     * @return
     */
    @RequestMapping("add")
    public ResultModel<Object> add(Book book) {
        try {
            if (StringUtils.isEmpty(book.getBookName()) || StringUtils.isEmpty(book.getBookCount())) {
                return new ResultModel<Object>().error("添加不得为空");
            }
            bookService.save(book);
            return new ResultModel<Object>().success();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.ERROR + e.getMessage());
        }
    }
}

