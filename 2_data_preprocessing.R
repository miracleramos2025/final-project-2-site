# load libraries
library(tidyverse)
library(stringr)

# read in datasets
teams <- read_csv("data/teams_cleaned.csv")  
games <- read_csv("data/games.csv")
games_details <- read_csv("data/games_details.csv")
nba_champions <- read_csv("data/nba_champions_cleaned.csv")
nba_playoff_stats <- read_csv("data/nba_playoff_stats_cleaned.csv")
ranking <- read_csv("data/ranking.csv")

# standardizing column names
colnames(nba_playoff_stats) <- c("Year", "League", "Series", "Team", "Wins", "Opponent", "Opponent_Wins", "Favorite", "Underdog")
colnames(nba_champions) <- c("Year", "League", "Champion", "Runner_Up", "Finals_MVP", "Points", "Rebounds", "Assists", "Win_Shares")

# convert column names to lowercase for consistency
colnames(ranking) <- tolower(colnames(ranking))  
colnames(games) <- tolower(colnames(games))
colnames(games_details) <- tolower(colnames(games_details))

# rename for consistency
games <- games %>% rename(Year = season)
ranking <- ranking %>% rename(Year = season_id, Team = team)

# rmove extra ranking numbers from Team and Opponent 
nba_playoff_stats <- nba_playoff_stats %>%
  mutate(
    Team = str_trim(str_squish(str_remove(Team, "\\s*\\(.*\\)"))),
    Opponent = str_trim(str_squish(str_remove(Opponent, "\\s*\\(.*\\)")))
  )

# fix Historical Team Names *AFTER* Parentheses Are Removed
team_name_mapping <- c(
  "New Jersey Nets" = "Brooklyn Nets",
  "Seattle SuperSonics" = "Oklahoma City Thunder",
  "New Orleans Hornets" = "New Orleans Pelicans",
  "San Francisco Warriors" = "Golden State Warriors",
  "Washington Bullets" = "Washington Wizards",
  "Kansas City Kings" = "Sacramento Kings",
  "Buffalo Braves" = "Los Angeles Clippers",
  "New York Nets" = "Brooklyn Nets",
  "Minneapolis Lakers" = "Los Angeles Lakers",
  "Fort Wayne Pistons" = "Detroit Pistons",
  "Rochester Royals" = "Sacramento Kings",
  "Cincinnati Royals" = "Sacramento Kings",
  "Philadelphia Warriors" = "Golden State Warriors",
  "Syracuse Nationals" = "Philadelphia 76ers",
  "St. Louis Hawks" = "Atlanta Hawks"
)

nba_playoff_stats <- nba_playoff_stats %>%
  mutate(
    Team = ifelse(Team %in% names(team_name_mapping), team_name_mapping[Team], Team),
    Opponent = ifelse(Opponent %in% names(team_name_mapping), team_name_mapping[Opponent], Opponent)
  )

# clean team names 
nba_playoff_stats <- nba_playoff_stats %>%
  mutate(
    Team = str_trim(str_squish(Team)),
    Opponent = str_trim(str_squish(Opponent))
  )

teams <- teams %>%
  mutate(Team_Name = str_trim(str_squish(Team_Name)))

# fnal check - unique Team Names
print("Final Unique Team Names in nba_playoff_stats:")
print(unique(nba_playoff_stats$Team))

print("Final Unique Opponent Names in nba_playoff_stats:")
print(unique(nba_playoff_stats$Opponent))

print("Final Unique Team Names in teams:")
print(unique(teams$Team_Name))

# save cleaned datasets
write_csv(nba_playoff_stats, "data/nba_playoff_stats_cleaned.csv")
write_csv(nba_champions, "data/nba_champions_cleaned.csv")
write_csv(ranking, "data/ranking_cleaned.csv")
write_csv(games, "data/games_cleaned.csv")
write_csv(games_details, "data/games_details_cleaned.csv")
