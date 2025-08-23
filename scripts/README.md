# 🤖 Automation Scripts

סקריפטים אוטומטיים לעדכון שני הפרויקטים (NetlifyPlugin ו-pluginTest) בבת אחת.

## 📁 Files

- **`update-both-projects.sh`** - הסקריפט הראשי לעדכון שני הפרויקטים
- **`quick-update.sh`** - סקריפט מהיר לעדכון עם push אוטומטי ל-GitHub

## 🚀 Usage

### הסקריפט הראשי

```bash
# עדכון ללא push (רק commit מקומי)
./scripts/update-both-projects.sh "הערת הקומיט" "גרסת הפלאגין"

# עדכון עם push אוטומטי ל-GitHub
./scripts/update-both-projects.sh "הערת הקומיט" "גרסת הפלאגין" --push
```

**דוגמאות:**
```bash
# עדכון רגיל
./scripts/update-both-projects.sh "הוספת תכונה חדשה" "1.0.12"

# עדכון עם push
./scripts/update-both-projects.sh "תיקון באג" "1.0.11" --push
```

### הסקריפט המהיר

```bash
# עדכון עם push אוטומטי (מומלץ לשימוש יומיומי)
./scripts/quick-update.sh "הערת הקומיט" "גרסת הפלאגין"
```

**דוגמה:**
```bash
./scripts/quick-update.sh "עדכון פלאגין" "1.0.12"
```

## ⚙️ מה הסקריפט עושה

1. **עדכון NetlifyPlugin:**
   - עובר לתיקיית NetlifyPlugin
   - מוסיף את כל השינויים ל-git
   - מבצע commit עם ההודעה שנתת
   - דוחף ל-GitHub (אם בחרת ב-`--push`)

2. **עדכון pluginTest:**
   - עובר לתיקיית pluginTest
   - מתקין את גרסת הפלאגין החדשה
   - מוסיף את כל השינויים ל-git
   - מבצע commit עם ההודעה שנתת
   - דוחף ל-GitHub (אם בחרת ב-`--push`)

## 🔧 Requirements

- הסקריפט חייב לרוץ מתוך תיקיית NetlifyPlugin
- שתי התיקיות חייבות להיות באותה רמה (אחיות)
- Git חייב להיות מוגדר בשתי התיקיות
- npm חייב להיות מותקן

## 📁 Directory Structure

```
Projects/
├── NetlifyPlugin/          # הפרויקט הראשי
│   ├── scripts/
│   │   ├── update-both-projects.sh
│   │   ├── quick-update.sh
│   │   └── README.md
│   └── ...
└── pluginTest/             # פרויקט הבדיקה
    └── ...
```

## 🎯 Use Cases

### עדכון יומיומי
```bash
./scripts/quick-update.sh "עדכון יומי" "1.0.12"
```

### עדכון עם בדיקה מקומית
```bash
./scripts/update-both-projects.sh "בדיקת פיצ'ר חדש" "1.0.12"
# בדוק שהכל עובד
./scripts/update-both-projects.sh "בדיקת פיצ'ר חדש" "1.0.12" --push
```

### עדכון גרסה חדשה
```bash
./scripts/quick-update.sh "שחרור גרסה 1.0.13" "1.0.13"
```

## ⚠️ Notes

- הסקריפט יבצע commit רק אם יש שינויים
- אם אין שינויים ב-pluginTest, הוא יציג אזהרה אבל לא ייכשל
- הסקריפט ייכשל אם התיקיות לא קיימות או אם יש בעיה עם Git
- תמיד בדוק את הפלט לפני push ל-GitHub

## 🆘 Troubleshooting

### שגיאה: "directory not found"
- וודא שהסקריפט רץ מתוך תיקיית NetlifyPlugin
- וודא שתיקיית pluginTest קיימת באותה רמה

### שגיאה: "Not in NetlifyPlugin directory"
- וודא שיש לך את הקבצים הנדרשים (package.json, index.js)

### שגיאה: "Not in pluginTest directory"
- וודא שיש לך את הקבצים הנדרשים (package.json, netlify.toml)
