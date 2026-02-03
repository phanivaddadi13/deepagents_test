from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("SQLToPySpark").getOrCreate()

df = spark.table("students")
df.show()