import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:guriya@localhost:3306/eco"
)

query = """
SELECT *
FROM vw_ecommerce_analysis
"""

df = pd.read_sql(query, engine)

print(f"Rows exported: {len(df)}")

df.to_csv(
    "../Data/vw_ecommerce_analysis.csv",
    index=False
)

df.to_excel(
    "../Data/vw_ecommerce_analysis.xlsx",
    index=False
)

print("Export completed successfully")
