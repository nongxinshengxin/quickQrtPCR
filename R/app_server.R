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
    df <- read_excel(path =  rawmat$datapath,skip = as.numeric(input$skiprow))
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
      ggbarplot(delta,x="Sample",y="value",fill="Sample",add="mean_se",facet.by = "gene",palette=input$palette,
                position = position_dodge(0.8))+
        xlab("")+
        ylab("Relative Expression")+
        stat_compare_means(aes(group = Sample), label = "p.signif",method = input$method,ref.group = input$refgroup)
    }else{
      ggbarplot(delta,x="gene",y="value",fill="Sample",add="mean_se",palette=input$palette,
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
  
  
  ##下载tpm
  output$download_qrt<-downloadHandler(filename = function() {paste("QrtPCR", Sys.Date(), ".csv", sep="")},content=function(file) {
    write.csv(qrtmat(), file)
  })
  
  
}