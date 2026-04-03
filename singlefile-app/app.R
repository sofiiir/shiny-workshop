# --- load pkgs --- 
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(DT)

# --- user interface ---
ui <- fluidPage(
  
  # app title ---
  tags$h1("My app title"),
  
  # app subtitle ---
  h2(strong("Exploring antarctic penguin data")),
  
  # body mass slider input ---
  sliderInput(inputId = "body_mass_input",
              label = "Select a range of body masses (g)",
              min = 2700, max = 6300, value = c(3000, 4000)),
  
  # body mass scatter plot output ---
  plotOutput(outputId = "body_mass_scatterplot_output"),
  
  # year checkbox input ---
  checkboxGroupInput(inputId = "years_input",
                     label = "Select year(s)",
                     choices = unique(penguins$year),
                     selected = c(2007, 2008)),
  
  # year dataframe output --- 
  DT::dataTableOutput(outputId = "penguin_DT_output")

  
)

# --- server ---
server <- function(input, output){
  
  # filter body masses ---
  body_mass_df <- reactive({
    
    penguins |> 
      filter(body_mass_g %in% c(input$body_mass_input[1]:input$body_mass_input[2]))
    
  })
  
  
  output$body_mass_scatterplot_output <- renderPlot({
    
    # code to generate plot goes here
    
    # create scatterplot ----
    ggplot(na.omit(body_mass_df()), 
           aes(x = flipper_length_mm, y = bill_length_mm, 
               color = species, shape = species)) +
      geom_point() +
      scale_color_manual(values = c("Adelie" = "darkorange", "Chinstrap" = "purple", "Gentoo" = "cyan4")) +
      scale_shape_manual(values = c("Adelie" = 19, "Chinstrap" = 17, "Gentoo" = 15)) +
      labs(x = "Flipper length (mm)", y = "Bill length (mm)", 
           color = "Penguin species", shape = "Penguin species") +
      guides(color = guide_legend(position = "inside"),
             size = guide_legend(position = "inside")) +
      theme_minimal() +
      theme(legend.position.inside = c(0.85, 0.2), 
            legend.background = element_rect(color = "white"))
  })
  
  year_table <- reactive({
    
    # filter for year
    penguins |> 
      filter(year %in% c(input$years_input))
   
  })
  
  # render the DT datatable --- 
  output$penguin_DT_output <- DT::renderDataTable(year_table())
}

# --- combine ui and server into an app --- 
shinyApp(ui = ui, server = server)

