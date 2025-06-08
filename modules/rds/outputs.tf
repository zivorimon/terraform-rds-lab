# --- פלטים (Outputs) של מודול RDS ---

# פלט: rds_instance_endpoint
# תיאור: כתובת ה-Endpoint של מופע ה-RDS.
# זוהי הכתובת שבה יישומים אחרים (לדוגמה, שרת ה-Web) יתחברו למסד הנתונים.
output "rds_instance_endpoint" {
  description = "The endpoint of the RDS instance."
  value       = aws_db_instance.main.address # ה-hostname של ה-RDS
}

# פלט: rds_instance_port
# תיאור: פורט החיבור של מופע ה-RDS.
output "rds_instance_port" {
  description = "The port of the RDS instance."
  value       = aws_db_instance.main.port
}

# פלט: rds_instance_arn
# תיאור: ה-ARN (Amazon Resource Name) של מופע ה-RDS.
# ARN משמש לזיהוי ייחודי של משאבים ב-AWS, שימושי עבור הרשאות IAM.
output "rds_instance_arn" {
  description = "The ARN of the RDS instance."
  value       = aws_db_instance.main.arn
}

# פלט: rds_security_group_id
# תיאור: ה-ID של ה-Security Group שיצרנו עבור ה-RDS.
output "rds_security_group_id" {
  description = "The ID of the Security Group for the RDS instance."
  value       = aws_security_group.rds_sg.id
}