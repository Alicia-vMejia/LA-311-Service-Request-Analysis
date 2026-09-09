library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

la311_analysis <- read_csv(
  "Data/la311_clean_q1_2025.csv",
  show_col_types = FALSE
)
glimpse(la311_analysis)
nrow(la311_analysis)
top_request_types <- la311_analysis %>%
  count(RequestType, sort = TRUE)

top_request_types
request_type_plot <- top_request_types %>%
  slice_head(n=10) %>%
  ggplot(aes(x= reorder(RequestType, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 MyLA311 Request Types",
    subtitle = "January 1-March 27, 2025",
    x = NULL,
    y = "Number of Requests"
  ) +
  theme_minimal()
request_type_plot
daily_requests <- la311_analysis %>%
  mutate(
    Day = as_date(CreatedDate)
  ) %>%
  count(Day)
daily_requests
daily_request_plot <- ggplot(
  daily_requests,
  aes(x = Day, y = n)
) +
  geom_line() +
  labs(
    title = "Daily MyLA311 Request Volume",
    subtitle = "January 1-March 27, 2025",
    x = "Date",
    y = "Number of Requests"
  ) +
  theme_minimal()
daily_request_plot
weekday_requests <- la311_analysis %>%
  mutate(
    Weekday = wday(CreatedDate, label = TRUE, abbr = FALSE)
  ) %>%
  count(Weekday)
weekday_requests
weekday_plot <- ggplot(
  weekday_requests,
  aes(x = Weekday, y = n)
) +
  geom_col() +
  labs(
    title = "MyLA311 Requests by Day of Week",
    subtitle = "January 1-March 27, 2025",
    x = NULL,
    y = "Number of Requests"
  ) +
  theme_minimal()
weekday_plot
request_source_counts <- la311_analysis %>%
  count(RequestSource, sort = TRUE)
request_source_counts
request_source_plot <- request_source_counts %>%
  slice_head(n = 6) %>%
  ggplot(aes(x = reorder(RequestSource, n), y= n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top MyLA311 Request Sources",
    subtitle = "January 1-March 27, 2025",
    x = NULL,
    y = "Number of Requests"
  ) +
  theme_minimal()
request_source_plot
location_counts <- la311_analysis %>%
  count(NCName, sort = TRUE)
location_counts
location_plot <- location_counts %>%
  slice_head(n = 10) %>%
  ggplot(aes(x = reorder(NCName, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 Neighborhood Council Areas by MyLA311 Requests",
    subtitle = "January 1-March 27, 2025",
    x = NULL,
    y = "Number of Requests"
  ) +
  theme_minimal()
location_plot
resolution_data <- la311_analysis %>%
  filter(
    !is.na(CreatedDate),
    !is.na(ClosedDate),
    ClosedDate >= CreatedDate
  ) %>%
  mutate(
    resolution_hours = as.numeric(
      difftime(ClosedDate, CreatedDate, units = "hours")
    )
  )
resolution_data %>%
  summarise(
    request_with_resolution_time = n (),
    median_resolution_hours = median(resolution_hours, na.rm = TRUE),
    average_resolution_hours = mean(resolution_hours, na.rm = TRUE)
  )
resolution_data %>%
  summarise(
    requests_with_resolution_time = n(),
    median_resolution_hours = median(resolution_hours, na.rm = TRUE),
    average_resolution_hours = mean(resolution_hours, na.rm = TRUE)
  ) %>%
  print(width = Inf)
cat(
  "Average resolution hours:",
  mean(resolution_data$resolution_hours, na.rm = TRUE),
  "\n"
)

cat(
  "Median resolutin hours:",
  median(resolution_data$resolution_hours, na.rm = TRUE),
  "\n"
)
resolution_by_type <- resolution_data %>%
  group_by(RequestType) %>%
  summarise(
    requests = n (),
    median_resolution_hours = median(resolution_hours, na.rm = TRUE),
    average_resolution_hours = mean(resolution_hours, na.rm = TRUE)
  ) %>%
  filter(requests >= 1000) %>%
  arrange(desc(median_resolution_hours))
resolution_by_type
resolution_type_plot <- resolution_by_type %>%
  slice_head(n = 8) %>%
  ggplot(
    aes(
      x = reorder(RequestType, median_resolution_hours),
      y = median_resolution_hours
    )
  ) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Slowest MyLA311 Request Types by Median Resolution Time",
    subtitle = "January 1-March 27, 2025",
    x = NULL,
    y = "Median Resolution Time (Hours)"
  ) +
  theme_minimal()
resolution_type_plot
write_csv(top_request_types,"Tableau/top_request_types.csv")
write_csv(daily_requests, "Tableau/daily_requests.csv")
write_csv(weekday_requests, "Tableau/weekday_requests.csv")
write_csv(request_source_counts, "Tableau/request_source_counts.csv")
write_csv(location_counts, "Tableau/location_counts.csv")
write_csv(resolution_by_type, "Tableau/resolution_by_type.csv")