
feedback_user_ui <- function(id){
  tagList(
    fluidRow(
      col_12(
        bs4Card(
          title = "Feedback",
          status = "primary",
          solidHeader = FALSE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = TRUE,
          label = NULL,
          width = 12,
          tagList(
            includeMarkdown(app_sys("app", "docs", "feedback_intro.md"))
          )
        )
      )))
  
}