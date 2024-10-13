# ServletRequestListenerImplementation

## 用途

本案例用于监听发起的请求并记录HTTP请求信息

## 实现

### requestInitialized

由于是针对HTTP请求，在请求发起时，该类会调用requestInitialized类，在这个类中记录：

- 发起请求起始的时间戳startTime
- 客户端IP地址-customer
- 获取请求的方法-method
- 请求的URI-path
- 请求字符串-quit
- User-Agent-usetAgent

以上信息并记录入列表list中，并将起始时间戳和列表作为请求属性传递给requestDestroyed。

### requestDestroyed

记录结束的时间戳-endTime，并与传递过来的起始时间戳计算出请求时间-payTime，并添加进传递过来的列表中，然后写入data.csv文件完成记录