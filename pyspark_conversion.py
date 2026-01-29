from pyspark.sql import SparkSession
from pyspark.sql.utils import AnalysisException

def convert_sql_to_pyspark(spark, table_name, limit=10):
    """
    Convert SQL query to PySpark and execute it.
    
    Args:
        spark (SparkSession): The active SparkSession.
        table_name (str): The name of the table to query.
        limit (int): The number of rows to display (default: 10).
    
    Returns:
        None
    """
    # Original SQL query:
    # select * from students

    try:
        # Check if the table exists
        if spark.catalog.tableExists(table_name):
            # Implement the query logic using PySpark DataFrame operations
            df = spark.table(table_name)
            
            # Display the first 'limit' rows of the result
            print(f"Displaying first {limit} rows of the '{table_name}' table:")
            df.show(n=limit, truncate=False)
        else:
            print(f"Error: The table '{table_name}' does not exist.")
    except AnalysisException as e:
        print(f"An error occurred while querying the table: {str(e)}")

# Example usage:
if __name__ == "__main__":
    # Create a SparkSession
    spark = SparkSession.builder.appName("SQL to PySpark Conversion").getOrCreate()
    
    # Call the function to execute the converted query
    convert_sql_to_pyspark(spark, "students")
    
    # Stop the SparkSession
    spark.stop()