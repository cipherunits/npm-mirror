# ساختار پروژه

```
npm_mirrors/
├── docker-compose.yml
├── Makefile
├── config/
│   └── config.yaml
├── preload/
│   ├── package.json
│   ├── packages.txt
│   └── install-packages.sh
├── storage/
└── plugins/
```

## docker-compose.yml

فایل اصلی اجرای سرویس Docker.

مسئولیت‌ها:

- اجرای کانتینر Verdaccio
- اتصال Volumeها
- انتشار پورت سرویس
- مدیریت Restart Policy

## config/

این پوشه شامل تنظیمات Verdaccio است.

```
config/
└── config.yaml
```

در این فایل موارد زیر تعریف می‌شوند:

- Registry اصلی npm
- قوانین دسترسی
- تنظیمات کش
- تنظیمات Authentication
- تنظیمات Logging

این فایل مغز اصلی سرویس محسوب می‌شود.

## storage/

مهم‌ترین پوشه پروژه. تمام اطلاعات کش شده داخل این پوشه قرار می‌گیرند.

نمونه:

```
storage/
├── react/
├── next/
├── axios/
├── express/
└── ...
```

اگر این پوشه حذف شود، تمام Cache از بین خواهد رفت. به همین دلیل باید از آن Backup تهیه شود.

## plugins/

پوشه‌ای برای پلاگین‌های سفارشی Verdaccio. در حال حاضر خالی است و در صورت نیاز به پلاگین‌های سفارشی می‌توانید فایل‌های مربوطه را در اینجا قرار دهید.
