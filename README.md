# NPM Mirror

سرویس **NPM Mirror** یک Registry داخلی مبتنی بر **Verdaccio** است که به عنوان یک Mirror و Cache برای Registry اصلی npm عمل می‌کند.

هدف این پروژه کاهش وابستگی به اینترنت، افزایش سرعت نصب پکیج‌ها و امکان نصب پکیج‌ها در زمان قطعی اینترنت است.

---

# نحوه عملکرد

```text
                    اولین درخواست

           pnpm / npm / yarn
                    │
                    ▼
              Verdaccio Mirror
                    │
        ┌───────────┴───────────┐
        │                       │
    در Cache وجود دارد؟      وجود ندارد؟
        │                       │
        ▼                       ▼
 ارسال به کاربر          دریافت از npmjs.org
                                │
                                ▼
                        ذخیره داخل Storage
                                │
                                ▼
                         ارسال به کاربر
```

پس از اولین دانلود، نسخه موردنظر داخل سرور ذخیره شده و درخواست‌های بعدی مستقیماً از Storage پاسخ داده می‌شوند.

---

# مزایا

- کاهش مصرف اینترنت
- افزایش سرعت نصب پکیج‌ها
- امکان نصب پکیج‌های کش‌شده در زمان قطعی اینترنت
- اشتراک یک Cache بین تمام توسعه‌دهندگان
- بدون نیاز به تغییر در پروژه‌ها

---

# پیش‌نیازها

- Docker
- Docker Compose
- Make

---

# نصب و راه‌اندازی

## ۱. کلون کردن پروژه

```bash
git clone https://git.mananegaar.ir/mananegaar/npm_mirrror
cd npm_mirrors
```

## ۲. اجرای سرویس

```bash
make up
```

## ۳. بررسی وضعیت

```bash
make ps
```

یا

```bash
make logs
```

## ۴. دسترسی به Registry

پس از اجرا، Registry در آدرس زیر قابل دسترسی است:

```
http://localhost:4873
```

---

# تنظیم Registry روی سیستم

## npm

```bash
npm config set registry http://localhost:4873
```

## pnpm

```bash
pnpm config set registry http://localhost:4873
```

## yarn

```bash
yarn config set registry http://localhost:4873
```

---

# پیش‌بارگذاری پکیج‌ها

برای پیش‌بارگذاری پکیج‌های موجود در `preload/packages.txt`:

```bash
make preload
```

یا به صورت دستی:

```bash
chmod +x preload/install-packages.sh
./preload/install-packages.sh
```

---

# دستورات Makefile

```
make up        - Start Verdaccio
make down      - Stop Verdaccio
make restart   - Restart Verdaccio
make logs      - Follow logs
make ps        - Show container status
make build     - Recreate container
make pull      - Pull latest image
make clean     - Remove container
make reset     - Remove container and storage
make shell     - Open shell inside container
make preload   - Start install package
```

---

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

---

## Makefile

```
make up        - Start Verdaccio
make down      - Stop Verdaccio
make restart   - Restart Verdaccio
make logs      - Follow logs
make ps        - Show container status
make build     - Recreate container
make pull      - Pull latest image
make clean     - Remove container
make reset     - Remove container and storage
make shell     - Open shell inside container
make preload   - Start install package
```

---

## preload/

این پوشه برای پیش‌بارگذاری پکیج‌ها در Registry استفاده می‌شود.

```
preload/
├── package.json
├── packages.txt
└── install-packages.sh
```

### packages.txt

لیست پکیج‌هایی که باید پیش‌بارگذاری شوند. هر پکیج در یک خط جداگانه قرار داده می‌شود.

### install-packages.sh

اسکریپتی که پکیج‌های موجود در `packages.txt` را نصب می‌کند.

```bash
chmod +x preload/install-packages.sh
./preload/install-packages.sh
```

یا از طریق Makefile:

```bash
make preload
```

---

## docker-compose.yml

فایل اصلی اجرای سرویس Docker.

مسئولیت‌ها:

- اجرای کانتینر Verdaccio
- اتصال Volumeها
- انتشار پورت سرویس
- مدیریت Restart Policy

---

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

---

## storage/

مهم‌ترین پوشه پروژه.

تمام اطلاعات کش شده داخل این پوشه قرار می‌گیرند.

نمونه:

```
storage/
├── react/
├── next/
├── axios/
├── express/
└── ...
```

اگر این پوشه حذف شود، تمام Cache از بین خواهد رفت.

به همین دلیل باید از آن Backup تهیه شود.

---

## plugins/

پوشه‌ای برای پلاگین‌های سفارشی Verdaccio.

در حال حاضر خالی است و در صورت نیاز به پلاگین‌های سفارشی می‌توانید فایل‌های مربوطه را در اینجا قرار دهید.

---

# روند نصب یک پکیج

فرض کنید دستور زیر اجرا شود:

```bash
pnpm add react
```

مراحل انجام کار:

1. درخواست به Verdaccio ارسال می‌شود.
2. بررسی می‌شود که پکیج داخل Cache وجود دارد یا خیر.
3. اگر وجود داشته باشد مستقیماً ارسال می‌شود.
4. در غیر این صورت از Registry رسمی npm دانلود می‌شود.
5. داخل Storage ذخیره می‌شود.
6. به Client ارسال می‌شود.

از این پس تمام کاربران همان نسخه را از Cache دریافت خواهند کرد.

---

# نصب پروژه‌های موجود

اگر پروژه‌ای دارای package.json باشد:

```bash
pnpm install
```

Verdaccio تمام Dependencyها را بررسی می‌کند.

برای هر Dependency:

- اگر قبلاً دانلود شده باشد از Cache نصب می‌شود.
- اگر دانلود نشده باشد از npmjs دریافت شده و سپس ذخیره می‌شود.

بنابراین با گذشت زمان Cache بزرگ‌تر و کامل‌تر خواهد شد.

---

# رفتار در زمان قطعی اینترنت

فرض کنید قبلاً این پروژه نصب شده باشد:

```bash
pnpm install
```

و تمام Dependencyها داخل Cache قرار گرفته باشند.

در صورت قطع اینترنت:

```bash
pnpm install
```

بدون نیاز به اینترنت انجام خواهد شد.

تنها شرط این است که نسخه موردنیاز قبلاً داخل Cache ذخیره شده باشد.

---

# تنظیم Registry

برای npm

```bash
npm config set registry http://npm.example.com
```

برای pnpm

```bash
pnpm config set registry http://npm.example.com
```

برای yarn

```bash
yarn config set registry http://npm.example.com
```

---

# نکات مهم

## Storage را حذف نکنید

پوشه Storage شامل تمام Cache سیستم است.

حذف آن برابر است با دانلود مجدد تمام پکیج‌ها.

---

## بروزرسانی پکیج‌ها

Verdaccio فقط نسخه‌هایی را ذخیره می‌کند که کاربران درخواست کرده باشند.

هیچ پکیجی به صورت خودکار دانلود نمی‌شود.

---


# هدف نهایی

تمام توسعه‌دهندگان شرکت تنها از یک Registry داخلی استفاده می‌کنند.

```
Developer
      │
      ▼
NPM Mirror
      │
      ├── Cache
      │
      └── npmjs.org
```

در نتیجه:

- سرعت نصب افزایش می‌یابد.
- مصرف اینترنت کاهش پیدا می‌کند.
- در زمان قطعی اینترنت، پکیج‌های کش‌شده همچنان قابل نصب خواهند بود.