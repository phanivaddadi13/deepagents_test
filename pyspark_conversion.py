from pyspark.sql import SparkSession

# Initialize Spark session
spark = SparkSession.builder.appName("SQLToPySpark").getOrCreate()

# Assuming 'students' is the name of your DataFrame
# If you need to create this DataFrame, you would typically read it from a data source
# For example: students = spark.read.format("csv").option("header", "true").load("path/to/students.csv")

# Perform the equivalent of "SELECT * FROM students"
result = spark.sql("SELECT * FROM students")

# Show the result (optional)
result.show()

# If you want to use the DataFrame API instead of spark.sql, you can do:
# result = students

# Don't forget to stop the Spark session when you're done
spark.stop()