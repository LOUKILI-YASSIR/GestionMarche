# استخدام أحدث إصدار من Debian
FROM debian:latest

# تثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    libsqlite3-dev \
    curl \
    fontconfig \
    xfonts-75dpi \
    xfonts-base \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    postgresql-client \
    git \
    wget \
    nodejs \
    npm \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# تحميل وبناء Python 3.12
RUN curl -O https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz \
    && tar -xf Python-3.12.2.tgz \
    && cd Python-3.12.2 \
    && ./configure --enable-optimizations \
    && make -j$(nproc) \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.12.2 Python-3.12.2.tgz

# تثبيت wkhtmltopdf لإنشاء التقارير في Odoo
RUN wget -q https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && apt-get install -y ./wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && rm -f wkhtmltox_0.12.6.1-3.bookworm_amd64.deb

# إنشاء المستخدم odoo
RUN useradd -m -d /odoo -U -r -s /bin/bash odoo

# ضبط متغير البيئة ليشمل مسار المستخدم
ENV PATH="/odoo/.local/bin:${PATH}"

# نسخ Odoo 18 من المجلد المحلي
COPY ./odoo-18 /odoo

# ضبط الأذونات
RUN chown -R odoo:odoo /odoo

# تحديد مجلد العمل
WORKDIR /odoo

# نسخ ملف المتطلبات
COPY ./odoo-18/requirements.txt /odoo/requirements.txt

# إنشاء وتفعيل البيئة الافتراضية ثم تثبيت المتطلبات
RUN python3.12 -m venv /odoo/venv \
    && . /odoo/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install -r requirements.txt

# التبديل إلى مستخدم Odoo
USER odoo

# تعيين منفذ Odoo
EXPOSE 7000

# تشغيل Odoo عند بدء الحاوية
CMD ["/odoo/venv/bin/python", "/odoo/odoo-bin", "--db_host=yonetwork_odoo_db", "--db_port=5432", "--db_user=odoo", "--db_password=dev11", "--conf", "/odoo/odoo.conf"]