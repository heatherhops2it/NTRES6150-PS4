
# Load in packages --------------------------------------------------------

library(tidyverse)
library(janitor)
library(rstatix)  # install.packages("rstatix")


# Load in data ------------------------------------------------------------

s02_raw <- read_csv("datasets/S1123KIP1_048K_S02_S7106_20240108_070004.Table.1.selections.csv")

s04_raw <- read_csv("datasets/S1123KIP1_048K_S04_S7112_20240108_070004.Table.1.selections.csv")



# Make a figures folder ---------------------------------------------------

dir.create("figures")


# Combining datasets ------------------------------------------------------

kipukas_raw <- bind_rows(s02_raw, s04_raw)

kipukas_clean <- kipukas_raw |> 
  clean_names() |> 
  mutate(
    center_time_percent = (center_time_s - time_5_percent_s)/dur_90_percent_s) |>
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



# Pivoting tables for stats -----------------------------------------------

songs_long <- songs |> 
  pivot_longer(
    c(
      "freq_95_percent_hz", 
      "dur_90_percent_s",
      "peak_freq_hz",
      "syllables_p_song",
      "center_time_percent"),
    names_to = "variable", 
    values_to = "value")

syllables_long <- syllables |> 
  pivot_longer(
    c(
      "freq_95_percent_hz", 
      "dur_90_percent_s",
      "peak_freq_hz",
      "center_time_percent"),
    names_to = "variable", 
    values_to = "value")



# Simple t-test -----------------------------------------------------------

songs_long |> 
  group_by(variable) |> 
  t_test(value ~ site)

syllables_long |> 
  group_by(variable) |> 
  t_test(value ~ site)




# Mean and standard deviation ---------------------------------------------

songs_long |> 
  group_by(variable) |> 
  summarise(
    mean= mean(value), 
    sd= sd(value), 
    max = max(value),
    min = min(value))

syllables_long |> 
  group_by(variable) |> 
  summarise(
    mean= mean(value), 
    sd= sd(value), 
    max = max(value),
    min = min(value))



# Chi square --------------------------------------------------------------

songs |> 
  select(site, syllables_p_song) |> 
  chisq_test()



# Box and whisker plots ---------------------------------------------------

song_plot <- songs_long |> 
  ggplot(aes(x = value)) +
  geom_boxplot(aes(fill = site, colour = site), alpha = 0.5) +
  facet_wrap(
    ~variable,
    scales = "free",
    labeller = as_labeller(c(
      `center_time_percent` = "Center Time (%)",
      `dur_90_percent_s` = "90% Duration (s)",
      `freq_95_percent_hz` = "95% Frequency (Hz)",
      `peak_freq_hz` = "Peak Frequency (Hz)",
      `syllables_p_song` = "Syllables Per Song"))) +
  labs(title = "Acoustic Measurements for Songs Across Two Kipuka")


syllable_plot <- syllables_long |> 
  ggplot(aes(x = value)) +
  geom_boxplot(aes(fill = site, colour = site), alpha = 0.5) +
  facet_wrap(
    ~variable,
    scales = "free",
    labeller = as_labeller(c(
      `center_time_percent` = "Center Time (%)",
      `dur_90_percent_s` = "90% Duration (s)",
      `freq_95_percent_hz` = "95% Frequency (Hz)",
      `peak_freq_hz` = "Peak Frequency (Hz)"))) +
  labs(title = "Acoustic Measurements for Syllables Across Two Kipuka")



# Export plots ------------------------------------------------------------

ggsave(filename = "figures/songs_boxplot.png", plot = song_plot)  

ggsave(filename = "figures/syllables_boxplot.png", plot = syllable_plot)
