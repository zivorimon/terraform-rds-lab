# משתנה: vpc_cidr_block
# תיאור: בלוק ה-CIDR הראשי עבור ה-VPC. זה קובע את טווח כתובות ה-IP של הרשת כולה.
# סוג: מחרוזת (string)
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

# משתנה: public_subnet_1_cidr
# תיאור: בלוק ה-CIDR עבור תת-רשת ציבורית ראשונה באזור זמינות A (AZ A).
# תת-רשתות ציבוריות מכילות משאבים שפונים לאינטרנט.
# סוג: מחרוזת (string)
variable "public_subnet_1_cidr" {
  description = "The CIDR block for Public Subnet 1 in AZ A."
  type        = string
}

# משתנה: private_subnet_1_cidr
# תיאור: בלוק ה-CIDR עבור תת-רשת פרטית ראשונה באזור זמינות A (AZ A).
# תת-רשתות פרטיות מכילות משאבים שאינם חשופים ישירות לאינטרנט (לדוגמה, מסדי נתונים).
# סוג: מחרוזת (string)
variable "private_subnet_1_cidr" {
  description = "The CIDR block for Private Subnet 1 in AZ A."
  type        = string
}

# משתנה: public_subnet_2_cidr
# תיאור: בלוק ה-CIDR עבור תת-רשת ציבורית שנייה באזור זמינות B (AZ B).
# אנו משתמשים בשני אזורי זמינות כדי להבטיח זמינות גבוהה.
# סוג: מחרוזת (string)
variable "public_subnet_2_cidr" {
  description = "The CIDR block for Public Subnet 2 in AZ B."
  type        = string
}

# משתנה: private_subnet_2_cidr
# תיאור: בלוק ה-CIDR עבור תת-רשת פרטית שנייה באזור זמינות B (AZ B).
# סוג: מחרוזת (string)
variable "private_subnet_2_cidr" {
  description = "The CIDR block for Private Subnet 2 in AZ B."
  type        = string
}

# משתנה: az_a_name
# תיאור: שם אזור הזמינות הראשון. זהו שם ייחודי לכל אזור (לדוגמה, us-east-1a).
# חשוב להגדיר את זה כדי לפרוס משאבים באופן ספציפי.
# סוג: מחרוזת (string)
variable "az_a_name" {
  description = "The name of Availability Zone A (e.g., us-east-1a)."
  type        = string
}

# משתנה: az_b_name
# תיאור: שם אזור הזמינות השני.
# סוג: מחרוזת (string)
variable "az_b_name" {
  description = "The name of Availability Zone B (e.g., us-east-1b)."
  type        = string
}

# משתנה: project_name
# תיאור: שם הפרויקט, שישמש לתיוג (tags) ומתן שמות למשאבים.
# סוג: מחרוזת (string)
variable "project_name" {
  description = "The name of the project, used for naming conventions and tags."
  type        = string
}