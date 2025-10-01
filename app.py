from flask import Flask
import os
import boto3
import json


app = Flask(__name__)

def get_db_creds():
    secret_name = os.environ["DB_SECRET_ARN"]
    region_name = os.environ["AWS_REGION"]
    client = boto3.client("secretsmanager", region_name=region_name)
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response["SecretString"])
    return secret["username"], secret["password"]

@app.route("/")
def hello():
    user, password = get_db_creds()
    return f"Hello from Flask! Using DB user: {user}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
