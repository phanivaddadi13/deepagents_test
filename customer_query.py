from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("CustomerQuery").getOrCreate()

customers_df = spark.table("customers")
customers_df.show()
