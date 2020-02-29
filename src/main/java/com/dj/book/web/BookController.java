package com.dj.book.web;

import com.dj.book.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/book/")
public class BookController {

    @Autowired
    private BookService bookService;

}

