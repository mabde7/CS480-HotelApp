CREATE TABLE manager (
    ssn   CHAR(11),
    name  VARCHAR(255),
    email VARCHAR(255),
    PRIMARY KEY (ssn)
);

CREATE TABLE client (
    email VARCHAR(255),
    name  VARCHAR(255),
    PRIMARY KEY (email)
);

CREATE TABLE address (
    street_name VARCHAR(255),
    number      VARCHAR(255),
    city        VARCHAR(255),
    PRIMARY KEY (street_name, number, city)
);

CREATE TABLE has_address (
    email        VARCHAR(255),
    street_name  VARCHAR(255),
    number       VARCHAR(255),
    city         VARCHAR(255),
    PRIMARY KEY (email, street_name, number, city),
    FOREIGN KEY (email)
        REFERENCES client (email),
    FOREIGN KEY (street_name, number, city)
        REFERENCES address (street_name, number, city)
);

CREATE TABLE hotel (
    hotel_id    INTEGER,
    name        VARCHAR(255),
    street_name VARCHAR(255) NOT NULL,
    number      VARCHAR(255)  NOT NULL,
    city        VARCHAR(255)  NOT NULL,
    PRIMARY KEY (hotel_id),
    FOREIGN KEY (street_name, number, city)
        REFERENCES address (street_name, number, city)
);

CREATE TABLE room (
    hotel_id              INTEGER,
    room_number           INTEGER,
    num_windows           INTEGER CHECK (num_windows >= 0),
    last_renovation_year  INTEGER CHECK (last_renovation_year >= 0),
    access_type           VARCHAR(225) CHECK (access_type IN ('elevator', 'stairs')),
    PRIMARY KEY (hotel_id, room_number),
    FOREIGN KEY (hotel_id)
        REFERENCES hotel (hotel_id)
);

CREATE TABLE credit_card (
    card_number  CHAR(16),
    email        VARCHAR(255) NOT NULL,
    street_name  VARCHAR(255) NOT NULL,
    number       VARCHAR(255)  NOT NULL,
    city         VARCHAR(255)  NOT NULL,
    PRIMARY KEY (card_number),
    FOREIGN KEY (email)
        REFERENCES client (email),
    FOREIGN KEY (street_name, number, city)
        REFERENCES address (street_name, number, city)
);

CREATE TABLE booking (
    booking_id     INT PRIMARY KEY,
    email          VARCHAR(255) NOT NULL,
    hotel_id       INTEGER NOT NULL,
    room_number    INTEGER NOT NULL,
    start_date     DATE,
    end_date       DATE CHECK (start_date <= end_date),
    price_per_day  NUMERIC(10,2) CHECK (price_per_day >= 0),
    FOREIGN KEY (email)
        REFERENCES client (email),
    FOREIGN KEY (hotel_id, room_number)
        REFERENCES room (hotel_id, room_number)
);

CREATE TABLE review (
    hotel_id      INTEGER,
    review_id     INTEGER,
    email         VARCHAR(255) NOT NULL,
    rating        INTEGER CHECK (rating BETWEEN 0 AND 10),
    message       TEXT,
    PRIMARY KEY (hotel_id, review_id),
    FOREIGN KEY (hotel_id)
        REFERENCES hotel (hotel_id),
    FOREIGN KEY (email)
        REFERENCES client (email)
);
