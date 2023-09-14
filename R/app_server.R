#' The application server-side
#'
#' @param input,output Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinythemes


#' @noRd
app_server <- function(input,output) {
  options(shiny.maxRequestSize = 30 * 1024^2)
  
  qrtmat<-eventReactive(input$start,{
    rawmat<-input$inputfile
    if (is.null(rawmat))
      return(NULL)
    df <- readxl::read_excel(path =  rawmat$datapath,col_names = input$header)
    oldgeneid<-colnames(df)[3:ncol(df)]
    colnames(df)<-c("Sample","keeper",paste("gene",seq(1:(ncol(df)-2)),sep = ""))
    
    CKname<-as.character(df[1,1])
    
    delta<-tibble(df[,1])
    keeperMean<-df%>%group_by(Sample)%>%summarise(keeperMean=mean(keeper))
    delta<-left_join(df,keeperMean)
    
    
    delta<-delta%>%mutate_at(vars(contains("gene")),~(.-delta$keeperMean))
    
    firstmean<-colMeans(delta%>%filter(Sample==CKname)%>%select(contains("gene")))
    
    
    for (i in 1:length(firstmean)){
      delta<-delta%>%mutate_at(vars(contains(names(firstmean[i]))),~(2**-(.-firstmean[i])))
    }
    
    delta<-delta%>%select(Sample,contains("gene"))
    colnames(delta)[2:ncol(df)]<-oldgeneid
    delta
    
  })
  
  
  output$table <- renderTable({
    
    if (is.null(qrtmat()))
      return(NULL)
    head(qrtmat())
    
  },rownames = T,colnames = T)
  
  
  drawbar<-reactive({
    ###绘制
    delta<-pivot_longer(qrtmat(),-Sample,names_to = "gene")
    if (input$test==TRUE){
      ggpubr::ggbarplot(delta,x="Sample",y="value",fill="Sample",add="mean_se_",facet.by = "gene",palette=input$palette,
                position = position_dodge(0.8))+
        xlab("")+
        ylab("Relative Expression")+
        stat_compare_means(aes(group = Sample), label = "p.signif",method = input$method,ref.group = input$refgroup)
    }else{
      ggpubr::ggbarplot(delta,x="gene",y="value",fill="Sample",add="mean_se_",palette=input$palette,
                position = position_dodge(0.8))+
        xlab("")+
        ylab("Relative Expression")
    }
    
  })
  
  
  
  
  
  output$plot_ht<-renderPlot({
    if (is.null(drawbar()))
      return(NULL)
    drawbar()
  })
  
  
  #下载图片
  output$download_plot<-downloadHandler(
    filename = function() {
      paste('barplot', Sys.Date(), '.',input$ext2ht, sep='')
    },
    content=function(file){
      
      ggsave(file,plot =drawbar(), width = as.numeric(input$htwidth), height = as.numeric(input$htheight))
      
    })
  
  
  ##下载
  output$download_qrt<-downloadHandler(filename = function() {paste("QrtPCR", Sys.Date(), ".csv", sep="")},content=function(file) {
    write.csv(qrtmat(), file)
  })

  
  ###第二部分
  plotdf<-eventReactive(input$start2,{
    rawmat<-input$inputfile2
    if (is.null(rawmat))
      return(NULL)
    df <- readxl::read_excel(path =  rawmat$datapath,col_names = input$header2)
    colnames(df)<-c("Ct","dilution")
    lmformula<-lm(df$Ct~log10(df$dilution))
    df
  })
  
  ##plot
  drawpoint<-reactive({
    ###热图绘制
    df<-plotdf()
    k<-as.numeric(lmformula$coefficients[2])
    b<-as.numeric(lmformula$coefficients[1])
    ggplot(df,aes(x=log10(dilution),y=Ct))+
      geom_point(size=1.5)+
      geom_smooth(method = "lm")+
      labs(title = paste("y=",k,"x","+",b,sep = ""))+
      theme_bw()
  })
  
  
  output$plot_lm<-renderPlot({
    if (is.null(drawpoint()))
      return(NULL)
    drawpoint()
  })
  
  ##text
  Etext<-reactive({
    df<-plotdf()
    k<-as.numeric(lmformula$coefficients[2])
    e<-(10**(-1/k)-1)*100
    ev<-paste(e,"%")
    ev
  })
  
  
  output$Evalue<-renderText({
    if (is.null(Etext()))
      return(NULL)
    Etext()
  })
    
  
}
