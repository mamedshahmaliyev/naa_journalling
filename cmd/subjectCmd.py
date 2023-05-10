from entities.subject import *
from helpers.db import *
from cmd.generalCmd import *


class SubjectCmd(GeneralCmd):

    @staticmethod
    def getEntityTitle()-> str:
        return 'Subject'

    @staticmethod
    def getActions() -> dict:
        return {
            'Add new subject': SubjectCmd.add,
            'Delete subject': SubjectCmd.delete,
            'Show subject(s)': SubjectCmd.show,
        }
    
    def add():

        name = input("Enter subject name: ")
        short_name = input("Enter subject short name: ")
        hours = int(input("Enter subject hours (default 75): ") or 75)
        credit = int(input("Enter subject credit (default 4): ") or 4)

        subject = Subject(name, short_name, hours, credit)
        subject.save()

        print("{} added successfully:".format(__class__.getEntityTitle()), subject, subject.__dict__)

    def delete():
        id = int(input("Enter subject id: "))
        subject = Subject.byId(id)
        subject.delete()
        print("{} removed successfully:".format(__class__.getEntityTitle()), subject.__dict__)

    def show():
        sql = 'select * from subjects where 1=1'

        print("Set filters below:")

        # exact filters
        for field in ['id', 'hours', 'credit']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " and `{}` = '{}'".format(field, value)
        
        # wildcard filters
        for field in ['name', 'short_name']:
            value = input("Enter filter for field '{}': ".format(field))
            if value != '':
                sql += " and `{}` like '%{}%'".format(field, value)

        Db.selectAndPrettyPrint(sql)