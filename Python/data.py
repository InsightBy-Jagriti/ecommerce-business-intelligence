import mysql.connector

import pandas as pd
import numpy as np
from pathlib import Path

rng = np.random.default_rng(42)

OUTPUT_DIR = Path("ecommerce_bi_dataset")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

N_CUSTOMERS = 8000
N_PRODUCTS = 1000
N_ORDERS = 20000
N_ORDER_ITEMS = 50000
N_PAYMENTS = 20000
N_RETURNS = 4000

FIRST_NAMES = [
    "Arjun", "Riya", "Aarav", "Ananya", "Rahul",
    "Priya", "Rohan", "Sneha", "Aditya", "Ishita",
    "Vikram", "Neha", "Karan", "Pooja", "Amit",
    "Kavya", "Sahil", "Meera", "Nikhil", "Tanya"
]

LAST_NAMES = [
    "Sharma", "Das", "Patel", "Singh", "Roy",
    "Gupta", "Sen", "Khan", "Verma", "Banerjee",
    "Iyer", "Mehta", "Ghosh", "Nair", "Chatterjee",
    "Jain", "Bose", "Malhotra", "Dutta", "Reddy"
]

LOCATIONS = {
    "West Bengal": ("Kolkata", "East"),
    "Maharashtra": ("Mumbai", "West"),
    "Karnataka": ("Bengaluru", "South"),
    "Tamil Nadu": ("Chennai", "South"),
    "Telangana": ("Hyderabad", "South"),
    "Delhi": ("New Delhi", "North"),
    "Gujarat": ("Ahmedabad", "West"),
    "Rajasthan": ("Jaipur", "North"),
    "Uttar Pradesh": ("Lucknow", "North"),
    "Bihar": ("Patna", "East"),
    "Odisha": ("Bhubaneswar", "East"),
    "Kerala": ("Kochi", "South"),
    "Punjab": ("Ludhiana", "North"),
    "Haryana": ("Gurugram", "North"),
    "Madhya Pradesh": ("Bhopal", "Central")
}

STATES = list(LOCATIONS.keys())

STATE_PROBABILITIES = np.array([
    0.12, 0.12, 0.10, 0.08, 0.08,
    0.08, 0.07, 0.05, 0.08, 0.04,
    0.04, 0.04, 0.03, 0.04, 0.03
])

STATE_PROBABILITIES /= STATE_PROBABILITIES.sum()

CATEGORIES = {
    "Electronics": [
        "Audio", "Mobiles", "Computing",
        "Cameras", "Accessories"
    ],
    "Home & Kitchen": [
        "Kitchen", "Furniture", "Appliances",
        "Decor", "Storage"
    ],
    "Fashion": [
        "Men's Wear", "Women's Wear",
        "Footwear", "Bags", "Accessories"
    ],
    "Beauty": [
        "Skincare", "Haircare", "Makeup",
        "Fragrance", "Personal Care"
    ],
    "Sports": [
        "Fitness", "Outdoor", "Team Sports",
        "Cycling", "Yoga"
    ],
    "Books": [
        "Fiction", "Non-Fiction",
        "Academic", "Children", "Comics"
    ],
    "Grocery": [
        "Staples", "Snacks", "Beverages",
        "Organic", "Household"
    ],
    "Accessories": [
        "Watches", "Jewelry", "Travel",
        "Stationery", "Gadgets"
    ]
}

CATEGORY_NAMES = list(CATEGORIES.keys())

CATEGORY_PROBABILITIES = np.array([
    0.18, 0.15, 0.17, 0.10,
    0.10, 0.10, 0.12, 0.08
])

BRAND_POOL = [
    "NovaTech", "SoundMax", "PixelPro",
    "TechEdge", "Voltix", "HomeCraft",
    "KitchenPro", "UrbanNest", "UrbanWear",
    "StyleHub", "TrendLine", "GlowCare",
    "PureSkin", "FitPro", "TrailMaster",
    "PageTurner", "ReadMore", "DailyFresh",
    "PureHarvest", "TimeCraft", "TravelMate"
]

SUPPLIERS = [
    "PrimeSupply",
    "GlobalTrade",
    "RetailSource",
    "MetroDistributors",
    "ValueChain"
]

PAYMENT_METHODS = [
    "UPI",
    "Credit Card",
    "Debit Card",
    "Net Banking",
    "Cash on Delivery",
    "Wallet"
]

RETURN_REASONS = [
    "Damaged Product",
    "Wrong Product",
    "Poor Quality",
    "Size Issue",
    "Changed Mind",
    "Late Delivery",
    "Not as Expected"
]


def create_customers():

    customer_ids = np.arange(
        10001,
        10001 + N_CUSTOMERS
    )

    customer_states = rng.choice(
        STATES,
        size=N_CUSTOMERS,
        p=STATE_PROBABILITIES
    )

    signup_dates = (
        pd.Timestamp("2023-01-01")
        + pd.to_timedelta(
            rng.integers(
                0,
                1080,
                N_CUSTOMERS
            ),
            unit="D"
        )
    )

    return pd.DataFrame({

        "customer_id": customer_ids,

        "first_name": rng.choice(
            FIRST_NAMES,
            N_CUSTOMERS
        ),

        "last_name": rng.choice(
            LAST_NAMES,
            N_CUSTOMERS
        ),

        "gender": rng.choice(
            ["Male", "Female", "Other"],
            N_CUSTOMERS,
            p=[0.49, 0.49, 0.02]
        ),

        "age": rng.integers(
            18,
            66,
            N_CUSTOMERS
        ),

        "city": [
            LOCATIONS[state][0]
            for state in customer_states
        ],

        "state": customer_states,

        "region": [
            LOCATIONS[state][1]
            for state in customer_states
        ],

        "customer_segment": rng.choice(
            [
                "Consumer",
                "Corporate",
                "Small Business"
            ],
            N_CUSTOMERS,
            p=[0.68, 0.17, 0.15]
        ),

        "signup_date": signup_dates
    })


def create_products():

    product_categories = rng.choice(
        CATEGORY_NAMES,
        N_PRODUCTS,
        p=CATEGORY_PROBABILITIES
    )

    subcategories = [
        rng.choice(CATEGORIES[category])
        for category in product_categories
    ]

    brands = rng.choice(
        BRAND_POOL,
        N_PRODUCTS
    )

    price_ranges = {
        "Electronics": (1800, 9000),
        "Home & Kitchen": (500, 6500),
        "Fashion": (400, 3500),
        "Beauty": (250, 2200),
        "Sports": (400, 4500),
        "Books": (150, 1200),
        "Grocery": (80, 1200),
        "Accessories": (200, 3000)
    }

    prices = []
    costs = []

    for category in product_categories:

        minimum, maximum = price_ranges[category]

        price = np.exp(
            rng.uniform(
                np.log(minimum),
                np.log(maximum)
            )
        )

        margin = rng.uniform(0.12, 0.42)

        prices.append(round(price, 2))
        costs.append(round(price * (1 - margin), 2))

    return pd.DataFrame({

        "product_id": np.arange(
            5001,
            5001 + N_PRODUCTS
        ),

        "product_name": [
            f"{brands[i]} {subcategories[i]} {i + 1}"
            for i in range(N_PRODUCTS)
        ],

        "category": product_categories,

        "subcategory": subcategories,

        "brand": brands,

        "supplier": rng.choice(
            SUPPLIERS,
            N_PRODUCTS
        ),

        "unit_cost": costs,

        "selling_price": prices,

        "launch_date": (
            pd.Timestamp("2023-01-01")
            + pd.to_timedelta(
                rng.integers(
                    0,
                    1000,
                    N_PRODUCTS
                ),
                unit="D"
            )
        )
    })


def create_orders(customers):

    customer_ids = customers["customer_id"].to_numpy()

    customer_weights = rng.lognormal(
        0,
        1.0,
        N_CUSTOMERS
    )

    customer_weights /= customer_weights.sum()

    order_customer_ids = rng.choice(
        customer_ids,
        N_ORDERS,
        p=customer_weights
    )

    customer_lookup = customers.set_index(
        "customer_id"
    )

    order_dates = []

    for customer_id in order_customer_ids:

        signup_date = customer_lookup.loc[
            customer_id,
            "signup_date"
        ]

        start_date = max(
            pd.Timestamp("2023-01-01"),
            signup_date
        )

        end_date = pd.Timestamp("2025-12-31")

        available_days = max(
            1,
            (end_date - start_date).days
        )

        random_day = rng.integers(
            0,
            available_days + 1
        )

        order_dates.append(
            start_date
            + pd.Timedelta(
                days=int(random_day)
            )
        )

    order_dates = pd.Series(
        pd.to_datetime(order_dates)
    )

    order_statuses = rng.choice(
        [
            "Delivered",
            "Shipped",
            "Processing",
            "Cancelled"
        ],
        N_ORDERS,
        p=[0.84, 0.08, 0.05, 0.03]
    )

    order_states = customer_lookup.loc[
        order_customer_ids,
        "state"
    ].to_numpy()

    shipping_cost = rng.uniform(
        45,
        280,
        N_ORDERS
    )

    remote_states = np.isin(
        order_states,
        [
            "Rajasthan",
            "Bihar",
            "Odisha",
            "Kerala"
        ]
    )

    shipping_cost += (
        remote_states
        * rng.uniform(
            20,
            90,
            N_ORDERS
        )
    )

    delivery_days = np.clip(
        rng.normal(
            4.5,
            2,
            N_ORDERS
        )
        +
        remote_states
        * rng.uniform(
            1,
            3,
            N_ORDERS
        ),
        1,
        14
    ).round().astype(int)

    delivery_dates = (
        order_dates
        + pd.to_timedelta(
            delivery_days,
            unit="D"
        )
    ).to_numpy(
        dtype="datetime64[ns]"
    )

    no_delivery = np.isin(
        order_statuses,
        [
            "Cancelled",
            "Processing"
        ]
    )

    delivery_dates[no_delivery] = np.datetime64("NaT")

    return pd.DataFrame({

        "order_id": np.arange(
            200001,
            200001 + N_ORDERS
        ),

        "customer_id": order_customer_ids,

        "order_date": order_dates,

        "order_status": order_statuses,

        "shipping_city": customer_lookup.loc[
            order_customer_ids,
            "city"
        ].to_numpy(),

        "shipping_state": order_states,

        "shipping_region": customer_lookup.loc[
            order_customer_ids,
            "region"
        ].to_numpy(),

        "shipping_cost": np.round(
            shipping_cost,
            2
        ),

        "delivery_date": pd.to_datetime(
            delivery_dates
        ),

        "payment_id": np.arange(
            300001,
            300001 + N_ORDERS
        )
    })


def create_order_items(orders, products):

    item_counts = np.ones(
        N_ORDERS,
        dtype=int
    )

    while item_counts.sum() < N_ORDER_ITEMS:

        index = rng.integers(
            0,
            N_ORDERS
        )

        if item_counts[index] < 5:
            item_counts[index] += 1

    item_order_ids = np.repeat(
        orders["order_id"].to_numpy(),
        item_counts
    )

    product_weights = rng.lognormal(
        0,
        0.65,
        N_PRODUCTS
    )

    product_weights /= product_weights.sum()

    item_product_ids = rng.choice(
        products["product_id"].to_numpy(),
        N_ORDER_ITEMS,
        p=product_weights
    )

    product_lookup = products.set_index(
        "product_id"
    )

    unit_prices = product_lookup.loc[
        item_product_ids,
        "selling_price"
    ].to_numpy()

    unit_costs = product_lookup.loc[
        item_product_ids,
        "unit_cost"
    ].to_numpy()

    categories = product_lookup.loc[
        item_product_ids,
        "category"
    ].to_numpy()

    quantities = rng.choice(
        [1, 2, 3, 4, 5],
        N_ORDER_ITEMS,
        p=[0.62, 0.22, 0.10, 0.04, 0.02]
    )

    discounts = rng.uniform(
        0.02,
        0.16,
        N_ORDER_ITEMS
    )

    discounts += np.where(
        categories == "Fashion",
        rng.uniform(
            0.03,
            0.10,
            N_ORDER_ITEMS
        ),
        0
    )

    discounts += np.where(
        categories == "Electronics",
        rng.uniform(
            0,
            0.04,
            N_ORDER_ITEMS
        ),
        0
    )

    discounts = np.clip(
        discounts,
        0,
        0.35
    )

    gross_sales = (
        quantities
        * unit_prices
    )

    discount_amount = (
        gross_sales
        * discounts
    )

    sales_amount = (
        gross_sales
        - discount_amount
    )

    cost_amount = (
        quantities
        * unit_costs
    )

    profit_amount = (
        sales_amount
        - cost_amount
    )

    return pd.DataFrame({

        "order_item_id": np.arange(
            1,
            N_ORDER_ITEMS + 1
        ),

        "order_id": item_order_ids,

        "product_id": item_product_ids,

        "quantity": quantities,

        "unit_price": np.round(
            unit_prices,
            2
        ),

        "discount_percent": np.round(
            discounts * 100,
            2
        ),

        "discount_amount": np.round(
            discount_amount,
            2
        ),

        "sales_amount": np.round(
            sales_amount,
            2
        ),

        "cost_amount": np.round(
            cost_amount,
            2
        ),

        "profit_amount": np.round(
            profit_amount,
            2
        )
    })


def create_payments(orders, order_items):

    payment_methods = rng.choice(
        PAYMENT_METHODS,
        N_PAYMENTS,
        p=[
            0.31,
            0.23,
            0.16,
            0.10,
            0.13,
            0.07
        ]
    )

    payment_status = np.where(
        orders["order_status"].to_numpy()
        == "Cancelled",
        "Failed",
        rng.choice(
            ["Paid", "Pending"],
            N_PAYMENTS,
            p=[0.97, 0.03]
        )
    )

    order_totals = (
        order_items
        .groupby("order_id")["sales_amount"]
        .sum()
        .reindex(
            orders["order_id"]
        )
        .fillna(0)
    )

    return pd.DataFrame({

        "payment_id": orders["payment_id"],

        "order_id": orders["order_id"],

        "payment_date": orders["order_date"],

        "payment_method": payment_methods,

        "payment_status": payment_status,

        "transaction_amount": np.round(
            order_totals.to_numpy(),
            2
        )
    })


def create_returns(orders, order_items, products):

    delivered_orders = orders.loc[
        orders["order_status"] == "Delivered",
        "order_id"
    ].to_numpy()

    return_order_ids = rng.choice(
        delivered_orders,
        N_RETURNS,
        replace=False
    )

    product_lookup = products.set_index(
        "product_id"
    )

    records = []

    for return_id, order_id in enumerate(
        return_order_ids,
        start=1
    ):

        order_items_for_order = order_items[
            order_items["order_id"] == order_id
        ]

        product_id = int(
            rng.choice(
                order_items_for_order[
                    "product_id"
                ].to_numpy()
            )
        )

        category = product_lookup.loc[
            product_id,
            "category"
        ]

        if category == "Fashion":

            probabilities = [
                0.06, 0.08, 0.10,
                0.32, 0.14, 0.15, 0.15
            ]

        else:

            probabilities = [
                0.08, 0.10, 0.12,
                0.08, 0.15, 0.15, 0.32
            ]

        probabilities = (
            np.array(probabilities)
            / sum(probabilities)
        )

        order_date = orders.loc[
            orders["order_id"] == order_id,
            "order_date"
        ].iloc[0]

        return_date = (
            order_date
            + pd.Timedelta(
                days=int(
                    rng.integers(
                        3,
                        31
                    )
                )
            )
        )

        refund_amount = (
            order_items_for_order.loc[
                order_items_for_order["product_id"]
                == product_id,
                "sales_amount"
            ].sum()
        )

        records.append({

            "return_id": return_id,

            "order_id": order_id,

            "product_id": product_id,

            "return_date": return_date,

            "return_reason": rng.choice(
                RETURN_REASONS,
                p=probabilities
            ),

            "refund_amount": round(
                float(refund_amount),
                2
            ),

            "return_status": rng.choice(
                [
                    "Approved",
                    "Processed",
                    "Rejected"
                ],
                p=[0.72, 0.23, 0.05]
            )
        })

    return pd.DataFrame(records)


def save_dataset(name, dataframe):

    dataframe.to_csv(
        OUTPUT_DIR / f"{name}.csv",
        index=False
    )

    print(
        f"{name}: "
        f"{len(dataframe):,} rows"
    )


def create_data_dictionary(tables):

    records = []

    for table_name, dataframe in tables.items():

        for column in dataframe.columns:

            records.append({

                "table": table_name,

                "column": column,

                "data_type": str(
                    dataframe[column].dtype
                ),

                "rows": len(dataframe),

                "missing_values": int(
                    dataframe[column].isna().sum()
                ),

                "unique_values": int(
                    dataframe[column].nunique()
                )
            })

    dictionary = pd.DataFrame(records)

    dictionary.to_csv(
        OUTPUT_DIR / "data_dictionary.csv",
        index=False
    )


def main():

    print("Creating datasets...\n")

    customers = create_customers()

    products = create_products()

    orders = create_orders(
        customers
    )

    order_items = create_order_items(
        orders,
        products
    )

    payments = create_payments(
        orders,
        order_items
    )

    returns = create_returns(
        orders,
        order_items,
        products
    )

    tables = {
        "customers": customers,
        "products": products,
        "orders": orders,
        "order_items": order_items,
        "payments": payments,
        "returns": returns
    }

    for name, dataframe in tables.items():

        save_dataset(
            name,
            dataframe
        )

    create_data_dictionary(tables)

    readme = f"""
E-Commerce Business Intelligence Dataset

Workflow:
Excel -> SQL -> Power BI

Tables:
customers: {len(customers):,}
products: {len(products):,}
orders: {len(orders):,}
order_items: {len(order_items):,}
payments: {len(payments):,}
returns: {len(returns):,}

Total rows: {sum(len(df) for df in tables.values()):,}

Relationships:

orders.customer_id -> customers.customer_id
orders.payment_id -> payments.payment_id
order_items.order_id -> orders.order_id
order_items.product_id -> products.product_id
payments.order_id -> orders.order_id
returns.order_id -> orders.order_id
returns.product_id -> products.product_id
"""

    with open(
        OUTPUT_DIR / "README.txt",
        "w",
        encoding="utf-8"
    ) as file:

        file.write(readme)

    print("\nDone.")
    print(
        f"Files saved in: "
        f"{OUTPUT_DIR.resolve()}"
    )


if __name__ == "__main__":
    main()