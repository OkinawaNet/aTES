# aTES

## Установка:
1) Запустите команды:
```bash
docker-compose build
docker-compose run task-tracker rails db:migrate
docker-compose run accounting rails db:migrate
docker-compose run analytics rails db:migrate
docker-compose up
```

2) Настройка Keycloak:
- Перейдите по адресу http://localhost:7000/auth (admin/admin)
- Активируйте события webhook в пользовательском интерфейсе администратора, перейдя в раздел Configure Realm Settings > Events tab > Event Listeners, в раскрывающемся списке слушателей событий выберите ext-event-webhook и сохраните изменения.
- Добавьте клиенты: task_tracker, accounting, analytics
- Создайте роль "popug"
- Добавьте пользователей с ролью "popug"

## Ссылки:
- TaskTracker: [http://localhost:9000](http://localhost:9000)
- Accounting: [http://localhost:10000](http://localhost:10000)
- Analytics: [http://localhost:11000](http://localhost:11000)
- KafkaUI: [http://localhost:12000](http://localhost:12000)

## Схема:
### Event Storming
![Event Storming](images/hw_1/ES.png)
### Модель данных
![Data Model](images/hw_1/DM.png)
### Сервисы
![Services](images/hw_1/Services.png)



