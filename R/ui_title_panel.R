#' Add BTO title panel
#'
#' @param app_title = str, the name of the app to be shown in the title panel
ui_title_panel <- function(app_title) {
  tagList(
    div(style = "height: 10px; background-color: #ABC44B;"),
    titlePanel(
      windowTitle = app_title,
      title = div(
        style = "background-color: #000000; color: white; padding:10px; display: flex; align-items: center; ",
        HTML(
          '<a href = "https://www.bto.org" target="_blank"><img src="www/logo_BTO_bw.png"></a>'
        ),
        tags$h1(app_title, style = "margin: 0;")
      )
    )  #end titlePanel
  )
}
