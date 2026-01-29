from pyspark.sql import SparkSession

# Assume 'spark' is already created
df = spark.table("students")
df.show()