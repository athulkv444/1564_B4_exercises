library(readxl)
library(data.table)
library(plyr)
library(dplyr)
library(stringi)
setwd("C:\\Users\\athul.kalloorvee\\Downloads")
sales_df <- read_excel('SaleData.xlsx')
imdb <- read.csv('imdb.csv',stringsAsFactors=FALSE,sep = ",")
meta <- read.csv('movie_metadata.csv',stringsAsFactors=FALSE)

dia <- read.csv('diamonds.csv',stringsAsFactors=FALSE)
setDT(sales_df)
setDT(imdb)
setDT(dia)
setDT(meta)

## 1
least_sales <- function(df_sales){
  # write code to return pandas dataframe
  df <- sales_df[,min_sales := min(Sale_amt),by = .(Item)]
  df <-unique(sales_df[,.(Item,min_sales)])
}

# Q2 compute total sales at each year X region
sales_year_region <- function(sales_df){
  sales_df[,OrderDate := as.Date(OrderDate)]
  sales_df[,Year := year(OrderDate)]
  sales_df[,tot_sale := sum(Sale_amt) , by =.(Year,Region)]
  df <- unique(sales_df[,.(Year,Region,tot_sale)])
  
}

# Q3 append column with no of days difference from present date to each order date
 days_diff <- function(sales_df){
   tdate <- as.Date(Sys.Date())
   sales_df[,OrderDate := as.Date(OrderDate)]
   sales_df[, days_diff := tdate-OrderDate]
   
 }

# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
mgr_slsmn <- function (sales_df){
  sales_df[,list_of_salesman := list[unique(SalesMan)],by=.(Manager)]
  }


# Q5 For all regions find number of salesman and number of units
no_saleman <- function (sales_df){
  sales_df[,salesmen_count  := uniqueN(SalesMan), by = .(Region)]
  sales_df[,total_sales  := sum(Sale_amt), by = .(Region)]
  df <- unique(sales_df[,.(Region,total_sales,salesmen_count)])
}


# Q6 Find total sales as percentage for each manager
sales_pct <- function (sales_df){ 
  totsale <- sum(sales_df$Sale_amt)
  sales_df[,percent_sales := (sum(Sale_amt)/totsale)*100,by = .(Manager)]
  df <- unique(sales_df[,.(Manager,percent_sales)])
  }


# Q7 get imdb rating for fifth movie of dataframe
fifth_movie <- function(imdb){
  imdb[,imdbRating := as.character(imdbRating)]
  df <- imdb$imdbRating[5]
  
}

# Q8 return titles of movies with shortest and longest run time
movies <- function(imdb){
  imdb[,duration := as.numeric(duration)]
  imdb2 <- imdb[!is.na(duration)]
  setorder(imdb2,duration)
  df <- imdb2[c(1,nrow(imdb2)),.(duration,title)]
}
# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
sort_df <- function(df_imdb){
  imdb[,year := as.numeric(year)]
  imdb[,imdbRating := as.numeric(imdbRating)]
  imdb3 <- imdb[!is.na(year) & !is.na(imdbRating)]
  setorder(imdb3,-year,-imdbRating)
}

# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
subset_df <- function(meta){ 
  df <- meta[duration<=180 & duration>=30][gross >=2000000 & budget <=1000000]
  }

# Q11 count the duplicate rows of diamonds DataFrame.
dupl_rows <- function(dia){ 
  
  df <- nrow(dia)-uniqueN(dia)
  }

# Q12 droping those rows where any value in a row is missing in carat and cut columns
drop_row <- function(dia){ 
  df <- dia[!is.na(carat) | !is.na(cut)]
  }

# Q13 subset only numeric columns
sub_numeric <- function(dia){ 
  dia[,z := as.numeric(z)]
  df <- dia[,.(carat,depth,table,price,x,y,z)]
  } 

# Q14 compute volume as (x*y*z) when depth > 60 else 8
volume <- function(dia){
  dia[,z := as.numeric(z)]
  dia[depth>60,volume := x*y*z]
  dia[depth<=60,volume := 8]
  dia[,z := as.numeric(z)]
}

# Q15 impute missing price values with mean
impute <- function(dia){
  m <-as.integer(mean(dia$price,na.rm = TRUE))
  dia[is.na(price),price := m]
}

## Bonus questions
## 1. Generate a report that tracks the various 
##Genere combinations for each type year on year.

imdb_type_year <- function(imdb){
  genre <- c("Action"   ,        "Adult"    ,  "Adventure"       , "Animation"       
             , "Biography"      ,  "Comedy"          , "Crime"           , "Documentary"     
             , "Drama"          ,  "Family"           ,"Fantasy"         , "FilmNoir"        
             ,"GameShow"        , "History"          ,"Horror"          , "Music"           
             ,"Musical"        ,  "Mystery"          ,"News"             ,"RealityTV"       
             , "Romance"        ,  "SciFi"            ,"Short"            ,"Sport"           
             , "TalkShow"        , "Thriller"         ,"War"             , "Western"  )
  
  df <- imdb
  setDT(df)
  #df[,Genre_combo := my_fun(genre,title,df),by=.(title,year)]
  df[ , (genre) := lapply(.SD, as.character), .SDcols = genre]
  my_fun2 <- function(cl,g){
    #dt <- as.data.frame(cl)
    #coln <- colnames(dt)
    #coln <- genre[1]
    # b#rowser()
    #coln <- myfunc(cl)
    y <- c(cl)
    y <- y[[1]]
    y <- replace(y,y=="0","")
    y <-replace(y,y=="1",g[1])
  }
  
  for (i in 1:length(genre)){
    #print(i)
    #browser()
    df[,(genre[i]) := my_fun2( df[,genre[i],with=FALSE],genre[i])]
  }
  
  #df[ , (genre) := lapply(.SD, my_fun2), .SDcols = genre]
  df[, Genre_combo := do.call(paste0, c(.SD)), .SDcols = genre]
  df[,imdbRating := as.numeric(imdbRating)]
  df[,min_rating := min(imdbRating,na.rm = TRUE), by = .(type,year,Genre_combo)]
  df[,max_rating := max(imdbRating,na.rm = TRUE), by = .(type,year,Genre_combo)]
  df[,avg_rating := mean(imdbRating,na.rm = TRUE), by = .(type,year,Genre_combo)]
  df[,total_run_time := sum(duration,na.rm = TRUE), by = .(type,year,Genre_combo)]
  df <- unique(df[,.(year,type,Genre_combo,min_rating,max_rating,
                     avg_rating,total_run_time  )])
  return (df)
}

##2Generate a report that captures
#the trend of the number of letters in movies titles over years

title_length <- function(imdb){
  df <- imdb
  setDT(df)
  df[,year := as.integer(year)]
  df <- df[year<=2020 & year >=1800]
  df[,title_len :=  nchar(wordsInTitle)]
  df[,min_length := min(title_len),by=.(year)]
  df[,max_length := max(title_len),by=.(year)]
  df[title_len <= quantile(title_len)[2],  
     num_videos_less_than25Percentile := .N, by =.(year)]
  df[title_len > quantile(title_len)[2] & title_len <= quantile(title_len)[3],  
     num_videos_25_50Percentile := .N, by =.(year)]
  df[title_len > quantile(title_len)[3] & title_len <= quantile(title_len)[4],  
     num_videos_50_75Percentile := .N, by =.(year)]
  df[title_len > quantile(title_len)[4],  
     num_videos_greater_than75Percentile := .N, by =.(year)]
  df <- unique(df[,.(year,min_length,max_length,num_videos_less_than25Percentile,
                     num_videos_25_50Percentile,num_videos_50_75Percentile,
                     num_videos_greater_than75Percentile)])
  df[is.na(df)]<- 0
  
}


## 3 Generate a report that contains cross tab between bins and cut. 

bin_cut_summary <- function(diam){
  library(Hmisc)
  df <- diamonds
  setDT(df)
  df[depth>60,volume := x*y*z]
  df[depth<=60,volume := 8]
  df$bin <- cut(df$volume,10)
  df1 <- ftable(table(df$cut,df$bin))
  df[,cnt := .N , by =.(bin,cut)]
  df <- unique(df[,.(cut,bin,cnt)])
}


## 4 Generate a report that tracks the Avg.
##imdb rating quarter on quarter, in the last 10 years

top_perf_movies <- function(imdb){
  df <- meta
  setDT(df)
  df <- df[!is.na(title_year) & !is.na(gross)]
  setkey(df,title_year,gross)
  setorder(df,title_year,-gross)
  
  df[,nn := 1:.N , by =.(title_year)]
  df[,no_movies := round(.N *0.1), by =.(title_year)]
  df <- df[title_year >= (max(title_year)-10)]
  df <- df[nn<= no_movies]
  df[,title_year := as.integer(title_year)]
  #imdb[,year := as.integer(year)]
  df[,avg.rating := mean(imdb_score,na.rm = TRUE),by = .(title_year)]
  df <- unique(df[,.(title_year,avg.rating)])
  
}

## 5

duration_decile <- function(imdb){
  library(StatMeasures)
  imdb[,duration := as.integer(duration)]
  df <- imdb[!is.na(duration)]
  df[,deci := as.factor(decile(duration))]
  cols_chosen <-  c( "nrOfWins","nrOfNominations","Action"   ,        "Adult"    ,  "Adventure"       , "Animation"       
                     , "Biography"      ,  "Comedy"          , "Crime"           , "Documentary"     
                     , "Drama"          ,  "Family"           ,"Fantasy"         , "FilmNoir"        
                     ,"GameShow"        , "History"          ,"Horror"          , "Music"           
                     ,"Musical"        ,  "Mystery"          ,"News"             ,"RealityTV"       
                     , "Romance"        ,  "SciFi"            ,"Short"            ,"Sport"           
                     , "TalkShow"        , "Thriller"         ,"War"             , "Western" )
  df[, (cols_chosen) := lapply(.SD,as.numeric), .SDcols = cols_chosen]
  sum_fn <- function(x){
    sm <- sum(x,na.rm = TRUE)
  }
  x <- df[, lapply(.SD,sum_fn), by = .(deci), .SDcols = cols_chosen]
}
