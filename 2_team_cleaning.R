# Load necessary library
library(tibble)

# Define team colors for only active NBA teams
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

# Save the tibble in an RData file
save(nba_team_colors, file = "nba_team_colors.RData")
