import pandas
import firebase_admin as firebase
from firebase_admin import firestore, credentials, db 
import os
if __name__ == "__main__":
    credential = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
    cred = credentials.Certificate(credential)
    firebase.initialize_app(cred, {'projectId': 'vcounter-6d83c'})               #initialize firebase app
    
    db = firestore.client()
    db_ref = db.collection(u'saved-games')
    #print("Hello There!")
    docs = db_ref.stream()
    del_elem = []    


    counter = 0
    for elem in docs:
        elem_dict = elem.to_dict()
        if elem_dict['date'] == 'Null':
            #print(elem_dict)
            counter += 1
        elem.reference.delete()

        #print(f'{elem.id} => {elem.to_dict()}')
        counter += 1
    print("you have "+str(counter)+" elem to delete!")
