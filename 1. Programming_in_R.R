#Skills: 
  #Creating a data pipeline
  #Writing modular code
  #Keeping data safe
  #Keeping code sane
  #Code that runs on other people's computers

#How to create a new project:
#Press +R in a box at top left of the page
#Click New Directory, Then new Project, tick both of the boxes for git repository and use renv
#You can add folders to your project using the + folder sign in right bottom panel

#Install packages the reproducible way - dont run this again - this should be in your console but its here for next time
renv::init()
#put installed libaries in here 
renv::snapshot()
#uses renv folder to install all the right libaries - allows you to share folder with others 
renv::restore()
#Tells you what is in your renv folder 
renv::diagnostics()

#This tells you where to find your code
here::here()

#Shows first 6 rows of data frame
head(penguins_raw)

#Checking column names. This has mixed caputals, spaces and extra notes - not useful for data analysis 
colnames(penguins_raw)
#DO NOT edit the original excel spreadsheet. this makes the data non-reproducible as there is no record of what you changed 

#Keep a raw copy of your data - read only set of data 
#telling the computer to save in the penguins folder in the data folder. AND to name the new file penguins_raw.csv
write.csv(penguins_raw,here("data","penguins_raw.csv"))

#BAD PRACTICE AS HAS OVER WRITTEN THE CODE = BUGS
#Removes the comments column using select and hyphen (-)
penguins_raw <- select(penguins_raw, -Comments)
#You can see the comments column has been removed
colnames(penguins_raw)

#Remove columns beginning with Delta using the function starts_with()
penguins_raw <- select (penguins_raw, -starts_with("Delta"))
colnames(penguins_raw)

#TO PREVENT OVER WRITING WE USE PIPES
#Pipes used - ctrl, shift, M
# %>% = and then 
#Pipes is in tidyverse package
penguins_clean <- penguins_raw %>% 
  select(-Comments) %>% 
  select(-starts_with("Delta")) %>% 
  #Removes capital letters, gaps, full stops, consistency - makes columns computer readable and human readable (no spaces, slashes, brackets etc)
  #This function is in the janitor package
  clean_names()

colnames(penguins_clean)

#WE CAN MAKE FUNCTION FILES - TO HOLD FUNCTIONS WE MAKE SEPARATE FROM OUR ACTUAL CODE
#We making a function file you want to include the title, date and author to keep track of what you are doing over time
#Loading our function file
source(here("functions","cleaning.R"))

#Creating 1 giant function using our functions from the functions script and functions from the pacakges themselves in a pipe
cleaning_penguin_columns <- function(raw_data){
  print("Cleaned names, removed comments, removed empty and cols, removed delta")
  raw_data %>% 
    clean_names() %>% 
    shorten_species() %>% 
    remove_empty(c("rows", "cols")) %>% 
    select(-comments) %>% 
    select(-starts_with("delta"))
}

#USEING THE FUNCTION WE MADE ABOVE TO CLEAN OUR COLUMNS IN 1 GO
colnames(penguins_raw)
penguins_clean <- cleaning_penguin_columns(penguins_raw)
colnames(penguins_clean)

#Save the clean data into our project on OneDrive
write.csv(penguins_clean, here("data", "penguins_clean.csv"))

#SUBSET THE DATA (using select function from tidyverse) and REMOVE MISSING VALUES (using function we made in the functions file)
subset_penguins <- penguins_clean %>% 
select(body_mass_g, species) %>% 
  remove_NA()

#Subset the data but this time filtering by adelie species of penguins and only looking at body mass of Adelie spp
subset_penguins_adelie <- penguins_clean %>% 
  filter(species == "Adelie") %>% 
  select(body_mass_g) %>% 
  remove_NA()
