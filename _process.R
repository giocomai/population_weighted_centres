library("dplyr")
combo_df <- tibble::tribble(~pop_grid_year, ~lau_year, ~power_centre, ~adjusted,
                            2018, 2018, 2, TRUE,
                            2018, 2018, 2, FALSE,
                            2018, 2020, 2, TRUE,
                            2018, 2020, 2, FALSE,
                            2011, 2019, 2, TRUE,
                            2018, 2019, 2, FALSE,
                            2018, 2020, 5, TRUE,
                            2018, 2018, 2, TRUE,
                            2011, 2018, 2, FALSE,
                            2011, 2018, 2, TRUE)

purrr::walk(.x = 1:nrow(combo_df),
            .f = function(i) {
              current_combo_df <- combo_df %>% dplyr::slice(i)
              
              adjusted_text <- ifelse(current_combo_df$adjusted,
                                      "adjusted_intersection",
                                      "full_intersection")
              
              current_html <- fs::path("html", 
                                       paste0(paste("pop",
                                                    current_combo_df$pop_grid_year,
                                                    "lau",
                                                    current_combo_df$lau_year,
                                                    "p",
                                                    current_combo_df$power_centre,
                                                    adjusted_text,
                                                    sep = "_"),
                                              ".html"))
              
              if (fs::file_exists(current_html)==FALSE) {
                rmarkdown::render(input = "_process.Rmd",
                                  params = list(
                                    pop_grid_year = current_combo_df$pop_grid_year,
                                    lau_year = current_combo_df$lau_year,
                                    power_centre = current_combo_df$power_centre,
                                    adjusted = current_combo_df$adjusted
                                  ),
                                  output_file = paste0(paste("pop",
                                                             current_combo_df$pop_grid_year,
                                                             "lau",
                                                             current_combo_df$lau_year,
                                                             "p",
                                                             current_combo_df$power_centre,
                                                             adjusted_text,
                                                             sep = "_"),
                                                       ".html"),
                                  output_dir = "html")
              }
            })
