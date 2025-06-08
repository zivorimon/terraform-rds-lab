# --- פלטים (Outputs) של מודול ה-VPC ---

# פלט: vpc_id
# תיאור: מזהה ה-ID הייחודי של ה-VPC שנוצר.
# זהו ערך קריטי שמודולים אחרים יצטרכו כדי להתייחס ל-VPC.
output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id # הפניה למזהה ה-ID של משאב ה-VPC
}

# פלט: public_subnet_1_id
# תיאור: מזהה ה-ID של תת-רשת ציבורית 1 (AZ A).
output "public_subnet_1_id" {
  description = "The ID of Public Subnet 1 in AZ A."
  value       = aws_subnet.public_1.id
}

# פלט: private_subnet_1_id
# תיאור: מזהה ה-ID של תת-רשת פרטית 1 (AZ A).
output "private_subnet_1_id" {
  description = "The ID of Private Subnet 1 in AZ A."
  value       = aws_subnet.private_1.id
}

# פלט: public_subnet_2_id
# תיאור: מזהה ה-ID של תת-רשת ציבורית 2 (AZ B).
output "public_subnet_2_id" {
  description = "The ID of Public Subnet 2 in AZ B."
  value       = aws_subnet.public_2.id
}

# פלט: private_subnet_2_id
# תיאור: מזהה ה-ID של תת-רשת פרטית 2 (AZ B).
output "private_subnet_2_id" {
  description = "The ID of Private Subnet 2 in AZ B."
  value       = aws_subnet.private_2.id
}

# פלט: public_route_table_id
# תיאור: מזהה ה-ID של טבלת הניתוב הציבורית.
output "public_route_table_id" {
  description = "The ID of the Public Route Table."
  value       = aws_route_table.public.id
}

# פלט: private_route_table_id
# תיאור: מזהה ה-ID של טבלת הניתוב הפרטית.
output "private_route_table_id" {
  description = "The ID of the Private Route Table."
  value       = aws_route_table.private.id
}

# פלט: nat_gateway_id
# תיאור: מזהה ה-ID של ה-NAT Gateway.
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.main.id
}