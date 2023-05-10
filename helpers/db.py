import mysql.connector
from prettytable import PrettyTable

class Db:

    _db: mysql.connector = None

    def getCursor():
        if not Db._db:
            Db._db = mysql.connector.connect(host="localhost", user="root", password="", database="naa")
            Db._db.autocommit = True
        return Db._db.cursor(dictionary=True)
    
    def selectAndPrettyPrint(sql):
        print("SQL:", sql)

        crs = Db.getCursor()
        crs.execute(sql)

        rows = crs.fetchall()

        if not rows:
            print("-----------------No data found!-----------------")
            return

        table = PrettyTable()

        table.field_names = rows[0].keys()

        for row in rows:
            table.add_row(row.values())

        print(table)


class DbObject:
    id: int = None

    def setId(self, id: int):
        self.id = id
        return self

    def save(self):
        pass

    def byId(id):
        pass

    def getTableName()-> str:
        pass

    def delete(self):
        sql = "DELETE FROM {} WHERE id = %s".format(self.__class__.getTableName())
        Db.getCursor().execute(sql, (self.id,))