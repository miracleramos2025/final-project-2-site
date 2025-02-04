

# load necessary libraries
library(tidyverse)
library(ggplot2)

# load data
nba_champions <- read_csv("data/nba_champions_cleaned.csv")
ranking <- read_csv("data/ranking.csv")

# Load team colors
load("nba_team_colors.RData")

# Define the list of active NBA teams
active_teams <- c("Atlanta Hawks", "Boston Celtics", "Brooklyn Nets", "Charlotte Hornets", 
                  "Chicago Bulls", "Cleveland Cavaliers", "Dallas Mavericks", "Denver Nuggets", 
                  "Detroit Pistons", "Golden State Warriors", "Houston Rockets", "Indiana Pacers", 
                  "Los Angeles Clippers", "Los Angeles Lakers", "Memphis Grizzlies", "Miami Heat", 
                  "Milwaukee Bucks", "Minnesota Timberwolves", "New Orleans Pelicans", "New York Knicks", 
                  "Oklahoma City Thunder", "Orlando Magic", "Philadelphia 76ers", "Phoenix Suns", 
                  "Portland Trail Blazers", "Sacramento Kings", "San Antonio Spurs", "Toronto Raptors", 
                  "Utah Jazz", "Washington Wizards")

# Filter only active teams
nba_champions_active <- nba_champions %>%
  filter(Champion %in% active_teams)

# -----------------------------------------------
# PLOT 1: Bar Chart - Total NBA Championships by Active Team
# -----------------------------------------------
nba_champions_active %>%
  count(Champion, sort = TRUE) %>%
  left_join(nba_team_colors, by = c("Champion" = "full_name")) %>%  # Match team colors
  ggplot(aes(x = reorder(Champion, n), y = n, fill = color)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(title = "Total NBA Championships by Active Teams",
       x = "Team",
       y = "Number of Championships") +
  scale_fill_identity() +  
  theme_minimal()

# save plot
ggsave("figures/championship_wins_by_active_teams.png", width = 8, height = 6)


# -----------------------------------------------
# PLOT 2: Championship Wins Over Time (Active Teams Only)
# -----------------------------------------------

# -----------------------------------------------
# TABLE: Summary Statistics for Target Variable
# -----------------------------------------------
champ_summary <- nba_champions_active %>%
  group_by(Champion) %>%
  summarise(
    Championships = n(),
    First_Championship = min(Year),
    Last_Championship = max(Year),
    Championship_Span = Last_Championship - First_Championship
  ) %>%
  arrange(desc(Championships))

# View the table
knitr::kable(champ_summary, caption = "NBA Champions Summary (Active Teams)")

# save the summary table as a CSV for easy reference
write_csv(champ_summary, "data/nba_champions_summary.csv")
