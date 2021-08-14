from google.cloud import firestore, storage

if __name__ == "__main__":
    print("Clear saved-game database")
    storage_client = storage.Client()
    db = firestore.Client()
    collections = db.collections()
    # print(db.collections())
    doc_ref = db.collection('saved-games').list_documents()
    # doc_list = list(doc_ref)
    # print(doc_list)
    # for elem in range(doc_ref):
    #     None
    # print(doc_ref)
    for row in doc_ref:
        print(row)
        # None
