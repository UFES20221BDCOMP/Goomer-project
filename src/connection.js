const { Client } = require('pg')
const client = new Client({
    user: 'Abe',
    host: 'localhost',
    database: 'api_goomer',
    password: 'password',
    port: 5432,
});

module.exports = client;