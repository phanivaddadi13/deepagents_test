from pyspark.sql import SparkSession
from pyspark.sql.utils import AnalysisException

# This script demonstrates SQL-to-PySpark conversions and basic data analysis

# Initialize SparkSession with configuration
spark = SparkSession.builder \
    .appName("SQLToPySpark") \
    .config("spark.executor.memory", "2g") \
    .config("spark.driver.memory", "1g") \
    .getOrCreate()

try:
    # Load the students table
    # SQL equivalent: SELECT * FROM students
    df = spark.table("students")
    print("Original data:")
    df.show()

    # Filter and order data
    # SQL equivalent: SELECT name, age FROM students WHERE age > 18 ORDER BY age DESC
    df_filtered = df.select("name", "age") \
        .filter("age > 18") \
        .orderBy("age", ascending=False)
    print("Filtered and ordered data:")
    df_filtered.show()

    # Calculate average age
    avg_age = df.agg({"age": "avg"}).collect()[0][0]
    print(f"Average age: {avg_age:.2f}")

    # Group by grade and count students
    # SQL equivalent: SELECT grade, COUNT(*) as count FROM students GROUP BY grade ORDER BY grade
    grade_counts = df.groupBy("grade").count().orderBy("grade")
    print("Student count by grade:")
    grade_counts.show()

except AnalysisException as e:
    print(f"Error: {str(e)}")
    print("Make sure the 'students' table exists in the default database.")
finally:
    spark.stop()