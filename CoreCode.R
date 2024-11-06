#-----------------------------------------------------
#Loading our function file
source(here("functions","cleaning.R"))

#Load the raw data
penguins_raw <- read.csv(here("data", "penguins_raw.csv"))

#-----------------------------------------------------
#Using our functions from the functions script 
cleaning_penguin_columns <- function(raw_data){
  print("Cleaned names, removed comments, removed empty and cols, removed delta")
  raw_data %>% 
    clean_names() %>% 
    shorten_species() %>% 
    remove_empty(c("rows", "cols")) %>% 
    select(-comments) %>% 
    select(-starts_with("delta"))
}

#-----------------------------------------------------
colnames(penguins_raw)
penguins_clean <- cleaning_penguin_columns(penguins_raw)
colnames(penguins_clean)
