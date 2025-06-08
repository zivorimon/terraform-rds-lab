# --- משתנים (Inputs) עבור מודול RDS ---

# משתנה: project_name
# תיאור: שם הפרויקט, ישמש לתיוג ומתן שמות למשאבים.
variable "project_name" {
  description = "The name of the project, used for naming conventions and tags."
  type        = string
}

# משתנה: vpc_id
# תיאור: מזהה ה-ID של ה-VPC שבו RDS יפרוס.
# זהו קלט שיגיע מפלט מודול ה-VPC.
variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be deployed."
  type        = string
}

# משתנה: db_subnet_group_name
# תיאור: שם קבוצת התת-רשתות של ה-RDS.
# זהו קלט שיגיע מפלט מודול ה-DB Subnet Group.
variable "db_subnet_group_name" {
  description = "The name of the DB Subnet Group for RDS."
  type        = string
}

# משתנה: db_engine
# תיאור: סוג מנוע מסד הנתונים (לדוגמה: mysql, postgres, aurora).
variable "db_engine" {
  description = "The database engine (e.g., mysql, postgres, aurora)."
  type        = string
  default     = "mysql" # ערך ברירת מחדל
}

# משתנה: db_engine_version
# תיאור: גרסת מנוע מסד הנתונים.
variable "db_engine_version" {
  description = "The database engine version."
  type        = string
  default     = "8.0.35" # ערך ברירת מחדל, ודא שזו גרסה זמינה באזור שלך.
}

# משתנה: db_instance_class
# תיאור: סוג מופע ה-RDS (לדוגמה: db.t3.micro, db.m5.large).
variable "db_instance_class" {
  description = "The DB instance class (e.g., db.t3.micro)."
  type        = string
  default     = "db.t3.micro" # ערך ברירת מחדל, ודא שזה מתאים לצרכים שלך.
}

# משתנה: db_allocated_storage
# תיאור: כמות האחסון המוקצה למסד הנתונים ב-GB.
variable "db_allocated_storage" {
  description = "The allocated storage in GB for the DB instance."
  type        = number
  default     = 20 # 20GB כברירת מחדל
}

# משתנה: db_name
# תיאור: השם של מסד הנתונים הראשוני שייווצר בתוך מופע ה-RDS.
variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "mydb" # ערך ברירת מחדל
}

# משתנה: db_username
# תיאור: שם המשתמש הראשי למסד הנתונים.
variable "db_username" {
  description = "The master username for the DB instance."
  type        = string
}

# משתנה: db_password
# תיאור: סיסמת המשתמש הראשי למסד הנתונים.
# אזהרה: לא מומלץ להגדיר סיסמאות כברירת מחדל או לקודד אותן ישירות בקוד.
# יש להשתמש ב-terraform.tfvars, משתני סביבה או secrets management.
variable "db_password" {
  description = "The master password for the DB instance."
  type        = string
  sensitive   = true # מציין שזהו נתון רגיש, ו-Terraform יצנזר אותו בפלט.
}

# משתנה: db_multi_az
# תיאור: האם לפרוס את מסד הנתונים במצב Multi-AZ לזמינות גבוהה.
variable "db_multi_az" {
  description = "Specifies if the DB instance is a Multi-AZ deployment."
  type        = bool
  default     = true # מומלץ לזמינות גבוהה
}

# משתנה: db_publicly_accessible
# תיאור: האם לאפשר גישה ציבורית ל-RDS.
# בדרך כלל, לא מומלץ לאפשר גישה ציבורית למסד נתונים.
variable "db_publicly_accessible" {
  description = "Specifies if the DB instance is publicly accessible."
  type        = bool
  default     = false # מומלץ שלא
}

# משתנה: allowed_security_group_ids
# תיאור: רשימת Security Group ID-ים שיורשו לגשת ל-RDS.
# בדרך כלל, ה-Security Group של שרת ה-Web/Application.
variable "allowed_security_group_ids" {
  description = "List of Security Group IDs that can access the RDS instance."
  type        = list(string)
  default     = [] # ברירת מחדל: אף אחד לא יכול לגשת
}