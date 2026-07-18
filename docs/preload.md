# پیش‌بارگذاری پکیج‌ها

برای پیش‌بارگذاری همه‌ی پکیج‌های موجود در `preload/packages.conf`:

```bash
make preload
```

یا به صورت دستی:

```bash
cd preload
chmod +x install-packages.sh
./install-packages.sh
```

## ساختار پوشه preload

```
preload/
├── package.json
├── packages.conf
└── install-packages.sh
```

### packages.conf

لیست پکیج‌هایی که باید پیش‌بارگذاری شوند، هر خط به این شکل:

```
next@13                             #tags: frontend,framework
```

اضافه یا حذف پکیج فقط با ویرایش همین فایل انجام می‌شود؛ نیازی به تغییر در اسکریپت یا Makefile نیست.

## Profile ها

هر پکیج یک یا چند تگ دارد (`frontend`, `backend`, `mobile`, `desktop`, `tooling`, `testing`, `database`, ...). با متغیر `PROFILE` می‌توانید فقط پکیج‌های یک تگ خاص را پیش‌بارگذاری کنید:

```bash
make preload PROFILE=frontend
make preload PROFILE=backend
make preload PROFILE=mobile
```

اگر `PROFILE` مشخص نشود، مقدار پیش‌فرض `all` است و همه‌ی پکیج‌ها نصب می‌شوند.

لیست کامل تگ‌های موجود در ابتدای فایل `packages.conf` مستند شده است.

## Incremental Preload

اگر `make preload` را دوباره اجرا کنید، به صورت پیش‌فرض همه‌ی پکیج‌ها دوباره بررسی می‌شوند (چون Verdaccio خودش پکیج‌های موجود در Storage را دوباره دانلود نمی‌کند، ولی اسکریپت به‌صورت پیش‌فرض درخواست نصب را برای همه می‌فرستد). برای این‌که اسکریپت خودش هم پکیج‌هایی که قبلاً با موفقیت پردازش شده‌اند را رد کند:

```bash
make preload INCREMENTAL=1
```

وضعیت پکیج‌های نصب‌شده در فایل `preload/.preload-state` نگهداری می‌شود (در Git ذخیره نمی‌شود). برای شروع دوباره از صفر، این فایل را حذف کنید.

### ترکیب Profile و Incremental

```bash
make preload PROFILE=frontend INCREMENTAL=1
```
