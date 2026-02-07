

\# Docker Mini Game — Test 02-02-2026



\## Выполненные уровни



\### Уровень 1 — Контейнер под контролем

\- Запущен контейнер `web\_middle` на основе образа `nginx`

\- Параметры: `--restart unless-stopped`, проброс порта `8080:80`



\### Уровень 2 — Диагностика через `docker inspect`

\- Полная конфигурация контейнера сохранена в `inspect.json`

\- Подтверждены параметры: `RestartPolicy: unless-stopped`, `PortBindings: 8080->80`



\### Уровень 3 — Своя сеть

\- Создана кастомная сеть `middle\_net` (bridge)

\- Проверена связность между контейнерами по имени:

&nbsp; - `ping web\_middle` — успешен

&nbsp; - `wget http://web\_middle` — возвращает страницу nginx



\### Уровень 4 — Volume для сохранения данных

\- Создан именованный том `web\_data`

\- Том подключён к `/usr/share/nginx/html`

\- Данные сохраняются между перезапусками контейнера (проверено пересозданием)



\### Уровень 5 — Управление через Docker Compose

\- Файл `docker-compose.yml` настроен с использованием внешних тома и сети

\- Стек запускается командой `docker compose up -d`

\- Все данные из тома сохраняются при управлении через Compose



\## Структура проекта

test-02-02-2026/

├── docker-compose.yml # Конфигурация Compose

├── inspect.json # Вывод docker inspect

├── index.html # Тестовый HTML-файл

├── .gitignore # Исключения для Git

└── README.md # Документация



\## Запуск проекта

```bash

\# Запуск через Docker Compose

docker compose up -d



\# Проверка работы

curl http://localhost:8080

\# Ожидаемый результат: <h1>Volume works!</h1>

