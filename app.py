from flask import Flask
import os
import boto3
import json
import mysql.connector
from mysql.connector import Error


app = Flask(__name__)

def get_db_creds():
    secret_name = os.environ["DB_SECRET_ARN"]
    region_name = os.environ["AWS_REGION"]
    client = boto3.client("secretsmanager", region_name=region_name)
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response["SecretString"])
    return secret["username"], secret["password"], secret["host"], secret["database"]

def create_connection():
    """
    Establishes a connection to the MySQL RDS database using credentials from AWS Secrets Manager.
    """
    user, password, host, database = get_db_creds()
    
    try:
        connection = mysql.connector.connect(
            host=host,  # RDS endpoint (example: mydbinstance.xxxxxxxxxxxx.us-west-2.rds.amazonaws.com)
            user=user,
            password=password,
            database=database
        )
        
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Error: {e}")
        return None


@app.route("/")
def hello():
    connection = create_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("SELECT DATABASE();")  # Just a simple query to check
        db_name = cursor.fetchone()
        connection.close()
        return f"Hello from Flask! Connected to database: {db_name[0]}"
    else:
        return "Failed to connect to the database."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
