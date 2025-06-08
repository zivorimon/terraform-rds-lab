# --- משתנים (Inputs) עבור מודול DB Subnet Group ---

# משתנה: private_subnet_ids
# תיאור: רשימת ה-IDs של התת-רשתות הפרטיות שבהן ישכון ה-RDS.
# זהו קלט קריטי שיגיע מפלט מודול ה-VPC.
variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the DB subnet group."
  type        = list(string) # סוג: רשימה של מחרוזות (IDs של Subnets)
}

# משתנה: project_name
# תיאור: שם הפרויקט, ישמש לתיוג המשאבים.
variable "project_name" {
  description = "The name of the project, used for naming conventions."
  type        = string
}