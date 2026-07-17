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

## ساختار پوشه preload

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
