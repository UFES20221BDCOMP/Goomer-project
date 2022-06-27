# Iniciando

# Maiores dificuldades

    Triggers: sintaxe muito dificil de aplicar, qualquer detalhe gera um erro catastrófico e
    nao tem tantas fontes de informações sobre, tem que correr um pouco atrás para chegar num resultado.
    
    Normalizar as tabelas: Inicialmente fiz um esqueleto do modelo relacional do banco, porém com o passar do tempo vi que poderia ficar ainda melhor com a adição de alguns uniques e mudando algumas chaves.

    Funções: assim como as triggers possui uma sintaxe bastante especifica e contém com inumeras funções prontas

    Acertar a configuração de dois cotainers, foi extremamente dificil ao ponto de precsicar nao dormir, revirei muitos e muitos sites, mas na proxima vez ja sei oq fazer kskdakk, uma experiencia muito marcante xD

# Tecnologias Utilizadas

    node.js, express, postgres

# Estruturas das tabelas

    A tabela promo_product tem como chave primária prod_id da tabela produtos, pois não tem promoção sem ter o produto.
    
    A tabela de opening_hours tem como unique(op_day, rest_id) fazendo com que o registro duplicado de dias da semana nao exista, por restaurante (o mesmo para a tabela promo_time com os produtos)

    A tabela category prod, para que possa deletar ou alterar uma tupla da tabela, a categoria deve não estar sendo utilizada por nenhum produto

    As tabelas opening_hours e promo_time possuem uma função que checa se os minutos inseridos ou atualizados são divisíveis por 15 (MIN%15 = 0)

    Para a tupla na tabela promo_time existir, antes o prod_id deve ser adicionado na tabela de promo_product, assim evitanto que seja adicionado uma data de promoção sem o produto estar em promoção

    Deletar um restaurante faz com que seus produtos e todas as referencias a eles também se apaguem, assim como a opening_hours

    Deletar uma promoção faz com que as datas da promoção também se apaguem

    

