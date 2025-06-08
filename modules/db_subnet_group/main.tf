# --- יצירת DB Subnet Group ---

# משאב: aws_db_subnet_group.main
# תיאור: יוצר קבוצת תת-רשתות עבור מסד הנתונים של RDS.
# RDS דורש לפרוס את המופעים שלו על פני מספר תת-רשתות באזורי זמינות שונים
# כדי לאפשר פריסת Multi-AZ וזמינות גבוהה.
resource "aws_db_subnet_group" "main" {
  # name: שם ייחודי לקבוצת התת-רשתות.
  # חשוב לציין שהשם חייב להיות באותיות קטנות (lowercase).
  name       = "${var.project_name}-db-subnet-group"
  # subnet_ids: רשימת מזהי ה-ID של התת-רשתות שיכללו בקבוצה.
  # אנו משתמשים במשתנה 'private_subnet_ids' שקיבלנו כקלט.
  subnet_ids = var.private_subnet_ids
  # description: תיאור של קבוצת התת-רשתות, לתיעוד.
  description = "DB Subnet Group for the ${var.project_name} RDS instance"

  # tags: תגיות עבור קבוצת התת-רשתות.
  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name
  }
}