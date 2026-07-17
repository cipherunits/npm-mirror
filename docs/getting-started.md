# نصب و راه‌اندازی

## پیش‌نیازها

- Docker
- Docker Compose
- Make

## ۱. کلون کردن پروژه

```bash
git clone https://github.com/MohammadTahaBatoomi/npm-mirror
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

## دستورات Makefile

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
