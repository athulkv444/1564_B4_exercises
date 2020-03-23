# import pandas, numpy
import pandas as pd
import numpy as np
# Create the required data frames by reading in the files
df_sales = pd.read_excel('SaleData.xlsx')
df_diam = pd.read_csv('diamonds.csv',na_values=['NAN'])
df_imdb = pd.read_csv('imdb.csv', escapechar="\\")
df_meta = pd.read_csv('movie_metadata.csv')
# Q1 Find least sales amount for each item
# has been solved as an example
def least_sales(df_sales):
    # write code to return pandas dataframe
	ls = df.groupby(["Item"])["Sale_amt"].min().reset_index()
    return ls

# Q2 compute total sales at each year X region
def sales_year_region(df_sales):
    # write code to return pandas dataframe
    df_sales['Year'] = df_sales['OrderDate'].dt.year
    df_sales.groupby(['Year','Region'])['Sale_amt'].sum().reset_index()
# Q3 append column with no of days difference from present date to each order date
def days_diff(df_sales):
    # write code to return pandas dataframe
    from datetime import date
    today = date.today()
    df_sales['OrderDate']=pd.to_datetime(df_sales['OrderDate']).dt.date
    df_sales['day_diff'] = today-df_sales['OrderDate']
# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
def mgr_slsmn(df_sales):
    # write code to return pandas dataframe
    df = df_sales[['Manager','SalesMan']]
    df =df.groupby(['Manager'])['SalesMan'].apply(lambda x :x.unique()).reset_index()
    return_df
# Q5 For all regions find number of salesman and number of units
def slsmn_units(df_sales):
    # write code to return pandas dataframe
    df2 = df_sales[['Region','SalesMan','Sale_amt']]
    df2 = df2.groupby(['Region']).agg({"SalesMan": lambda x: x.nunique(), 
                      "Sale_amt": sum}).reset_index()
    df2.rename(columns = {'SalesMan':'Salesmen_count','Sale_amt':'total_sale'},
               inplace = True) 
    return df2
    
# Q6 Find total sales as percentage for each manager
def sales_pct(df_sales):
    # write code to return pandas dataframe
    df3 = df_sales.groupby(['Manager'])['Sale_amt'].apply(sum).reset_index()
    df3['percent_sales'] = (df3['Sale_amt']/sum(df3['Sale_amt']))*100
    return df3

# Q7 get imdb rating for fifth movie of dataframe
def fifth_movie(df_imdb):
	# write code here
    df = df_imdb['imdbRating'][4]
    return df
# Q8 return titles of movies with shortest and longest run time
def movies(df_imdb):
	# write code here
    df_imdb['duration'].fillna(value=df_imdb['duration'].mean(),inplace=True)
    df_imdb.sort_values(by='duration',inplace = True)
    #df_imdb.tail()
    df3 = df_imdb[['duration','title']]
    df3.iloc[[0,df3.shape[0]-1]]
    return df3

# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
def sort_df(df_imdb):
	# write code here
    df_imdb.dropna(subset=["year", "imdbRating"],inplace = True)
    df_imdb.sort_values(["year", "imdbRating"], ascending = (False,False))
    return df_imdb
# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
def subset_df(df_meta):
	# write code here
    df = df_meta[(df_meta['gross']>=2000000) & (df_meta['budget']<=1000000) 
         & (df_meta['duration']>=30) & (df_meta['duration']<=180)].reset_index()
    return df
# Q11 count the duplicate rows of diamonds DataFrame.
def dupl_rows(df_diam):
	# write code here
    df = df_diam.duplicated(keep='first').sum()
    return df
# Q12 droping those rows where any value in a row is missing in carat and cut columns
def drop_row(df_diam):
	# write code here
    df = df_diam.dropna(subset=['carat', 'cut'], inplace=True)
    return df

# Q13 subset only numeric columns
def sub_numeric(df_diam): 
	# write code here
    df = df_diam[['carat','depth','table','price','x','y','z']]
    return df
# Q14 compute volume as (x*y*z) when depth > 60 else 8
def volume(df_diam):
	# write code here
    df_diam['z']=df_diam['z'].apply(pd.to_numeric, errors='coerce')
    df_diam['price'].fillna(value=df_diam['price'].mean(),inplace=True)
    def my_fun_1(x):
        
        if x[0]>60:
            v = x[1]*x[2]*x[3]
        else:
            v = 8
        return v
    df_diam['volume'] = df_diam[['depth','x','y','z']].apply(my_fun_1,axis=1)
    return df_diam
# Q15 impute missing price values with mean
def impute(df_diam):
     df_diam['price'].fillna(value=df_diam['price'].mean(),inplace=True)
     return df_diam
	# write code here
