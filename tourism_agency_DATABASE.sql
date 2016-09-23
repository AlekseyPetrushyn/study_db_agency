--Database tourism agency (course project)

-------------------------------------------------------------------
-- начинаем с раздела ГОСТИНИЦА
-------------------------------------------------------------------

--1_countries
CREATE TABLE IF NOT EXISTS countries(
country_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
country_name VARCHAR(80) NOT NULL
);

--2_places
CREATE TABLE IF NOT EXISTS places(
place_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
country_id INTEGER NOT NULL REFERENCES countries(country_id) 
	ON DELETE CASCADE ON UPDATE CASCADE,
place_name VARCHAR(80) NOT NULL
);

--3_accomodation (тип размещения)
CREATE TABLE IF NOT EXISTS accomodation(
accomodation_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
accomodation_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--4_hotel category (кол-во звёзд)
CREATE TABLE IF NOT EXISTS hotel_category(
hotel_category_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
hotel_category_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--5_room type (классификация по типу номеров в гостинице)
CREATE TABLE IF NOT EXISTS rooms_type(
room_type_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
room_type_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--6_type of food (тип питания в гостинице)
CREATE TABLE IF NOT EXISTS food(
food_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
food_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--7_location(расположение отеля)
CREATE TABLE IF NOT EXISTS location(
location_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
location_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--8_type of recreation (тип отдыха в туре)
CREATE TABLE IF NOT EXISTS recreation(
recreation_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
recreation_name VARCHAR(80) NOT NULL,
description VARCHAR(280)
);

--9_hotels (объединяем все что касается отеля -
--			 первая основная таблица базы данных)
CREATE TABLE IF NOT EXISTS hotels(
hotel_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
place_id INTEGER NOT NULL REFERENCES places(place_id) 
	ON DELETE CASCADE ON UPDATE CASCADE,
hotel_name VARCHAR(80) NOT NULL,
hotel_category_id INTEGER REFERENCES hotel_category(hotel_category_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
food_id INTEGER REFERENCES food(food_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
room_type_id INTEGER REFERENCES rooms_type(room_type_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
accomodation_id INTEGER REFERENCES accomodation(accomodation_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
location_id INTEGER REFERENCES location(location_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
recreation_id INTEGER REFERENCES recreation(recreation_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
price NUMERIC(6,2) NOT NULL
);
-----------------------------------------------------------------------
--закончили по гостинице
-----------------------------------------------------------------------

-----------------------------------------------------------------------
--начинаем раздел со второй основной таблицей ТУРЫ
-----------------------------------------------------------------------

--10transport(относится к таблице ТРАНСФЕР)
CREATE TABLE IF NOT EXISTS transport(
transport_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
transport_name VARCHAR(80) NOT NULL
);

--11departure city (город отправления)
CREATE TABLE IF NOT EXISTS departure_city(
city_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
country_id INTEGER REFERENCES countries(country_id),
city_name VARCHAR(80) NOT NULL
);

--12destination city (город назначения)
CREATE TABLE IF NOT EXISTS destination_city(
city_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
country_id INTEGER REFERENCES countries(country_id),
city_name VARCHAR(80) NOT NULL
);

--13transfer (первая ключевая таблица раздела ТУРЫ)
CREATE TABLE IF NOT EXISTS transfer(
transfer_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
transport_id INTEGER REFERENCES transport(transport_id),
departure_city_id INTEGER REFERENCES departure_city(city_id),
destination_city_id INTEGER REFERENCES destination_city(city_id),
transfer_price NUMERIC(6,2) NOT NULL
);

--14additional services (дополнительные услуги - для ТУРОПЕРАТОРЫ)
CREATE TABLE IF NOT EXISTS additional_services(
service_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
service_name VARCHAR(80) NOT NULL,
description VARCHAR(280),
price NUMERIC(6,2) NOT NULL
);

--15tour operators (туроператоры)
CREATE TABLE IF NOT EXISTS tour_operators(
operator_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
operator_name VARCHAR(80) NOT NULL,
additional_service_id INTEGER REFERENCES additional_services(service_id),
transfer_id INTEGER REFERENCES transfer(transfer_id)
);

--16tours (вторая основная таблица базы данных)
CREATE TABLE IF NOT EXISTS tours(
tour_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
tour_operator_id INTEGER REFERENCES tour_operators(operator_id),
hotel_id INTEGER REFERENCES hotels(hotel_id),
quantity INTEGER NOT NULL
);

--------------------------------------------------------------------
-- подготавливаем и заполняем третий основной раздел ЗАКАЗЫ
--------------------------------------------------------------------

--discounts(скидки для постоянных клиентов)
CREATE TABLE IF NOT EXISTS discounts(
discount_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
discount_name VARCHAR(80) NOT NULL,
percent REAL NOT NULL
);

--client (регистрационные данные клиента)
CREATE TABLE IF NOT EXISTS clients(
client_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
second_name VARCHAR(80) NOT NULL,
first_name VARCHAR(80) NOT NULL,
patronymic VARCHAR(80),
birth_day DATE NOT NULL,
adress VARCHAR(280) NOT NULL,
mobil_number VARCHAR(280) NOT NULL,
email VARCHAR(80) NOT NULL,
discount_id INTEGER REFERENCES discounts(discount_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
login VARCHAR(80) UNIQUE NOT NULL,
password VARCHAR(80) NOT NULL
);

--access level(уровень доступа сотрудника)
CREATE TABLE IF NOT EXISTS access_level(
access_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
access_name VARCHAR(80) NOT NULL,
description VARCHAR(280)
);

--employees (сотрудники)
CREATE TABLE IF NOT EXISTS employees(
employee_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
second_name VARCHAR(80) NOT NULL,
first_name VARCHAR(80) NOT NULL,
patronymic VARCHAR(80) NOT NULL,
birth_day DATE NOT NULL,
position VARCHAR(80) NOT NULL,
adress VARCHAR(80) NOT NULL,
mobil_number VARCHAR(80) NOT NULL,
work_number VARCHAR(80),
access_id INTEGER REFERENCES access_level(access_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
login VARCHAR(80) UNIQUE NOT NULL,
password VARCHAR(80) NOT NULL
);

--orders(заказы)
CREATE TABLE IF NOT EXISTS orders(
order_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
tour_id INTEGER REFERENCES tours(tour_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
client_id INTEGER REFERENCES clients(client_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
employee_id INTEGER REFERENCES employees(employee_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
registration_date TIMESTAMP NOT NULL,
departure_date TIMESTAMP NOT NULL,
destination_date TIMESTAMP NOT NULL
);