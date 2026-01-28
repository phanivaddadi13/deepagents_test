from pyspark.sql import SparkSession

# Create a SparkSession
spark = SparkSession.builder.appName("SQLtoPySpark").getOrCreate()

# Assuming 'students' is the name of your DataFrame
# If it's a table in a database, you would need to load it first
# For example: students = spark.read.table("students")

# Perform the selection
result = spark.sql("SELECT * FROM students")

# Show the result (optional)
result.show()

# Stop the SparkSession
spark.stop()