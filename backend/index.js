const express = require('express');
const bodyParser = require('body-parser');
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



app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use("/api/", authRoute);
app.use("/api/users", userRoute);
app.use("/api/jobs", jobRoute);
app.use("/api/bookmarks", bookmarkRoute);
app.use("/api/applied", appliedRoute);


//app.listen(process.env.PORT || 4000, () => console.log(`Example app listening on port ${process.env.PORT}!`));
const ip = process.env.IP || "127.0.0.1";

const port = process.env.PORT || 3000; 

app.listen(port, ip, () => {
  console.log(`Product server listening on ${ip}:${port}`);
});