const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');
const app = express();
const dotenv = require('dotenv');

const authRoute = require("./routes/auth");
const userRoute = require("./routes/user");
const jobRoute = require("./routes/job");
const bookmarkRoute = require("./routes/bookmark");
const appliedRoute = require("./routes/apply");
const chatRoute = require("./routes/chat");
const matchingRoute = require("./routes/matching");


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
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept', 'Origin'],
    credentials: false,
    optionsSuccessStatus: 200
}));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Serve uploaded resumes as static files
app.use('/resumes', express.static(path.join(__dirname, 'resumes')));

app.use("/api/", authRoute);
app.use("/api/users", userRoute);
app.use("/api/jobs", jobRoute);
app.use("/api/bookmarks", bookmarkRoute);
app.use("/api/applied", appliedRoute);
app.use("/api/chat", chatRoute);
app.use("/api/matching", matchingRoute);


//app.listen(process.env.PORT || 4000, () => console.log(`Example app listening on port ${process.env.PORT}!`));
const ip = process.env.IP || "0.0.0.0";
const port = process.env.PORT || 5002; 

app.listen(port, ip, () => {
  console.log(`Product server listening on ${ip}:${port}`);
});