## ---------------------------
##
## Script name: plotting.r
##
## Purpose of script: 
##      # A file of functions for plotting
##
## Author: Jiya Soomal
##
## Date Created: 2024-11-06 
##
##
## ---------------------------
##
## Notes:
##When making a function file make sure to include information on what the file is for, when it was made and who made it 
##
## ---------------------------

#Data,x-column etc means use data, specific labels and colours supplied at the time of using the function
plot_boxplot <- function(data,
                         x_column,
                         y_column,
                         x_label,
                         y_label,
                         colour_mapping) {
  #Drop the na
  data <- data  %>% 
    drop_na({{y_column}})
  
  #Make the plot
  flipper_boxplot <- ggplot(
    data = data,
    aes(x = {{x_column}}, 
        y = {{y_column}},
    color = {{x_column}})) +
    geom_boxplot(aes(
                 width = 0.3,
                 show.legend = FALSE)) +
    geom_jitter(size = 1,
                alpha = 0.3,
                show.legend = FALSE,
                position = position_jitter(
                  width = 0.2,
                  seed = 0)) +
    scale_colour_manual(values = species_colours) +
    labs(x = x_label,
         y = y_label) +
    theme_bw()}

species_colours <- c("Adelie" = "darkorange",
                     "Chinstrap" = "purple",
                     "Gentoo" = "cyan4")

plot_boxplot(penguins_clean, "species", "flipper_length_mm", "Penguin Species", "Flipper Length (mm)")

