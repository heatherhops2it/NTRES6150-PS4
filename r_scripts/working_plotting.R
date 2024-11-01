
# Load in packages --------------------------------------------------------

library(tidyverse)
library(janitor)
library(rstatix)  # install.packages("rstatix")


# Load in data ------------------------------------------------------------

s02_raw <- read_csv("datasets/S1123KIP1_048K_S02_S7106_20240108_070004.Table.1.selections.csv")

s04_raw <- read_csv("datasets/S1123KIP1_048K_S04_S7112_20240108_070004.Table.1.selections.csv")


# Combining datasets ------------------------------------------------------

kipukas_raw <- bind_rows(s02_raw, s04_raw)

kipukas_clean <- kipukas_raw |> 
  clean_names() |> 
  mutate(center_time_percent = (center_time_s - time_5_percent_s)/dur_90_percent_s) |> 
  select(
    site, 
    type, 
    freq_95_percent_hz,
    dur_90_percent_s,
    peak_freq_hz,
    syllables_p_song,
    center_time_percent) |> 
  filter(!is.na(type))

songs <- kipukas_clean |> 
  filter(type == "Song")

syllables <- kipukas_clean |> 
  filter(type == "Syllable") |> 
  select(!syllables_p_song)



# Pivot tables for stats --------------------------------------------------

s





