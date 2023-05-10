from cmd.subjectCmd import SubjectCmd
from cmd.studentCmd import StudentCmd
from cmd.teacherCmd import TeacherCmd
from cmd.studentGroupCmd import StudentGroupCmd
from cmd.journalCmd import JournalCmd
from cmd.journalRecordCmd import *

class cmdApp:

    def getEntityList()-> list:
        return [
            SubjectCmd,
            StudentCmd,
            TeacherCmd,
            StudentGroupCmd,
            JournalCmd,
            JournalRecordCmd,
        ]
    
    def run():

        selectedEntity = None
        entities = cmdApp.getEntityList()
        selectedAction = None
        entityActions = []

        while True:

            # first select entity if not selected
            if selectedEntity is None:

                for i, entity in enumerate(entities):
                    print('{}.'.format(i+1), entity.getEntityTitle())

                print('{}.'.format(len(entities)+1), 'Exit')
                
                selectedEntity = int(input("Select entity: ") or len(entities)+1)

                if selectedEntity < 1 or selectedEntity > len(entities):
                    return
                
                selectedEntity = entities[selectedEntity-1]
                entityActions = selectedEntity.getActions()

            # then select action
            for i, action in enumerate(entityActions.keys()):
                print('{}.'.format(i+1), action)
            
            print('{}.'.format(len(entityActions)+1), 'Go back and select entity')
            
            selectedAction = int(input("Select action for '{}' entity: ".format(selectedEntity.getEntityTitle())) or 99)

            if selectedAction < 1 or selectedAction > len(entityActions):
                selectedEntity = None
            else:
                list(entityActions.values())[selectedAction-1]()

            print()



if __name__ == '__main__':
    cmdApp.run()