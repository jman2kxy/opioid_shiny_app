library(shiny)
library(shinydashboard)
library(dplyr)
library(reshape)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(qcc)
library(broom)
library(Metrics)
library(rsample)
library(modelr)
library(rio)
library(DT)
library(datasets)


convert('data/overdoses.csv','data/overdoses.rds')
convert('data/opioids.csv', 'data/opioids.rds')
convert('data/prescriber-info.csv', 'data/prescriber-info.rds')
convert('data/all_county_data.csv', 'data/all_county_data.rds')

opioids <- readRDS("data/opioids.rds")
overdoses <- readRDS("data/overdoses.rds")
prescribers <- readRDS("data/prescriber-info.rds")
all_county_data_16 <- readRDS("data/all_county_data.rds")

#opioids <- read.csv("data/opioids.csv")
#overdoses <- read.csv("data/overdoses.csv")
#prescribers <- rea.csv("data/prescriber-info.csv")
#all_county_data_16 <- read.csv("data/all_county_data.csv")

#I noticed that the formatting of drugs in the Opioids files were not the same as in the Prescribers file, so I manually created a column in the Opioids file that would correspond with the Prescribers file. 
#Doing this helps to filters out drugs that aren't opioids in the Prescriber file
prescribers <-  prescribers[,c(1:5,na.omit(match(opioids$Prescriber.Name, colnames(prescribers))),c(256))]

prescribers

#Here I look at the most frequently prescribed opioids

prescribers_gathered <- prescribers %>% 
  gather(medicine,quantity,FENTANYL:HYDROMORPHONE.HCL, -one_of('State'))

prescribers_gathered <- prescribers_gathered[order(prescribers_gathered$quantity, decreasing = TRUE),]

prescribers_gathered

overdoses$Deaths <- as.numeric(gsub(",", "", overdoses$Deaths))
overdoses$Population <- as.numeric(gsub(",", "", overdoses$Population))


overdoses <- overdoses %>%
  mutate(death_per_cap = (Deaths/Population)*100)

prescribe_overdose_merge <- merge(prescribers_gathered,overdoses, by='State')


all_county_data_16["Labor_force"] <- as.numeric(gsub(",", "", all_county_data_16["Labor_force"]))
all_county_data_16["Employed"] <- as.numeric(gsub(",", "", all_county_data_16["Employed"] ))
all_county_data_16["Unemployed"] <- as.numeric(gsub(",", "", all_county_data_16["Unemployed"]))
all_county_data_16["Unemployment_Rate"] <- as.numeric(gsub("%", "", all_county_data_16["Unemployment_Rate"]))
all_county_data_16["Medicare_Enrollment"] <- as.numeric(gsub(",", "", all_county_data_16["Medicare_Enrollment"]))



#all_county_data_16 <- all_county_data_16 %>%
#  mutate(Deaths = (Opioid_Death_Cumal/Population)*100000)

#plotting theme for ggplot2
.theme<- theme(
  axis.line = element_line(colour = 'gray', size = .75),
  panel.background = element_blank(),
  plot.background = element_blank()
)
