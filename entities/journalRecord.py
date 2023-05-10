from __future__ import annotations
from dataclasses import dataclass
from .journal import Journal
from .teacher import Teacher
from .subject import Subject
from .student import Student
from helpers.db import *
from helpers.enums import *
from datetime import date

@dataclass
class JournalRecord(DbObject):

    journal: Journal
    teacher: Teacher
    record_date: date
    subject: Subject
    record_type: JournalRecordType
    hour: int
    student: Student
    is_present: Presence
    mark: int = None

    def getTableName()-> str:
        return 'journal_records'
    
    def save(self):
        sql = "INSERT INTO {} (`journal_id`, `teacher_id`, `record_date`, `subject_id`, `record_type`, `hour`, `student_id`, `is_present`, `mark`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)".format(self.__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (self.journal.id, self.teacher.id, self.record_date, self.subject.id, self.record_type.value, self.hour, self.student.id, self.is_present.value, self.mark))
        self.id = crs.lastrowid

    def byId(id: int)-> JournalRecord:
        sql = "SELECT * FROM {} WHERE id = %s".format(__class__.getTableName())
        crs = Db.getCursor()
        crs.execute(sql, (id,))
        row = crs.fetchone()
        if row is None:
            raise Exception("JournalRecord not found!")
        return Journal(
                        Journal.byId(row['journal_id']),
                        Teacher.byId(row['teacher_id']), 
                        row['record_date'],
                        Subject.byId(row['subject_id']),
                        JournalRecordType(row['record_type']),
                        row['hour'],
                        Student.byId(row['student_id']),
                        Presence(row['is_present']),
                        row['mark']
                    ).setId(row['id']).setId(row['id'])
    
    
    