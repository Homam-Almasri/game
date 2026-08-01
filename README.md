# 🚀 Flutter Modular Application Template

مشروع فلتر متكامل مبني وفق أفضل الممارسات في هيكلة وتصميم تطبيقات الفلتر (Clean Architecture & Feature-First).

## 📁 هيكل المشروع (Directory Structure)

```text
lib/
├── core/                   # الأساسيات والألوان والثريدات العامة
│   ├── constants/          # الثوابت (الألوان، الخطوط، الأبعاد)
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   └── theme/              # ثيم التطبيق (Light & Dark Themes)
│       └── app_theme.dart
├── features/               # الميزات والموديولات المقسمة بحسب الميزة
│   └── home/
│       └── presentation/
│           ├── pages/
│           │   └── home_page.dart
│           └── widgets/
│               └── stat_card.dart
├── shared/                 # العناصر المشتركة في كامل التطبيق
│   └── widgets/
│       ├── custom_button.dart
│       └── glass_card.dart
└── main.dart               # نقطة الانطلاق الرئيسية
```

## ✨ الميزات المجهزة:
- ✅ ثيم عصري يدعم الـ Dark Mode و Light Mode بالكامل.
- ✅ دعم الاتجاه العربي (RTL / Directionality) والخطوط العربية (Cairo عبر Google Fonts).
- ✅ مكونات تفاعلية حديثة مع مظهر الزجاج (Glassmorphic Cards & Gradient Buttons).
- ✅ جاهز لإضافة بقية الميزات والشاشات والـ State Management لاحقاً.
