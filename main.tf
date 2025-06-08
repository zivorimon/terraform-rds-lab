# --- קריאה למודול ה-VPC ---

# בלוק המודול שקורא למודול ה-VPC שיצרנו.
# זהו המקום בו אנו "משתמשים" במודול שלנו.
module "vpc" {
  # source: הנתיב (path) לתיקייה שבה נמצא מודול ה-VPC.
  # הנתיב הוא יחסי למיקום של קובץ main.tf זה.
  source = "./modules/vpc"

  # העברת משתנים (inputs) למודול ה-VPC.
  # אנו מעבירים את הערכים של המשתנים הגלובליים (שהוגדרו ב-variables.tf הראשי)
  # כקלטים למשתנים התואמים במודול ה-VPC.
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_1_cidr = var.public_subnet_1_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  az_a_name           = var.az_a_name
  az_b_name           = var.az_b_name
  project_name        = var.project_name
}

# --- פלטים (Outputs) ברמת הפרויקט הראשי ---
# אנו מציגים כאן חלק מהפלטים של מודול ה-VPC.
# זה מאפשר לנו לראות את המידע החשוב לאחר פריסה
# וגם להשתמש בו במודולים עתידיים ברמה העליונה.

# פלט: main_vpc_id
# תיאור: מזהה ה-ID של ה-VPC שנוצר על ידי מודול ה-VPC.
# הגישה לפלט של מודול נעשית באמצעות: module.<שם_המודול>.<שם_הפלט_בתוך_המודול>
output "main_vpc_id" {
  description = "The ID of the main VPC created by the VPC module."
  value       = module.vpc.vpc_id
}

# פלט: main_public_subnet_1_id
# תיאור: מזהה ה-ID של תת-רשת ציבורית 1 ממודול ה-VPC.
output "main_public_subnet_1_id" {
  description = "The ID of Public Subnet 1 from the VPC module."
  value       = module.vpc.public_subnet_1_id
}

# פלט: main_private_subnet_1_id
# תיאור: מזהה ה-ID של תת-רשת פרטית 1 ממודול ה-VPC.
output "main_private_subnet_1_id" {
  description = "The ID of Private Subnet 1 from the VPC module."
  value       = module.vpc.private_subnet_1_id
}

# פלט: main_public_subnet_2_id
# תיאור: מזהה ה-ID של תת-רשת ציבורית 2 ממודול ה-VPC.
output "main_public_subnet_2_id" {
  description = "The ID of Public Subnet 2 from the VPC module."
  value       = module.vpc.public_subnet_2_id
}

# פלט: main_private_subnet_2_id
# תיאור: מזהה ה-ID של תת-רשת פרטית 2 ממודול ה-VPC.
output "main_private_subnet_2_id" {
  description = "The ID of Private Subnet 2 from the VPC module."
  value       = module.vpc.private_subnet_2_id
}

# פלט: main_nat_gateway_id
# תיאור: מזהה ה-ID של ה-NAT Gateway ממודול ה-VPC.
output "main_nat_gateway_id" {
  description = "The ID of the NAT Gateway from the VPC module."
  value       = module.vpc.nat_gateway_id
}


# --- קריאה למודול DB Subnet Group ---
module "db_subnet_group" {
  source = "./modules/db_subnet_group"

  # העברת פלטים ממודול ה-VPC כקלטים למודול DB Subnet Group.
  # אנו משתמשים בשתי התת-רשתות הפרטיות מ-AZ A ומ-AZ B
  # כדי לאפשר Multi-AZ עבור ה-RDS.
  private_subnet_ids = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id,
  ]
  project_name = var.project_name
}

# --- קריאה למודול RDS Instance ---
module "rds" {
  source = "./modules/rds"

  # העברת פלטים ממודולים קודמים ומשתנים גלובליים כקלטים.
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id # מזהה ה-VPC ממודול VPC
  db_subnet_group_name  = module.db_subnet_group.db_subnet_group_name # שם קבוצת הסאבנטים ממודול DB Subnet Group

  # העברת משתנים שהוגדרו ב-variables.tf הראשי
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = var.db_allocated_storage
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_multi_az           = var.db_multi_az
  db_publicly_accessible = var.db_publicly_accessible
  # allowed_security_group_ids: כרגע ריק, נמלא אותו אם נבנה SG לאפליקציה.
  allowed_security_group_ids = var.allowed_security_group_ids
}

# --- פלטים (Outputs) נוספים ברמת הפרויקט הראשי (עבור RDS) ---

# פלט: rds_endpoint
# תיאור: כתובת ה-Endpoint של מופע ה-RDS.
output "rds_endpoint" {
  description = "The endpoint of the RDS instance."
  value       = module.rds.rds_instance_endpoint
}

# פלט: rds_port
# תיאור: פורט החיבור של מופע ה-RDS.
output "rds_port" {
  description = "The port of the RDS instance."
  value       = module.rds.rds_instance_port
}

# פלט: rds_security_group_id
# תיאור: ה-ID של ה-Security Group של ה-RDS.
output "rds_security_group_id" {
  description = "The ID of the Security Group for the RDS instance."
  value       = module.rds.rds_security_group_id
}


