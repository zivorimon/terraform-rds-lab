# 🚀 Terraform AWS VPC & RDS Lab: Infrastructure as Code Playground 🚀

 

---

## ✨ סקירה כללית

ברוכים הבאים ל-**Terraform AWS VPC & RDS Lab**! פרויקט זה מהווה הדגמה מקיפה ומודולרית של פריסת תשתית ענן מאובטחת וזמינה גבוהה ב-Amazon Web Services (AWS) באמצעות Infrastructure as Code (IaC) עם Terraform.

בין אם אתה מפתח, מהנדס DevOps או ארכיטקט ענן, פרויקט זה מספק בסיס איתן להבנת עקרונות ה-IaC וכיצד לבנות תשתית מורכבת בצורה ניתנת לשחזור, ניתנת לניהול וניתנת להרחבה.

## 🎯 מה תלמד?

* **מודולריזציה ב-Terraform**: כיצד לפרק תשתית גדולה למודולים קטנים וניתנים לשימוש חוזר (VPC, DB Subnet Group, RDS).
* **בניית רשת מאובטחת**: הגדרת VPC מותאם אישית עם תת-רשתות ציבוריות ופרטיות, Internet Gateway ו-NAT Gateway.
* **פריסת RDS עמיד לכשלים**: הגדרת מופע RDS (MySQL) במצב Multi-AZ לזמינות גבוהה, הממוקם בתת-רשתות פרטיות בלבד.
* **ניהול אבטחה**: שימוש ב-Security Groups לשליטה בגישה למשאבי ה-VPC וה-RDS.
* **ניהול מחזור חיים מלא**: אתחול, תכנון, פריסה ומחיקה של משאבי ענן באופן אוטומטי.

## 🏛️ ארכיטקטורה

הפרויקט פורס את הארכיטקטורה הבאה ב-AWS, המתמקדת ביצירת סביבה מאובטחת ויציבה עבור מסד נתונים:

* **Virtual Private Cloud (VPC)**: רשת לוגית מבודדת ב-AWS, מוגדרת עם טווח IP (`10.0.0.0/16`).
* **Internet Gateway (IGW)**: שער גישה יחיד לאינטרנט עבור התת-רשתות הציבוריות.
* **NAT Gateway**: ממוקם בתת-רשת ציבורית, מאפשר לתעבורה יוצאת מתת-רשתות פרטיות להגיע לאינטרנט (לדוגמה, עבור עדכוני מערכת) מבלי לחשוף את המשאבים הפרטיים. מקושר ל-Elastic IP סטטי.
* **Subnets**:
    * **Public Subnets (x2)**: תת-רשתות המיועדות למשאבים הנגישים מהאינטרנט (כמו Load Balancers).
    * **Private Subnets (x2)**: תת-רשתות המיועדות למשאבים פנימיים ורגישים (כמו שרתי אפליקציה ו-Databases).
    * כל תת-רשת מפוזרת על פני **אזורי זמינות (Availability Zones)** שונים (`us-east-1a`, `us-east-1b`) ליתירות.
* **Route Tables**: טבלאות ניתוב מותאמות אישית המנתבות תעבורה:
    * **Public Route Table**: מנותבת ל-Internet Gateway.
    * **Private Route Table**: מנותבת ל-NAT Gateway.
* **RDS DB Subnet Group**: אוסף של תת-רשתות פרטיות המוגדרות עבור מופעי RDS, המאפשר לפריסות Multi-AZ לעבור בין אזורי זמינות.
* **Amazon RDS Instance (MySQL)**:
    * מופע מסד נתונים של MySQL (גרסה 8.0.35 כברירת מחדל).
    * **Multi-AZ**: מופעל לזמינות גבוהה ועמידות בפני כשלים (כולל רפליקת Standby באזור זמינות אחר).
    * **Private Placement**: ממוקם רק בתת-רשתות פרטיות, ולא נגיש ציבורית.
    * מאובטח באמצעות **Security Group** ייעודי השולט בגישה לפורט DB.



## 📦 מבנה הפרויקט

הפרויקט מובנה בצורה מודולרית עבור קריאות טובה ויכולת שימוש חוזר:terraform-rds-lab/

![image](https://github.com/user-attachments/assets/43a097f1-eab8-453f-8d0c-995263b52243)


## 🛠️ דרישות קדם

לפני שתתחיל, ודא שהאמצעים הבאים מותקנים ומוגדרים:

* **חשבון AWS פעיל**: עם הרשאות מספקות ליצירת כל המשאבים המוזכרים לעיל (IAM User עם הרשאות AdministratorAccess למטרת מעבדה).
* **AWS CLI**: מותקן ומוגדר עם פרטי גישה לחשבון ה-AWS שלך.
* **Terraform CLI**: מותקן במערכת שלך (גרסה 1.0 ומעלה).
* **Git**: מותקן במערכת שלך.

## 🚀 תחילת העבודה: פריסה

עקוב אחר השלבים הבאים כדי לפרוס את התשתית בחשבון ה-AWS שלך:

1.  **שיבוט הרפוזיטורי:**
    ```bash
    git clone [https://github.com/zivorimon/terraform-rds-lab.git](https://github.com/zivorimon/terraform-rds-lab.git)
    cd terraform-rds-lab
    ```

2.  **הגדרת משתני סביבה רגישים:**
    צור קובץ בשם `terraform.tfvars` בתיקיית השורש של הפרויקט (`terraform-rds-lab/`). קובץ זה יכיל את הסיסמאות ושמות המשתמשים עבור ה-RDS ולא יועלה ל-Git (בהתאם להגדרות `.gitignore`).

    ```hcl
    # terraform.tfvars
    db_username = "your_admin_username" # לדוגמה: admin
    db_password = "YourSuperStrongPassword123!" # הקפד על סיסמה חזקה
    ```
    *(החלף בערכים האמיתיים שברצונך להשתמש בהם)*

3.  **אתחול Terraform:**
    פקודה זו מאתחלת את ספריית העבודה של Terraform, מורידה את ספקי ה-AWS ואת המודולים המקומיים.
    ```bash
    terraform init
    ```

4.  **אימות התצורה:**
    בודק את תקינות קבצי התצורה של Terraform עבור שגיאות תחביר או לוגיקה.
    ```bash
    terraform validate
    ```

5.  **תכנון הפריסה:**
    מציג תצוגה מקדימה של כל השינויים ש-Terraform יבצע ב-AWS (יצירה, שינוי, מחיקה) מבלי לבצע אותם בפועל. **מומלץ לבדוק פלט זה בקפידה!**
    ```bash
    terraform plan
    ```
    צפה לראות `Plan: 19 to add, 0 to change, 0 to destroy.`.

6.  **ביצוע הפריסה:**
    פורס את המשאבים בפועל בחשבון ה-AWS שלך. תתבקש לאשר את הפעולה על ידי הקלדת `yes`. תהליך זה יכול לקחת 10-15 דקות.
    ```bash
    terraform apply
    ```
    לאחר השלמה מוצלחת, תקבל פלט עם כלל ה-Outputs המוגדרים בפרויקט, כגון Endpoint של ה-RDS.

## 🧹 ניקוי משאבים

כדי למנוע חיובים מיותרים ב-AWS, חשוב למחוק את כל המשאבים שיצרת בסיום העבודה.

1.  **מחיקת המשאבים:**
    פקודה זו תמחק את כל המשאבים שנוצרו על ידי Terraform בפרויקט זה.
    ```bash
    terraform destroy
    ```
    תתבקש לאשר את הפעולה על ידי הקלדת `yes`. תהליך זה יכול לקחת מספר דקות.

---

## 🤝 תרומה

רעיונות לשיפור, תיקוני באגים או הרחבת יכולות הפרויקט יתקבלו בברכה! אנא פתח Issue או שלח Pull Request.

## 👤 מחבר

זיו מונטאוריאנו
