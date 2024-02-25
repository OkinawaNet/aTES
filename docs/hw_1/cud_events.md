1) Login to  Auth
Producer:
   Auth Service
Consumer:
   Task Tracker Service
   Accounting Service
   Analytic Service
2) Balance Updated
Producer:
    TaskTrackerResolverService
    TaskTrackerAssignService
Consumer:
    AccountingService
    TaskTrackerResolverService
    TaskTrackerAssignService
2) AccountingEventAdded
producer:
   AccountingService
consumer:
    TaskTrackerResolverService
    TaskTrackerAssignService

