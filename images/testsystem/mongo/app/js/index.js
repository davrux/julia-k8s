// Create indexes for julialog collection
//
// call:
//
// /opt/julia/mongodb/bin/mongo 127.0.0.1:27017/juliadb index.js
//
// or with auth enabled:
// /opt/julia/mongodb/bin/mongo 127.0.0.1:27017/juliadb -ssl -sslAllowInvalidCertificates --authenticationDatabase admin -u julia -p password index.js
//
// show indexes:
// db.julialog.getIndexes()
//
// see, if index is used:
// db.julialog.find({'recipients':'meik.kreyenkoetter@iccsec.com'}).explain()
// db.julialog.find({time: {$gte: ISODate("2015-01-01T17:00:46Z") }}).explain()
//

// Create indexes on julialog collection

// ascending index on from and recipients
db.getCollection("julialog").ensureIndex({from:1}, {unique: false, sparse: true, dropDups: false, background: true});
db.getCollection("julialog").ensureIndex({recipients:1}, {unique: false, sparse: true, dropDups: false, background: true});


// combound index on from and recipients by time
db.getCollection("julialog").ensureIndex({from:1, time:-1}, {unique: false, sparse: true, dropDups: false, background: true});
db.getCollection("julialog").ensureIndex({recipients:1, time:-1}, {unique: false, sparse: true, dropDups: false, background: true});
db.getCollection("julialog").ensureIndex({from:1, recipients:1, time:-1}, {unique: false, sparse: true, dropDups: false, background: true});

// index on message id
db.getCollection("julialog").ensureIndex({messageid:1}, {unique: false, sparse: true, dropDups: false, background: true});

// index on log id
db.getCollection("julialog").ensureIndex({logid:1}, {unique: false, sparse: true, dropDups: false, background: true});


// ascending index on client
db.getCollection("julialog").ensureIndex({client:1}, {unique: false, sparse: true, dropDups: false, background: true});

// descending index on time field.
db.getCollection("julialog").ensureIndex({time:-1}, {unique: false, sparse: true, dropDups: false, background: true});


