package com.red.workone;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter(filterName = "LoginFilter",urlPatterns = "/*")
public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String path=request.getRequestURI();
        String loginPath=request.getContextPath()+"/login";
        //判断是否请求登录、注册页面或公共资源
        if(isIn(request,path)){
            filterChain.doFilter(request, response);//表示是公共页面等，请求通过，继续执行
        }
        else{
            if(request.getServletPath().equals("/login")){//判断是否是由login界面发送请求，是则判断账号密码
                HttpSession session=request.getSession();
                String username=(String)session.getAttribute("username");
                String password=(String)session.getAttribute("password");
                if("admin".equals(username)&&"admin".equals(password)){
                    filterChain.doFilter(request, response);//通过则继续执行login的doPost
                }else{
                    response.sendRedirect(loginPath);
                }
            }else{
                response.sendRedirect(loginPath);
            }
        }
    }
    @Override
    public void destroy() {

    }
    //检查请求路径是否在排除列表的方法，如果在排除列表则返回true
    private boolean isIn(HttpServletRequest request,String path){
        //排除列表
        final List<String> STATIC_LIST = Arrays.asList(
                request.getContextPath()+"/login",
                request.getContextPath()+"/register",
                request.getContextPath()+"/public",
                request.getContextPath()+"/servlet",
                request.getContextPath()+"/"
        );
        if(STATIC_LIST.contains(path)){
            return true;
        }else {
            return false;
        }
    }
}
