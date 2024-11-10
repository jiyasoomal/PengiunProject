#####Week 1 - Programming in R code
#Loading libaries
library(tidyverse)
library(palmerpenguins)
library(janitor)
library(here)

#Install packages the reproducible way - dont run this again - this should be in your console but its here for next time
renv::init()
#put installed libaries in here 
renv::snapshot()
#uses renv folder to install all the right libaries - allows you to share folder with others 
renv::restore()
#Tells you what is in your renv folder 
renv::diagnostics()

#loading function file (we made our function file)
source(here("functions","cleaning.R"))

#tells you where your data is - instead of using setwd()
here::here()

#shows first 6 rows of data frame
head(penguins_raw)

#checking column names but this has mixed caputals, spaces and extra notes - not useful for data analysis 
colnames(penguins_raw)
#You could edit the original excel spreadsheet but this makes the data non-reproducible as there is no record of what you changed 

#Keep a raw copy of your data - read only set of data 
#telling the computer to save in the penguins folder in the data folder. AND to name the new file penguins_raw.csv
write.csv(penguins_raw,here("data","penguins_raw.csv"))

colnames(penguins_raw)
#Removes the comments column
penguins_raw <- select(penguins_raw, -Comments)
colnames(penguins_raw)

penguins_raw <- select (penguins_raw, -starts_with("Delta"))
colnames(penguins_raw)

#Getting back the raw data as the code above is bad practice - overwriting 
penguins_raw <- read.csv(here("data", "penguins_raw.csv"))

#Making a new variable + removing comments column
penguins_clean <- select(penguins_raw, -Comments)

#Removing delta columns 
penguins_clean <- select(penguins_clean, -starts_with("Delta"))
colnames(penguins_clean)
#This is still overwriting - not good code 

#Pipes used - ctrl, shift, M
# %>% = and then 
penguins_clean <- penguins_raw %>% 
  select(-Comments) %>% 
  select(-starts_eith("Delta")) %>% 
  #Removes capital letters, gaps, full stops, consistency - makes columns computer readable and human readable (no spaces, slashes, brackets etc)
  clean_names()

colnames(penguins_clean)

#Creating a function in R 
#Dont copy and paste code - instead make a function!

#Making a function for the pipe we did earlier
#remove_empty removes empty columns and rows
#there are no capitals for "delta" and for "comments" bc we removed those previously w clean_names()
#print function just explains what happened - makes your cleaning function more transparent when used
cleaning_penguins_columns <- function(raw_data){
  print("Removed empty columns and rows, cleaned column names, removed comments and delta columns") %>% 
  raw_data %>% 
  clean_names() %>% 
  remove_empty(c("rows","cols")) %>% 
  select(-starts_with("delta")) %>% 
  select(-comments)
}

penguins_raw <- read.csv(here("data", "penguins_raw.csv"))
colnames(penguins_raw)
penguins_clean <- cleaning_penguins_columns(penguins_raw)
colnames(penguins_clean)

#Saving the clean data 
write.csv(penguins_clean, here("data", "penguins_clean.csv"))

#Moving the cleaning function to a seperate script - keeping safe copy of our code 

############# Week 4 - Graphics code
#Exploratory figures = ways to check the your raw data before modelling 
#Eg box plot, scatter plot (with no line - no modelling), histograms, violin, box and whisker

#Error message: removed 2 rows containing non-finite oustdie scale range
#This means there is NA in the data set - so these have been removed
#We need to clean our data

#Removing NAs
#We should only remove NA from the columns we are using - because removing NA in other columns will remove most of your data
#Subset the data with select and them remove NAs with drop_na function
#Use piping to prevent overwriting your code - this could be done in 2 steps but we want to do this in one step
penguins_flippers <- penguins_clean %>% 
  select(species,flipper_length_mm) %>%                         
  drop_na()
head(penguins_flippers)
#Now edit the boxplot function above to run data from penguins_flippers

#Box plot 
#Box plot = geom_boxplot 
#Raw data on top = geom_jitter

#Reproducibility of random dots of raw data = seed 
#geom_jitter gives each value a random x value = causes it to scatter
#We want the randomisation to be the same every-time - so we give it a random seed (seed = 0 labels this randomness as the name 0 - could name it anything)

#Label axis = labs()
#Can label axis with spaces because it in a string = human language 

#Change transparency = alpha

#Change width = width

#theme means you dont need to edit the background plot lines - does it for you

#Need colour blind friendly colours --> Adelie = darkorange, chinstrap = purple, gentoo = cyan4)
#Put colours into a variable so we can reuse the same species-colour combos with other plots
#Add into plot with scale_colour_manual
species_colours <- c("Adelie" = "darkorange",
                     "Chinstrap" = "purple",
                     "Gentoo" = "cyan4")

flipper_boxplot <- ggplot(
  data = penguins_flippers,
  aes(x = species, 
      y = flipper_length_mm)) +
  geom_boxplot(aes(color = species),
               width = 0.3,
               show.legend = FALSE) +
  geom_jitter(aes(color = species),
              alpha = 0.3,
              show.legend = FALSE,
              position = position_jitter(
                width = 0.2,
                seed = 0)) +
  scale_colour_manual(values = species_colours) +
  labs(x = "Penguin species",
       y = "Flipper Length (mm)") +
         theme_bw()
flipper_boxplot

#We can make this into a function in function folder - means you can reuse for other plot

