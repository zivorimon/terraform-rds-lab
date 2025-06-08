# משאב: aws_vpc.main
# תיאור: יוצר את ה-Virtual Private Cloud (VPC) שלנו ב-AWS.
# זהו הבסיס לכל התשתית הרשתית שלנו.
resource "aws_vpc" "main" {
  # vpc_cidr_block: טווח כתובות ה-IP המרכזי של ה-VPC.
  # אנחנו משתמשים במשתנה שקיבלנו כקלט למודול.
  cidr_block = var.vpc_cidr_block

  # enable_dns_support: מאפשר ל-DNS של AWS (Amazon Route 53 Resolver) לפתור שמות דומיין.
  # מומלץ להשאיר true כדי שמכונות ב-VPC יוכלו לפתור שמות חיצוניים ופנימיים.
  enable_dns_support = true

  # enable_dns_hostnames: מאפשר שמות מארח (hostnames) ציבוריים ופרטיים.
  # כאשר מופעל, מכונות EC2 ב-VPC יקבלו שמות DNS אוטומטיים.
  enable_dns_hostnames = true

  # tags: תגיות (metadata) שימושיות לזיהוי המשאב באמזון.
  # אנו משתמשים במשתנה project_name לתיוג עקבי.
  tags = {
    Name    = "${var.project_name}-vpc" # שם ידידותי שיופיע בקונסולת AWS
    Project = var.project_name         # תגית Project שתעזור בסידור וחיפוש
  }
}



# משאב: aws_internet_gateway.main
# תיאור: יוצר Internet Gateway (IGW) ומחבר אותו ל-VPC.
# IGW מאפשר תעבורת אינטרנט בין ה-VPC לאינטרנט הציבורי.
resource "aws_internet_gateway" "main" {
  # vpc_id: מקשר את ה-IGW ל-VPC הספציפי שיצרנו.
  # אנו משתמשים ב-`aws_vpc.main.id` כדי להתייחס למזהה ה-ID של ה-VPC שנוצר בחלק הקודם.
  vpc_id = aws_vpc.main.id

  # tags: תגיות עבור ה-Internet Gateway.
  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}


# משאב: aws_eip.nat_gateway_eip
# תיאור: יוצר Elastic IP (EIP). זוהי כתובת IP ציבורית סטטית.
# NAT Gateway דורש Elastic IP כדי לאפשר גישה לאינטרנט.
resource "aws_eip" "nat_gateway_eip" {
  # שינוי: עכשיו משתמשים ב-`domain = "vpc"` במקום `vpc = true`
  domain = "vpc"

  # depends_on: תלויות מפורשות. Terraform מנסה לזהות תלויות אוטומטית,
  # אך במקרים מסוימים (כמו עם EIP שמשויך ל-NAT Gateway שתלוי ב-IGW),
  # עדיף לציין במפורש. כאן אנו מוודאים שה-Internet Gateway נוצר לפני ה-EIP.
  depends_on = [aws_internet_gateway.main]

  # tags: תגיות עבור ה-Elastic IP.
  tags = {
    Name    = "${var.project_name}-nat-gateway-eip"
    Project = var.project_name
  }
}

# משאב: aws_nat_gateway.main
# תיאור: יוצר NAT Gateway.
# NAT Gateway מאפשר למשאבים בתת-רשתות פרטיות (Private Subnets)
# ליזום חיבורים לאינטרנט (לדוגמה, להוריד עדכונים או לגשת לשירותי AWS אחרים),
# מבלי להיות חשופים ישירות לתעבורה נכנסת מהאינטרנט.
resource "aws_nat_gateway" "main" {
  # allocation_id: מקשר את ה-NAT Gateway ל-Elastic IP שיצרנו.
  # אנו משתמשים ב-`aws_eip.nat_gateway_eip.id` כדי להתייחס ל-ID של ה-EIP.
  allocation_id = aws_eip.nat_gateway_eip.id

  # subnet_id: התת-רשת הציבורית שבה ה-NAT Gateway ימוקם.
  # חשוב ש-NAT Gateway יהיה בתת-רשת ציבורית.
  # כרגע, אנחנו מפנים לתת-רשת ציבורית שעדיין לא הגדרנו בקוד!
  # זה בסדר - Terraform יזהה את התלות מאוחר יותר.
  subnet_id = aws_subnet.public_1.id # נתייחס לכאן ל-Public Subnet 1 שנגדיר מיד.

  # depends_on: מוודא שה-Internet Gateway נוצר לפני ה-NAT Gateway,
  # מכיוון שה-NAT Gateway צריך את ה-IGW כדי לתפקד.
  depends_on = [aws_internet_gateway.main]

  # tags: תגיות עבור ה-NAT Gateway.
  tags = {
    Name    = "${var.project_name}-nat-gateway"
    Project = var.project_name
  }
}


# --- יצירת תת-רשתות (Subnets) ---

# משאב: aws_subnet.public_1
# תיאור: יוצר תת-רשת ציבורית באזור זמינות A (AZ A).
# מכיוון שהיא ציבורית, נפעיל את האפשרות להקצאת כתובת IP ציבורית אוטומטית.
resource "aws_subnet" "public_1" {
  # vpc_id: מקשר את התת-רשת ל-VPC הראשי שיצרנו.
  vpc_id = aws_vpc.main.id

  # cidr_block: טווח כתובות ה-IP הספציפי לתת-רשת זו.
  # משתמשים במשתנה שקיבלנו כקלט למודול.
  cidr_block = var.public_subnet_1_cidr

  # availability_zone: מציין באיזה אזור זמינות התת-רשת תמוקם.
  # חשוב לפרוס תת-רשתות באזורי זמינות שונים עבור זמינות גבוהה.
  availability_zone = "us-west-2a" # אזור A

  # map_public_ip_on_launch: כאשר מופעל (true), כל מופע EC2
  # שיושק בתת-רשת זו יקבל כתובת IP ציבורית באופן אוטומטי.
  # זה הכרחי עבור תת-רשתות ציבוריות שחשופות לאינטרנט.
  map_public_ip_on_launch = true

  # tags: תגיות עבור התת-רשת.
  tags = {
    Name    = "${var.project_name}-public-subnet-1"
    Project = var.project_name
  }
}

# משאב: aws_subnet.private_1
# תיאור: יוצר תת-רשת פרטית באזור זמינות A (AZ A).
# תת-רשתות פרטיות אינן חשופות ישירות לאינטרנט.
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_1_cidr
  availability_zone       = "us-west-2a" # אזור A
  map_public_ip_on_launch = false         # לא מקצים כתובת IP ציבורית אוטומטית.

  tags = {
    Name    = "${var.project_name}-private-subnet-1"
    Project = var.project_name
  }
}

# משאב: aws_subnet.public_2
# תיאור: יוצר תת-רשת ציבורית באזור זמינות B (AZ B).
# חלק מפתרון הזמינות הגבוהה שלנו.
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "us-west-2b" # אזור B
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-public-subnet-2"
    Project = var.project_name
  }
}

# משאב: aws_subnet.private_2
# תיאור: יוצר תת-רשת פרטית באזור זמינות B (AZ B).
# חלק מפתרון הזמינות הגבוהה שלנו.
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_2_cidr
  availability_zone       = "us-west-2b" # אזור B
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project_name}-private-subnet-2"
    Project = var.project_name
  }
}



# --- טבלאות ניתוב (Route Tables) וקישורן לתת-רשתות ---

# משאב: aws_route_table.public
# תיאור: יוצר טבלת ניתוב ציבורית. טבלה זו מיועדת לתת-רשתות הציבוריות.
# היא תנחה תעבורת אינטרנט דרך ה-Internet Gateway.
resource "aws_route_table" "public" {
  # vpc_id: מקשר את טבלת הניתוב ל-VPC הראשי.
  vpc_id = aws_vpc.main.id

  # tags: תגיות עבור טבלת הניתוב.
  tags = {
    Name    = "${var.project_name}-public-rt" # 'rt' מייצג Route Table
    Project = var.project_name
  }
}

# משאב: aws_route.public_internet_gateway_route
# תיאור: מוסיף כלל ניתוב לטבלת הניתוב הציבורית.
# כלל זה מורה לכל התעבורה (0.0.0.0/0, כלומר "כל דבר")
# לצאת דרך ה-Internet Gateway.
resource "aws_route" "public_internet_gateway_route" {
  # route_table_id: מקשר את הניתוב לטבלת הניתוב הציבורית שיצרנו.
  route_table_id         = aws_route_table.public.id
  # destination_cidr_block: יעד התעבורה. 0.0.0.0/0 הוא "האינטרנט".
  destination_cidr_block = "0.0.0.0/0"
  # gateway_id: היעד של הניתוב. במקרה זה, ה-Internet Gateway.
  gateway_id             = aws_internet_gateway.main.id
}

# משאב: aws_route_table_association.public_1_association
# תיאור: מקשר את תת-רשת ציבורית 1 לטבלת הניתוב הציבורית.
# כך, כל התעבורה בתת-רשת זו תשתמש בכללי הניתוב של הטבלה.
resource "aws_route_table_association" "public_1_association" {
  # subnet_id: מזהה תת-הרשת שאנו מקשרים.
  subnet_id      = aws_subnet.public_1.id
  # route_table_id: מזהה טבלת הניתוב שאליה אנו מקשרים.
  route_table_id = aws_route_table.public.id
}

# משאב: aws_route_table_association.public_2_association
# תיאור: מקשר את תת-רשת ציבורית 2 לטבלת הניתוב הציבורית.
resource "aws_route_table_association" "public_2_association" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# משאב: aws_route_table.private
# תיאור: יוצר טבלת ניתוב פרטית. טבלה זו מיועדת לתת-רשתות הפרטיות.
# היא תנחה תעבורת אינטרנט (יוצאת בלבד) דרך ה-NAT Gateway.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-private-rt"
    Project = var.project_name
  }
}

# משאב: aws_route.private_nat_gateway_route
# תיאור: מוסיף כלל ניתוב לטבלת הניתוב הפרטית.
# כלל זה מורה לכל התעבורה (0.0.0.0/0) לצאת דרך ה-NAT Gateway.
# זה מאפשר למשאבים פרטיים לגשת לאינטרנט מבלי להיות חשופים.
resource "aws_route" "private_nat_gateway_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  # nat_gateway_id: היעד של הניתוב. במקרה זה, ה-NAT Gateway שיצרנו.
  nat_gateway_id         = aws_nat_gateway.main.id
}

# משאב: aws_route_table_association.private_1_association
# תיאור: מקשר את תת-רשת פרטית 1 לטבלת הניתוב הפרטית.
resource "aws_route_table_association" "private_1_association" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

# משאב: aws_route_table_association.private_2_association
# תיאור: מקשר את תת-רשת פרטית 2 לטבלת הניתוב הפרטית.
# שימו לב ששתי התת-רשתות הפרטיות מקושרות לאותה טבלת ניתוב פרטית,
# המפנה את כל התעבורה היוצאת דרך ה-NAT Gateway היחיד שלנו באזור AZ A.
resource "aws_route_table_association" "private_2_association" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

