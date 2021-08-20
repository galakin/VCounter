import pandas
import firebase_admin as firebase
from firebase_admin import firestore, credentials, db 
import os
if __name__ == "__main__":
    credential = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
    #print(credential)
    cred = credentials.Certificate(credential)
    firebase.initialize_app(cred, {'projectId': 'vcounter-6d83c'})               #initialize firebase app
    
    #Clinet = firestore.client()
    db = firestore.client()
    db_ref = db.collection(u'saved-games')
    #print("Hello There!")
    print(db_ref)
    docs = db_ref.stream()
    
    for elem in docs:
        print(f'{elem.id} => {elem.to_dict()}')
        #print(elem)
        None

