from pyspark.sql import functions as F

# Create DataFrames from tables
orders_df = spark.table("orders")
customers_df = spark.table("customers")

# Filter orders and join with customers
filtered_orders = orders_df.filter(
    (F.col("order_date") >= F.lit("2024-01-01")) &
    (F.col("status") == F.lit("COMPLETED"))
)

joined_df = filtered_orders.join(
    customers_df,
    filtered_orders.customer_id == customers_df.customer_id,
    "inner"
)

# Add row number and filter for latest order
window_spec = F.Window.partitionBy("customer_id").orderBy(F.col("order_date").desc())

ranked_orders = joined_df.withColumn("rn", F.row_number().over(window_spec))

df_result = ranked_orders.filter(F.col("rn") == 1).select(
    F.col("customer_id"),
    F.col("customer_name"),
    F.col("country"),
    F.col("order_id").alias("latest_order_id"),
    F.col("order_date").alias("latest_order_date"),
    F.col("amount").alias("latest_order_amount")
).orderBy(F.col("amount").desc())
