library(readxl)
library(tidyverse)


# download.file("https://elsevier.digitalcommonsdata.com/public-files/datasets/btchxktzyw/files/18cf2613-948f-4c56-8304-140b07913758/file_downloaded",
#               "2025/2025-01-07/Table_1_Authors_career_2023_pubs_since_1788_wopp_extracted_202408.xlsx")

career <- readxl::read_excel("2025/2025-01-7/Table_1_Authors_career_2023_pubs_since_1788_wopp_extracted_202408.xlsx")


# clean data



# colors
elsevier_blue <- "#0056D6"
elsevier_orange <- "#FF4203"
elsevier_grey <- "#53565A"

# fonts
font_add_google("Playfair Display")

# font  somewhat replicates an Elsevier font
title_font <- "Playfair Display"
body_font <- "Times New Roman"