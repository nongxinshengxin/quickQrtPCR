# quickQrtPCR

[中文](CH.md) | [英文](README.md)
## APP介绍
### 什么是quickQrtPCR ?
quickQrtPCR是一款shiny app，可以根据实时荧光定量PCR（Quantitative Real-time PCR）下机产生的Ct（cycle threshold：QPCR扩增过程中，扩增产物的荧光信号达到设定的荧光阈值时所对应的扩增循环数）值，计算不同样本基因的相对表达量。 
 
### 这款APP如何构建 ?
基因的相对表达量计算是基于 2<sup>-ΔΔCt</sup> 方法；APP是基于`shiny`、`tidyverse`和`ggpubr`构建。

### 这款APP可以做什么 ?
仅需输入包含Ct值的excel列表，即可输出计算好的相对表达量。

**注意**：你的输入文件格式必须符合以下要求：

- 第一列为样本列。而且第一个样本必须作为“对照”。
- 第二列是内参基因的Ct值。
- 从第三列开始，每一列代表一种基因的Ct值。

![](/image/img0.png)

## 如何安装
在安装之前，你需要在你的R上安装 **devtools** 包。

```{r}
if (!require("devtools"))
  install.packages("devtools")
```

完成 `devtools` 安装后, 开始下载安装 `quickQrtPCR`。

```{r}
devtools::install_github("nongxinshengxin/quickQrtPCR")
```

安装完成，运行 `quickQrtPCR::run_app()` 打开APP页面。

## APP界面
### Home界面

![Alt1](/image/img1.png)

### 功能界面

![Alt2](/image/img2.png)

### 更改配色

可以更换多种配色，目前提供了9种配色方案。

![Alt3](/image/img3.png)

### 显著性检验

可以选择t.test（参数检验，默认）和wilcox.test（非参检验）两种检验方式。

**注意**，进行检验时，需输入对照组样品名称，及CK，该样品名应该与输入的excel表的第一列第一行相同。
![Alt4](/image/img4.png)

## Web版本
quickQrtPCR也拥有在线web版本。你可以登录 https://nongxinshengxinapp.shinyapps.io/quickqrtpcr/，来获取APP的全部功能。

## 说明文档
英文文档首发于 - <https://github.com/nongxinshengxin/quickQrtPCR>

中文文档首发于 - 微信公众号**农心生信工作室**

## 如何引用
如果 `quickQrtPCR`对你有帮助，请引用: https://github.com/nongxinshengxin/quickQrtPCR

## 联系我们
- Email: nongxinshengxin@163.com
- 微信公众号：农心生信工作室

![Alt1](/image/wx.png)
