//
// Setup Auth for MongoDB
//
// call:
//
// /opt/julia/mongodb/bin/mongo 127.0.0.1:27017/admin -ssl -sslAllowInvalidCertificates -u julia -p password
//

// Julia User
db.createUser(
    {
      user: "julia",
      pwd: "juliapwd",
      roles: [ "root" ]
    }
)
