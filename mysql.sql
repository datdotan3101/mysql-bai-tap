CREATE DATABASE mysql;

USE mysql;

-- USER
CREATE TABLE `user` (
    `user_id` INT PRIMARY KEY AUTO_INCREMENT,
    `full_name` varchar(255),
    `email` VARCHAR(255),
    `password` VARCHAR(255)
)

INSERT INTO
    `user` (
        `full_name`,
        `email`,
        `password`
    )
VALUES (
        'Alice',
        'alice@example.com',
        'pass1'
    ),
    (
        'Bob',
        'bob@example.com',
        'pass2'
    ),
    (
        'Charlie',
        'charlie@example.com',
        'pass3'
    ),
    (
        'David',
        'david@example.com',
        'pass4'
    ),
    (
        'Emma',
        'emma@example.com',
        'pass5'
    ),
    (
        'Frank',
        'frank@example.com',
        'pass6'
    ),
    (
        'Grace',
        'grace@example.com',
        'pass7'
    );

-- RESTAURANT
CREATE TABLE `restaurant` (
    `res_id` INT PRIMARY KEY AUTO_INCREMENT,
    `res_name` VARCHAR(255),
    `Image` VARCHAR(255),
    `desc` VARCHAR(255)
)
INSERT INTO
    `restaurant` (`res_name`, `Image`, `desc`)
VALUES (
        'Pizza House',
        'pizza.jpg',
        'Best pizza in town'
    ),
    (
        'Sushi Bar',
        'sushi.jpg',
        'Fresh sushi daily'
    ),
    (
        'Burger King',
        'burger.jpg',
        'Delicious burgers'
    );

-- RATE_RES
CREATE TABLE `rate_res` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `user_id` INT,
    `res_id` INT,
    `amount` INT,
    `date_rate` DATETIME,
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    FOREIGN KEY (`res_id`) REFERENCES `restaurant` (`res_id`)
)

INSERT INTO
    `rate_res` (
        `user_id`,
        `res_id`,
        `amount`,
        `date_rate`
    )
VALUES (1, 1, 4, NOW()),
    (2, 2, 5, NOW()),
    (3, 1, 5, NOW()),
    (4, 3, 3, NOW());

-- LIKE_RES
CREATE TABLE `like_res` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `user_id` INT,
    `res_id` INT,
    `data_like` DATETIME,
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
)
-- Alice likes 2 res
INSERT INTO
    `like_res` (
        `user_id`,
        `res_id`,
        `data_like`
    )
VALUES (1, 1, NOW()),
    (1, 2, NOW()),

-- Bob likes 1 res
(2, 1, NOW()),

-- Charlie likes 3 res
(3, 1, NOW()), (3, 2, NOW()), (3, 3, NOW()),

-- David likes 2 res
(4, 2, NOW()), (4, 3, NOW()),

-- Emma likes 1 res
(5, 3, NOW());

-- FOOD_TYPE
CREATE TABLE `food_type` (
    `type_id` INT PRIMARY KEY AUTO_INCREMENT,
    `type_name` VARCHAR(255)
)
-- FOOD
CREATE TABLE `food` (
    `food_id` INT PRIMARY KEY AUTO_INCREMENT,
    `food_name` VARCHAR(255),
    `image` VARCHAR(255),
    `price` FLOAT,
    `desc` VARCHAR(255),
    `type_id` INT,
    FOREIGN KEY (`type_id`) REFERENCES `food_type` (`type_id`)
)

INSERT INTO
    `food_type` (`type_name`)
VALUES ('Fast Food'),
    ('Japanese');

INSERT INTO
    `food` (
        `food_name`,
        `image`,
        `price`,
        `desc`,
        `type_id`
    )
VALUES (
        'Pizza',
        'pizza.jpg',
        10.0,
        'Cheese pizza',
        1
    ),
    (
        'Sushi',
        'sushi.jpg',
        12.0,
        'Salmon sushi',
        2
    ),
    (
        'Burger',
        'burger.jpg',
        8.0,
        'Beef burger',
        1
    );

-- order
CREATE TABLE `order` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `user_id` INT,
    `food_id` INT,
    `amount` INT,
    `code` VARCHAR(255),
    `arr_sub_id` VARCHAR(255),
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`)
)

-- Alice orders 2 items
INSERT INTO
    `order` (
        `user_id`,
        `food_id`,
        `amount`,
        `code`,
        `arr_sub_id`
    )
VALUES (1, 1, 1, 'ORD001', ''),
    (1, 2, 1, 'ORD002', ''),

-- Charlie orders 3 items
(3, 2, 1, 'ORD003', ''),
(3, 3, 1, 'ORD004', ''),
(3, 1, 1, 'ORD005', ''),

-- Emma orders 1 item
(5, 3, 1, 'ORD006', '');

-- Alice orders 2 items
INSERT INTO
    `order` (
        `user_id`,
        `food_id`,
        `amount`,
        `code`,
        `arr_sub_id`
    )
VALUES (1, 1, 1, 'ORD001', ''),
    (1, 2, 1, 'ORD002', ''),

-- Charlie orders 3 items
(3, 2, 1, 'ORD003', ''),
(3, 3, 1, 'ORD004', ''),
(3, 1, 1, 'ORD005', ''),

-- Emma orders 1 item
(5, 3, 1, 'ORD006', '');

-- sub_food
CREATE TABLE `sub_food` (
    `sub_id` INT PRIMARY KEY AUTO_INCREMENT,
    `sub_name` VARCHAR(255),
    `sub_price` FLOAT,
    `food_id` INT,
    FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`)
)

INSERT INTO
    `sub_food` (
        `sub_name`,
        `sub_price`,
        `food_id`
    )
VALUES ('Extra Cheese', 1.5, 1),
    ('Wasabi', 0.5, 2);

-- Giải
-- Tìm 5 người đã like nhà hàng nhiều nhất

SELECT user.user_id, user.full_name, COUNT(like_res.id) AS total_likes
FROM user
    INNER JOIN like_res ON user.user_id = like_res.user_id
GROUP BY
    `user`.user_id
ORDER BY total_likes DESC
LIMIT 5;

-- Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT restaurant.res_id, restaurant.res_name, COUNT(like_res.id) AS total_likes
FROM restaurant
    INNER JOIN like_res ON restaurant.res_id = like_res.res_id
GROUP BY
    restaurant.res_id
ORDER BY total_likes DESC
LIMIT 2;

--  Tìm người đã đặt hàng nhiều nhất
SELECT user.user_id, user.full_name, COUNT(`order`.id) AS total_orders
FROM user
    INNER JOIN `order` ON user.user_id = `order`.user_id
GROUP BY
    user.user_id
ORDER BY total_orders DESC
LIMIT 1;

-- Tìm người dùng không hoạt động trong hệ thống
SELECT user.user_id, user.full_name
FROM
    user
    LEFT JOIN like_res ON user.user_id = like_res.user_id
    LEFT JOIN `order` ON user.user_id = `order`.user_id
    LEFT JOIN rate_res ON user.user_id = rate_res.user_id
WHERE
    like_res.id IS NULL
    AND `order`.id IS NULL
    AND rate_res.id IS NULL;