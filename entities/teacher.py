from __future__ import annotations
from dataclasses import dataclass
from .person import Person
from helpers.db import *
from helpers.enums import *

@dataclass
class Teacher(Person, DbObject):
    
    def save(self):
        sql = '''
            INSERT INTO {} (`id`, `name`, `surname`, `patronymic`, `gender`) 
                    VALUES (%s, %s, %s, %s, %s) as new
            ON DUPLICATE KEY UPDATE `name`=new.`name`, `surname`=new.`surname`, `patronymic`=new.`patronymic`, `gender`=new.`gender`
        '''.format(self.__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (self.id, self.name, self.surname, self.patronymic, self.gender.value))
        self.id = crs.lastrowid

    def byId(id: int)-> Teacher:
        sql = "SELECT * FROM {} WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (id,))
        row = crs.fetchone()
        if row is None:
            raise Exception("Teacher not found!")
        return Teacher(row['name'], row['surname'], row['patronymic'], Gender(row['gender'])).setId(row['id'])
    
    def getTableName()-> str:
        return 'teachers'