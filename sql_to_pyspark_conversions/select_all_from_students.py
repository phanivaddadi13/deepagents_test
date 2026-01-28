# SQL to PySpark Conversion
# Original SQL query: select * from students

from pyspark.sql import SparkSession

# Create a SparkSession (if not already created)
spark = SparkSession.builder.appName("SQL to PySpark Conversion").getOrCreate()

# Assuming the 'students' table is already available as a DataFrame
# If not, you would need to load it from a data source

# PySpark equivalent of the SQL query
result = spark.table("students")

# Show the result (optional)
result.show()

# Note: Make sure to stop the SparkSession when you're done
# spark.stop()