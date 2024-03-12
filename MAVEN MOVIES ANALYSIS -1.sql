use mavenmovies;
/* 1. Write a SQL query to count the number of characters except for the spaces for each actor. Return the
 first 10 actors' name lengths along with their names*/
 
 select concat(first_name," ",last_name) as actor_fullname,length(concat(first_name,last_name)) as length_of_actor_names from actor 
 order by actor_fullname asc limit 10 offset 0;
 
/*2.List all Oscar awardees(Actors who received the Oscar award) with their full names and the length of their names.*/

select concat(first_name," " ,last_name) as full_name ,length(concat(first_name,last_name)) as length_of_names from 
actor_award where actor_award.awards like "Oscar" order by length_of_names asc,full_name asc ;

/*3.Find the actors who have acted in the film ‘Frost Head.’*/ 

select concat(actor.first_name," ",actor.last_name) as actors_fullname from film inner join film_actor on film.film_id = film_actor.film_id inner join actor on film_actor.actor_id = actor.actor_id
where film.title = "Frost Head" order by actors_fullname asc;


/*4.Pull all the films acted by the actor ‘Will Wilson.’*/

select film.title from film inner join film_actor on film.film_id = film_actor.film_id inner join actor on 
film_actor.actor_id = actor.actor_id where concat(actor.first_name," ",actor.last_name) like "WILL WILSON" order by film.title asc;



/*5.Pull all the films which were rented and return them in the month of May.*/

select film.title as films from film inner join inventory on film.film_id = inventory.film_id 
inner join rental on inventory.inventory_id = 
rental.inventory_id where extract(month from rental.rental_date) = 5 and extract(month from rental.return_date) = 5;

/*6.Pull all the films with ‘Comedy’ category.*/

select film.title from film inner join film_category on film.film_id = film_category.film_id inner join category on film_category.category_id = 
category.category_id where category.name = "comedy";




