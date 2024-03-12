               /* MANDATORY PROJECT */


 use ig_clone;
 
 select * from users ; 
 select * from photos;
 select * from comments;
 select * from likes;
 select * from follows; 
 select * from Tags ;
 select * From photo_tags;
 
 /* 1. How many times does the average user post? */ 
 
SELECT  ROUND((SELECT COUNT(*) from photos)/(SELECT COUNT(*) from users)) as avg_user_post;
 
 /*2. Find the top 5 most used hashtags.*/

SELECT t.tag_name, count(t.tag_name) AS num_of_tags
FROM tags t
INNER JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY t.tag_name
ORDER BY num_of_tags DESC limit 5 OFFSET 0;  


/* 3.Find users who have liked every single photo on the site? */

SELECT users.id,username, 
COUNT(users.id) As total_likes_by_user
FROM users
INNER JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos) ;

/* 4.Retrieve a list of users along with their usernames and 
the rank of their account creation, ordered by the creation date in ascending order. */

select id,username,
rank() over(order by created_at asc)
 Rank_on_acct_creation from users;

/*5.List the comments made on photos with their comment texts, 
photo URLs,and usernames of users who posted the comments.
Include the comment count for each photo*/ 

SELECT p.id as photo_id,p.image_url,c.comment_text 
as comment_on_photo
,u.username,count(c.id) 
OVER(PARTITION BY c.photo_id) as comment_count  from comments c 
INNER JOIN photos p on c.photo_id = p.id INNER JOIN users u on c.user_id = u.id;

select count(comment_text) over(partition by photo_id) from comments; # for better understanding of count of comments for photo_id


/* 6.For each tag, show the tag name and 
the number of photos associated with that tag. 
Rank the tags by the number of photos in descending order. */
 with tag_details as 
(select t.tag_name,count(photo_id) as num_of_photos
 from tags t join photo_tags pt on t.id = pt.tag_id 
 group by t.tag_name),
 rank_for_tags as 
 (select tag_name,num_of_photos,rank() over(order by num_of_photos desc) as rank_of_tags from tag_details)
 
 select * from rank_for_tags;
 
 
 /*7.List the usernames of users who have 
posted photos along with the count of photos they have posted. 
Rank them by the number of photos in descending order.*/ 
with photo_count as 
(select u.username,count(p.id) as count_of_photos from users u inner join photos p on
u.id = p.user_id group by p.user_id ),
rank_dets as 
(select  username ,count_of_photos ,rank() over(order by count_of_photos desc) as Rank_based_on_photos 
from photo_count)

select * from rank_dets;

/*8.Display the username of each user along with the 
creation date of their first posted photo and the creation date of their next posted photo */
with rank_Dets as 
(select u.username,p.created_at,row_number() over(partition by u.username order by created_at asc) as Rank_on_createddate 
from users u inner join photos p on u.id = p.user_id) ,
first_two_dates as 
(select username,created_at from rank_Dets where Rank_on_createddate <= 2 )

select * from first_two_dates;


/*9.	For each comment, show the comment text, the username of the commenter, 
and the comment text of the previous comment made on the same photo.*/

select c.id,c.photo_id,u.username,c.comment_text, lag(c.comment_text)
over(order by c.photo_id) as previous_comment from comments c join users u on 
c.user_id = u.id;

/*10.Show the username of each user 
along with the number of photos they have posted and
 the number of photos posted
 by the user before them and after them, 
 based on the creation date */
 
 with post_details as 
 (select p.user_id,u.username,p.created_at,count(p.id) as num_of_posts from photos p
 inner join users u on p.user_id = u.id group by p.user_id,p.created_at),
 bef_Aft_posts as 
 (select pd.user_id,pd.username,pd.num_of_posts,lead(num_of_posts) 
 over(order by pd.created_at)as aft_posts,
 lag(num_of_posts) over(order by pd.created_at)as bef_posts
 from post_details pd ) 
 
 select * from bef_Aft_posts;
 


 
 










 















 
 
 
 





 







 
 
 
