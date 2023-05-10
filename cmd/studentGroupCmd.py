from entities.studentGroup import *
from entities.student import *
from helpers.db import *
from cmd.generalCmd import *


class StudentGroupCmd(GeneralCmd):

    @staticmethod
    def getEntityTitle()-> str:
        return 'Student Group'

    @staticmethod
    def getActions() -> dict:
        return {
            'Add': __class__.add,
            'Delete': __class__.delete,
            'Show': __class__.show,
            'Show Starosta': __class__.showStarosta,
            'Specify Starosta': __class__.setStarosta,
            'Show Students': __class__.showStudents,
            'Add Student': __class__.addStudent,
            'Remove Student': __class__.deleteStudent,
        }
    
    @staticmethod
    def add():
        name = input("Enter group name: ")

        group = StudentGroup(name)
        group.save()

        print("{} added successfully:".format(__class__.getEntityTitle()), group, group.__dict__)

    @staticmethod
    def delete():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        item = StudentGroup.byId(id)
        item.delete()
        print("{} removed successfully:".format(__class__.getEntityTitle()), item, item.__dict__)

    @staticmethod
    def show():
        sql = 'select * from {} where 1=1'.format(StudentGroup.getTableName())

        print("Set filters below:")

        # exact filters
        for field in ['id']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " and `{}` = '{}'".format(field, value)
        
        # wildcard filters
        for field in ['name']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " and `{}` like '%{}%'".format(field, value)

        Db.selectAndPrettyPrint(sql)
    
    @staticmethod
    def showStarosta():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        group = StudentGroup.byId(id)
        print("Starosta of {}:".format(group.name), group.getStarosta())
    
    @staticmethod
    def setStarosta():
        id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        studentId = int(input("Enter student id: "))
        group = StudentGroup.byId(id)
        group.setStarosta(studentId)
        print("Starosta successfully set. Starosta of {}:".format(group.name), group.getStarosta())

    
    @staticmethod
    def showStudents(id: int = None):
        if id is None:
            id = int(input("Enter {} id: ".format(__class__.getEntityTitle())))
        group = StudentGroup.byId(id)
        students = group.getStudents()

        table = PrettyTable()
        table.field_names = ['id', 'name', 'surname', 'patronymic']

        for student in students:
            table.add_row([student.id, student.name, student.surname, student.patronymic])
        print('List of students for group:', group.name)
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