library(readr)
library(dplyr)
library(lubridate)
la311<-read_csv(
  "Data/myla311_2025.csv",
  col_types=cols(
    ZipCode=col_character(),
    TBMPage=col_character()
    )
  )
la311<-la311 %>%
  mutate(
    CreatedDate = mdy_hms(CreatedDate),
    UpdatedDate = mdy_hms(UpdatedDate),
    ServiceDate = mdy_hms(ServiceDate),
    ClosedDate = mdy_hms (ClosedDate)
  )
glimpse(la311)

la311 %>%
  summarise(
    missing_created = sum(is.na(CreatedDate)),
    missing_updated = sum(is.na(UpdatedDate)),
    missing_service = sum(is.na(ServiceDate)),
    missing_closed = sum(is.na(ClosedDate)),
    missing_request_type = sum(is.na(RequestType)),
    missing_zip = sum(is.na(ZipCode))
  ) %>%
  print(width = Inf)
la311 %>%
  filter(is.na(ClosedDate)) %>%
  count(Status, sort = TRUE)
la311 %>%
  filter(
    is.na(ClosedDate),
    Status == "Closed"
  ) %>%
  select(
    SRNumber,
    CreatedDate,
    UpdatedDate,
    RequestType,
    Status,
    ServiceDate,
    ClosedDate,
  ) %>%
  head(20)
la311 %>%
  count(SRNumber) %>%
  filter(n > 1) %>%
  arrange(desc(n))
la311 %>%
  count(RequestType, sort = TRUE)
la311 %>%
  mutate(
    Month = floor_date(CreatedDate, "month")
  ) %>%
  count(Month) %>%
  arrange(Month)
la311 %>%
  summarise(
    earliest_request = min(CreatedDate,na.rm = TRUE),
    latest_request = max(CreatedDate, na.rm = TRUE)
)
la311 %>%
  mutate(
    Day = as_date(CreatedDate)
  ) %>%
  count(Day) %>%
  arrange(Day)
la311 %>%
  mutate(
    Day = as_date(CreatedDate)
  ) %>%
  count(Day) %>%
  arrange(Day) %>%
  tail(20)
la311 %>%
  mutate(
    Day = as_date(CreatedDate)
  ) %>%
  count(Day)%>%
  filter(
    Day >= as.Date("2025-03-20"),
    Day <= as.Date("2025-04-15")
  ) %>%
  arrange(Day) %>%
  print(n= Inf)
la311 %>%
  mutate(
    Day = as_date(CreatedDate)
  ) %>%
  count(Day) %>%
  filter(
    Day >= as.Date("2025-03-27"),
    Day <= as.Date("2025-04-05")
  ) %>%
  arrange(Day) %>%
  print(n = Inf)
la311_clean <- la311 %>%
  filter(
    CreatedDate >= as.POSIXct("2025-01-01"),
    CreatedDate < as.POSIXct("2025-03-28")
  )
nrow(la311_clean)
write_csv(
  la311_clean,
  "Data/la311_clean_q1_2025.csv"
)