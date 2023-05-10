from entities.journalRecord import *
from entities.studentGroup import *
from entities.journal import *
from helpers.db import *
from helpers.enums import *
from cmd.generalCmd import *
from datetime import datetime


class JournalRecordCmd(GeneralCmd):

    @staticmethod
    def getEntityTitle()-> str:
        return 'Journal Record'

    @staticmethod
    def getActions() -> dict:
        return {
            'Add': __class__.add,
            'Delete': __class__.delete,
            'Show': __class__.show,
            'Show Vedomost': __class__.showVedomost,
        }
    
    @staticmethod
    def add():

        journal_id = input("Enter journal id: ")
        teacher_id = int(input("Enter teacher id: "))
        record_date = datetime.strptime( input("Enter record date (Y-m-d): "), '%Y-%m-%d').date()
        subject_code_or_id = input("Enter subject code or id: ")
        record_type = JournalRecordType(input("Enter record type({}, {}, {}, {}): ".format(JournalRecordType.LECTURE.value, JournalRecordType.SEMINAR.value, JournalRecordType.LAB.value, JournalRecordType.KOLLOKVIUM.value)))
        hour = int(input("Enter hour: "))
        student_id = int(input("Enter student id: "))
        precence = Presence(int(input("Enter presence (1 or 0): ")))
        mark = input("Enter mark (if student has mark, leave empty if no mark): ")
        mark = None if mark == '' else int(mark)

        record = JournalRecord(Journal.byId(journal_id), Teacher.byId(teacher_id), record_date, Subject.byIdOrCode(subject_code_or_id), record_type, hour, Student.byId(student_id), precence, mark)
        record.save()

        print("Record added successfully:", record, record.__dict__)

    @staticmethod
    def delete():
        id = int(input("Enter record id: "))
        record = JournalRecord.byId(id)
        record.delete()
        print("Journal record removed successfully:", record, record.__dict__)

    @staticmethod
    def show():

        sql = '''
            select 
                concat(sub.name, '[', sub.short_name, ']') as subject,
                jr.record_date,
                concat(s.surname, ' ', s.name, ' ', s.patronymic) as student,
                jr.record_type,
                jr.hour,
                jr.is_present,
                jr.mark,
                sg.name as 'group',
                j.kafedra,
                concat(j.date_start, ' - ', j.date_end) as period,
                concat(t.surname, ' ', t.name, ' ', t.patronymic) as teacher
              from journal_records jr
              inner join journals j on jr.journal_id = j.id
              inner join student_groups sg on j.student_group_id = sg.id
              inner join students s on jr.student_id = s.id
              inner join teachers t on jr.teacher_id = t.id
              inner join subjects sub on jr.subject_id = sub.id
            where 1=1
        '''

        print("Set filters below:")

        # first choose journal
        sql += " and `journal_id` = '{}'".format(int(input("Enter journal_id: ")))

        # exact filters
        for field in ['subject_id', 'teacher_id', 'student_id', 'hour', 'is_present', 'mark']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " and `{}` = '{}'".format(field, value)
        
        # # wildcard filters
        # for field in ['name', 'surname', 'patronymic']:
        #     value = input("Enter filter for field '{}': ".format(field))
        #     if value != '':
        #         sql += " AND `{}` like '%{}%'".format(field, value)

        sql += " order by j.id, sub.name, jr.record_date, jr.record_type, jr.hour, s.id"
        Db.selectAndPrettyPrint(sql)

    @staticmethod
    def showVedomost():
        # TODO: to be implemented by students
        pass