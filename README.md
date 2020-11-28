# scss

解析scss语言代码，输出展开后的css代码

## 使用方法

```shell
make                   # 编译，第一、二次编译会有错误，再来一次即可
./scss scss_file       # 转换给定的scss文件
./unit_test.sh         # 运行单元测试
./scss scss_file -vvvv # 输出更多调试信息
```

scss的功能：
- [x] 嵌套选择器
- [x] 父元素选择器
- [x] 嵌套属性
- [x] 正确处理注释
- [ ] 未完待续
