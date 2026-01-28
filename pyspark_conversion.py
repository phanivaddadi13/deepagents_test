from pyspark.sql import SparkSession

# Initialize SparkSession
spark = SparkSession.builder.appName("SQL to PySpark Conversion").getOrCreate()

# Assuming 'students' is the name of your DataFrame
# If you need to create this DataFrame from a source, you would do so here
# For example: students = spark.read.csv("path_to_csv_file", header=True)

# Perform the equivalent of "SELECT * FROM students" in PySpark
result = spark.table("students")

# Show the result (optional)
result.show()

# To save the result to a file or table, you can use:
# result.write.saveAsTable("output_table_name")
# or
# result.write.csv("output_path")

# Don't forget to stop the SparkSession when you're done
spark.stop()