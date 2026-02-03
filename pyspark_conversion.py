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

# Perform the equivalent of SELECT * FROM students
result = spark.table("students")

# Show the result (optional)
result.show()

# To save the result to a new table or file, you can use:
# result.write.saveAsTable("new_students_table")
# or
# result.write.csv("output_path")

# Don't forget to stop the SparkSession when you're done
spark.stop()