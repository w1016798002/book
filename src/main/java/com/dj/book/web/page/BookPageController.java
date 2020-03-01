package com.dj.book.web.page;

import com.dj.book.pojo.Book;
import com.dj.book.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/book/")
public class BookPageController {

    @Autowired
    private BookService bookService;

    @RequestMapping("toAdd")
    private String toAdd() {
        return "book/add";
    }

    @RequestMapping("toShow")
    private String toShow() {
        return "book/show";
    }

    @RequestMapping("toUpdateById/{id}")
    public String toUpdate(@PathVariable Integer id, Model model) {
        Book book = bookService.getById(id);
        model.addAttribute("book", book);
        return "book/update";
    }
}
