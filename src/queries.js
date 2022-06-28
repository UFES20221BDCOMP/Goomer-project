//BANCO LOCAL USANDO PGADMIN

const Pool = require('pg').Pool
const pool = new Pool({
    user: 'Abe',
    host: 'localhost',
    database: 'api_goomer',
    password: 'password',
    port: 5432,
})


pool.connect(err => {
    if (err) {
        console.error('connection error', err.stack)

    } else {
        console.log('connected')
    }
})

const home = (req, res) => {
    res.send('Wellcome to the Goomer Database and RESTful API!!');
}

//?Get all restaurants
const get_restaurants = (req, res) => {
    pool.query(`Select * from restaurant ORDER BY rest_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get a restaurant by id
const get_restaurants_byid = (req, res) => {
    pool.query(`Select * from restaurant where rest_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all products
const get_products = (req, res) => {
    pool.query(`Select * from product ORDER BY prod_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get a product by id
const get_products_byid = (req, res) => {
    pool.query(`Select * from product where prod_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all products from a restaurant by id
const get_products_restaurant_byid = (req, res) => {
    pool.query(`Select prod_id, prod_name, prod_price, rest_name, cat_id
                 from restaurant natural join product 
                  where rest_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all categorys
const get_categorys = (req, res) => {
    pool.query(`Select * from category_prod ORDER BY cat_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get a category by id
const get_categorys_byid = (req, res) => {
    pool.query(`Select * from category_prod where cat_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all products with a category by id
const get_products_category_byid = (req, res) => {
    pool.query(`Select pd.prod_id, pd.prod_name, pd.prod_price, cp.cat_name
                from category_prod as cp natural join product as pd 
                where cat_id=${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all opening_hours
const get_opening = (req, res) => {
    pool.query(`Select op_id, rest_id, to_char(op_opening, 'HH24:MI') as op_opening, 
                    to_char(op_closing, 'HH24:MI') as op_closing, op_day
                    from opening_hours ORDER BY op_id ASC`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all opening_hours from a restaurant by id
const get_opening_restaurant_byid = (req, res) => {
    pool.query(`Select op_id, rest_id, to_char(op_opening, 'HH24:MI') as op_opening, 
                    to_char(op_closing, 'HH24:MI') as op_closing, op_day
                    from opening_hours as op natural join restaurant 
                    where op.rest_id = ${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all promotion_product
const get_promotion = (req, res) => {
    pool.query(`Select prod_id, prod_name, promo_description, promo_price
                from promo_product natural join product`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}

//?Get all promotion_time product from a product by id
const get_promotiontime_product_byid = (req, res) => {
    pool.query(`Select prod_id, prod_name, proti_id, to_char(proti_timeinit, 'HH24:MI') as proti_timeinit, 
                to_char(proti_timeend, 'HH24:MI') as proti_timeend, proti_day
                from promo_time natural join product 
                where prod_id = ${req.params.id}`, (err, result) => {
        if (!err) {
            res.send(result.rows);
        } else {
            throw err;
        }
    });
    pool.end;
}


//!---------------POSTS---------------//

//?Create a new restaurant
const post_restaurant = (req, res) => {
    const restaurant = req.body;
    let insertQuery = `INSERT INTO public.restaurant(rest_name, rest_adress)
                       values('${restaurant.rest_name}', '${restaurant.rest_adress}')`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion restaurant was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Create a new product
const post_product = (req, res) => {
    const product = req.body;
    let insertQuery = `INSERT INTO public.product(rest_id, prod_name, prod_price, cat_id)
                       values('${product.rest_id}', '${product.prod_name}', '${product.prod_price}', '${product.cat_id}')`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion product was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Create a new category
const post_category = (req, res) => {
    const category = req.body;
    let insertQuery = `INSERT INTO public.category_prod(cat_name)
                       values('${category.cat_name}')`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion category was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Create a new opening_hour
const post_opening = (req, res) => {
    const opening = req.body;
    let insertQuery = `INSERT INTO public.opening_hours(
                        rest_id, op_opening, op_closing, op_day)
                        VALUES ('${opening.rest_id}', '${opening.op_opening}',
                        '${opening.op_closing}', '${opening.op_day}')`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion opening_hour was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Create a new promotion_product
const post_promotion = (req, res) => {
    const promo_prod = req.body;
    let insertQuery = `INSERT INTO public.promo_product(
                        prod_id, promo_description, promo_price)
                        VALUES ('${promo_prod.prod_id}', '${promo_prod.promo_description}', '${promo_prod.promo_price}')`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion promo_product was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Create a new promotion_time
const post_promotiontime = (req, res) => {
    const promo_time = req.body;
    let insertQuery = `INSERT INTO public.promo_time(
                        prod_id, proti_timeinit, proti_timeend, proti_day)
                        VALUES ( '${promo_time.prod_id}', '${promo_time.proti_timeinit}',
                        '${promo_time.proti_timeend}', '${promo_time.proti_day}')`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Insertion promotion_time was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//!---------------UPDATES---------------//

//?Update a restaurant by id
const put_restaurant_byid = (req, res) => {
    let restaurant = req.body;
    let updateQuery = `UPDATE public.restaurant SET  
                        rest_name='${restaurant.rest_name}', 
                        rest_adress='${restaurant.rest_adress}' 
                        WHERE rest_id = ${restaurant.rest_id}`

    pool.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update restaurant was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Update a products by id
const put_product_byid = (req, res) => {
    let product = req.body;
    let updateQuery = `UPDATE public.product SET  
                        prod_name='${product.prod_name}', 
                        prod_price ='${product.prod_price}',
                        cat_id  = '${product.cat_id}',
                        rest_id='${product.rest_id}'
                        WHERE prod_id = ${product.prod_id}`

    pool.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update product was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Update a category by id
const put_category_byid = (req, res) => {
    let category = req.body;
    let updateQuery = `UPDATE public.category_prod SET  
                        cat_name='${category.cat_name}' 
                        WHERE cat_id = ${category.cat_id}`

    pool.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update category was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Update a opening_hour by id
const put_opening_byid = (req, res) => {
    let opening = req.body;
    let updateQuery = `UPDATE public.opening_hours SET   
                        op_opening = '${opening.op_opening}', 
                        op_closing = '${opening.op_closing}', 
                        op_day = '${opening.op_day}'
                        WHERE op_id = ${opening.op_id}`

    pool.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update opening_hour was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Update a promo_product by id
const put_promotion_byid = (req, res) => {
    let promo_prod = req.body;
    let updateQuery = `UPDATE public.promo_product SET 
                        promo_description = '${promo_prod.promo_description}', 
                        promo_price =  '${promo_prod.promo_price}'
                        WHERE prod_id = ${opening.op_id}`

    pool.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update promo_product was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Update a promotion_time by id
const put_promotiontime_byid = (req, res) => {
    let promo_time = req.body;
    let updateQuery = `UPDATE public.promo_time SET 
                        proti_timeinit = '${promo_time.proti_timeinit}', 
                        proti_timeend = '${promo_time.proti_timeend}', 
                        proti_day =  '${promo_time.proti_day}'
                        WHERE proti_id = ${promo_time.proti_id}`

    pool.query(updateQuery, (err, result) => {
        if (!err) {
            res.send('Update promotion_time was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}


//!---------------DELETES---------------//

//?Delete a restaurant by id
const del_restaurant_byid = (req, res) => {
    let insertQuery = `DELETE FROM public.restaurant
	                    WHERE rest_id =${req.params.id}`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion restaurant was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Delete a product by id
const del_product_byid = (req, res) => {
    let insertQuery = `DELETE FROM public.product
	                    WHERE prod_id =${req.params.id}`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion product was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Delete a category by id
const del_category_byid = (req, res) => {
    let insertQuery = `DELETE FROM public.category_prod
	                    WHERE cat_id =${req.params.id}`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion category was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Delete a opening_hour by id
const del_opening_byid = (req, res) => {
    let insertQuery = `DELETE FROM public.opening_hours
	                    WHERE op_id =${req.params.id}`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion opening_hour was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Delete a promotion_product by id
const del_promotion_byid = (req, res) => {
    let insertQuery = `DELETE FROM public.promo_product
	                    WHERE prod_id =${req.params.id}`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion promotion_product was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

//?Delete a promotion_time by id
const del_promotiontime_byid = (req, res) => {
    let insertQuery = `DELETE FROM public.promo_time
	                    WHERE proti_id =${req.params.id}`

    pool.query(insertQuery, (err, result) => {
        if (!err) {
            res.send('Deletion promo_time was successful')
        } else { console.log(err.message); throw err; }
    })
    pool.end;
}

module.exports = {
    home,
    get_restaurants,
    get_restaurants_byid,
    get_products,
    get_products_byid,
    get_products_restaurant_byid,
    get_categorys,
    get_categorys_byid,
    get_products_category_byid,
    get_opening,
    get_opening_restaurant_byid,
    get_promotion,
    get_promotiontime_product_byid,
    post_restaurant,
    post_product,
    post_category,
    post_opening,
    post_promotion,
    post_promotiontime,
    put_restaurant_byid,
    put_product_byid,
    put_category_byid,
    put_opening_byid,
    put_promotion_byid,
    put_promotiontime_byid,
    del_restaurant_byid,
    del_product_byid,
    del_category_byid,
    del_opening_byid,
    del_promotion_byid,
    del_promotiontime_byid,
}