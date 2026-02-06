from pyspark.sql import SparkSession

# Initialize Spark session
spark = SparkSession.builder.appName("UserDataQuery").getOrCreate()

# Assuming the 'users' table is available as a Spark DataFrame
# If it's not, you'd need to load it from a data source

# Perform the query
result = spark.table("users")

# Show the results (you can adjust the number of rows to display)
result.show()

# Optional: If you want to save the results
# result.write.format("parquet").save("path/to/output")

# Stop the Spark session
spark.stop()