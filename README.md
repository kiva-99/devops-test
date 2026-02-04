\# Docker Compose Debug Quest



Исправленная версия микросервисного приложения.



\## Исправленные ошибки

\- ✅ `DB\_HOST: localhost` → `DB\_HOST: db` (корректное имя сервиса в сети Docker)

\- ✅ Добавлен именованный volume `pgdata` для сохранения данных БД

\- ✅ Добавлен `healthcheck` для БД + `condition: service\_healthy` для ожидания готовности

\- ✅ Исправлен `proxy\_pass` во фронтенде: `localhost:5000` → `backend:5000`



\## Запуск

```bash

docker compose up --build

