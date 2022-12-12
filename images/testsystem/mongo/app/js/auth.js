//
// Setup Auth for MongoDB
//
// call:
//
// /opt/julia/mongodb/bin/mongo 127.0.0.1:27017/admin -ssl -sslAllowInvalidCertificates -u juliaAdmin -p password
//

// Create the admin user juliaAdmin
// This is the user admin
db.createUser(
  {
    user: "juliaAdmin",
    pwd: "juliaadminpwd",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)

