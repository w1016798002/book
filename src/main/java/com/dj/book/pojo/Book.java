package com.dj.book.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.lang.reflect.Type;

@Data
@TableName("book")
public class Book {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String bookName;

    private Integer bookCount;

    /**
     * 1 已删除  2 未删除
     */
    private Integer isDel;

    /**
     * 1 下架 2 上架
     */
    private Integer status;

}
