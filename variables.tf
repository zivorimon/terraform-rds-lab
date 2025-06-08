# הגדרת משתנה עבור שם הפרויקט.
# זה יעזור לנו לתת שמות אחידים למשאבים ולתייג אותם.
variable "lab_160_rds_project" {
  description = "The name of the project, used for naming conventions and tags."
  type        = string
  default     = "terraform-rds-lab" # ערך ברירת מחדל. ניתן לשנות אותו.
}

# הגדרת משתנה עבור שם הפרויקט (כבר קיים משלב 1.3)
variable "project_name" {
  description = "The name of the project, used for naming conventions and tags."
  type        = string
  default     = "terraform-rds-lab"
}

# --- משתנים עבור הגדרות הרשת (VPC) ---

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16" # ערך ברירת מחדל
}

variable "public_subnet_1_cidr" {
  description = "The CIDR block for Public Subnet 1 in AZ A."
  type        = string
  default     = "10.0.0.0/24" # ערך ברירת מחדל
}

variable "private_subnet_1_cidr" {
  description = "The CIDR block for Private Subnet 1 in AZ A."
  type        = string
  default     = "10.0.1.0/24" # ערך ברירת מחדל
}

variable "public_subnet_2_cidr" {
  description = "The CIDR block for Public Subnet 2 in AZ B."
  type        = string
  default     = "10.0.2.0/24" # ערך ברירת מחדל
}

variable "private_subnet_2_cidr" {
  description = "The CIDR block for Private Subnet 2 in AZ B."
  type        = string
  default     = "10.0.3.0/24" # ערך ברירת מחדל
}

variable "az_a_name" {
  description = "The name of Availability Zone A (e.g., us-east-1a)."
  type        = string
  default     = "us-east-1a" # ערך ברירת מחדל. ודא שזהו AZ חוקי באזור שלך.
}

variable "az_b_name" {
  description = "The name of Availability Zone B (e.g., us-east-1b)."
  type        = string
  default     = "us-east-1b" # ערך ברירת מחדל. ודא שזהו AZ חוקי באזור שלך.
}


# --- משתנים עבור הגדרות RDS ---

variable "db_engine" {
  description = "The database engine (e.g., mysql, postgres, aurora)."
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The database engine version."
  type        = string
  default     = "8.0.35"
}

variable "db_instance_class" {
  description = "The DB instance class (e.g., db.t3.micro)."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage in GB for the DB instance."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "The master username for the DB instance."
  type        = string
  # אין default כאן, המשתמש חייב לספק את זה.
}

variable "db_password" {
  description = "The master password for the DB instance."
  type        = string
  sensitive   = true
  # אין default כאן, המשתמש חייב לספק את זה.
}

variable "db_multi_az" {
  description = "Specifies if the DB instance is a Multi-AZ deployment."
  type        = bool
  default     = true
}

variable "db_publicly_accessible" {
  description = "Specifies if the DB instance is publicly accessible."
  type        = bool
  default     = false
}

# משתנה זה הוא קריטי, כרגע נשאיר אותו ריק.
# בעתיד (במידה ונבנה מודול לאפליקציה/EC2),
# נכניס לכאן את ה-ID של ה-Security Group של האפליקציה.
variable "allowed_security_group_ids" {
  description = "List of Security Group IDs that can access the RDS instance."
  type        = list(string)
  default     = []
}

