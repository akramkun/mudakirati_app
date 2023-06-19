const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');

const todoRoutes = require('./routes/todo')

const app = express();
dotenv.config();
const PORT = process.env.PORT;
const DATABASE_URL = process.env.DATABASE_URL;

app.use([express.urlencoded({ extended: true }), express.json()]);
app.get('/', (req, res) => res.json('API is Working !!'));
app.use('/todo', todoRoutes);

mongoose.connect(DATABASE_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log('connect to DB successful');
    app.listen(PORT, () => console.log(`Server is running at ${PORT}`));
}).catch((err) => {
    console.log('connect to DB failed');
    console.log(err);
})
    ;

