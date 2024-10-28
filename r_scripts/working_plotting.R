
# Load in packages --------------------------------------------------------

library(tidyverse)
library(janitor)


# Load in data ------------------------------------------------------------

s02_raw <- read_csv("datasets/S1123KIP1_048K_S02_S7106_20240108_070004.Table.1.selections.csv")

s04_raw <- read_csv("datasets/S1123KIP1_048K_S04_S7112_20240108_070004.Table.1.selections.csv")


# Combining datasets ------------------------------------------------------

df_combined <- bind_rows(s02_raw, s04_raw)

df_cleaned <- df_combined |> 
  clean_names() |> 
  select(
    site, 
    type, 
    freq_95_percent_hz,
    dur_90_percent_s,
    peak_freq_hz,
    syllables_p_song,
    center_time_s)


# Plot creation -----------------------------------------------------------


