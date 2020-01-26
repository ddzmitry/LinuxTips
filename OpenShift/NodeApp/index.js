const express = require('express');
const app = express();
app.get('/', (req,res) => {

    function getRandomColor() {
        var letters = '0123456789ABCDEF';
        var color = '#';
        for (var i = 0; i < 6; i++) {
          color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
      }
    let color = getRandomColor()
    console.log(color)
    let colo2 = `color:${color}`
    console.log(colo2)
    res.send(`<h1 style="${colo2}" >TEST WAS  HERE TOO POOP44 ${colo2} </h1>`)
});

app.listen(8080, () => { 
    console.log("HELLO")

    console.log(`Listerinig on port 8080`)
});
