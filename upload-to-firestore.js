const admin = require('firebase-admin');
const fs = require('fs');

var serviceAccount = require('./ServiceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

var db = admin.firestore();
db.settings({timestampsInSnapshots: true});

var collection = db.collection('performance-tests');

fs.readFile('result.json', 'utf8', function(err, contents){
  collection.add(JSON.parse(contents));
});	

