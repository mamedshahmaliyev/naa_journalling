
select 
jr.record_date, 
sb.name as 'subject',
CONCAT_WS(' ', s.name, s.surname) as 'student',
jr.is_present ,
jr.mark,
jr.record_type 
from journal_records jr
inner join subjects sb on sb.id = jr.subject_id 
inner join students s on s.id = jr.student_id 
where jr.mark is not null 
and jr.record_type = 'kollokvium';

select 
record_type,
count(distinct record_date)
from journal_records jr
group by record_type;



select s.name, s.surname, avg(mark) 
from journal_records jr
inner join students s on s.id = jr.student_id 
where jr.mark is not null
group by s.id



-- number of presents
select s.name, s.surname, sum(is_present) 'present_count'
from journal_records jr
inner join students s on s.id = jr.student_id
group by jr.student_id 
order by 3 desc


-- number of absents
select 
s.name,
s.surname, 
count(is_present) - sum(is_present) 'absent_count'
from journal_records jr
inner join students s on s.id = jr.student_id
group by jr.student_id 
order by 3 desc



-- number of absents
select 
s.name,
s.surname, 
count(*) 'absent_count'
from journal_records jr
inner join students s on s.id = jr.student_id
where jr.is_present = 0
group by jr.student_id 
order by 3 desc






select 
concat(s.name, ' ', s.surname) as 'student',
sum(is_present) 'cnt',
'present_count' as 'label'
from journal_records jr
inner join students s on s.id = jr.student_id
group by jr.student_id 
union 
select 
concat(s.name, ' ', s.surname) as 'student',
count(*) 'cnt',
'absent_count'
from journal_records jr
inner join students s on s.id = jr.student_id
where jr.is_present = 0
group by jr.student_id 




----- general info
select distinct
	s.name 'Subject', 
	concat_ws(' - ', j.date_start , j.date_end) as 'period',
	sg.name as 'Group',
	concat_ws(' ', st.name, st.surname, st.patronymic) as 'student'
from       journal_records jr
inner join journals        j on j.id = jr.journal_id 
inner join student_groups  sg on sg.id = j.student_group_id
inner join subjects        s on s.id = jr.subject_id 
inner join students        st on st.id = jr.student_id 













