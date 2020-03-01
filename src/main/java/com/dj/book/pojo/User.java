package com.dj.book.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("user")
public class User {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String userName;

    private String userPwd;

    private String userPhone;

    private String userEmail;

    private String code;
    /**
     * 1 已删除  2 未删除
     */
    private Integer isDel;

    /**
     * 角色 1 用户  2 图书管理员
     */
    private Integer role;

    private String salt;

    private Date endTime;

}
