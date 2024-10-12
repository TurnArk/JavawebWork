package com.red.worktwo;
import jakarta.servlet.ServletRequestEvent;
import jakarta.servlet.ServletRequestListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpServletRequest;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebListener
public class ServletRequestListenerImplementation implements ServletRequestListener {
    public void requestInitialized(ServletRequestEvent servletRequestEvent) {
        List<String> list=new ArrayList<>();//这个列表的数据将被记录如list
        //记录起始时间的时间戳
        long startTime=System.currentTimeMillis();
        HttpServletRequest request=(HttpServletRequest)servletRequestEvent.getServletRequest();
        //获取请求时间并格式化处理
        LocalDateTime currentTime=LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String time=currentTime.format(formatter);
        //获取客户端IP地址
        String customer=request.getRemoteAddr();
        //获取请求方法
        String method=request.getMethod();
        //获取请求的URI
        String path=request.getRequestURI();
        String quit="没有查询字符串";
        //获取请求字符串
        if(request.getQueryString()!=null){
            quit=request.getQueryString();
        }
        //获取User-Agent
        String userAgent=request.getHeader("User-Agent");

        list.add(time);
        list.add(customer);
        list.add(method);
        list.add(path);
        list.add(quit);
        list.add(userAgent);

        // 将 `startTime` 和 `list` 作为请求属性传递给 `requestDestroyed`
        request.setAttribute("startTime", startTime);
        request.setAttribute("requestLogList", list);
    }

    public void requestDestroyed(ServletRequestEvent servletRequestEvent) {
        //记录结束时的时间戳
        long endTime=System.currentTimeMillis();

        // 获取 `startTime` 和 `list` 请求属性
        HttpServletRequest request = (HttpServletRequest) servletRequestEvent.getServletRequest();
        long startTime = (long) request.getAttribute("startTime");
        List<String> list = (List<String>) request.getAttribute("requestLogList");
        //String filePath = "D:/用户/桌面/javaweb/work/workTwo/src/main/webapp/data.csv";//要记录的数据将记录在该csv文件中
        String filePath=getAbsolutePath();
        //计算时间戳的差并添加进列表
        Instant start= Instant.ofEpochMilli(startTime);
        Instant end= Instant.ofEpochMilli(endTime);
        long payTime=end.toEpochMilli()-start.toEpochMilli();
        String requestTime=String.valueOf(payTime)+"毫秒";
        list.add(requestTime);

        File file = new File(filePath);
        try{
            if (!file.exists()) {
                file.createNewFile(); // 创建新文件（如果没有这个文件）
            }
            try(FileWriter fileWriter=new FileWriter(filePath,true)){
                StringBuffer sb=new StringBuffer();
                for(String s:list){
                    sb.append(s).append(",");
                }
                sb.deleteCharAt(sb.length()-1);
                fileWriter.write(sb.toString());
                //fileWriter.write("试试写进去没有");
                fileWriter.write("\n");
                fileWriter.flush();
                fileWriter.close();
                System.out.println(list);
            }catch(IOException e){
                System.out.println("写入CSV文件出现错误:"+e);
            }
        }catch (IOException e){
            System.out.println("没有这个文件啊");
            System.out.println(e);
        }
    }

    private String getAbsolutePath(){
        //获取这个类所在的绝对路径
        String pathAbsolute = ServletRequestListenerImplementation.class.getProtectionDomain().getCodeSource().getLocation().getPath();
        File fileAbsolute = new File(pathAbsolute);
        String absolutePath = fileAbsolute.getAbsolutePath();
        //System.out.println("当前类的绝对路径：" + absolutePath);

        //处理路径拼接到webapp下的data.csv
        String[] pathParts = absolutePath.split("\\\\");
        int length = pathParts.length;
        String realPath="";
        for(int i=0;i<length-4;i++){
            //减4是因为运行以后会执行在target的workTwo-1.0-SNAPSHOT的WEB-INF下且该类标记为classes，回退四次到Listener目录（项目文件根目录）
            realPath+=pathParts[i]+"/";
        }
        realPath+="src/main/webapp/data.csv";
        //System.out.println("真正路径"+realPath);
        return realPath;
    }
}
