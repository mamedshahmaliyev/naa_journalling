from entities.studentGroup import *
from entities.journal import *
from helpers.db import *
from cmd.generalCmd import *
from datetime import datetime


class JournalCmd(GeneralCmd):

    @staticmethod
    def getEntityTitle()-> str:
        return 'Journal'

    @staticmethod
    def getActions() -> dict:
        return {
            'Add': __class__.add,
            'Delete': __class__.delete,
            'Show': __class__.show,
            'Show Group': __class__.showGroup,
            'Set Group': __class__.setGroup,
            'Show Students': __class__.showStudents,
        }
    
    @staticmethod
    def add():
        kafedra = input("Enter kafedra: ")
        group = input("Enter group name: ")
        group = StudentGroup.byName(group)
        start_date = datetime.strptime( input("Enter start date (Y-m-d): "), '%Y-%m-%d').date()
        end_date = datetime.strptime( input("Enter end date (Y-m-d): "), '%Y-%m-%d').date()

        journal = Journal(kafedra, group.id, start_date, end_date)
        journal.save()

        print("{} added successfully:".format(__class__.getEntityTitle()), journal, journal.__dict__)

    @staticmethod
    def delete():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        item = Journal.byId(id)
        item.delete()
        print("{} removed successfully:".format(__class__.getEntityTitle()), item, item.__dict__)

    @staticmethod
    def show():
        sql = 'select a.*, b.name as "group" from {} a inner join {} b on a.student_group_id = b.id where 1=1'.format(Journal.getTableName(), StudentGroup.getTableName())

        print("Set filters below:")

        # exact filters
        for field in ['id', 'student_group_id']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " and `{}` = '{}'".format(field, value)
        
        # date filters
        for field in ['date_start', 'date_end']:
            value = input("Enter filter for field '{}' (Y-m-d): ".format(field))
            if value != '':
                sql += " and `{}` = '{}'".format(field, value)

        # wildcard filters
        for field in ['kafedra']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " AND `{}` like '%{}%'".format(field, value)

        Db.selectAndPrettyPrint(sql)
    
    @staticmethod
    def showGroup():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        journal = Journal.byId(id)
        print("Group of journal #{}:".format(journal.id), journal.getGroup())
    
    @staticmethod
    def setGroup():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        groupName = input("Enter group name: ")
        journal = Journal.byId(id)
        journal.setGroup(StudentGroup.byName(groupName).id)
        print("Group successfully set. Group of journal #{}:".format(journal.id), journal.getGroup())

    @staticmethod
    def showStudents(id: int = None):
        if id is None:
            id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        journal = Journal.byId(id)
        students = journal.getGroup().getStudents()

        table = PrettyTable()
        table.field_names = ['id', 'name', 'surname', 'patronymic']

        for student in students:
            table.add_row([student.id, student.name, student.surname, student.patronymic])
        print('List of students for journal:', journal.__dict__)
        print(table)

    @staticmethod
    def addStudent():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        studentId = int(input("Enter student id: "))
        group = StudentGroup.byId(id)
        group.addStudent(studentId)
        print("Student added")
        __class__.showStudents(id)
    
    @staticmethod
    def deleteStudent():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        studentId = int(input("Enter student id: "))
        group = StudentGroup.byId(id)
        group.deleteStudent(studentId)
        print("Student deleted")
        __class__.showStudents(id)