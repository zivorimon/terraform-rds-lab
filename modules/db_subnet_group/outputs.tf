# --- פלטים (Outputs) של מודול DB Subnet Group ---

# פלט: db_subnet_group_name
# תיאור: שם קבוצת התת-רשתות של ה-RDS שנוצרה.
# מודול ה-RDS יצטרך את השם הזה כדי להתייחס לקבוצה.
output "db_subnet_group_name" {
  description = "The name of the DB Subnet Group."
  value       = aws_db_subnet_group.main.name # הפניה לשם של המשאב
}