/*  Evaluación Final Módulo 2: SQL - DIANA PUERTA GÓMEZ */

USE sakila; -- Llamamos a la base de datos 

/* . Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/

SELECT title 
	FROM film
	GROUP BY title; -- Podría haber usado un WHERE DISTINCT pero Group by hace el mismo efecto ya que al agrupar por título no duplica. 


/* . Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/

SELECT title
	FROM film
	WHERE rating = "PG-13"; -- He buscado los valores "PG-13" en rating 


/* Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/

SELECT title, description
	FROM film
	WHERE description LIKE "%amazing%"; -- el % delante y detrás marca que la palabra puede estar en medio de una frase. Probé con el % tanto delante como atrás en la consulta, pero el resultado no variaba. 

/* Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT title, length
	FROM film
	WHERE length > 120; -- Indiqué que la duración de la película fuera mayor que 120

/* Recupera los nombres de todos los actores.*/

SELECT CONCAT(first_name, " ", last_name) AS "Nombre completo" -- Aquí hice un concat para que apareciera una sola columna
	FROM actor;

/*Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT CONCAT(first_name, " ", last_name) AS "Actores con Gibson en su apellido " 
	FROM actor
	WHERE last_name = "Gibson"; -- Usé un WHERE para buscar los apellidos que fueran Gibson

/* . Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

SELECT actor_id, CONCAT(first_name, " ", last_name) AS "Actors cuyo id esté entre 10 y 20"
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20; -- Aquí podría haber usado marcadores más qué o menos qué, pero la función BETWEEEN hace lo mismo. 


/*  Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/

SELECT title AS "Películas cuyo rating no sea R ni PG-13", rating
	FROM film
	WHERE rating NOT IN ("R", "PG-13"); -- Aquí usé NOT IN porque me parecía lo más eficiente, pero podría haber usado NOT o !=


/* Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.*/

SELECT COUNT(rating) AS "Cantidad de películas por categoría", rating
	FROM film
	GROUP BY rating;

/*Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT r.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS "Number of rentals" -- Usé un INNER JOIN ya que lo que me interesaba eran las coincidencias en las tablas rental y cutomer. El COUNT cuenta la cantidad de películas alquiladas
	FROM rental AS r
	INNER JOIN customer AS c  
		USING (customer_id)
	GROUP BY customer_id;

/*Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.*/

SELECT c.name, COUNT(DISTINCT f.film_id) AS "Number of movies per category", COUNT(rental_id) "Number of rentals per category" -- Aquí he usado un DISTINCT dentro de COUNT ya que al hacer los JOINS de inventory se sumaban todas las películas con el mismo nombre. El COUNT en rental ID sirve para contar la cantidad de veces que se han alquilado
	FROM film AS f
	LEFT JOIN film_category -- Aquí uso un left join porque quiero sacar todas las películas
		USING (film_id)
	INNER JOIN category AS c -- Aquí uso un INNER JOIN porque quiero sacar solo las coincidencias en categoría, inventario y alquiler.
		USING (category_id)
	INNER JOIN inventory
		USING (film_id)
	INNER JOIN rental
		USING (inventory_id)
	GROUP BY name; 


/*Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración. */

SELECT rating, AVG(length) AS "Media de duración por categoría" -- Aquí uso un AVG para calcular la media de duración por categoría
	FROM film
	GROUP BY rating;

/*Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/

SELECT CONCAT(first_name, " ", last_name) AS "Actores ya ctrices que aparecieron en Indian Love"
	FROM actor
	INNER JOIN film_actor -- Uso INNER JOINS porque solo busco las coincidencias entre acotres y películas
		USING (actor_id)
	INNER JOIN film
		USING (film_id)
	WHERE title = "Indian Love";

/* Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

SELECT title, description AS "Descripciones que contienen cat o dog"
	FROM film
	WHERE description LIKE "%dog%" OR description LIKE "%cat%"; -- Aquí uso un LIKE para buscar las palabras que pide el enunciado. Hay que concatenar la búsqueda con un OR y repetir la columna, ya que si no no hace la búsqueda correctamente

/*Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor*/

SELECT *
	FROM actor
	LEFT JOIN film_actor
		USING(actor_id)
	WHERE film_id IS NULL; -- Aquí he hecho un LEFT JOIN para sacar todos los actores y compararlos con la tabla film_id. He buscado en la columna film_id por algún actor que tuviera NULL en esta columna, pero no aparece ninguno. 

/* . Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/

SELECT title AS "Películas que se lanzaron entre el 2005 y 2010", release_year
	FROM film
	WHERE release_year BETWEEN 2005 AND 2010; -- Aquí he usado un BETWEEN como antes

/* . Encuentra el título de todas las películas que son de la misma categoría que "Family".*/

SELECT f.title AS "Películas en la categoría Family", c.name
	FROM film AS f
	LEFT JOIN film_category -- Aquí he usado un LEFT JOIN para sacar todas las películas y relacionarlas con su categoría. 
		USING (film_id)
	INNER JOIN category AS c
		USING (category_id)
	WHERE c.name = "Family"; -- Aquí he acotado por mostrar solo las de la categoría Family.

/* . Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

SELECT CONCAT(first_name, " ", last_name) AS "Nombre completo", COUNT(film_id) AS "Cantidad de películas por actor/actriz" -- He usado un CONCAT para poner el nombre completo en una tabla y un COUNT para hacer el recuento de todas las películas de cada actor
	FROM actor
	INNER JOIN film_actor -- INNER JOIN para buscar solo las coincidencias
		USING (actor_id)
	GROUP BY first_name, last_name -- Agrupamos por los nombres 
		HAVING COUNT(film_id) > 10 -- Y descartamos los que aparezcan en menos de 10 películas
	ORDER BY COUNT(film_id) DESC;

/*. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film*/
 
 SELECT title AS "Películas de categoría R que duran más de 2 horas", rating, length
	FROM film
	WHERE rating = "R" -- Buscamos películas que figuren en la cateogría "R" 
		AND length > 120; -- Y discriminamos las que duren menos de 2 horas


/* . Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración*/

SELECT c.name AS "Categorías", AVG(length) AS "Duración media por categoría"
	FROM film
	INNER JOIN film_category
		USING(film_id)
	INNER JOIN category AS c
		USING (category_id)
	GROUP BY c.name
		HAVING AVG(length) > 120; -- En esta query usamos INNER JOINS porque solo nos interesa las coincidencias entre tablas, agrupamos por nombre de categoría y discriminamos las que duran menos de 2 horas. 

/* Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/

SELECT first_name, last_name, COUNT(film_id) AS "Cantidad de películas por actor"
	FROM actor
	INNER JOIN film_actor
		USING(actor_id)
	GROUP BY first_name, last_name
		HAVING COUNT(film_id) >= 5
	ORDER BY COUNT(film_id) DESC; -- Se ha usado un INNER JOIN para buscar las coincidencias entre las tablas actor y film_actor, se agrupa por nombre y se discriminan los actores con menos de 5 películas.

/* Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las
 películas correspondientes.*/
 
 SELECT title, DATEDIFF(return_date, rental_date) AS "Días en alquiler"
	 FROM film
	 LEFT JOIN inventory -- Uso LEFT JOIN para traer todas las películas
		USING(film_id)
	 INNER JOIN rental -- Uso INNER JOIN para traer las películas del inventario que están en rental. 
		USING (inventory_id)
	 WHERE rental_id IN (SELECT rental_id
							FROM rental
							WHERE DATEDIFF(return_date, rental_date) > 5) -- En esta subquery se busca por rental ID por la cantidad de días que las pelis han estado alquiladas usando DATEDIFF que resta una fecha de la otra y haciendo un mayor qué que discriminará las películas que estuvieron alquiladas por menos de 5 días. 
	ORDER BY DATEDIFF(return_date, rental_date) DESC;



/*Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
 categoría "Horror" y luego exclúyelos de la lista de actores"*/
 
SELECT CONCAT(first_name, " ", last_name) AS "Actores y actrices que nunca han participado en una película de Horror", name AS "Categoría"
	FROM category 
	LEFT JOIN film_category -- LEFT JOIN para traer todas las categorías
		USING (category_id)
	INNER JOIN film_actor -- INNER JOIN para encontrar las coincidencias entre categoría y película, y en la siguiente entre película y actor. 
		USING (film_id)
	INNER JOIN actor
		USING (actor_id)
	WHERE actor_id NOT IN (SELECT actor_id -- El WHERE discrimina los actores que aparecen en la subquery.
								FROM category 
								LEFT JOIN film_category
									USING (category_id)
								INNER JOIN film_actor
									USING (film_id)
								INNER JOIN actor
									USING (actor_id)
								WHERE name = "Horror"); -- En esta subquery extraemos todos los actores que han trabajado en una película que esté categorizada con "Horror".



/*Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film*/

SELECT title AS "Comedias que duran más de 3h", length, c.name
	FROM film AS f
	INNER JOIN film_category
		USING(film_id)
	INNER JOIN category AS c
		USING(category_id)
	WHERE f.length > 180 
	AND c.name = "Comedy"; -- INNER JOINs para traer solo coincidencias. En el WHERE descriminamos por películas más largas que 180 minutos y que aparezcan en la categoría comedy.

/* BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.*/
 
SELECT -- Seleccionamos los id y los nombres de los actores que queremos emparejar y ponemos una columna que sume la cantidad de películas que tienen en común. 
	fa1.actor_id AS "ID Actor 1", 
    a1.first_name AS "Nombre actor 1", 
    a1.last_name AS "Apellido actor 1", 
    fa2.actor_id AS "ID actor 2", 
    a2.first_name AS "Nombre actor 2", 
    a2.last_name AS "Apellido actor 2", 
    COUNT(fa2.film_id) AS "Películas en común"
		FROM film_actor AS fa1 -- Se hace un INNER JOIN que saque el ID de los actores
        JOIN film_actor AS fa2
        JOIN actor AS a1 -- Con los siguientes JOIN sacamos el nombre de los actores
			ON fa1.actor_id = a1.actor_id -- En este ON relacionamos las tablas
        JOIN actor AS a2
			ON fa2.actor_id = a2.actor_id
		WHERE fa1.actor_id < fa2.actor_id -- Este WHERE es clave para que los actores no se repitan en un bucle A-B B-A. El menor qué aplica al ID situando siempre el número menor a la izquierda y el mayor a la derecha, evitando repeticiones. 
		AND fa1.film_id = fa2.film_id -- Aquí se relacionan las películas de las tablas autoreferenciadas para que podamos sumarlas. 
		GROUP BY fa1.actor_id, -- Agrupamos por los nombres e ID de los actores
				a1.first_name, 
				a1.last_name, 
				fa2.actor_id, 
				a2.first_name, 
				a2.last_name
	ORDER BY COUNT(fa2.film_id)DESC;
                

-- CTE: Pequeño ejercicio para practicar CTE

WITH ParejasActores AS (
						SELECT 
							fa1.actor_id AS "ID Actor 1", 
							a1.first_name AS "Nombre actor 1", 
							a1.last_name AS "Apellido actor 1", 
							fa2.actor_id AS "ID actor 2", 
							a2.first_name AS "Nombre actor 2", 
							a2.last_name AS "Apellido actor 2", 
							COUNT(fa2.film_id) AS peliculas_comun
								FROM film_actor AS fa1 
								JOIN film_actor AS fa2
								JOIN actor AS a1 
									ON fa1.actor_id = a1.actor_id 
								JOIN actor AS a2
									ON fa2.actor_id = a2.actor_id
								WHERE fa1.actor_id < fa2.actor_id 
								AND fa1.film_id = fa2.film_id
								GROUP BY fa1.actor_id, 
										a1.first_name, 
										a1.last_name, 
										fa2.actor_id, 
										a2.first_name, 
										a2.last_name)
                                        
SELECT * 
FROM ParejasActores
ORDER BY peliculas_comun DESC;
