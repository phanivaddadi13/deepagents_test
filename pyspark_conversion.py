from pyspark.sql import SparkSession
from pyspark.sql.functions import avg

# Create a SparkSession
spark = SparkSession.builder.appName("AverageAgeCalculation").getOrCreate()

# Assuming the students table is already available as a DataFrame named 'students'
# If not, you would need to load it first

# Calculate the average age
result = students.agg(avg("age").alias("average_age"))

# Show the result
result.show()