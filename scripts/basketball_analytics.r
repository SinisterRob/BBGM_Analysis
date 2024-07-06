library(dplyr)
library(jsonlite)
library(data.table)
library(purrr)
library(tidyr)
library(duckdb)

# Set working directory to the current script directory.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load user-defined functions.
source("00 - functions.r")

# Read the league data file.
json_data <- read_game_data()

# Scrape the game-level and the game/player-level results.
game_results <- scrape_game_results(json_data)
game_player_results <- scrape_game_player_results(json_data)
player_results <- scrape_player_results(json_data)

# Setup database.
source("01 - database_setup.r")