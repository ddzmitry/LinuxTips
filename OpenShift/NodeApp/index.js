const express = require('express');
const app = express();
app.get('/', (req,res) => {
    res.send("<h1>TEST  HERE TOO UPDATED</h1>")
});

app.listen(8080, () => {
    console.log(`Listerinig on port 8080`)
});
