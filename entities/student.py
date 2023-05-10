from __future__ import annotations
from dataclasses import dataclass
from .person import Person
from helpers.db import *
from helpers.enums import *

@dataclass
class Student(Person, DbObject):
    
    def save(self):
        sql = "INSERT INTO {} (`name`, `surname`, `patronymic`, `gender`) VALUES (%s, %s, %s, %s)".format(self.__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (self.name, self.surname, self.patronymic, self.gender.value))
        self.id = crs.lastrowid

    def byId(id: int)-> Student:
        sql = "SELECT * FROM {} WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (id,))
        row = crs.fetchone()
        if row is None:
            raise Exception("Student not found!")
        return Student(row['name'], row['surname'], row['patronymic'], Gender(row['gender'])).setId(row['id'])
    
    def getTableName()-> str:
        return 'students'