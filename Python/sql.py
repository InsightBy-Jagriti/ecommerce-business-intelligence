import mysql.connector

connection = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password="guriya",
    database="eco"
)

cursor = connection.cursor()

print("Connected successfully")
