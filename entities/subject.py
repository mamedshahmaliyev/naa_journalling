from __future__ import annotations
from dataclasses import dataclass
from helpers.db import *

@dataclass
class Subject(DbObject):
    name: str
    short_name: str
    hours: int = 75
    credit: int = 4

    def __str__(self) -> str:
        return '{} - {} [id: {}]'.format(self.short_name, self.name, self.id)
    
    def save(self):
        sql = "INSERT INTO {} (name, short_name, hours, credit) VALUES (%s, %s, %s, %s)".format(self.__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (self.name, self.short_name, self.hours, self.credit))
        self.id = crs.lastrowid

    def byId(id: int)-> Subject:
        sql = "SELECT * FROM {} WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (id,))
        row = crs.fetchone()
        if row is None:
            raise Exception("Subject not found!")
        return Subject(row['name'], row['short_name'], row['hours'], row['credit']).setId(row['id'])
    
    def byIdOrCode(id_or_code)-> Subject:
        sql = "SELECT * FROM {} WHERE id = %s or short_name = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (id_or_code,id_or_code))
        row = crs.fetchone()
        if row is None:
            raise Exception("Subject not found!")
        return Subject(row['name'], row['short_name'], row['hours'], row['credit']).setId(row['id'])
    
    def getTableName()-> str:
        return 'subjects'