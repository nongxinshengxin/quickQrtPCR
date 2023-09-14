#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinythemes
#' @import colourpicker
#' @noRd
app_ui <- function(request) {
  # Define UI for application
  navbarPage(title=div(a("quickQrtPCR v0.2.0")),
             theme = shinytheme("flatly"),
             tabPanel("Home", sidebarLayout(
               sidebarPanel(h3("quickQrtPCR",style = "font-family: 'times'"),
                            p("Calculating qrtPCR results from Ct values.",style = "font-family: 'times'; font-size:12pt;color:grey"),
                            br(),
                            strong("Welcome to follow our Wechat Official Account.", style = "font-family: 'times'; font-size:16pt"),
                            hr(),
                            p("Our Wechat Official Account is dedicated to sharing knowledge, sharing tools and sharing experiences.",style = "font-family: 'times'; font-size:14pt"),
                            br(),
                            p("For any feedback and tool suggestions, please feel free to leave a message at", a("Github issues.", href="https://github.com/nongxinshengxin/quickQrtPCR/issues",style = "font-family: 'times'; font-size:14pt"), style = "font-family: 'times'; font-size:14pt"),
                            hr(),
                            hr(),
                            p(em("Email: nongxinshengxin@163.com",style = "font-family: 'times'; font-size:12pt;color:grey"))
               ),
               mainPanel(
                 div(includeMarkdown(system.file("app/www/introduction.md", package = "quickQrtPCR")),style="position:relative;left: 40px")
               )
             )
             ),
             tabPanel("qrtPCR",sidebarLayout(
               sidebarPanel(
                 fileInput("inputfile", "Choose Table File"),
                 checkboxInput('header', 'ColName', TRUE),
                 br(),
                 actionButton("start","Start")
               ),
               mainPanel(
                 splitLayout(
                   div(helpText("Show the plot in this view."),plotOutput("plot_ht"),helpText("Show the results in this view."),tableOutput("table")),
                   div(selectInput("palette","Choose the the color palette",choices = c("npg", "grey","aaas", "lancet", "jco", "ucscgb", "uchicago", "simpsons","rickandmorty")),
                       p("Parameters of significance test"),
                       checkboxInput('test', 'Do significance test ?', TRUE),
                       textInput("refgroup","Choose the reference group",value = "CK"),
                       selectInput("method","Choose the test method",choices = c("t.test", "wilcox.test")),
                       p("Parameters of the download module"),
                       fluidRow(column(6,textInput("htwidth","Plot width",value = 7)),
                                column(6,textInput("htheight","Plot height",value = 5))),
                       radioButtons('ext2ht', 'Plot output format',choices = c('PDF'='pdf',"PNG"='png', 'JPEG'='jpeg'), inline = T),
                       helpText("Download Barplot"),
                       downloadButton("download_plot","Download"),
                       helpText("Download Qrt-PCR result"),
                       downloadButton("download_qrt","Download")),
                   cellWidths = c("70%","30%")
                 )
               )))
             ,
             tabPanel("Efficiency",sidebarLayout(
               sidebarPanel(
                 fileInput("inputfile2", "Choose Xlsx File"),
                 checkboxInput('header2', 'ColName', TRUE),
                 br(),
                 actionButton("start2","Start")
               ),
               mainPanel(
                 div(helpText("Show the LM plot in this view."),plotOutput("plot_lm"),
                     helpText("Show the amplification efficiency in this view."),textOutput("Evalue"))
               ))),
             
             div(div(p("Copyright © nongxinshengxin 2023. All rights reserved. Designed by Cy.")),style= "margin-top:20px;width: 100%;height: 65px;text-align:center;color: black;position: absolute;bottom:5px")
             
  )

}


#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "quickQrtPCR"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
