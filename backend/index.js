const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const dotenv = require('dotenv');

const authRoute = require("./routes/auth");
const userRoute = require("./routes/user");
const jobRoute = require("./routes/job");
const bookmarkRoute = require("./routes/bookmark");
const appliedRoute = require("./routes/apply");


dotenv.config()

// Temporarily comment out Firebase for testing
// const admin = require('firebase-admin')
// const serviceAccount = require('./servicesAccountKey.json')
// admin.initializeApp({
//     credential: admin.credential.cert(serviceAccount)
// });

const mongoose = require('mongoose');
mongoose.connect(process.env.MONGO_URL)
    .then(() => console.log("connected to the db")).catch((err) => { console.log(err) });

// CORS Configuration for HTTP only - Allow all origins
app.use(cors({
    origin: true, // Allow all origins
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept', 'Origin'],
    credentials: false, // Set to false for HTTP
    optionsSuccessStatus: 200
}));

// Additional CORS middleware to handle HTTP requests
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With, Accept, Origin');
    res.header('Access-Control-Allow-Credentials', 'false');
    
    if (req.method === 'OPTIONS') {
        res.sendStatus(200);
    } else {
        next();
    }
});
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use("/api/", authRoute);
app.use("/api/users", userRoute);
app.use("/api/jobs", jobRoute);
app.use("/api/bookmarks", bookmarkRoute);
app.use("/api/applied", appliedRoute);


//app.listen(process.env.PORT || 4000, () => console.log(`Example app listening on port ${process.env.PORT}!`));
const ip = process.env.IP || "0.0.0.0";
const port = process.env.PORT || 5002; 

app.listen(port, ip, () => {
  console.log(`Product server listening on ${ip}:${port}`);
});