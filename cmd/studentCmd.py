from entities.student import *
from helpers.db import *
from helpers.enums import *
from cmd.generalCmd import *


class StudentCmd(GeneralCmd):

    @staticmethod
    def getEntityTitle()-> str:
        return 'Student'

    @staticmethod
    def getActions() -> dict:
        return {
            'Add': StudentCmd.add,
            'Delete': StudentCmd.delete,
            'Show': StudentCmd.show,
            'New Action': StudentCmd.newAction,
        }
    
    @staticmethod
    def add():

        name = input("Enter student name: ")
        surname = input("Enter student surname: ")
        patronymic = input("Enter student patronymic: ")
        gender = input("Enter student gender (male, female): ")

        if gender not in [Gender.MALE.value, Gender.FEMALE.value]:
            raise Exception("Wrong gender!")

        student = Student(name=name, surname=surname, patronymic=patronymic, gender=Gender(gender))
        student.save()

        print("Student added successfully:", student, student.__dict__)

    @staticmethod
    def delete():
        id = int(input("Enter student id: "))
        student = Student.byId(id)
        student.delete()
        print("Student removed successfully:", student, student.__dict__)

    @staticmethod
    def show():

        sql = 'select * from {} where 1=1'.format(Student.getTableName())

        print("Set filters below:")

        # exact filters
        for field in ['id']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " and `{}` = '{}'".format(field, value)
        
        # wildcard filters
        for field in ['name', 'surname', 'patronymic']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " AND `{}` like '%{}%'".format(field, value)

        Db.selectAndPrettyPrint(sql)

    @staticmethod
    def newAction():
        print("New action")