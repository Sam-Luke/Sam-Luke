# Load required packages
library(shiny)
library(shinycssloaders)
library(shinyjs)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(janitor)
library(stringr)
library(purrr)
library(scales)
library(ggradar)
library(plotly)
library(networkD3)
library(viridis)
library(patchwork)
library(ggrepel)
library(forcats)
library(DT)
library(htmlwidgets)
library(ggiraph)
library(sentimentr)

# Define file paths 
file_path <- "Curriculum_and_Assessment_Review_interim_report_-_KS4_and_16-19_polling_-_detailed_results.xlsx"

# Check if file exists
if (!file.exists(file_path)) {
  stop("The specified file does not exist.")
}

# Get and verify sheet names
sheet_names <- excel_sheets(file_path)
print("Available sheets in the Excel file:")
print(sheet_names)

# Define target sheet names
target_sheets <- c(
  "Results - KS4 learners",
  "Results - 16 to 19 learners",
  "Results - KS4 parents",
  "Results - 16 to 19 parents"
)


# Define table ranges
table_ranges <- list(
  "KS4_Learners_1" = "A9:AC26",
  "KS4_Learners_2" = "A30:AC51",
  "KS4_Learners_3" = "A55:AC76",
  "KS4_Learners_3a" = "A80:O97",
  "KS4_Learners_4" = "A101:AC122",
  "KS4_Learners_5" = "A126:AC135",
  "KS4_Learners_5a" = "A139:AB160",
  "KS4_Learners_6" = "A164:AC173",
  "KS4_Learners_6a" = "A177:AC198",
  "KS4_Learners_7" = "A202:AC231",
  "KS4_Learners_8" = "A235:AC256",
  "KS4_Learners_9" = "A260:AC279",
  "KS4_Learners_10" = "A283:AC292",
  "KS4_Learners_11" = "A296:AC305",
  "KS4_Learners_12" = "A309:AC318",
  "KS4_Learners_13" = "A322:AC331",
  "KS4_Learners_14" = "A335:AC344",
  "KS4_Learners_15" = "A348:AC359",
  "KS4_Learners_16" = "A363:AC384",
  "KS4_Learners_17" = "A388:AC409",
  "KS4_Learners_17a" = "A413:K426",
  "KS4_Learners_18" = "A430:AC451",
  "KS4_Learners_19" = "A455:AC476",
  
  "Sixteen_to_Nineteen_Learner_1" = "A9:AH26",
  "Sixteen_to_Nineteen_Learner_2" = "A30:AH51",
  "Sixteen_to_Nineteen_Learner_3" = "A55:AH76",
  "Sixteen_to_Nineteen_Learner_3a" = "A80:Q95",
  "Sixteen_to_Nineteen_Learner_4" = "A99:AH120",
  "Sixteen_to_Nineteen_Learner_5" = "A124:AH135",
  "Sixteen_to_Nineteen_Learner_6" = "A139:AH160",
  "Sixteen_to_Nineteen_Learner_7" = "A164:AH185",
  "Sixteen_to_Nineteen_Learner_8" = "A189:AH210",
  "Sixteen_to_Nineteen_Learner_9" = "A214:AH235",
  "Sixteen_to_Nineteen_Learner_10" = "A239:AH260",
  "Sixteen_to_Nineteen_Learner_11" = "A264:AH283",
  "Sixteen_to_Nineteen_Learner_12" = "A287:AH296",
  "Sixteen_to_Nineteen_Learner_13" = "A300:AH309",
  "Sixteen_to_Nineteen_Learner_14" = "A313:AH322",
  "Sixteen_to_Nineteen_Learner_15" = "A326:AH335",
  "Sixteen_to_Nineteen_Learner_16" = "A339:AH348",
  "Sixteen_to_Nineteen_Learner_17" = "A352:AH363",
  "Sixteen_to_Nineteen_Learner_18" = "A367:AH388",
  "Sixteen_to_Nineteen_Learner_19" = "A392:AH413",
  "Sixteen_to_Nineteen_Learner_19a" = "A418:T431",
  "Sixteen_to_Nineteen_Learner_20" = "A435:AH456",
  "Sixteen_to_Nineteen_Learner_21" = "A460:AH481",
  
  "KS4_Parents_1" = "A9:AJ26",
  "KS4_Parents_2" = "A30:AJ51",
  "KS4_Parents_3" = "A55:AJ76",
  "KS4_Parents_3a" = "A80:Q97",
  "KS4_Parents_4" = "A102:AJ123",
  "KS4_Parents_5" = "A127:AJ136",
  "KS4_Parents_5a" = "A140:AJ161",
  "KS4_Parents_6" = "A165:AJ174",
  "KS4_Parents_6a" = "A175:AJ199",
  "KS4_Parents_7" = "A203:AJ232",
  "KS4_Parents_8" = "A236:AJ257",
  "KS4_Parents_9" = "A261:AJ280",
  "KS4_Parents_10" = "A284:AJ293",
  "KS4_Parents_11" = "A297:AJ306",
  "KS4_Parents_13" = "A323:AJ332",
  "KS4_Parents_14" = "A336:AJ345",
  "KS4_Parents_15" = "A349:AJ360",
  "KS4_Parents_16" = "A364:AJ385",
  "KS4_Parents_17" = "A389:AJ410",
  "KS4_Parents_17a" = "A414:O427",
  "KS4_Parents_18" = "A431:AJ452",
  "KS4_Parents_18a" = "A456:AJ477",
  
  "Sixteen_to_Nineteen_Parents_1" = "A9:AP26",
  "Sixteen_to_Nineteen_Parents_2" = "A30:AP51",
  "Sixteen_to_Nineteen_Parents_3" = "A55:AP76",
  "Sixteen_to_Nineteen_Parents_3a" = "A80:P95",
  "Sixteen_to_Nineteen_Parents_4" = "A100:AP121",
  "Sixteen_to_Nineteen_Parents_5" = "A125:AP146",
  "Sixteen_to_Nineteen_Parents_6" = "A150:AP169",
  "Sixteen_to_Nineteen_Parents_7" = "A173:AP182",
  "Sixteen_to_Nineteen_Parents_8" = "A186:AP195",
  "Sixteen_to_Nineteen_Parents_9" = "A199:AP208",
  "Sixteen_to_Nineteen_Parents_10" = "A212:AP221",
  "Sixteen_to_Nineteen_Parents_11" = "A225:AP234",
  "Sixteen_to_Nineteen_Parents_12" = "A238:AP249",
  "Sixteen_to_Nineteen_Parents_13" = "A253:AP274",
  "Sixteen_to_Nineteen_Parents_14" = "A278:AP299",
  "Sixteen_to_Nineteen_Parents_14a" = "A303:H316",
  "Sixteen_to_Nineteen_Parents_15" = "A320:AP341",
  "Sixteen_to_Nineteen_Parents_16" = "A345:AP366"
)

# Enhanced data validation function
validate_data <- function(df) {
  if (is.null(df) || nrow(df) == 0) {
    return(list(valid = FALSE, issues = "Empty data frame"))
  }
  
  issues <- list()
  
  # Check for required columns
  if (!"breakdown" %in% names(df)) {
    issues <- c(issues, "Missing 'breakdown' column")
  }
  
  # Check numeric columns
  numeric_cols <- names(df)[sapply(df, is.numeric)]
  if (length(numeric_cols) > 0) {
    # Check for NA values
    na_counts <- sapply(df[numeric_cols], function(x) sum(is.na(x)))
    if (any(na_counts > 0)) {
      issues <- c(issues, paste("NA values found in:", 
                                paste(names(na_counts[na_counts > 0]), collapse = ", ")))
    }
    
    # Check for values outside expected range (0-100 for %)
    out_of_range <- sapply(df[numeric_cols], function(x) {
      sum(x < 0 | x > 100, na.rm = TRUE)
    })
    if (any(out_of_range > 0)) {
      issues <- c(issues, paste("Values out of 0-100 range in:", 
                                paste(names(out_of_range[out_of_range > 0]), collapse = ", ")))
    }
  }
  
  # Check character columns
  char_cols <- names(df)[sapply(df, is.character)]
  if (length(char_cols) > 0) {
    # Check for empty strings
    empty_counts <- sapply(df[char_cols], function(x) sum(x == "" | is.na(x)))
    if (any(empty_counts > 0)) {
      issues <- c(issues, paste("Empty strings in:", 
                                paste(names(empty_counts[empty_counts > 0]), collapse = ", ")))
    }
  }
  
  # Return validation results
  if (length(issues) > 0) {
    return(list(valid = FALSE, issues = issues))
  } else {
    return(list(valid = TRUE, issues = NULL))
  }
}

# Enhanced cleaning function with validation
clean_table <- function(df, table_name) {
  tryCatch({
    if (nrow(df) < 2) {
      message(paste("Table", table_name, "has insufficient rows - skipping"))
      return(NULL)
    }
    
    # Print structure and sample of the data for debugging
    message(paste("Inspecting table:", table_name))
    print(head(df))
    print(str(df))
    
    df_cleaned <- df %>%
      row_to_names(row_number = 2) %>%
      clean_names()
    
    if (!"breakdown" %in% names(df_cleaned)) {
      df_cleaned <- df_cleaned %>%
        mutate(breakdown = as.character(row_number()))
    }
    
    # Identify numeric columns more carefully
    cols_to_numeric <- names(df_cleaned)[!names(df_cleaned) %in% c("breakdown") & 
                                           sapply(df_cleaned, function(x) {
                                             x <- as.character(x)
                                             x <- str_remove_all(x, "[,%]") %>%
                                               str_trim()
                                             x <- ifelse(x %in% c("", "NA", "N/A", "Prefer not to say", "NULL", ".", "-"),
                                                         NA_character_, x)
                                             !all(is.na(suppressWarnings(as.numeric(x))))
                                           })]
    
    # Convert to numeric with better handling
    df_cleaned <- df_cleaned %>%
      mutate(across(
        all_of(cols_to_numeric),
        ~ suppressWarnings({
          x <- as.character(.x)
          x <- str_remove_all(x, "[,%]") %>%
            str_trim()
          x <- ifelse(x %in% c("", "NA", "N/A", "Prefer not to say", "NULL", ".", "-"),
                      NA_character_, x)
          as.numeric(x)
        })
      )) %>%
      filter(rowSums(!is.na(across(-breakdown))) > 0)
    
    # Check character columns
    char_cols <- names(df_cleaned)[sapply(df_cleaned, is.character)]
    if (length(char_cols) == 0 || any(char_cols == "")) {
      message(paste("No valid character columns found in table:", table_name))
      return(df_cleaned)  # Return cleaned data without further processing character columns
    }
    
    # Log character columns for debugging
    message(paste("Character columns in table:", table_name, ":", paste(char_cols, collapse = ", ")))
    
    message(paste("Successfully cleaned table:", table_name))
    df_cleaned
    
  }, error = function(e) {
    message(paste("Error cleaning table:", table_name))
    message(e)
    return(NULL)
  })
}

# Narrative text generation functions
generate_narrative <- function(data, plot_type, selected_columns, selected_breakdowns) {
  tryCatch({
    if (is.null(data) || nrow(data) == 0) {
      return("No data available to generate narrative.")
    }
    
    # Basic statistics
    num_cols <- length(selected_columns)
    num_breakdowns <- length(selected_breakdowns)
    
    # Generate narrative based on plot type
    narrative <- switch(plot_type,
                        "bar" = {
                          paste("The bar plot compares", num_cols, "metrics across", 
                                num_breakdowns, "different groups. This visualization helps identify ",
                                "patterns and differences between the groups for each metric.")
                        },
                        "stacked" = {
                          paste("The stacked bar chart shows the composition of", num_cols,
                                "components across", num_breakdowns, "groups. This helps understand ",
                                "how each component contributes to the whole for different categories.")
                        },
                        "heatmap" = {
                          paste("The heatmap displays the relationship between", num_cols,
                                "variables across", num_breakdowns, "categories. Warmer colors indicate ",
                                "higher values, making it easy to spot areas of concentration.")
                        },
                        "pie" = {
                          paste("The pie chart illustrates the proportional distribution of",
                                num_cols, "categories for the selected group. This helps visualize ",
                                "relative contributions to the whole.")
                        },
                        "box" = {
                          paste("The box plot shows the distribution of", num_cols,
                                "metrics, displaying median, quartiles, and outliers. This helps ",
                                "understand the variability and central tendency of each metric.")
                        },
                        "violin" = {
                          paste("The violin plot combines a box plot with a density plot to show ",
                                "the distribution of", num_cols, "metrics. The width represents ",
                                "the frequency of values at different levels.")
                        },
                        "density" = {
                          paste("The density plot visualizes the probability distribution of",
                                num_cols, "metrics. This helps identify patterns such as ",
                                "multimodality or skewness in the data.")
                        },
                        "bubble" = {
                          paste("The bubble chart displays", num_cols, "metrics in a ",
                                "multidimensional view, where bubble size represents an additional ",
                                "dimension of the data.")
                        },
                        "radar" = {
                          paste("The radar chart compares", num_cols, "metrics across",
                                num_breakdowns, "groups on axes arranged radially. This helps ",
                                "visualize strengths and weaknesses across multiple dimensions.")
                        },
                        "sankey" = {
                          paste("The Sankey diagram illustrates flows between", num_cols,
                                "categories and", num_breakdowns, "groups. The width of the links ",
                                "represents the magnitude of the flows.")
                        },
                        paste("The visualization displays", num_cols, "metrics across",
                              num_breakdowns, "groups in a", plot_type, "format.")
    )
    
    # Add key findings
    key_findings <- data %>%
      select(all_of(selected_columns)) %>%
      summarise(across(everything(), mean, na.rm = TRUE)) %>%
      pivot_longer(everything(), names_to = "metric", values_to = "mean") %>%
      arrange(desc(mean))
    
    highest_metric <- key_findings$metric[1]
    lowest_metric <- key_findings$metric[nrow(key_findings)]
    
    narrative <- paste(narrative, 
                       "\n\nKey Findings:\n",
                       "- The highest scoring metric was '", highest_metric, 
                       "' with an average of ", round(key_findings$mean[1], 1), ".\n",
                       "- The lowest scoring metric was '", lowest_metric, 
                       "' with an average of ", round(key_findings$mean[nrow(key_findings)], 1), ".\n",
                       sep = "")
    
    # Add sentiment analysis if text data is available
    if ("breakdown" %in% names(data) && any(grepl("[a-zA-Z]{10,}", data$breakdown))) {
      sentiment_scores <- sentiment_by(data$breakdown)
      avg_sentiment <- mean(sentiment_scores$ave_sentiment, na.rm = TRUE)
      
      sentiment_desc <- ifelse(avg_sentiment > 0.5, "generally positive",
                               ifelse(avg_sentiment < -0.5, "generally negative",
                                      "relatively neutral"))
      
      narrative <- paste(narrative,
                         "\nSentiment Analysis:\n",
                         "- The descriptive text in the data shows ", sentiment_desc, 
                         " sentiment (average score: ", round(avg_sentiment, 2), ").",
                         sep = "")
    }
    
    # Add data quality notes
    na_counts <- sapply(data[selected_columns], function(x) sum(is.na(x)))
    if (any(na_counts > 0)) {
      narrative <- paste(narrative,
                         "\n\nData Quality Notes:\n",
                         "- Missing values detected in: ", 
                         paste(names(na_counts[na_counts > 0]), collapse = ", "),
                         ". Consider this when interpreting results.",
                         sep = "")
    }
    
    return(narrative)
  }, error = function(e) {
    return(paste("Could not generate narrative due to error:", e$message))
  })
}

# Define UI for fluidPage
ui <- fluidPage(
  useShinyjs(),  # For help modal functionality
  
  tags$head(
    tags$style(HTML("
      .marquee {
        overflow: hidden;
        white-space: nowrap;
        box-sizing: border-box;
        width: 100%;
      }
      
      .marquee span {
        display: inline-block;
        animation: marquee 60s linear infinite;
      }
      
      @keyframes marquee {
        0% { transform: translateX(100%); }
        100% { transform: translateX(-100%); }
      }

      .blinking { animation: blink 2s step-end infinite; }
      @keyframes blink { 50% { opacity: 0; } }
      
      .fixed-header {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        background-color: #8ad3ff;
        z-index: 1000;
        padding: 10px;
        height: 120px;
      }
      
      .main-content {
        margin-top: 140px;
        padding: 20px;
      }
      
      .footer {
        background-color: #8ad3ff;
        color: white;
        padding: 25px;
        margin-top: 20px;
        text-align: center;
      }

      .footer p { margin: 8px 0; }

      .home-container {
        text-align: center;
        margin-top: 140px;
        padding: 20px;
      }

      .description { font-size: 20px; margin-bottom: 20px; }

      #main_content { display: none; }

      .home-outer {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: calc(100vh - 170px);
      }

      #start_button {
        font-size: 24px;
        padding: 15px 30px;
        margin-top: 30px;
        background-color: #8ad3ff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: all 0.3s;
      }

      #start_button:hover {
        background-color: #6ac3ff;
        transform: scale(1.05);
      }

      #go_home_button {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 1001;
        font-size: 18px;
        padding: 10px 20px;
        background-color: #ff6b6b;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
      }

      .tab-content { padding-top: 20px; }

      .shiny-output-error, .shiny-output-error:before {
        margin-top: 140px;
      }
    
      .star-rating {
        unicode-bidi: bidi-override;
        direction: rtl;
        text-align: center;
        margin: 20px 0;
      }
      .star-rating .star {
        font-size: 32px;
        color: #ddd;
        cursor: pointer;
        display: inline-block;
        transition: color 0.2s;
        margin: 0 5px;
      }
      .star-rating .star:hover,
      .star-rating .star.active,
      .star-rating .star:hover ~ .star {
        color: #ffcc00;
      }
      .review-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
      }
      .rating-form {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
      }
      .reviews-list {
        margin-top: 30px;
      }
      .review-item {
        border-bottom: 1px solid #eee;
        padding: 15px 0;
      }
      .reviewer-name {
        font-weight: bold;
        margin-right: 10px;
      }
      .review-date {
        color: #777;
        font-size: 0.9em;
      }
      .review-text {
        margin: 10px 0;
      }
      .rating-stars {
        color: #ffcc00;
        font-size: 1.2em;
        letter-spacing: 2px;
      }
      .thank-you {
        color: #28a745;
        font-weight: bold;
        margin-top: 10px;
        animation: fadeIn 1s;
      }
      
      .narrative-text {
        background-color: #f8f9fa;
        border-left: 4px solid #8ad3ff;
        padding: 15px;
        margin: 20px 0;
        border-radius: 0 5px 5px 0;
      }
      .narrative-text h4 {
        margin-top: 0;
        color: #007bff;
      }
      .key-finding {
        font-weight: bold;
        color: #28a745;
      }
      .data-warning {
        color: #dc3545;
        font-weight: bold;
      }
    "))
  ),
  
  # Custom header with logo, title, and help button
  div(class = "fixed-header",
      style = "display: flex; align-items: center; justify-content: space-between;",
      tags$img(src = "logo.png", style = "height: 100px; width: 100px; margin-right: 15px;"),
      div(style = "flex-grow: 1; text-align: center;", 
          h2("Curriculum and Assessment Review", style = "margin: 0;"),
          div(class = "marquee",
              tags$span("To what extent do both parents and students agree that the curriculum supports their readiness for future success?")
          )
      ),
      actionButton("helpBtn", "Help", icon = icon("question-circle"), 
                   style = "background-color: white; color: #8ad3ff;")
  ),
  
  # Home Page - Centered content
  div(id = "home_page",
      class = "home-outer",
      div(class = "home-container",
          h1("Welcome to Our Data Analysis Tool"),
          p(class = "description", "This tool helps you analyze curriculum and assessment data to improve educational outcomes."),
          actionButton("start_button", "Start Here", class = "blinking")
      )
  ),
  
  # Main content area with tabs
  div(id = "main_content",
      class = "main-content",
      sidebarLayout(
        sidebarPanel(
          width = 3,
          selectInput("dataset", "Select Dataset:",
                      choices = c("KS4 Learners" = "ks4_learners",
                                  "16-19 Learners" = "sixteen_nineteen_learners",
                                  "KS4 Parents" = "ks4_parents",
                                  "16-19 Parents" = "sixteen_nineteen_parents")),
          uiOutput("table_select"),
          selectInput("plot_type", "Select Plot Type:",
                      choices = c(
                        "Bar Plot" = "bar",
                        "Stacked Bar" = "stacked",
                        "Heatmap" = "heatmap",
                        "Pie Chart" = "pie",
                        "Box Plot" = "box",
                        "Violin Plot" = "violin",
                        "Density Plot" = "density",
                        "Bubble Chart" = "bubble",
                        "Radar Chart" = "radar",
                        "Sankey Diagram" = "sankey"
                      )),
          uiOutput("column_select"),
          uiOutput("breakdown_filter"),
          hr(),
          selectInput("comparison_table", "Select Table for Comparison:",
                      choices = names(cleaned_data$ks4_learners))
        ),
        
        mainPanel(
          width = 9,
          tabsetPanel(
            id = "mainTabs",
            tabPanel("Data Explorer",
                     DTOutput("data_table"),
                     downloadButton("download_data", "Download Table", 
                                    class = "btn-primary")
            ),
            tabPanel("Visualizations",
                     uiOutput("plot_output_ui"),
                     htmlOutput("plot_warning")
            ),
            tabPanel("Group Comparison",
                     plotlyOutput("group_comparison_plot", height = "600px")
            ),
            tabPanel("Narrative Insights",
                     div(class = "narrative-text",
                         h4("Data Story"),
                         htmlOutput("narrative_text")
                     )
            ),
            tabPanel("Feedback",
                     div(class = "review-container",
                         h3("Share Your Experience"),
                         p("We'd love to hear your feedback about this app!"),
                         
                         div(class = "rating-form",
                             h4("Rate this App"),
                             div(class = "star-rating",
                                 span(id = "star5", class = "star", "★"),
                                 span(id = "star4", class = "star", "★"),
                                 span(id = "star3", class = "star", "★"),
                                 span(id = "star2", class = "star", "★"),
                                 span(id = "star1", class = "star", "★"),
                                 hidden(textInput("rating_value", "", value = "0"))
                             ),
                             
                             textInput("reviewer_name", "Your Name (optional)", ""),
                             textAreaInput("review_text", "Your Feedback", "", 
                                           placeholder = "What did you like about this app? How can we improve?",
                                           rows = 4),
                             actionButton("submit_review", "Submit Feedback", 
                                          class = "btn-primary"),
                             
                             # Success message placeholder
                             uiOutput("thank_you_message")
                         ),
                         
                         hr(),
                         
                         h4("Recent Feedback"),
                         div(class = "reviews-list",
                             uiOutput("reviewsList")
                         )
                     )
            )
          )
        )
      ),
      
      # Go back home button (blinking)
      actionButton("go_home_button", "Go back Home", class = "blinking")
  ),
  
  # Footer
  div(class = "footer",
      tags$img(src = "logo.png", style = "height: 100px; width: 100px; float: left; margin-right: 10px;"),
      p("© 2024 Curriculum and Assessment Review Tool"),
      p("Contact us at: ", tags$a(href="mailto:samndiege2015@gmail.com", "info@curriculumreview2024.com", style="color:white;")),
      p("Trial Version 1.0.0")
  )
)

# JavaScript for star rating
tags$script(HTML("
  $(document).ready(function() {
    // Star rating interaction
    $('.star').click(function() {
      let starId = $(this).attr('id');
      let rating = parseInt(starId.replace('star', ''));
      
      // Update visual display
      $('.star').removeClass('active');
      $(this).addClass('active');
      $(this).prevAll('.star').addClass('active');
      
      // Update the hidden input value
      $('#rating_value').val(rating).trigger('change');
    });
    
    // Hover effects
    $('.star').hover(
      function() {
        let starId = $(this).attr('id');
        let hoverRating = parseInt(starId.replace('star', ''));
        $('.star').each(function() {
          let thisId = $(this).attr('id');
          let thisRating = parseInt(thisId.replace('star', ''));
          if (thisRating <= hoverRating) {
            $(this).css('color', '#ffcc00');
          }
        });
      },
      function() {
        $('.star').css('color', '#ddd');
        // Restore active stars if any
        let currentRating = parseInt($('#rating_value').val());
        if (currentRating > 0) {
          $('.star').each(function() {
            let thisId = $(this).attr('id');
            let thisRating = parseInt(thisId.replace('star', ''));
            if (thisRating <= currentRating) {
              $(this).css('color', '#ffcc00');
            }
          });
        }
      }
    );
  });
"))

# Define server logic
server <- function(input, output, session) {
  
  # Load existing reviews from CSV file
  reviews <- reactiveVal({
    if (file.exists("reviews.csv")) {
      read.csv("reviews.csv", stringsAsFactors = FALSE)
    } else {
      data.frame(name = character(), rating = numeric(), text = character(), date = character(), stringsAsFactors = FALSE)
    }
  })
  
  # Show main content when start button is clicked
  observeEvent(input$start_button, {
    shinyjs::hide("home_page")
    shinyjs::show("main_content")
    shinyjs::runjs("window.scrollTo(0, 0);")  # Scroll to top of main content
  })
  
  # Go back to home page when button is clicked
  observeEvent(input$go_home_button, {
    shinyjs::show("home_page")
    shinyjs::hide("main_content")
    shinyjs::runjs("window.scrollTo(0, 0);")  # Scroll to top of page
  })
  
  # Reactive dataset selection
  selected_data <- reactive({
    req(input$dataset)
    switch(input$dataset,
           "ks4_learners" = cleaned_data$ks4_learners,
           "sixteen_nineteen_learners" = cleaned_data$sixteen_nineteen_learners,
           "ks4_parents" = cleaned_data$ks4_parents,
           "sixteen_nineteen_parents" = cleaned_data$sixteen_nineteen_parents)
  })
  
  output$table_select <- renderUI({
    req(selected_data())
    selectInput("selected_table", "Select Table:",
                choices = names(selected_data()))
  })
  
  current_table <- reactive({
    req(input$selected_table)
    tbl <- tryCatch({
      selected_data()[[input$selected_table]]
    }, error = function(e) {
      showNotification(paste("Error retrieving table:", e$message), type = "error")
      NULL
    })
    
    if (is.null(tbl)) return(NULL)
    
    if (!"breakdown" %in% names(tbl)) {
      if (nrow(tbl) > 0) {
        tbl <- tbl %>% mutate(breakdown = as.character(1:nrow(tbl)))
      } else {
        tbl <- tbl %>% mutate(breakdown = character())
      }
    }
    tbl
  })
  
  output$data_table <- renderDT({
    req(current_table())
    datatable(current_table(),
              options = list(scrollX = TRUE, pageLength = 10))
  })
  
  output$narrative_text <- renderUI({
    req(current_table(), input$selected_columns, input$selected_breakdowns, input$plot_type)
    
    narrative <- generate_narrative(
      data = current_table() %>% 
        filter(breakdown %in% input$selected_breakdowns) %>%
        select(breakdown, all_of(input$selected_columns)),
      plot_type = input$plot_type,
      selected_columns = input$selected_columns,
      selected_breakdowns = input$selected_breakdowns
    )
    
    # Convert to HTML with formatting
    narrative <- gsub("\n", "<br>", narrative)
    narrative <- gsub("Key Findings:", "<h4>Key Findings</h4>", narrative)
    narrative <- gsub("Sentiment Analysis:", "<h4>Sentiment Analysis</h4>", narrative)
    narrative <- gsub("Data Quality Notes:", "<h4 class='data-warning'>Data Quality Notes</h4>", narrative)
    
    HTML(narrative)
  })
  
  # Dynamic plot output UI
  output$plot_output_ui <- renderUI({
    req(input$plot_type)
    
    if (input$plot_type == "sankey") {
      sankeyNetworkOutput("sankey_plot", height = "600px")
    } else {
      plotlyOutput("main_plot", height = "600px")
    }
  })
  
  # Get available columns
  available_columns <- reactive({
    req(current_table())
    setdiff(names(current_table()), "breakdown")
  })
  
  # Dynamic column selection for plots
  output$column_select <- renderUI({
    cols <- available_columns()
    if (length(cols) == 0) return(NULL)
    
    selected_cols <- if (length(cols) >= 5) cols[1:5] else cols
    
    checkboxGroupInput("selected_columns", "Select Columns to Plot:",
                       choices = cols,
                       selected = selected_cols)
  })
  
  # Breakdown filter
  output$breakdown_filter <- renderUI({
    req(current_table())
    if (!"breakdown" %in% names(current_table())) return(NULL)
    
    breakdowns <- current_table()$breakdown
    if (length(breakdowns) == 0) return(NULL)
    
    selected_bd <- if (length(breakdowns) >= 6) breakdowns[1:6] else breakdowns
    
    selectInput("selected_breakdowns", "Filter Breakdowns:",
                choices = breakdowns,
                multiple = TRUE,
                selected = selected_bd)
  })
  
  # Plot warning message
  output$plot_warning <- renderUI({
    if (is.null(current_table())) {
      return(HTML("<div style='color:red;'>No data available for selected table</div>"))
    }
    if (length(available_columns()) == 0) {
      return(HTML("<div style='color:red;'>No columns available for plotting</div>"))
    }
    NULL
  })
  
  # Main plot rendering
  output$main_plot <- renderPlotly({
    req(current_table(), input$plot_type)
    if (input$plot_type == "sankey") return(NULL)
    
    valid_columns <- intersect(input$selected_columns, names(current_table()))
    if (length(valid_columns) == 0) return(NULL)
    
    plot_data <- tryCatch({
      current_table() %>%
        filter(breakdown %in% input$selected_breakdowns) %>%
        select(breakdown, all_of(valid_columns)) %>%
        pivot_longer(-breakdown, names_to = "category", values_to = "value")
    }, error = function(e) {
      NULL
    })
    
    if (is.null(plot_data)) return(NULL)
    
    plot_data <- plot_data %>%
      mutate(
        category = gsub("_", " ", category) %>% tools::toTitleCase(),
        breakdown = str_wrap(breakdown, width = 30)
      )
    
    plot_output <- tryCatch({
      switch(input$plot_type,
             "bar" = {
               p <- ggplot(plot_data,
                           aes(x = breakdown, y = value, fill = category,
                               text = paste("Category:", category, "<br>Value:", value))) +
                 geom_col(position = "dodge") +
                 labs(title = "Comparison by Breakdown",
                      x = "", y = "Value") +
                 theme_minimal() +
                 theme(axis.text.x = element_text(angle = 45, hjust = 1))
               ggplotly(p, tooltip = "text")
             },
             "stacked" = {
               p <- ggplot(plot_data,
                           aes(x = category, y = value, fill = breakdown,
                               text = paste("Breakdown:", breakdown, "<br>Value:", value))) +
                 geom_col(position = "stack") +
                 labs(title = "Stacked Comparison",
                      x = "", y = "Value") +
                 coord_flip() +
                 theme_minimal()
               ggplotly(p, tooltip = "text")
             },
             "heatmap" = {
               p <- ggplot(plot_data,
                           aes(x = category, y = breakdown, fill = value,
                               text = paste("Category:", category, "<br>Breakdown:", breakdown,
                                            "<br>Value:", value))) +
                 geom_tile() +
                 scale_fill_gradient(low = "white", high = "maroon") +
                 labs(title = "Heatmap of Values",
                      x = "", y = "") +
                 theme_minimal()
               ggplotly(p, tooltip = "text")
             },
             "pie" = {
               if (length(input$selected_breakdowns) > 0) {
                 pie_data <- plot_data %>%
                   filter(breakdown == input$selected_breakdowns[1])
                 
                 plot_ly(pie_data,
                         labels = ~category, values = ~value, type = 'pie',
                         textinfo = 'label+percent',
                         hoverinfo = 'text',
                         text = ~paste(category, ": ", value),
                         showlegend = FALSE) %>%
                   layout(title = paste("Distribution for:", input$selected_breakdowns[1]))
               } else {
                 NULL
               }
             },
             "box" = {
               p <- ggplot(plot_data, aes(x = category, y = value, fill = category)) +
                 geom_boxplot() +
                 labs(title = "Box Plot - Value Distribution",
                      x = "", y = "Value") +
                 theme_minimal() +
                 theme(legend.position = "none",
                       axis.text.x = element_text(angle = 45, hjust = 1))
               ggplotly(p)
             },
             "violin" = {
               p <- ggplot(plot_data, aes(x = category, y = value, fill = category)) +
                 geom_violin(trim = FALSE) +
                 labs(title = "Violin Plot - Density Distribution",
                      x = "", y = "Value") +
                 theme_minimal() +
                 theme(legend.position = "none",
                       axis.text.x = element_text(angle = 45, hjust = 1))
               ggplotly(p)
             },
             "density" = {
               p <- ggplot(plot_data, aes(x = value, fill = category)) +
                 geom_density(alpha = 0.5) +
                 labs(title = "Density Plot - Distribution Comparison",
                      x = "Value", y = "Density") +
                 theme_minimal() +
                 theme(legend.position = "bottom")
               ggplotly(p)
             },
             "bubble" = {
               bubble_data <- plot_data %>%
                 group_by(category) %>%
                 summarise(avg_value = mean(value, na.rm = TRUE),
                           count = n(),
                           diversity = sd(value, na.rm = TRUE))
               
               p <- ggplot(bubble_data,
                           aes(x = avg_value, y = diversity,
                               size = count, color = category,
                               text = paste("Category:", category, "<br>Average Value:", avg_value,
                                            "<br>Diversity:", diversity, "<br>Count:", count))) +
                 geom_point(alpha = 0.7) +
                 scale_size(range = c(5, 15)) +
                 geom_text(aes(label = category), size = 3, vjust = -0.5) +
                 labs(title = "Bubble Chart - Multidimensional Analysis",
                      x = "Average Value", y = "Diversity (SD)") +
                 theme_minimal() +
                 theme(legend.position = "none")
               ggplotly(p, tooltip = "text")
             },
             "radar" = {
               radar_data <- plot_data %>%
                 group_by(breakdown, category) %>%
                 summarise(value = mean(value, na.rm = TRUE), .groups = "drop") %>%
                 pivot_wider(names_from = category, values_from = value) %>%
                 select(-breakdown)
               
               if (ncol(radar_data) > 0 && nrow(radar_data) > 0) {
                 radar_data <- radar_data[1:min(3, nrow(radar_data)), ] %>%
                   mutate(across(everything(), ~ scales::rescale(.x, to = c(0, 1)))) %>%
                   mutate(group = input$selected_breakdowns[1:min(3, length(input$selected_breakdowns))]) %>%
                   relocate(group)
                 
                 p <- ggradar(radar_data,
                              axis.label.size = 3,
                              group.line.width = 1,
                              group.point.size = 3) +
                   labs(title = "Radar Chart - Multivariate Comparison")
                 
                 ggplotly(p)
               } else {
                 NULL
               }
             }
      )
    }, error = function(e) {
      showNotification(paste("Error generating plot:", e$message), type = "error")
      NULL
    })
    
    plot_output
  })
  
  # Sankey diagram rendering
  output$sankey_plot <- renderSankeyNetwork({
    req(current_table(), input$plot_type == "sankey", input$selected_columns, 
        "breakdown" %in% names(current_table()))
    
    sankey_links <- current_table() %>%
      select(breakdown, all_of(input$selected_columns)) %>%
      pivot_longer(-breakdown, names_to = "category", values_to = "value") %>%
      group_by(breakdown, category) %>%
      summarise(value = mean(value, na.rm = TRUE), .groups = "drop") %>%
      filter(value > 0) %>%
      rename(source = breakdown) %>%
      mutate(source = paste("Breakdown:", source),
             target = paste("Category:", category),
             value = round(value))
    
    sankey_nodes <- data.frame(
      name = unique(c(sankey_links$source, sankey_links$target))
    )
    
    sankey_links <- sankey_links %>%
      mutate(source = match(source, sankey_nodes$name) - 1,
             target = match(target, sankey_nodes$name) - 1)
    
    sankeyNetwork(Links = as.data.frame(sankey_links), 
                  Nodes = sankey_nodes,
                  Source = "source", 
                  Target = "target", 
                  Value = "value",
                  NodeID = "name", 
                  fontSize = 12, 
                  nodeWidth = 30)
  })
  
  # Data table display
  output$data_table <- renderDT({
    req(current_table())
    datatable(current_table(),
              options = list(scrollX = TRUE, pageLength = 10))
  })
  
  # Download handler
  output$download_data <- downloadHandler(
    filename = function() {
      paste(input$dataset, "_", input$selected_table, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(current_table(), file, row.names = FALSE)
    }
  )
  
  # Group Comparison Plot
  output$group_comparison_plot <- renderPlotly({
    req(input$comparison_table)
    
    tables <- list(
      KS4_Learners = cleaned_data$ks4_learners[[input$comparison_table]],
      Sixteen_Nineteen_Learners = cleaned_data$sixteen_nineteen_learners[[input$comparison_table]],
      KS4_Parents = cleaned_data$ks4_parents[[input$comparison_table]],
      Sixteen_Nineteen_Parents = cleaned_data$sixteen_nineteen_parents[[input$comparison_table]]
    ) %>%
      compact()
    
    combined_data <- imap_dfr(tables, ~ {
      .x %>%
        mutate(group = .y) %>%
        pivot_longer(-c(breakdown, group), names_to = "category", values_to = "value")
    })
    
    p <- combined_data %>%
      group_by(group, category) %>%
      summarise(mean_value = mean(value, na.rm = TRUE), .groups = "drop") %>%
      ggplot(aes(x = category, y = mean_value, fill = group)) +
      geom_col(position = position_dodge(preserve = "single")) +
      labs(title = paste("Comparison of", input$comparison_table),
           x = "", y = "Mean Value") +
      scale_fill_viridis_d() +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
  
  # Handle review submission
  observeEvent(input$submit_review, {
    req(input$rating_value > 0, input$review_text != "")
    
    # Validate review text length
    if (nchar(input$review_text) < 10) {
      showNotification("Please provide more detailed feedback (at least 10 characters).", 
                       type = "warning")
      return()
    }
    
    new_review <- data.frame(
      name = ifelse(input$reviewer_name == "", "Anonymous", input$reviewer_name),
      rating = as.numeric(input$rating_value),
      text = input$review_text,
      date = as.character(Sys.Date()),
      stringsAsFactors = FALSE
    )
    
    # Load existing reviews
    existing_reviews <- reviews()
    
    # Append new review
    updated_reviews <- rbind(existing_reviews, new_review)
    
    # Save updated reviews to CSV
    write.csv(updated_reviews, "reviews.csv", row.names = FALSE)
    
    # Update reactive value
    reviews(updated_reviews)
    
    # Reset form
    updateTextInput(session, "reviewer_name", value = "")
    updateTextInput(session, "review_text", value = "")
    updateTextInput(session, "rating_value", value = "0")
    runjs("$('.star').removeClass('active');")
  })
  
  # Display reviews
  output$reviewsList <- renderUI({
    revs <- reviews()
    if (nrow(revs) == 0) {
      return(p("No reviews yet. Be the first to share your feedback!"))
    }
    
    # Sort by date (newest first)
    revs <- revs[order(as.Date(revs$date), decreasing = TRUE), ]
    
    tagList(
      lapply(1:nrow(revs), function(i) {
        div(class = "review-item",
            div(
              span(class = "reviewer-name", revs$name[i]),
              span(class = "review-date", revs$date[i]),
              div(class = "rating-stars", 
                  HTML(paste0(rep("★", revs$rating[i]), collapse = ""))
              ),
              div(class = "review-text", revs$text[i])
            )
        )
      })
    )
  })
  
  # Thank you message
  output$thank_you_message <- renderUI({
    if (input$submit_review > 0) {
      div(class = "thank-you", 
          icon("check-circle"), 
          "Thank you for your feedback! Your input helps us improve this tool.")
    }
  })
  
  # Show help modal when help button is clicked
  observeEvent(input$helpBtn, {
    showModal(modalDialog(
      title = "App Instructions",
      size = "l",  # Large modal
      easyClose = TRUE,
      footer = modalButton("Close"),
      
      # Tabset for organized instructions
      tabsetPanel(
        tabPanel("Getting Started",
                 h4("Basic Usage"),
                 tags$ol(
                   tags$li("Select a dataset from the dropdown menu"),
                   tags$li("Choose a specific table within that dataset"),
                   tags$li("Select your preferred visualization type"),
                   tags$li("Pick the column you want to analyze")
                 ),
                 
                 h4("Quick Tips"),
                 tags$ul(
                   tags$li(icon("lightbulb"), " Hover over charts for detailed values"),
                   tags$li(icon("lightbulb"), " Use the download button to export data"),
                   tags$li(icon("lightbulb"), " Try different plot types for different insights")
                 )
        ),
        
        tabPanel("Visualization Guide",
                 h4("Choosing the Right Chart"),
                 tags$ul(
                   tags$li(strong("Bar Plot:"), " Compare categories"),
                   tags$li(strong("Heatmap:"), " Show relationships between two variables"),
                   tags$li(strong("Pie Chart:"), " Show proportions (use sparingly)"),
                   tags$li(strong("Box Plot:"), " View distributions and outliers")
                 ),
                 
                 h4("Interacting with Charts"),
                 tags$ul(tags$li("Click and drag to zoom"),
                         tags$li("Double-click to reset zoom"),
                         tags$li("Hover for tooltips with values")
                 )
        ),
        
        tabPanel("Feedback",
                 h4("How to Provide Feedback"),
                 p("We value your input! Here's how to share your thoughts:"),
                 tags$ol(
                   tags$li("Go to the 'Feedback' tab"),
                   tags$li("Rate your experience with the star rating system"),
                   tags$li("Add any comments in the text box"),
                   tags$li("Click 'Submit Review'")
                 ),
                 
                 h4("Contact Support"),
                 p("For technical issues, please contact:"),
                 tags$ul(
                   tags$li(icon("envelope"), " Email: samndiege2015@gmail.com"),
                   tags$li(icon("phone"), " Phone: (254) 712-122091")
                 )
        )
      )
    ))
  })
}

# Run the application
shinyApp(ui = ui, server = server)
