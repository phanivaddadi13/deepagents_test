# PySpark equivalent of 'SELECT * FROM students'

# Assuming you have a SparkSession named 'spark'

# Read the 'students' table into a DataFrame
students_df = spark.table("students")

# Display the contents of the DataFrame
students_df.show()