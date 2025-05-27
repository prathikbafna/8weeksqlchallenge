# import pandas as pd
# import plotly.express as px

# df = pd.read_csv('data/sample.csv')
# fig = px.scatter(df, x='quantity', y='value', text='item',
#                  title='Quantity vs. Value',
#                  labels={'quantity': 'Quantity', 'value': 'Value'})

# fig.update_traces(textposition='top center', marker=dict(size=12, color='lightblue'))
# fig.update_layout(template='plotly_white')

# # Displays
# import preswald

# preswald.text("# Welcome to Preswald!")
# preswald.text("This is your first app. 🎉")
# preswald.plotly(fig)
# preswald.table(df)

import pandas as pd
import plotly.express as px
from preswald import query
from preswald import table, text
from preswald import plotly
import preswald
import plotly.express as px


# df = pd.read_csv('data/PlayerIndex_nba_stats.csv')

from preswald import connect, get_df
connect()
df = get_df("data/PlayerIndex_nba_stats.csv")



sql = "SELECT * FROM data/PlayerIndex_nba_stats.csv where COUNTRY = 'France' "
filtered_df = query(sql, "data/PlayerIndex_nba_stats.csv")

# print(filtered_df)


text("# My Data Analysis App")
table(filtered_df, title="Filtered Data")





fig = px.scatter(filtered_df, x="PLAYER_SLUG", y="COUNTRY")

plotly(fig)
preswald.plot(fig)










