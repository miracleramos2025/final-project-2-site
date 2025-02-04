# Load necessary libraries
library(tidyverse)

# Read in key datasets
games_details <- read_csv(file.path("data/games_details.csv"))
games <- read_csv(file.path("data/games.csv"))
ranking <- read_csv(file.path("data/ranking.csv"))
teams <- read_csv(file.path("data/teams.csv"))
nba_champions <- read_csv("data/nba_champions.csv")

# Check structure
glimpse(games_details)
glimpse(games)
glimpse(ranking)
glimpse(teams)
glimpse(nba_champions)

# Function to summarize dataset
data_check <- function(df, df_name) {
  tibble(
    Dataset = df_name,
    Observations = nrow(df),
    Variables = ncol(df),
    Missing_Percentage = round(mean(is.na(df)) * 100, 2)
  )
}
    
var_type <- function(df, df_name) {
  tibble(
    Dataset = df_name,
    Categorical_Variables = sum(sapply(df, is.character)),
    Numerical_Variables = sum(sapply(df, is.numeric)),
    Date_Variables = sum(sapply(df, lubridate::is.Date))
  )
}

# Apply function to all datasets
data_summary <- bind_rows(
  data_check(games, "Games"),
  data_check(games_details, "Games Details"),
  data_check(ranking, "Ranking"),
  data_check(teams, "Teams")
)

# rename columns in data_summary_1
data_summary <- data_summary |>
  rename(
    "Missingness %" = Missing_Percentage
  )


var_type_summary <- bind_rows(
  var_type(games, "Games"),
  var_type(games_details, "Games Details"),
  var_type(ranking, "Ranking"),
  var_type(teams, "Teams")
)

# rename columns in var_type_summary
var_type_summary <- var_type_summary |>
  rename(
    "Categorical" = Categorical_Variables,
    "Numerical" = Numerical_Variables,
    "Date" = Date_Variables
  )

# Print the table
print(data_summary)
print(var_type_summary)

# View in a nicely formatted table if using RMarkdown or Quarto
knitr::kable(data_summary, caption = "Data Quality Check Summary")
knitr::kable(var_type_summary, caption = "Variable Types Summary")

save(data_summary, file = "data/data_summary.RData") 
save(var_type_summary, file = "data/var_type_summary.RData") 

# Load NBA champions and playoff stats datasets
nba_champions <- read_csv("data/nba_champions.csv", skip = 1)  # Skip potential extra headers
nba_playoff_stats <- read_csv("data/nba_playoff_stats.csv", skip = 1)

# Rename columns for nba_champions
colnames(nba_champions) <- c("Year", "Lg", "Champion", "Runner-Up", "Finals MVP", 
                             "NA1", "Points", "Rebounds", "Assists", "Win Shares")

# Rename columns for nba_playoff_stats
colnames(nba_playoff_stats) <- c("Yr", "Lg", "Series", "NA1", "NA2", 
                                 "Team", "W", "NA3", "Team2", "W2", 
                                 "NA4", "Favorite", "Underdog")

# Drop the unnecessary NA columns
nba_champions <- nba_champions %>%
  select(-NA1)  # Remove only NA1 column (since there's only one)

nba_playoff_stats <- nba_playoff_stats %>%
  select(-NA1, -NA2, -NA3, -NA4)  # Remove all unnecessary NA columns

# save the cleaned nba_champions dataset
write_csv(nba_champions, "data/nba_champions_cleaned.csv")

# save the cleaned nba_playoff_stats dataset
write_csv(nba_playoff_stats, "data/nba_playoff_stats_cleaned.csv")





