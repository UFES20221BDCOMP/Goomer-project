const express = require('express');
const database = require('./queries.js');
const bodyParser = require('body-parser')

const PORT = 3000;
const HOST = '0.0.0.0';

const app = express();

//configurando o body parser para interpretar requests mais tarde
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.get('/', database.home);

//app.listen(PORT, HOST);

if (require.main === module) {
    //inicia o servidor
    app.listen(PORT, HOST)
    console.log('API funcionando!')
}

/*
///!CONEXAO COM O BANCO POSTGRES CONTAINER
const { Client } = require('pg')
const client = new Client({
    user: 'postgres',
    host: 'database.',
    database: 'api_goomer',
    password: 'postgres',
    port: 5432,
});
*/



//!---------------GETS---------------//

//?Get all restaurants
app.get('/restaurants', database.get_restaurants)

//?Get a restaurant by id
app.get('/restaurants/:id', database.get_restaurants_byid)

//?Get all products
app.get('/products', database.get_products)

//?Get a product by id
app.get('/products/:id', database.get_products_byid)

//?Get all products from a restaurant by id
app.get('/restaurants_products/:id', database.get_products_restaurant_byid)

//?Get all categorys
app.get('/categorys', database.get_categorys)

//?Get a category by id
app.get('/categorys/:id', database.get_categorys_byid)

//?Get all products with a category by id
app.get('/categorys_products/:id', database.get_products_category_byid)

//?Get all opening_hours
app.get('/opening', database.get_opening)

//?Get all opening_hours from a restaurant by id
app.get('/opening/:id', database.get_opening_restaurant_byid)

//?Get all promotion_product
app.get('/promotion_products', database.get_promotion)

//?Get all promotion_time product from a product by id
app.get('/promotion_time/:id', database.get_promotiontime_product_byid)


//!---------------POSTS---------------//

//?Create a new restaurant
app.post('/restaurants', database.post_restaurant)

//?Create a new product
app.post('/products', database.post_product)

//?Create a new category
app.post('/categorys', database.post_category)

//?Create a new opening_hour
app.post('/opening', database.post_opening)

//?Create a new promotion_product
app.post('/promotion_products', database.post_promotion)

//?Create a new promotion_time
app.post('/promotion_time', database.post_promotiontime)

//!---------------UPDATES---------------//

//?Update a restaurant by id
app.put('/restaurants/:id', database.put_restaurant_byid)

//?Update a products by id
app.put('/products/:id', database.put_product_byid)

//?Update a category by id
app.put('/categorys/:id', database.put_category_byid)

//?Update a opening_hour by id
app.put('/opening/:id', database.put_opening_byid)

//?Update a promo_product by id
app.put('/promotion_products/:id', database.put_promotion_byid)

//?Update a promotion_time by id
app.put('/promotion_time/:id', database.put_promotiontime_byid)


//!---------------DELETES---------------//

//?Delete a restaurant by id
app.delete('/restaurants/:id', database.del_restaurant_byid)

//?Delete a product by id
app.delete('/products/:id', database.del_product_byid)

//?Delete a category by id
app.delete('/categorys/:id', database.del_category_byid)

//?Delete a opening_hour by id
app.delete('/opening/:id', database.del_opening_byid)

//?Delete a promotion_product by id
app.delete('/promotion_products/:id', database.del_promotion_byid)

//?Delete a promotion_time by id
app.delete('/promotion_time/:id', database.del_promotiontime_byid)



module.exports = app