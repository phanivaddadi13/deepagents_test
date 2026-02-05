# SQL to PySpark Conversion

# SQL Query: select * from students
# PySpark equivalent:
students_df = spark.table("students")
result_df = students_df.select("*")

# Note: This code assumes that the 'students' table is already registered in the Spark catalog.
# If you need to create the DataFrame from a different source, you may need to modify the code accordingly.