from enum import Enum

class Gender(Enum):
    MALE = 'male'
    FEMALE = 'female'

class JournalRecordType(Enum):
    LECTURE = 'lecture'
    SEMINAR = 'seminar'
    KOLLOKVIUM = 'kollokvium'
    LAB = 'lab'

class Presence(Enum):
    PRESENT = 1
    ABSENT = 0