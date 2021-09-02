import firebase_admin as firebase
from firebase_admin import firestore, credentials, db 
from google.api_core import datetime_helpers as datetimeh 
import os, datetime, pytz
from datetime import datetime, timedelta, timezone
if __name__ == "__main__":
    credential = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
    cred = credentials.Certificate(credential)
    firebase.initialize_app(cred, {'projectId': 'vcounter-6d83c'})               #initialize firebase app
    
    db = firestore.client()
    print('Scanning saved games...')
    db_ref = db.collection(u'saved-games')
    docs = db_ref.stream()
    del_elem = []    

    counter, skip_file = 0, 0
    for elem in docs:
        elem_dict = elem.to_dict()
        if elem_dict['date'] == 'Null':
            counter += 1
            elem.reference.delete()
        
        else:
            var_date = elem_dict['date']
            microseconds = datetimeh.to_microseconds(var_date) 
            epoch = datetime(1601, 1, 1, tzinfo=timezone.utc)
            start_date = datetime.fromtimestamp(int(microseconds/1000000))
            today = datetime.today()
            delta = (today - start_date).days
            if delta > 365:
                elem.reference.delete()
                counter += 1 
            else:
                print("Skip delete")
                skip_file += 1

    print("Scanning tournamente rankings...")
    db_ref = db.collection(u'tournament-ranking')
    docs = db_ref.stream()
    del_elem = []   

    for elem in docs:
        elem_dict = elem.to_dict()
        if 'date' in elem_dict.keys():
            var_date = elem_dict['date']
            microseconds = datetimeh.to_microseconds(var_date) 
            epoch = datetime(1601, 1, 1, tzinfo=timezone.utc)
            start_date = datetime.fromtimestamp(int(microseconds/1000000))
            today = datetime.today()
            delta = (today - start_date).days
            print('delta days: '+str(delta))
            if delta > 365:
                elem.reference.delete()
                counter += 1
            else: 
                print('Skip delete')
                skip_file += 1
        else:
            counter += 1
            elem.reference.delete()
            None 


    print("You have deleted "+str(counter)+" element/s!\nSkipped "+str(skip_file)+" files")
