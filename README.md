# quickQrtPCR
[![shiny](https://img.shields.io/badge/ShinyApp_web-ready-red.svg)](https://nongxinshengxinapp.shinyapps.io/quickqrtpcr/)

[English](README.md) | [Chinese](CH.md)
## Introduction
#### What is quickQrtPCR ?
quickQrtPCR is a shiny APP which can calculate qrtPCR results from Ct values.  
#### How is this App built ?
Relative expression of genes is calculated using the 2<sup>-ΔΔCt</sup> method.
#### What can the App do ?
Simply enter the excel sheet containing the Ct values and output the calculated relative expressions.

**Note**: your input form needs to meet the following requirements.

- <font size=4 >The first column is the sample column. And the first sample must be used as "Control" Set.</font>
- <font size=4 >The second column shows the Ct values of reference gene.</font>
- <font size=4 >Starting from the third column, each column represents a gene.</font>

![](/image/img0.png)

## Installation
Before installing this App, you will need to install **devtools** on your R.

```{r}
if (!require("devtools"))
  install.packages("devtools")
```
Once you have completed the installation of `devtools`, start downloading and installing quickQrtPCR.
```{r}
devtools::install_github("nongxinshengxin/quickQrtPCR")
```
Once the installation is complete, run `quickQrtPCR::run_app()` to open the APP page.
## APP Interface
Home page

![Alt1](/image/img1.png)

Function page

![Alt2](/image/img2.png)

Change color palette

![Alt3](/image/img3.png)

Significance test 

![Alt4](/image/img4.png)

## Web Version
quickQrtPCR also has a web version. You can log on to https://nongxinshengxinapp.shinyapps.io/quickqrtpcr/ to get the full service of the app.

## Documentation
The English documentation is available in - <https://github.com/nongxinshengxin/quickQrtPCR>

The Chinese documentation is available in - 微信公众号**农心生信工作室**

## Citation
Please, when using `quickQrtPCR`, cite us using the reference: https://github.com/nongxinshengxin/quickQrtPCR

## Contact us
- Email: nongxinshengxin@163.com
- Wechat Official Account：

![Alt1](/image/wx.png)
