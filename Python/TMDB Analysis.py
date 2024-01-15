#!/usr/bin/env python
# coding: utf-8

# # TMDB Movie Data Analysis
# 

# In[1]:


# Import libraries
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import json
from pandas import json_normalize

import warnings
warnings.filterwarnings('ignore')


# ## NORMAILZING THE COLUMNS

# In[2]:


data=pd.read_csv('DS1_C8_V3_ND_Sprint2_Data Analysis Using Python_Dataset.csv')
data.head(2)


# In[3]:


data.info()


# In[4]:


json_columns=['genres','keywords','production_companies','production_countries','spoken_languages']

for col in json_columns:
    data[col]=data[col].apply(lambda x: str(x)[1:-1])


# In[5]:


def extract_names(col_val):
    name_list = json.loads(f'[{col_val}]')
    names = [col_val['name'] for col_val in name_list]
    return ', '.join(names)

for col in json_columns:
    data[f'{col}_name'] = data[col].apply(extract_names)
    data[f'{col}_name']=data[f'{col}_name'].apply(lambda x:x.split(', '))


# In[ ]:





# In[6]:


data.drop(columns=json_columns,inplace=True)


# In[ ]:





# In[7]:


data[['title','genres_name']]


# # TASKS

# 
# # Task 1:
# Load the movie dataset in the Python notebook. Display the numbers of rows and columns in the dataset. Display the titles and genres of the first 50 movies from the dataset.
# 

# In[8]:


data.shape


# In[9]:


# There are 4803 rows(records) and 20 columns


# In[10]:


data[['title','genres_name']].head(50)


# 
# # Task - 2 
# Identify the columns that have null values and perform the null value treatment. (Choose the imputation method based on the type of data in the columns of interest)
# 

# In[11]:


data.isnull().sum()


# In[12]:


data.dropna(subset='release_date',inplace=True)
data.runtime.fillna(data.runtime.mean,inplace=True)


# In[13]:


data.isnull().sum()


# 
# # Task -3: 
# Display the movie categories that have a budget greater than $220,000.
# 

# In[14]:


data[data['original_title'] == 'Avatar'][['original_title', 'genres_name']]


# In[15]:


data_genre_flaten=data.explode('genres_name')
data_genre_flaten[data_genre_flaten['original_title'] == 'Avatar'][['original_title', 'genres_name']]


# In[ ]:





# In[16]:


data_genre_flaten=data.explode('genres_name')
t3_nocondition=pd.pivot_table(index='genres_name',values='budget',data=data_genre_flaten,aggfunc='mean')
t3=t3_nocondition[t3_nocondition.budget>220000].sort_values('budget',ascending=False)


# In[38]:


t3


# In[17]:


plt.title('Genre with budget greater than $220,000')
sns.barplot(x=t3.budget,y=t3.index)
plt.xlabel('budget')
plt.ylabel('')
plt.show()


# 
# # Task -4:
# Display the movie categories where the revenue is greater than $961,000,000.
# 

# In[42]:


t4_nocondition=pd.pivot_table(index='genres_name',values='revenue',data=data_genre_flaten,aggfunc='sum')
t4=t4_nocondition[t4_nocondition.revenue>961000000].sort_values('revenue',ascending=False)


# In[43]:


t4


# In[19]:


plt.title('Genre with Revenue greater than $961,000,000')
sns.barplot(x=t4.revenue,y=t4.index)
plt.xlabel('Revenue')
plt.ylabel('')
plt.show()


# 
# # Task - 5 
# In the dataset, there are some movies for which the budget and revenue columns have the value 0, which mean unknown values. Remove the rows with value 0 from both the budget and revenue columns.
# 

# In[20]:


data = data[(data['budget'] != 0) ]
data = data[(data['revenue'] != 0) ]


# 
# # Task - 6 
# List the top 10 movies with the highest revenues and the top 10 movies with the least budget. 
# 

# In[21]:


top_10_movies=data[['original_title','budget']]\
.sort_values('budget',ascending=False).nlargest(10,columns='budget')
top_10_movies


# In[22]:


top_10lowest_movies=data[['original_title','budget']]\
.sort_values('budget',ascending=False).nsmallest(10,columns='budget')
top_10lowest_movies


# In[23]:


plt.figure(figsize=(5,10))
plt.subplot(211)
plt.figure(1)
plt.title('TOP 10 highest budget Movies')
sns.barplot(y='original_title',x='budget',data=top_10_movies)
plt.ylabel('Movie Title')

plt.subplot(212)
plt.title('TOP 10 lowest budget Movies')
sns.barplot(y='original_title',x='budget',data=top_10lowest_movies)
plt.ylabel('Movie Title')


# 
# # Task -7:
# How are popularities of movies related with the movie budgets? Are they correlated or totally uncorrelated with each other? Write the interpretation of your analysis.
# 

# In[24]:


data.columns


# In[25]:


plt.title('Budget Vs Popularity')
sns.scatterplot(y=data.popularity,x=data.budget)
plt.show()


# 
# # Task - 8: 
# Identify and display the names of all production companies along with the number of times they appear in the dataset.
# 

# In[26]:


data.columns


# In[ ]:





# In[27]:


data_productionname_flatten=data.explode('production_companies_name')
t8=data_productionname_flatten.production_companies_name.value_counts()
t8


# In[ ]:





# In[ ]:





# 
# # Task -9: 
# Display the names of the top 25 production companies based on the number of movies they have produced in descending order of the number of movies produced.
# 

# In[28]:


t9=t8.nlargest(25)
t9


# In[29]:


plt.title('Top 25 Production companies- Number of movies')
sns.barplot(y=t9.index,x=t9. values)
plt.show()


# 
# # Task - 10:
# Sort the data in descending order based on revenue and filter the top 500 movies. Find the measures of central tendency for the following columns using the filtered data:
# 
# 1. budget
# 
# 2. revenue
# 
# 3. runtime
# 
# Perform outlier analysis for the above three columns using box plots.
# 

# In[30]:


t10=data.nlargest(500,'revenue')
t10.head()


# In[31]:


def hist_box(col):
    plt.figure(figsize=(10,3))
    plt.subplot(1,2,1)
    plt.title(f'{col}- Histogram')
    sns.histplot(t10[col],kde=True)

    plt.subplot(1,2,2)
    plt.title(f'{col}- BoxPlot')
    sns.boxplot(x=t10[col],color='green',whis=True,fliersize=5)
    plt.show()


# In[32]:


columns=['budget','revenue','runtime']
for col in columns:
    hist_box(col)


# In[33]:


iqr_df=pd.DataFrame(index=['Mean','Median','Mode','Min','LowerBound','Q1','Q3','IQR','UpperBound','Max'])

def iqr(col):
    mean=t10[col].mean()
    median=t10[col].median()
    mode=t10[col].mode()[0]
    min=t10[col].min()
    
    Q1=t10[col].quantile(0.25)
    Q3=t10[col].quantile(0.75)
    IQR=Q3-Q1
    LowerBound=Q1-1.5*IQR
    UpperBound=Q3+1.5*IQR
    max=t10[col].max()
    
    ins=[mean,median,mode,min,LowerBound,Q1,Q3,IQR,UpperBound,max]

    iqr_df.insert(len(iqr_df.columns),column=f'{col}',value=ins)
    

for i in columns:
    iqr(i)
display(iqr_df)


# In[34]:


def remove_outliers(df, columns):
    df_no_outliers = df.copy()

    for col in columns:
        
        Q1 = df[col].quantile(0.25)
        Q3 = df[col].quantile(0.75)
        IQR = Q3 - Q1
        LowerBound = Q1 - 1.5 * IQR
        UpperBound = Q3 + 1.5 * IQR

        df_no_outliers = df_no_outliers[(df_no_outliers[col] > LowerBound) & (df_no_outliers[col] < UpperBound)]

    return df_no_outliers


# In[35]:


t10_no_outliers=remove_outliers(t10,columns)


# In[36]:


t10_no_outliers.shape


# 
# # Task - 11:
# Identify and display the names of the movies along with their run times for those movies that have above average runtime, using the data from the previous task.

# In[37]:


t10_no_outliers[t10_no_outliers.runtime>t10_no_outliers.runtime.mean()][['title','runtime']]


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




