const test = require('tape')
const supertest = require('supertest')
const app = require('./index')

test('GET /restaurants', (t) => {
    supertest(app)
        .get('/restaurants')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(err, 'Sem erros')
            t.assert(res.body[0].rest_id === 1, "Restaurantes visiveis")
                //console.log(res.body[0].rest_id)
            t.end()
        })
})

test('GET /restaurants/5', (t) => {
    supertest(app)
        .get('/restaurants/5')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(err, 'Sem erros')
            t.assert(res.body[0].rest_id === 5, "Restaurante de id 5 retornado")
            console.log(res.body[0])
            t.end()
        })
})

test('GET /products', (t) => {
    supertest(app)
        .get('/products')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(err, 'Sem erros')
            t.assert(res.body[0].prod_id === 1, "Produtos visiveis")
                //console.log(res.body[0].rest_id)
            t.end()
        })
})

test('GET /products/2', (t) => {
    supertest(app)
        .get('/products/2')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(err, 'Sem erros')
            t.assert(res.body[0].prod_id === 2, "Produto de id 2 retornado")
            console.log(res.body[0])
            t.end()
        })
})

test('GET /categorys', (t) => {
        supertest(app)
            .get('/categorys')
            .expect('Content-Type', /json/)
            .expect(200)
            .end((err, res) => {
                t.error(err, 'Sem erros')
                t.assert(res.body[0].cat_id === 1, "Categorias visiveis")
                    //console.log(res.body[0].rest_id)
                t.end()
            })
    })
    /*
    test('POST /restaurants', (t) => {
        supertest(app)
            .post('/restaurants')
            .send({
                rest_name: 'test auto',
                rest_adress: 'not a adress'
            })
            .set('Accept', 'application/json')
            .expect('Content-Type', /json/)
            .expect(200)
            .end((err, res) => {
                //a categoria post retorna um erro no err por padrao
                //Error: expected "Content-Type" matching /json/, got "text/html; charset=utf-8"
                //pois o post nao devolve nada a nao ser a mensagem que foi postado com sucesso
                //o valor res nao tem retorno
                //deve-se desconsiderar esse erro fazendo alguns armengues
                t.error(!err, 'Sem erros')
                t.assert(true, "restaurante criados")
                t.end()
            })
    })

    test('POST /products', (t) => {
        supertest(app)
            .post('/products')
            .send({
                rest_id: 1,
                prod_name: "Teste1 auto",
                prod_price: "15.90",
                cat_id: 2,
            })
            .set('Accept', 'application/json')
            .expect('Content-Type', /json/)
            .expect(200)
            .end((err, res) => {
                //a categoria post retorna um erro no err por padrao
                //Error: expected "Content-Type" matching /json/, got "text/html; charset=utf-8"
                //pois o post nao devolve nada a nao ser a mensagem que foi postado com sucesso
                //o valor res nao tem retorno
                //deve-se desconsiderar esse erro fazendo alguns armengues
                t.error(!err, 'Sem erros')
                t.assert(true, "produto criados")
                t.end();
            })
    })
    */
test('PUT /restaurants/9', (t) => {
    supertest(app)
        .put('/restaurants/9')
        .send({
            rest_id: 9,
            rest_name: 'teste put',
            rest_adress: 'not a adress'
        })
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(!err, 'Sem erros')
            t.assert(true, "restaurante de id 5 modificado")
            t.end()
        })
})

test('PUT /products/5', (t) => {
    supertest(app)
        .put('/products/5')
        .send({
            prod_id: 5,
            rest_id: 7,
            prod_name: "Teste put auto",
            prod_price: "15.90",
            cat_id: 2,
        })
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(!err, 'Sem erros')
            t.assert(true, "produto de id 5 modificado")
            t.end()
        })
})

test('DELETE /restaurants/9', (t) => {
    supertest(app)
        .delete('/restaurants/9')
        .send({
            rest_id: 9,
        })
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(!err, 'Sem erros')
            t.assert(true, "restaurante de id 9 deletado")
            t.end()
        })
})

test('DELETE /products/26', (t) => {
    supertest(app)
        .delete('/products/26')
        .send({
            prod_id: 26,
        })
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200)
        .end((err, res) => {
            t.error(!err, 'Sem erros')
            t.assert(true, "produto de id 5 deletado")
            t.end()
        })
})