from __future__ import annotations
from dataclasses import dataclass
from helpers.db import *
from .student import *
from typing import List

@dataclass
class StudentGroup(DbObject):
    name: str
    starosta_id: int = None

    def save(self)-> StudentGroup:
        sql = "INSERT INTO {} (name, starosta_id) VALUES (%s, %s)".format(self.__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (self.name, self.starosta_id))
        self.id = crs.lastrowid
        return self

    def byId(id: int)-> StudentGroup:
        sql = "SELECT * FROM {} WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (id,))
        row = crs.fetchone()
        if row is None:
            raise Exception("Group not found!")
        return StudentGroup(row['name'], row['starosta_id']).setId(row['id'])
    
    def byName(name: str)-> StudentGroup:
        sql = "SELECT * FROM {} WHERE name = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (name,))
        row = crs.fetchone()
        if row is None:
            raise Exception("Group not found!")
        return StudentGroup(row['name'], row['starosta_id']).setId(row['id'])
    
    # set show starosta
    def setStarosta(self, studentId: int)-> StudentGroup:
        sql = "update {} set starosta_id = %s WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (studentId, self.id))
        self.starosta_id = studentId
        return self
    
    def getStarosta(self)-> Student:
        return Student.byId(self.starosta_id) if self.starosta_id is not None else None
    

    # add remove students to group
    def getStudents(self)-> List[Student]:
        # TODO: check if student already added to group
        sql = "select s.* from students s inner join student_groups__students sg on sg.student_id = s.id and sg.student_group_id = %s"
        crs = Db.getCursor()
        crs.execute(sql, (self.id,))
        return list(map(lambda row: Student(row['name'], row['surname'], row['patronymic']).setId(row['id']), crs.fetchall()))
    
    def addStudent(self, studentId: int)-> StudentGroup:
        # TODO: check if student already added to other group
        sql = "insert into student_groups__students(student_group_id, student_id) values(%s, %s)"
        Db.getCursor().execute(sql, (self.id, studentId))
        return self
    
    def deleteStudent(self, studentId: int)-> int:
        sql = "delete from student_groups__students where student_group_id = %s and student_id = %s"
        crs = Db.getCursor()
        crs.execute(sql, (self.id, studentId))
        return crs.rowcount
    
    def getTableName()-> str:
        return 'student_groups'
    