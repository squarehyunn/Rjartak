
package com.basic.dao;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface MessageMapper {
 
    public String countMessageView(String email);
}
