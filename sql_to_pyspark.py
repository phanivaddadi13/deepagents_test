from pyspark.sql import SparkSession

# Create a SparkSession
spark = SparkSession.builder.appName("SQL to PySpark").getOrCreate()

# Assuming the 'customers' table is already available as a DataFrame or can be read from a data source
# If you need to read from a specific data source, you would add that code here

# Perform the equivalent of "SELECT * FROM customers"
result = spark.table("customers")

# Show the result (optional)
result.show()

# Stop the SparkSession
spark.stop()