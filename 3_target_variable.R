# load libraries 
library(tidyverse)
library(knitr)
library(dplyr)
library(tibble)

# read cleaned datasets
nba_champions <- read_csv("data/nba_champions_cleaned.csv") %>%
  mutate(Year = as.numeric(Year))  # Ensure Year is numeric

ranking <- read_csv("data/ranking_cleaned.csv")
nba_playoff_stats <- read_csv("data/nba_playoff_stats_cleaned.csv")
games_details <- read_csv("data/games_details_cleaned.csv")
games <- read_csv("data/games_cleaned.csv") %>%
  mutate(Year = as.numeric(Year))  # Ensure Year is numeric

# load NBA team colors 
load("nba_team_colors.RData")

# filter only champions that are still active NBA teams
active_champions <- nba_champions %>%
  filter(Champion %in% nba_team_colors$full_name) %>%
  count(Champion, sort = TRUE) %>%
  rename(Championships = n)

# merge with team colors
active_champions <- active_champions %>%
  left_join(nba_team_colors, by = c("Champion" = "full_name"))

# plot championship distribution (Active Teams Only)
ggplot(active_champions, aes(x = reorder(Champion, -Championships), y = Championships, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +  # Use colors from dataset
  theme_minimal() +
  labs(title = "NBA Championships by Active Teams", x = "Team", y = "Total Championships") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# save
ggsave("figures/nba_championships_by_team.png", width = 8, height = 5)

# merge games with games_details to add Year
games_details <- games_details %>%
  left_join(games %>% select(game_id, Year) %>% distinct(), by = "game_id")

# compute team-level averages for season performance
season_performance <- games_details %>%
  group_by(Year, Team = team_abbreviation) %>%
  summarise(
    Total_Points = sum(pts, na.rm = TRUE),
    Total_Assists = sum(ast, na.rm = TRUE),
    Total_Rebounds = sum(reb, na.rm = TRUE)
  ) %>%
  ungroup()


# create a Lookup Table for Team Names to Abbreviations
team_name_map <- tibble(
  Full_Team_Name = c("Atlanta Hawks", "Boston Celtics", "Brooklyn Nets", "Charlotte Hornets",
                     "Chicago Bulls", "Cleveland Cavaliers", "Dallas Mavericks", "Denver Nuggets",
                     "Detroit Pistons", "Golden State Warriors", "Houston Rockets", "Indiana Pacers",
                     "Los Angeles Clippers", "Los Angeles Lakers", "Memphis Grizzlies", "Miami Heat",
                     "Milwaukee Bucks", "Minnesota Timberwolves", "New Orleans Pelicans", "New York Knicks",
                     "Oklahoma City Thunder", "Orlando Magic", "Philadelphia 76ers", "Phoenix Suns",
                     "Portland Trail Blazers", "Sacramento Kings", "San Antonio Spurs", "Toronto Raptors",
                     "Utah Jazz", "Washington Wizards"),
  Abbreviation = c("ATL", "BOS", "BKN", "CHA", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", "HOU", "IND",
                   "LAC", "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL", "PHI", "PHX",
                   "POR", "SAC", "SAS", "TOR", "UTA", "WAS")
)

# convert Full Team Names in nba_champions to Abbreviations
nba_champions <- nba_champions %>%
  left_join(team_name_map, by = c("Champion" = "Full_Team_Name")) %>%
  select(Year, Abbreviation) %>%
  rename(Team = Abbreviation) %>%
  mutate(Is_Champion = 1)  # Explicitly create Is_Champion column

# merge with season_performance & Fix Is_Champion Column
season_performance <- season_performance %>%
  left_join(nba_champions %>% select(Year, Team, Is_Champion), 
            by = c("Year", "Team")) %>%
  mutate(Is_Champion = ifelse(is.na(Is_Champion), 0, 1))  # Ensure non-champions get 0

# save
write_csv(season_performance, "data/season_performance_cleaned.csv")

# verify 
# season_performance %>% filter(Year == 2016, Team == "CLE")
