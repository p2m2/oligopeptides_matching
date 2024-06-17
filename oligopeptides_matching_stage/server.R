server <- function(input, output) {
  
  # Pour Onglet : Amino acid assemblies
  filtered_results <- eventReactive(input$calculate, {
    req(input$od_1)
    oligopeptides <- get_oligopeptides(
      aminoacids = aa_mw,
      oligomerization_degree = input$od_1
    )
    as.data.frame(oligopeptides)
  })
  
  output$results <- renderDT({
    filter_od <- filtered_results()
    DT::datatable(filter_od)
  })
  
  
  #Pour Onlglet Amino acid and mass
  # selected_columns <- eventReactive(input$Ok, {
  #   columns <- input$columns
  #   if (is.null(columns)) {
  #     names(aa_mw)
  #   } else {
  #     columns
  #   }
  # })
  # output$amino_acid_table <- renderDataTable({
  #   datatable(aa_mw[, selected_columns()], rownames = FALSE, options = list(paging = FALSE)) %>%
  #     formatStyle(
  #       'Specification_AA',
  #       backgroundColor = styleEqual(
  #         unique(aa_mw$Specification_AA),
  #         c('Non-polaire' = 'lightyellow', 'Polaire' = 'skyblue', 'Charge Negative' = 'orchid', 'Charge Positive' = 'palegreen')
  #       ),
  #       fontWeight = 'bold'
  #     )
  # })
  
  
  # output$results <- renderDT({
  #   filter_od <- filtered_results()
  #   filter_od <- filter_od %>% 
  #     filter(od == input$od_1)
  #   DT::datatable(filter_od)
  # })
  
  # Pour Onglet Combination AA Polyphenol
  combination_compounds <- reactive({
    req(input$od)
    aaa_combined <- get_oligopeptides(
      aminoacids = aa_mw,
      oligomerization_degree = input$od
    )
    aa_combined <- as.data.frame(aaa_combined)
    aa_combined_names <- c(aa_combined$id)
    aa_combined_mass <- c(aa_combined$MW)
    aa_combined_mw <- setNames(aa_combined_mass, aa_combined_names)
    return(get_combination_compounds(
      oligopeptides = aaa_combined,
      polyphenols = polyphenols,
      chemical_derivation = chemical_derivation,
      addition_reaction = 10
    ))
  })
  
  output$view_arrangement <- renderDT({
    combination_compounds()
  })
  
  # Pour Onglet match single mz
  filtered_mz_obs <- reactive({
    req(input$mz_obs, input$ppm_error)
    data <- match_mz_obs(
      mz_obs = input$mz_obs,
      ionization = input$ionization,
      combination_compounds(),
      ppm_error = input$ppm_error
    )
    if (is.null(data)) {
      return(NULL)
    } else {
      if (!is.data.frame(data)) {
        data <- as.data.frame(data)
      }
      return(data)
    }
  })
  
  observeEvent(input$Ok, {
    Sys.sleep(2)
    output$view_filter_mz_obs <- renderDT({
      filtered_mz_obs()
    })
  })
  
  # output$downloadData <- downloadHandler(
  #   filename = function() {
  #     paste(input$file1, ".csv", sep = "")
  #   },
  #   content = function(file) {
  #     write.csv(datasetInput(), file, row.names = FALSE)
  #   }
  # )
  # match_res <- eventReactive(input$update, {
  #   req(input$od)
  #   matching <- match_mz_obs(
  #     aminoacids = aa_mw,
  #     oligomerization_degree = input$od
  #   )
  #   as.data.frame(matching)
  # }) 
  # 
  # output$view_match <- renderDT({
  #   filtered_mz_obs()
  # })
  
  # Pour Onglet Match list mz
  data <- reactive({
    req(input$file1)
    df <- read.csv(input$file1$datapath, header = input$header, sep = input$sep)
    df
  })
  
  observeEvent(input$update, {
    req(data())
    df <- data()
    selection <- df[, c(input$name_column, input$mz_column, input$RT_column)]
    colnames(selection) <- c("name", "mz", "RT")
    
    matched_results <- match_list_mz_obs(
      list_mz_obs = selection,
      ionization = "already_charged",  
      combined_compounds = combined_compounds,  
      ppm_error = input$ppm_error
    )
    if (is.null(matched_results) || nrow(matched_results) == 0) {
      matched_results <- data.frame(message = "No matches found")
    }
    
    output$view_match <- DT::renderDataTable({
      DT::datatable(matched_results)
    })
  })
  
  output$downloadDataList <- downloadHandler(
    filename = function() {
      "matched_mz_list.csv"
    },
    content = function(file) {
      req(data())
      df <- data()
      selection <- df[, c(input$name_column, input$mz_column, input$RT_column)]
      colnames(selection) <- c("name", "mz", "RT")
      
      matched_results <- match_list_mz_obs(
        list_mz_obs = selection,
        ionization = "already_charged", 
        combined_compounds = combined_compounds,  
        ppm_error = input$ppm_error
      )
      write.csv(matched_results, file, row.names = FALSE)
    }
  )
  
  
  # Ajout de l'observeEvent pour submit_feedback
  observeEvent(input$submit_feedback, { 
    description <- input$description
    suggestions <- input$suggestions
    
    
    showModal(modalDialog(
      title = "Thank you, your feedback has been submitted!",
      easyClose = TRUE,
      footer = NULL
    ))
  })
}