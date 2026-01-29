from pyspark.sql import SparkSession

# Initialize SparkSession
spark = SparkSession.builder.appName("SQL to PySpark Conversion").getOrCreate()

# Assuming 'students' is the name of your DataFrame
# If you need to create this DataFrame, you would typically read it from a file or database
# For example: students = spark.read.csv("students.csv", header=True, inferSchema=True)

# Perform the equivalent of "select * from students" in PySpark
result = spark.table("students")

# Show the result (optional)
result.show()

# Stop the SparkSession
spark.stop()