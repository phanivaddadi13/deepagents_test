from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("CustomerQuery").getOrCreate()

df = spark.table("customers")
df.show()