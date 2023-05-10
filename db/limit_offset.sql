
C - news count per page, P - page number

Select * from news LIMIT OFFSET, COUNT

COUNT = C,      OFFSET = C*(P-1)

C = 10, P = 1.    Select * from news LIMIT 0, 10
C = 10, P = 2.    Select * from news LIMIT 10, 10
C = 10, P = 3.    Select * from news LIMIT 20, 10
C = 10, P = 5.    Select * from news LIMIT 40, 10
