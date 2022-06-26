const client = require('./connection.js')
const express = require('express');
const app = express();

const bodyParser = require("body-parser");

app.use(bodyParser.json());

app.listen(3300, () => {
    console.log("Sever is now listening at port 3000");
})

client.connect();

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

//?Get a restaurant by id
app.get('/restaurants/:id', (req, res) => {
    client.query(`Select * from restaurant where rest_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all products
app.get('/products', (req, res) => {
    client.query(`Select * from product ORDER BY prod_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get a product by id
app.get('/products/:id', (req, res) => {
    client.query(`Select * from product where prod_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all products from a restaurant by id
app.get('/restaurants_products/:id', (req, res) => {
    client.query(`Select prod_id, prod_name, prod_price, rest_name, cat_id
                 from restaurant natural join product 
                  where rest_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all categorys
app.get('/categorys', (req, res) => {
    client.query(`Select * from category_prod ORDER BY cat_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get a category by id
app.get('/categorys/:id', (req, res) => {
    client.query(`Select * from category_prod where cat_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all products with a category by id
app.get('/categorys_products/:id', (req, res) => {
    client.query(`Select pd.prod_id, pd.prod_name, pd.prod_price, cp.cat_name
                from category_prod as cp natural join product as pd 
                where cat_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all opening_hours
app.get('/opening', (req, res) => {
    client.query(`Select op_id, rest_id, to_char(op_opening, 'HH24:MI') as op_opening, 
                    to_char(op_closing, 'HH24:MI') as op_closing, op_day
                    from opening_hours ORDER BY op_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all opening_hours from a restaurant by id
app.get('/opening/:id', (req, res) => {
    client.query(`Select op_id, rest_id, to_char(op_opening, 'HH24:MI') as op_opening, 
                    to_char(op_closing, 'HH24:MI') as op_closing, op_day
                    from opening_hours as op natural join restaurant 
                    where op.rest_id = ${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all promotion_product
app.get('/promotion_products', (req, res) => {
    client.query(`Select prod_id, prod_name, promo_description, promo_price
                from promo_product natural join product`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})

//?Get all promotion_time product from a product by id
app.get('/promotion_time/:id', (req, res) => {
    client.query(`Select prod_id, prod_name, proti_id, to_char(proti_timeinit, 'HH24:MI') as proti_timeinit, 
                to_char(proti_timeend, 'HH24:MI') as proti_timeend, proti_day
                from promo_time natural join product 
                where prod_id = ${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    client.end;
})


//!---------------POSTS---------------//

//?Create a new restaurant
app.post('/restaurants', (req, res) => {
    const restaurant = req.body;
    let insertQuery = `INSERT INTO public.restaurant(rest_name, rest_adress)
                       values('${restaurant.rest_name}', '${restaurant.rest_adress}')`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion restaurant was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Create a new product
app.post('/products', (req, res) => {
    const product = req.body;
    let insertQuery = `INSERT INTO public.product(rest_id, prod_name, prod_price, cat_id)
                       values('${product.rest_id}', '${product.prod_name}', '${product.prod_price}', '${product.cat_id}')`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion product was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Create a new category
app.post('/categorys', (req, res) => {
    const category = req.body;
    let insertQuery = `INSERT INTO public.category_prod(cat_name)
                       values('${category.cat_name}')`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion category was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Create a new opening_hour
app.post('/opening', (req, res) => {
    const opening = req.body;
    let insertQuery = `INSERT INTO public.opening_hours(
                        rest_id, op_opening, op_closing, op_day)
                        VALUES ('${opening.rest_id}', '${opening.op_opening}',
                        '${opening.op_closing}', '${opening.op_day}')`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion opening_hour was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Create a new promotion_product
app.post('/promotion_products', (req, res) => {
    const promo_prod = req.body;
    let insertQuery = `INSERT INTO public.promo_product(
                        prod_id, promo_description, promo_price)
                        VALUES ('${promo_prod.prod_id}', '${promo_prod.promo_description}', '${promo_prod.promo_price}')`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion promo_product was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Create a new promotion_time
app.post('/promotion_time', (req, res) => {
    const promo_time = req.body;
    let insertQuery = `INSERT INTO public.promo_time(
                        prod_id, proti_timeinit, proti_timeend, proti_day)
                        VALUES ( '${promo_time.prod_id}', '${promo_time.proti_timeinit}',
                        '${promo_time.proti_timeend}', '${promo_time.proti_day}')`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion promotion_time was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//!---------------UPDATES---------------//

//?Update a restaurant by id
app.put('/restaurants/:id', (req, res) => {
    let restaurant = req.body;
    let updateQuery = `UPDATE public.restaurant SET  
                        rest_name='${restaurant.rest_name}', 
                        rest_adress='${restaurant.rest_adress}' 
                        WHERE rest_id = ${restaurant.rest_id}`

    client.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update restaurant was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Update a products by id
app.put('/products/:id', (req, res) => {
    let product = req.body;
    let updateQuery = `UPDATE public.product SET  
                        prod_name='${product.prod_name}', 
                        prod_price ='${product.prod_price}',
                        cat_id  = '${product.cat_id}',
                        rest_id='${product.rest_id}'
                        WHERE prod_id = ${product.prod_id}`

    client.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update product was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Update a category by id
app.put('/categorys/:id', (req, res) => {
    let category = req.body;
    let updateQuery = `UPDATE public.category_prod SET  
                        cat_name='${category.cat_name}' 
                        WHERE cat_id = ${category.cat_id}`

    client.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update category was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Update a opening_hour by id
app.put('/opening/:id', (req, res) => {
    let opening = req.body;
    let updateQuery = `UPDATE public.opening_hours SET   
                        op_opening = '${opening.op_opening}', 
                        op_closing = '${opening.op_closing}', 
                        op_day = '${opening.op_day}'
                        WHERE op_id = ${opening.op_id}`

    client.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update opening_hour was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Update a promo_product by id
app.put('/promotion_products/:id', (req, res) => {
    let promo_prod = req.body;
    let updateQuery = `UPDATE public.promo_product SET 
                        promo_description = '${promo_prod.promo_description}', 
                        promo_price =  '${promo_prod.promo_price}'
                        WHERE prod_id = ${opening.op_id}`

    client.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update promo_product was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Update a promotion_time by id
app.put('/promotion_time/:id', (req, res) => {
    let promo_time = req.body;
    let updateQuery = `UPDATE public.promo_time SET 
                        proti_timeinit = '${promo_time.proti_timeinit}', 
                        proti_timeend = '${promo_time.proti_timeend}', 
                        proti_day =  '${promo_time.proti_day}'
                        WHERE proti_id = ${promo_time.proti_id}`

    client.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update promotion_time was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})


//!---------------DELETES---------------//

//?Delete a restaurant by id
app.delete('/restaurants/:id', (req, res) => {
    let insertQuery = `DELETE FROM public.restaurant
	                    WHERE rest_id =${req.params.id}`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion restaurant was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Delete a product by id
app.delete('/products/:id', (req, res) => {
    let insertQuery = `DELETE FROM public.product
	                    WHERE prod_id =${req.params.id}`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion product was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Delete a category by id
app.delete('/categorys/:id', (req, res) => {
    let insertQuery = `DELETE FROM public.category_prod
	                    WHERE cat_id =${req.params.id}`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion category was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Delete a opening_hour by id
app.delete('/opening/:id', (req, res) => {
    let insertQuery = `DELETE FROM public.opening_hours
	                    WHERE op_id =${req.params.id}`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion opening_hour was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Delete a promotion_product by id
app.delete('/promotion_products/:id', (req, res) => {
    let insertQuery = `DELETE FROM public.promo_product
	                    WHERE prod_id =${req.params.id}`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion promotion_product was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})

//?Delete a promotion_time by id
app.delete('/promotion_time/:id', (req, res) => {
    let insertQuery = `DELETE FROM public.promo_time
	                    WHERE proti_id =${req.params.id}`

    client.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion promo_time was successful')
        } else { console.log(err.message); throw err; }
    })
    client.end;
})