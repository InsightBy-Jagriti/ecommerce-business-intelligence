from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "ecommerce_bi_dataset"

engine = create_engine(
    "mysql+pymysql://root:guriya@localhost:3306/eco"
)

customers = pd.read_csv(DATA_DIR / "customers.csv")
products = pd.read_csv(DATA_DIR / "products.csv")
orders = pd.read_csv(DATA_DIR / "orders.csv")
order_items = pd.read_csv(DATA_DIR / "order_items.csv")
payments = pd.read_csv(DATA_DIR / "payments.csv")
returns = pd.read_csv(DATA_DIR / "returns.csv")

customers.to_sql(
    "customers",
    engine,
    if_exists="replace",
    index=False
)

products.to_sql(
    "products",
    engine,
    if_exists="replace",
    index=False
)

orders.to_sql(
    "orders",
    engine,
    if_exists="replace",
    index=False
)

order_items.to_sql(
    "order_items",
    engine,
    if_exists="replace",
    index=False
)

payments.to_sql(
    "payments",
    engine,
    if_exists="replace",
    index=False
)

returns.to_sql(
    "returns",
    engine,
    if_exists="replace",
    index=False
)

print("All datasets uploaded successfully!")
