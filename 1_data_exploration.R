# load libraries
library(tidyverse)

# read data
teams <- read_csv("data/teams.csv")
games <- read_csv("data/games.csv")
games_details <- read_csv("data/games_details.csv")  # Player-level stats
nba_champions <- read_csv("data/nba_champions.csv")  # Historical NBA champions
nba_playoff_stats <- read_csv("data/nba_playoff_stats.csv")  # Playoff performance stats
ranking <- read_csv("data/ranking.csv")  # Team rankings over different seasons

# check structure of datasets
glimpse(teams)
glimpse(games)
glimpse(games_details)
glimpse(nba_champions)
glimpse(nba_playoff_stats)
glimpse(ranking)

# summarize dataset
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

# apply function to all datasets
data_summary <- bind_rows(
  data_check(teams, "Teams"),
  data_check(games, "Games"),
  data_check(games_details, "Games Details"),
  data_check(ranking, "Ranking"),
  data_check(nba_playoff_stats, "NBA Playoff Stats"),
  data_check(nba_champions, "NBA Champions")
)

# rename columns in data_summary_1
data_summary <- data_summary |>
  rename(
    "Missingness %" = Missing_Percentage
  )


var_type_summary <- bind_rows(
  var_type(teams, "Teams"),
  var_type(games, "Games"),
  var_type(games_details, "Games Details"),
  var_type(ranking, "Ranking"),
  var_type(nba_playoff_stats, "NBA Playoff Stats"),
  var_type(nba_champions, "NBA Champions")
)

var_type_summary <- var_type_summary |> rename(
  "Categorical" = Categorical_Variables,
  "Numerical" = Numerical_Variables,
  "Date" = Date_Variables
)

# view table
knitr::kable(data_summary, caption = "Data Quality Check Summary")
knitr::kable(var_type_summary, caption = "Variable Types Summary")

# save
save(data_summary, file = "data/data_summary.RData") 
save(var_type_summary, file = "data/var_type_summary.RData") 

# load NBA champions and playoff stats datasets
nba_champions <- read_csv("data/nba_champions.csv", skip = 1)  # skip potential extra headers
nba_playoff_stats <- read_csv("data/nba_playoff_stats.csv", skip = 1)

# rename columns for nba_champions
colnames(nba_champions) <- c("Year", "Lg", "Champion", "Runner-Up", "Finals MVP", 
                             "NA1", "Points", "Rebounds", "Assists", "Win Shares")

# rename columns for nba_playoff_stats
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

# team colors for only active NBA teams
nba_team_colors <- tibble::tibble(
  full_name = c("Atlanta Hawks", "Boston Celtics", "Brooklyn Nets", "Charlotte Hornets", 
                "Chicago Bulls", "Cleveland Cavaliers", "Dallas Mavericks", "Denver Nuggets", 
                "Detroit Pistons", "Golden State Warriors", "Houston Rockets", "Indiana Pacers", 
                "Los Angeles Clippers", "Los Angeles Lakers", "Memphis Grizzlies", "Miami Heat", 
                "Milwaukee Bucks", "Minnesota Timberwolves", "New Orleans Pelicans", "New York Knicks", 
                "Oklahoma City Thunder", "Orlando Magic", "Philadelphia 76ers", "Phoenix Suns", 
                "Portland Trail Blazers", "Sacramento Kings", "San Antonio Spurs", "Toronto Raptors", 
                "Utah Jazz", "Washington Wizards"),
  
  color = c("#E03A3E", "#007A33", "#000000", "#1D1160", "#CE1141", "#860038", "#00538C", "#0E2240", 
            "#C8102E", "#FFC72C", "#CE1141", "#002D62", "#C8102E", "#552583", "#5D76A9", "#98002E", 
            "#00471B", "#0C2340", "#0C2340", "#F58426", "#007AC1", "#0077C0", "#006BB6", "#1D1160", 
            "#E03A3E", "#5A2D81", "#C4CED4", "#CE1141", "#002B5C", "#002B5C")
)

# save tibble in RData file
save(nba_team_colors, file = "nba_team_colors.RData")

# column names for consistency
teams <- teams %>%
  rename(
    Team_ID = TEAM_ID,
    Team_Abbreviation = ABBREVIATION,
    Team_Nickname = NICKNAME,
    Team_City = CITY
  ) %>%
  mutate(Team_Name = paste(Team_City, Team_Nickname)) # Create full team name

# save 
write_csv(teams, "data/teams_cleaned.csv")




