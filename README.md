# LA-311-Service-Request-Analysis

## Project Overview
This project analyzes Los Angeles MYLA311 service request data from January 1 through March 27, 2025. The goal was to identify patterns in service demands, request types, geographic activity, request sources, and resolution times.

## Tools Used
- R
- RStudio
- tidyverse
- ggplot2
- Tableau Public

  ## Data Preparation
  The original dataset contained more than 423,000 service request records. Using R, I cleaned and prepared 368,961 records for analysis by reviewing missing values, transforming date fields, and creating analysis-ready datasets.

  ## Analysis
  The project explored:
  - Daily service request volume
  - Most common request types
  - Requests by day of week
  - Request sources
  - Neighborhood Council areas with the highest request volume
  - Median resolution time by request type
 
    ## Key Findings
    - Bulky Items was the most common request type during the analysis period.
    - Monday had the highest overall request volume.
    - Some streetlight-related requests had substantially longer median resolution times than other service categories.
    - Service request varied considerably across Neighborhood Council areas.
   
      ## Tableau Dashboard
      An interactive Tableau dashboard was created to present the main findings and trends from the analysis.
      
[View the Tableau Dashboard](https://public.tableau.com/views/LA311ServiceRequestAnalysis/LosAngeles311ServiceRequestAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) 
