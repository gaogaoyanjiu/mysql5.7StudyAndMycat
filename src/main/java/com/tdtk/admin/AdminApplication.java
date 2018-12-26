package com.tdtk.admin;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@SpringBootApplication
@Controller
public class AdminApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(AdminApplication.class,args);
    }
    
    @GetMapping("hello")
    @ResponseBody
    public String hello(){
        return "测试访问成功！！！";
    }
}
