# SQL to PySpark Conversion

# Original SQL query:
# select * from students

# PySpark equivalent:
from pyspark.sql import SparkSession

# Create a SparkSession
spark = SparkSession.builder.appName("SQLToPySpark").getOrCreate()

# Assuming 'students' is the name of your DataFrame
# If you need to create it from a source, you would do so here
# For example: students = spark.read.csv("students.csv", header=True)

# Perform the equivalent of 'SELECT *' in PySpark
result = spark.table("students")

# Show the result (optional)
result.show()

# Note: In a real-world scenario, you might want to do something with 'result'
# such as writing it to a file, performing further transformations, etc.

# Don't forget to stop the SparkSession when you're done
spark.stop()