from __future__ import annotations
from dataclasses import dataclass
from .studentGroup import StudentGroup
from helpers.db import *
from helpers.enums import *
from datetime import date

@dataclass
class Journal(DbObject):

    kafedra: str
    student_group_id: int
    date_start: date
    date_end: date

    def getTableName()-> str:
        return 'journals'
    
    def save(self):
        sql = "INSERT INTO {} (`kafedra`, `student_group_id`, `date_start`, `date_end`) VALUES (%s, %s, %s, %s)".format(self.__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (self.kafedra, self.student_group_id, self.date_start, self.date_end))
        self.id = crs.lastrowid

    def byId(id: int)-> Journal:
        sql = "SELECT * FROM {} WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (id,))
        row = crs.fetchone()
        if row is None:
            raise Exception("Journal not found!")
        return Journal(row['kafedra'], row['student_group_id'], row['date_start'], row['date_end']).setId(row['id']).setId(row['id'])
    
    def byGroupName(group: str)-> Journal:
        sql = "SELECT * FROM {} WHERE group_id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (StudentGroup.byName(group).id,))
        row = crs.fetchone()
        if row is None:
            raise Exception("Journal not found!")
        return Journal(row['kafedra'], row['student_group_id'], row['date_start'], row['date_end']).setId(row['id']).setId(row['id'])
    
    # group operations
    def setGroup(self, groupId: int)-> Journal:
        # TODO: check if group exists
        sql = "update {} set student_group_id = %s WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (groupId, self.id))
        self.student_group_id = groupId
        return self
    
    def getGroup(self)-> StudentGroup:
        return StudentGroup.byId(self.student_group_id)
    
    