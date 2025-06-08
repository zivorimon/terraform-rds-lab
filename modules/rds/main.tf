# --- Security Group עבור RDS ---

# משאב: aws_security_group.rds_sg
# תיאור: יוצר Security Group עבור מופע ה-RDS.
# זהו חומת אש וירטואלית השולטת בתעבורה נכנסת ויוצאת עבור מסד הנתונים.
resource "aws_security_group" "rds_sg" {
  # name: שם ייחודי ל-Security Group.
  name        = "${var.project_name}-rds-sg"
  # description: תיאור של ה-Security Group.
  description = "Security group for RDS instance in ${var.project_name} VPC"
  # vpc_id: מקשר את ה-Security Group ל-VPC הנכון.
  vpc_id      = var.vpc_id

  # כלל כניסה: מאפשר תעבורה נכנסת (ingress) מ-Security Groups מורשים.
  # בדרך כלל, נרצה לאפשר גישה רק משרתי היישום (Web Servers) ב-VPC.
  # for_each: לולאה כדי ליצור כלל כניסה לכל SG ID ברשימה.
  dynamic "ingress" {
    for_each = var.allowed_security_group_ids
    content {
      # from_port ו-to_port: יציאות ה-DB הסטנדרטיות (לדוגמה, 3306 ל-MySQL, 5432 ל-PostgreSQL).
      # ניתן להגדיר זאת כמשתנה אם יש צורך ביותר גמישות.
      from_port   = 3306 # יציאה סטנדרטית ל-MySQL
      to_port     = 3306 # יציאה סטנדרטית ל-MySQL
      # protocol: פרוטוקול התעבורה (tcp).
      protocol    = "tcp"
      # security_groups: רשימת ה-Security Groups המורשים לגשת.
      security_groups = [ingress.value]
      # description: תיאור הכלל.
      description = "Allow inbound from application security groups"
    }
  }

  # כלל כניסה: מאפשר תעבורה נכנסת ל-RDS מתוך ה-Security Group עצמו.
  # זה נדרש לעיתים קרובות עבור תקשורת פנימית בין מופעי RDS (לדוגמה, Read Replicas, או RDS Proxy).
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = true # מאפשר ל-SG להתחבר לעצמו
    description = "Allow inbound from self (for replication, proxy, etc.)"
  }


  # כלל יציאה: מאפשר תעבורה יוצאת מ-RDS לכל יעד (0.0.0.0/0).
  # זה נדרש עבור RDS כדי שיוכל לגשת לשירותי AWS אחרים (לדוגמה, S3 עבור גיבויים, CloudWatch ללוגים).
  egress {
    from_port   = 0           # כל היציאות
    to_port     = 0           # כל היציאות
    protocol    = "-1"        # כל הפרוטוקולים (TCP, UDP, ICMP וכו')
    cidr_blocks = ["0.0.0.0/0"] # לכל יעד
    description = "Allow all outbound traffic"
  }

  # tags: תגיות עבור ה-Security Group.
  tags = {
    Name    = "${var.project_name}-rds-sg"
    Project = var.project_name
  }
}

# --- יצירת מופע RDS ---

# משאב: aws_db_instance.main
# תיאור: יוצר מופע מסד נתונים של RDS.
resource "aws_db_instance" "main" {
  # identifier: שם ייחודי למופע ה-DB.
  identifier              = "${var.project_name}-db-instance"
  # engine ו-engine_version: סוג וגרסת מנוע ה-DB.
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  # instance_class: סוג המופע (לדוגמה, db.t3.micro).
  instance_class          = var.db_instance_class
  # allocated_storage: גודל האחסון.
  allocated_storage       = var.db_allocated_storage
  # name: שם מסד הנתונים הראשוני בתוך המופע.
  db_name                 = var.db_name
  # username ו-password: פרטי ההתחברות למנהל המערכת של ה-DB.
  username                = var.db_username
  password                = var.db_password
  # db_subnet_group_name: מקשר את המופע לקבוצת התת-רשתות שיצרנו.
  db_subnet_group_name    = var.db_subnet_group_name
  # vpc_security_group_ids: מקשר את המופע ל-Security Group שיצרנו.
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  # multi_az: האם לפרוס Multi-AZ.
  multi_az                = var.db_multi_az
  # publicly_accessible: האם לאפשר גישה ציבורית. (מומלץ false)
  publicly_accessible     = var.db_publicly_accessible
  # skip_final_snapshot: לצרכי פיתוח/בדיקות, ניתן לדלג על יצירת Snapshot בסיום.
  # ב-Production, מומלץ להגדיר false ולתת final_snapshot_identifier.
  skip_final_snapshot     = true
  # storage_type: סוג אחסון (gp2, gp3, io1). gp2 הוא ברירת מחדל טובה.
  storage_type            = "gp2"
  # apply_immediately: האם להחיל שינויים באופן מיידי (מומלץ false ל-Prod).
  apply_immediately       = false
  # backup_retention_period: מספר הימים לשמירת גיבויים אוטומטיים.
  backup_retention_period = 7 # 7 ימים כברירת מחדל
  # deletion_protection: הגנה מפני מחיקה (מומלץ true ל-Prod).
  deletion_protection     = false

  # tags: תגיות עבור מופע ה-RDS.
  tags = {
    Name    = "${var.project_name}-db-instance"
    Project = var.project_name
  }
}