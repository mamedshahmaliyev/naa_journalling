from __future__ import annotations
from dataclasses import dataclass
from helpers.enums import *

@dataclass
class Person:
    name: str
    surname: str
    patronymic: str = None
    gender: Gender = None

    def getFullName(self):
        return '{} {} {}'.format(self.name, self.surname, '{}{}'.format(self.patronymic, (' oğlu' if self.gender == Gender.MALE else ' qızı') if self.gender else '') if self.patronymic else '')
    
    def __str__(self) -> str:
        return self.getFullName()