const express = require('express');

const PORT = 3000;
const HOST = '0.0.0.0';

const app = express();

app.get('/', (req, res) =>{
    res.send('Hello World');
});

app.listen(PORT, HOST);

const { Client } = require('pg')
const client = new Client({
    user: 'postgres',
    host: 'db',
    database: 'api_goomer',
    password: 'postgres',
    port: 5432,
});


client.connect(err => {
    if (err) {
      console.error('connection error', err.stack)
      
    } else {
      console.log('connected')
    }
  })


//!---------------GETS---------------//

//?Get all restaurants
app.get('/restaurants', (req, res) => {
    client.query(`Select * from restaurant ORDER BY rest_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
    
})