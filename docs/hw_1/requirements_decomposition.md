# Общие требования

## Таск-трекер

1. Таск-трекер должен быть отдельным дашбордом и доступен всем сотрудникам компании UberPopug Inc.
    - Actor: "Account:LoginedToUberPopug" event
    - Command: TaskTracker: Login
    - Data: Account public id
    - Event: Account:LoginedToTaskTracker

2. Авторизация в таск-трекере должна выполняться через общий сервис авторизации UberPopug Inc (у нас там инновационная система авторизации на основе формы клюва).
    - Actor: Account
    - Command: Login to Uber Popug
    - Data: Account public id
    - Event: Account:LoginedToUberPopug

3. В таск-трекере должны быть только задачи. Проектов, скоупов и спринтов нет, потому что они не умещаются в голове попуга.
    - Actor: Account
    - Command: TaskTracker: Get tasks
    - Data: Account public id
    - Event: ?

4. Новые таски может создавать кто угодно (администратор, начальник, разработчик, менеджер и любая другая роль). У задачи должны быть описание, статус (выполнена или нет) и рандомно выбранный попуг (кроме менеджера и администратора), на которого заассайнена задача.
    - Actor: Account
    - Command: TaskTracker: Create new Task
    - Data: Task, Account public id
    - Event: TaskTracker:TaskCreated

5. Менеджеры или администраторы должны иметь кнопку «заассайнить задачи», которая возьмёт все открытые задачи и рандомно заассайнит каждую на любого из сотрудников (кроме менеджера и администратора) . Не успел закрыть задачу до реассайна — сорян, делай следующую.
   - a) Ассайнить задачу можно на кого угодно (кроме менеджера и администратора), это может быть любой существующий аккаунт из системы.
     - Actor: Account:Manager / Account:Admin
     - Command: TaskTracker: Assign Tasks
     - Data: ?
     - Event: TaskTracker:AssignTasks

   - b) Ассайнить задачу на нового попуга, можно только кнопкой «заассайнить задачи», других вариантов нет
      - Actor: "Task:Assign" event
      - Command: TaskTracker: Assign Task
      - Data: Task, Account:Popug public id
      - Event: Task:Assigned

   - c) При нажатии кнопки «заассайнить задачи» все текущие не закрытые задачи должны быть случайным образом перетасованы между каждым аккаунтом в системе
      - Actor: "TaskTracker:AssignTasks" event
      - Command: TaskTracker: Reassign Tasks
      - Data: Open Tasks, Account:Popug public ids
      - Event: Task:Assign

   - d) Мы не заморачиваемся на ограничение по нажатию на кнопку «заассайнить задачи». Её можно нажимать хоть каждую секунду.
      - Actor: Account:Manager / Account:Admin
      - Command: TaskTracker: Assign Tasks
      - Data: ?
      - Event: TaskTracker:AssignTasks

   - e) На одного сотрудника может выпасть любое количество новых задач, может выпасть ноль, а может и 10.
   - f) Создать задачу не заасайненую на пользователя нельзя. Т.е. любая задача должна иметь попуга, который ее делает
      - Actor: "Task:Assign" event
      - Command: TaskTracker: Assign Task
      - Data: Task, Account:Popug public id
      - Event: Task:Assigned

6. Каждый сотрудник должен иметь возможность:
   - видеть в отдельном месте список заассайненных на него задач.
     - Actor: Account
     - Command: TaskTracker: Get tasks
     - Data: Account public id
     - Event: ?
   - отметить задачу выполненной.
      - Actor: Account
      - Command: TaskTracker: ResolveTask 
      - Data: Task
      - Event: Task:Resolved

## Аккаунтинг: кто сколько денег заработал
1. Аккаунтинг должен быть в отдельном дашборде и доступным только для администраторов и бухгалтеров.
    - Actor: "Account:LoginedToUberPopug" event
    - Command: Accounting: Login
    - Data: Account(Popug, Admin, Accountant) public id
    - Event: Account:LoginedToAccounting

   - у обычных попугов доступ к аккаунтингу тоже должен быть. Но только к информации о собственных счетах (лог операций + текущий баланс).
     - лог операций
         - Actor: Account:Popug
         - Command: Accounting: Get log
         - Data: Account:Popug public id
         - Event: Accounting:GetLog
     - текущий баланс
         - Actor: Account:Popug
         - Command: Accounting: Get balance
         - Data: Account:Popug public id
         - Event: Accounting:GetBalance
   - У админов и бухгалтеров должен быть доступ к общей статистике по деньгами заработанным (количество заработанных топ-менеджментом за сегодня денег + статистика по дням).
       - количество заработанных топ-менеджментом за сегодня денег
           - Actor: Account:Admin / Account:Accountant
           - Command: Accounting: Get Stats Today
           - Data: date
           - Event: Accounting:GetStatsToday
       - статистика по дням
           - Actor: Account:Admin / Account:Accountant
           - Command: Accounting: Get Stats
           - Data: date interval
           - Event: Accounting:GetStats
2. Авторизация в дешборде аккаунтинга должна выполняться через общий сервис аутентификации UberPopug Inc.
    - Actor: Account
    - Command: Login to Uber Popug
    - Data: ?
    - Event: Account:LoginedToUberPopug
3. У каждого из сотрудников, при регистрации в системе, должен быть свой счёт, который показывает,
   - сколько за сегодня он получил денег
     - Actor: Account
     - Command: Accounting: Get Stats Today
     - Data: date, account public id
     - Event: Accounting:GetStatsToday
   - У счёта должен быть лог того, за что были списаны или начислены деньги, с подробным описанием каждой из операций.
       - Actor: Account
       - Command: Accounting: Get log
       - Data: date, Account public id
       - Event: Accounting:GetLog
4. Расценки:
   - цены на задачу определяется единоразово, в момент появления в системе (можно с минимальной задержкой)
   - цены рассчитываются без привязки к сотруднику
   - бизнес не планирует менять формулу генерации цен в обозримом будущем
   - формула, которая говорит сколько списать денег с сотрудника при ассайне задачи (всегда положительное число) — rand(10..20)$
       - Actor: "TaskTracker:TaskCreated" event
       - Command: Task: Set assign price
       - Data: Task public id
       - Event: Accounting: AssignPriceSet
   - формула, которая говорит сколько начислить денег сотруднику для выполненой задачи — rand(20..40)$
       - Actor: "TaskTracker:TaskCreated" event
       - Command: Task: Set resolved price
       - Data: Task public id
       - Event: Accounting: ResolvePriceSet
   - деньги 
     - списываются сразу после ассайна на сотрудника,
         - Actor: "Task:Assigned" event
         - Command: TaskTracker: Write off money
         - Data: Task public id, Sum
         - Event: TaskTracker: WriteOffMoney
     - а начисляются после выполнения задачи.
         - Actor: "Task:Resolved" event
         - Command: TaskTracker: Charge price
         - Data: Task public id, Sum
         - Event: Accounting: ResolvePriceCharged
   - отрицательный баланс переносится на следующий день. Единственный способ его погасить - закрыть достаточное количество задач в течение дня.
     - Actor: 00:00 trigger
     - Command: Accounting: Save debt
     - Data: Account public id, debt
     - Event: Accounting: DebtSaved
5. Дашборд должен выводить количество заработанных топ-менеджментом за сегодня денег.
   - a) т.е. сумма заасайненых задач минус сумма всех закрытых задач за день: sum(assigned task fee) - sum(completed task amount)
     - Actor: Account:Admin / Account:Accountant
     - Command: Accounting: Get Stats Today
     - Data: date
     - Event: Accounting:GetStatsToday
   - б) цена асайна или цена выплаты указывается всегда с положительным знаком
6. В конце дня необходимо:
   - a) считать сколько денег сотрудник получил за рабочий день
     - Actor: 00:00 trigger
     - Command: Accounting: calculate earned by id
     - Data: Account public id, debt
     - Event: Accounting: EarnedCalculated
   - b) отправлять на почту сумму выплаты.
       - Actor: "Accounting: EarnedCalculated" event
       - Command: Accounting: send earned to email
       - Data: Account public id, earned_sum
       - Event: Accounting: EarnedMessageSent

7. После выплаты баланса (в конце дня):
   - он должен обнуляться, 
      - Actor: "Accounting: EarnedMessageSent" event
      - Command: Accounting: account balancing
      - Data: Account public id
      - Event: Accounting: AccountBalanced
   - и в аудитлоге всех операций аккаунтинга должно быть отображено, что была выплачена сумма.
     - Actor: "Accounting: EarnedMessageSent" event
     - Command: Accounting: audit logging save "paid" message
     - Data: Account public id
     - Event: Accounting:AuditLog:PaidMessageSaved
8. Дашборд должен выводить информацию по дням, а не за весь период сразу.
   - a) вообще хватит только за сегодня (всё равно попуги дальше не помнят), но если чувствуете, что успеете сделать аналитику за каждый день недели — будет круто

## Аналитика

1. Аналитика — это отдельный дашборд, доступный только админам.
    - Actor: "Account:LoginedToUberPopug" event
    - Command: Analytic: Login
    - Data: Account(Admin) public id
    - Event: Account:LoginedToAnalytic
2. Нужно указывать, 
   - сколько заработал топ-менеджмент за сегодня
     - Actor: Account:Admin
     - Command: Analytic: get earned today
     - Data: date
     - Event: Analytic:GetEarnedToday
   - и сколько попугов ушло в минус.
     - Actor: Account:Admin
     - Command: Analytic: get bankrupts today
     - Data: ?
     - Event: Analytic:GetBankruptsToday
3. Нужно показывать самую дорогую задачу за день, неделю или месяц. Самой дорогой задачей является задача с наивысшей ценой из списка всех закрытых задач за указанный период времени
      - Actor: Account:Admin
      - Command: Analytic: get most expensive
      - Data: period
      - Event: Analytic:GetMostExpensive
