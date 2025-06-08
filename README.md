# Terraform AWS VPC and RDS Lab

זהו פרויקט Terraform המדגים יצירת תשתית בסיסית של AWS, הכוללת Virtual Private Cloud (VPC) מותאם אישית ומסד נתונים של Amazon RDS. הפרויקט בנוי בצורה מודולרית לניהול קל וגמישות.

## ארכיטקטורת התשתית

הפרויקט פורס את המשאבים הבאים ב-AWS:

* **VPC**: Virtual Private Cloud עם טווח IP מוגדר.
* **Internet Gateway (IGW)**: מאפשר תקשורת בין ה-VPC לאינטרנט.
* **Elastic IP (EIP)**: כתובת IP סטטית עבור ה-NAT Gateway.
* **NAT Gateway**: מאפשר לתת-רשתות פרטיות לגשת לאינטרנט (לדוגמה, עבור עדכונים) מבלי להיחשף באופן ישיר.
* **Subnets**:
    * שתי תת-רשתות ציבוריות (Public Subnets) באזורי זמינות שונים.
    * שתי תת-רשתות פרטיות (Private Subnets) באזורי זמינות שונים.
* **Route Tables**: טבלאות ניתוב נפרדות עבור התת-רשתות הציבוריות (מנותבות ל-IGW) והפרטיות (מנותבות ל-NAT Gateway).
* **RDS DB Subnet Group**: קבוצת תת-רשתות פרטיות עבור מופע ה-RDS, חיונית לפריסת Multi-AZ.
* **RDS Instance**: מופע מסד נתונים של MySQL (או אחר, לפי הגדרה) במצב Multi-AZ לזמינות גבוהה, הממוקם בתת-רשתות הפרטיות ומאובטח באמצעות Security Group.
* **Security Groups**:
    * Security Group ייעודי ל-RDS השולט בגישה למסד הנתונים.

הארכיטקטורה המפורטת:

[תוכל להוסיף כאן קישור לדיאגרמה אם תעלה אותה למקום כלשהו, או לצרף אותה בתור קובץ]

## מבנה הפרויקט

terraform-rds-lab/
├── main.tf                 # קובץ root המרכז את קריאות המודולים.
├── variables.tf            # משתנים גלובליים לפרויקט.
├── outputs.tf              # פלטים גלובליים של הפרויקט.
├── provider.tf             # הגדרות ספק AWS (Region).
├── terraform.tfvars        # קובץ להגדרת ערכי משתנים רגישים (לא נכלל ב-Git!).
├── .gitignore              # קובץ המגדיר אילו קבצים להתעלם מהם ב-Git.
└── modules/
├── vpc/                # מודול ליצירת VPC ומרכיביו.
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── db_subnet_group/    # מודול ליצירת DB Subnet Group.
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
└── rds/                # מודול ליצירת RDS Instance ו-Security Group עבורו.
├── main.tf
├── outputs.tf
└── variables.tf


## דרישות מקדימות

* **חשבון AWS**: עם הרשאות מספקות ליצירת משאבי VPC ו-RDS.
* **AWS CLI/Credentials**: מוגדרים במערכת שלך.
* **Terraform CLI**: מותקן במערכת שלך (גרסה 1.0 ומעלה).

## הגדרה ופריסה

1.  **שיבוט הרפוזיטורי:**
    ```bash
    git clone <URL_של_הרפוזיטורי_שלך>
    cd terraform-rds-lab
    ```

2.  **הגדרת משתנים רגישים:**
    צור קובץ בשם `terraform.tfvars` בתיקיית השורש של הפרויקט (`terraform-rds-lab/`) והוסף בו את פרטי המשתמש והסיסמה של ה-RDS. **קובץ זה לא יועלה ל-Git עקב הגדרות `.gitignore`.**
    ```hcl
    db_username = "admin"
    db_password = "MySecurePassword123!"
    ```
    (החלף בערכים המתאימים)

3.  **אתחול Terraform:**
    פקודה זו מורידה את ספקי Terraform ואת המודולים הנדרשים.
    ```bash
    terraform init
    ```

4.  **בדיקת התצורה:**
    בודק שאין שגיאות תחביר בקוד ה-Terraform.
    ```bash
    terraform validate
    ```

5.  **תכנון הפריסה:**
    מציג את השינויים ש-Terraform הולך לבצע ב-AWS מבלי לבצע אותם בפועל.
    ```bash
    terraform plan
    ```
    ודא שאתה מרוצה מתוכנית הפריסה (לדוגמה, `Plan: X to add, 0 to change, 0 to destroy`).

6.  **פריסת התשתית:**
    מבצע בפועל את השינויים ומקים את המשאבים ב-AWS.
    ```bash
    terraform apply
    ```
    תתבקש לאשר את הפריסה על ידי הקלדת `yes`. תהליך זה יכול לקחת מספר דקות (במיוחד עבור RDS).

## ניקוי המשאבים

לאחר סיום העבודה עם התשתית, חשוב למחוק את כל המשאבים שיצרתם כדי למנוע חיובים מיותרים.
```bash
terraform destroy

