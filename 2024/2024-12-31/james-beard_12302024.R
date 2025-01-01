library(tidyverse)
library(showtext)
library(magick)



restaurant_and_chef <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-12-31/restaurant_and_chef.csv')
james_beard <- image_read("2024/2024-12-31/james_beard.png") %>% as.raster()  # https://www.cleanpng.com/png-james-beard-foundation-award-2018-james-beard-medi-5880763/download-png.html

# some restaurants have city information in the restaurant column
restaurant_and_chef$city <- ifelse(is.na(restaurant_and_chef$city) & str_detect(restaurant_and_chef$restaurant, "\\,"),
                                   restaurant_and_chef$restaurant, restaurant_and_chef$city)

restaurant_and_chef[c("city_only", "state")] <- str_split_fixed(restaurant_and_chef$city, ",", 2)

# subsection best categories, but remove regional ones
top_categories <- restaurant_and_chef %>% 
  filter(!str_detect(subcategory, "Best Chef\\W") &
           year >= 1990) %>% 
  group_by(subcategory) %>% 
  summarize(n = n()) %>% 
  arrange(desc(n)) %>% 
  filter(subcategory %in% c("Best Chefs", "Rising Star Chef of the Year", "Outstanding Chef", "Outstanding Pastry Chef", "Outstanding Restaurateur"))


top_cities <- restaurant_and_chef %>% 
  group_by(city) %>% 
  summarize(n = n()) %>% 
  arrange(desc(n)) %>% 
  slice_head(n = 10)


# get some fonts
font_add_google("Libre Franklin", "libre")
font_add_google("Domine", "domine")
showtext_auto()



# plot
restaurant_and_chef %>% 
  filter(city %in% top_cities$city & subcategory %in% top_categories$subcategory) %>% 
  group_by(city, subcategory) %>% 
  summarize(n = n()) %>% 
  group_by(city) %>% 
  mutate(total_awards = sum(n)) %>% 
  arrange(desc(total_awards)) %>% 
  mutate(city = factor(city, levels = unique(city))) %>% 
  
  
  ggplot()+
  geom_col(aes(x= n, y = fct_reorder(city, total_awards), fill = subcategory)) +
  
  annotation_raster(james_beard, 305, 455, 3.6, 5.4)+
  
  paletteer::scale_fill_paletteer_d("calecopal::grassdry", direction = -1)+
  
  labs(y ="", x= "Awards", fill = "",
       title = "Top 10 foodie cities to find award winning chefs",
       subtitle = "Number of James Beard Awards in top chef categories, 1990-2024",
       caption = "Data: jamesbeard.org/awards | Graphic: Denyse Dawe | #tidytuesday")+
  guides(fill = guide_legend(position = "inside", byrow =TRUE)) +
  
  theme_minimal(base_family = "libre")+
  theme(plot.background = element_rect(fill = "#F4F1ED", color = NA),
        text = element_text(color = "#14213D"),
        plot.title = element_text(family = "domine", size = 32, hjust = 0.5),
        plot.subtitle = element_text(size = 20, hjust = 0.5, margin = margin(-2, 0, 0, 0)),
        plot.caption = element_text(size = 14, hjust = 1, margin = margin(8, 0, 0, 0)),
        axis.text = element_text(size = 18),
        axis.title = element_text(size = 20),
        legend.text = element_text(size = 18),
        legend.position.inside = c(0.76, 0.22),
        legend.key.size = unit(0.5, "cm")
        )
  


ggsave(
  file.path("2024", "2024-12-31", paste0("james_beard_20241230", ".png")),
  bg = "#F4F1ED",
  width = 5,
  height = 6
)
