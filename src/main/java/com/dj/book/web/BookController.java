package com.dj.book.web;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.dj.book.common.ResultModel;
import com.dj.book.common.SystemConstant;
import com.dj.book.pojo.Book;
import com.dj.book.service.BookService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;

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

    @RequestMapping("show")
    public ResultModel<Object> show(String bookName, Integer pageNo) {
        HashMap<String, Object> map = new HashMap<>();
        try {
            PageHelper.startPage(pageNo, SystemConstant.NUMBER_TWO);
            QueryWrapper<Book> wrapper = new QueryWrapper<>();
            if (!StringUtils.isEmpty(bookName)) {
                wrapper.like("book_name", bookName);
            }
            wrapper.eq("is_del", SystemConstant.NUMBER_TWO);
            List<Book> bookList = bookService.list(wrapper);
            PageInfo<Book> pageInfo = new PageInfo<Book>(bookList);
            map.put("totalNum", pageInfo.getPages());
            map.put("bookList", bookList);
            return new ResultModel<>().success(map);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<Object>().error(SystemConstant.ERROR + e.getMessage());
        }
    }

    @RequestMapping("updateById")
    public ResultModel<Object> update(Book book) {
        try {
            UpdateWrapper<Book> updateWrapper = new UpdateWrapper<>();
            updateWrapper.set("book_name", book.getBookName())
                    .set("book_count", book.getBookCount());
            updateWrapper.eq("id", book.getId());
            bookService.update(updateWrapper);
            return new ResultModel<>().success();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultModel<>().error(SystemConstant.ERROR + e.getMessage());
        }
    }
}

