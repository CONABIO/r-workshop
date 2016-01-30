### Manipulación y agrupación de datos
# Teresa Ortiz
# Febrero 2015

# cargamos dos paquetes que usaremos más adelante
library(plyr)
library(dplyr)

#### 1. Los encabezados de las columanas son valores
pew <- read.delim(file = "http://stat405.had.co.nz/data/pew.txt",
  header = TRUE, stringsAsFactors = FALSE, check.names = F)
pew

# el paquete para limpiar datos es tidyr
library(tidyr) 
pew_tidy <- gather(data = pew, income, frequency, -religion)
# vemos las primeras líneas de nuestros datos alargados 
head(pew_tidy) 
# y las últimas
tail(pew_tidy)

# para hacer gráficas usamos ggplot2
library(ggplot2)
ggplot(pew_tidy, aes(x = income, y = frequency, color = religion, 
  group = religion)) +
  geom_line() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# explicaremos el operador %>% más adelante
by_religion <- group_by(pew_tidy, religion)
pew_tidy_2 <- pew_tidy %>%
  filter(income != "Don't know/refused") %>%
  group_by(religion) %>%
  mutate(percent = frequency / sum(frequency)) %>% 
  filter(sum(frequency) > 1000)

head(pew_tidy_2)

ggplot(pew_tidy_2, aes(x = income, y = percent, group = religion)) +
  facet_wrap(~ religion, nrow = 1) +
  geom_bar(stat = "identity", fill = "darkgray") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# usamos readr para leer datos
library(readr)
billboard <- read_csv("data/billboard.csv")
billboard

# alargamos los datos
billboard_long <- gather(billboard, week, rank, wk1:wk76, na.rm = TRUE)
billboard_long

# más limpios!
billboard_tidy <- billboard_long %>%
  mutate(
    week = extract_numeric(week),
    date = as.Date(date.entered) + 7 * (week - 1)) %>%
    select(-date.entered)
billboard_tidy

# y más gráficas
tracks <- filter(billboard_tidy, track %in% 
    c("Higher", "Amazed", "Kryptonite", "Breathe", "With Arms Wide Open"))

ggplot(tracks, aes(x = date, y = rank)) +
  geom_line() + 
  facet_wrap(~track, nrow = 1) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#### 2. Una columna asociada a más de una variable
