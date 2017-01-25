--Database tourism agency (course project)

-------------------------------------------------------------------
-- íà÷èíàåì ñ ðàçäåëà ÃÎÑÒÈÍÈÖÀ
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

--3_accomodation (òèï ðàçìåùåíèÿ)
CREATE TABLE IF NOT EXISTS accomodations(
accomodation_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
accomodation_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--4_hotel category (êîë-âî çâ¸çä)
CREATE TABLE IF NOT EXISTS hotel_categorys(
hotel_category_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
hotel_category_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--5_room type (êëàññèôèêàöèÿ ïî òèïó íîìåðîâ â ãîñòèíèöå)
CREATE TABLE IF NOT EXISTS room_types(
room_type_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
room_type_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--6_type of food (òèï ïèòàíèÿ â ãîñòèíèöå)
CREATE TABLE IF NOT EXISTS foods(
food_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
food_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--7_location(ðàñïîëîæåíèå îòåëÿ)
CREATE TABLE IF NOT EXISTS locations(
location_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
location_name VARCHAR(80) NOT NULL,
description VARCHAR(280) NOT NULL
);

--8_type of recreation (òèï îòäûõà â òóðå)
CREATE TABLE IF NOT EXISTS recreations(
recreation_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
recreation_name VARCHAR(80) NOT NULL,
description VARCHAR(280)
);

--9_hotels (îáúåäèíÿåì âñå ÷òî êàñàåòñÿ îòåëÿ -
--			 ïåðâàÿ îñíîâíàÿ òàáëèöà áàçû äàííûõ)
CREATE TABLE IF NOT EXISTS hotels(
hotel_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
place_id INTEGER NOT NULL REFERENCES places(place_id),
hotel_name VARCHAR(80) NOT NULL,
hotel_category_id INTEGER REFERENCES hotel_categorys(hotel_category_id),
food_id INTEGER REFERENCES foods(food_id),
room_type_id INTEGER REFERENCES room_types(room_type_id),
accomodation_id INTEGER REFERENCES accomodations(accomodation_id),
location_id INTEGER REFERENCES locations(location_id),
recreation_id INTEGER REFERENCES recreations(recreation_id),
price NUMERIC(6,2) NOT NULL
);
-----------------------------------------------------------------------
--çàêîí÷èëè ïî ãîñòèíèöå
-----------------------------------------------------------------------

-----------------------------------------------------------------------
--íà÷èíàåì ðàçäåë ñî âòîðîé îñíîâíîé òàáëèöåé ÒÓÐÛ
-----------------------------------------------------------------------

--10transport(îòíîñèòñÿ ê òàáëèöå ÒÐÀÍÑÔÅÐ)
CREATE TABLE IF NOT EXISTS transports(
transport_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
transport_name VARCHAR(80) NOT NULL
);

--11departure city (ãîðîä îòïðàâëåíèÿ)
CREATE TABLE IF NOT EXISTS departure_citys(
city_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
country_id INTEGER REFERENCES countries(country_id),
city_name VARCHAR(80) NOT NULL
);

--12destination city (ãîðîä íàçíà÷åíèÿ)
CREATE TABLE IF NOT EXISTS destination_citys(
city_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
country_id INTEGER REFERENCES countries(country_id),
city_name VARCHAR(80) NOT NULL
);

--13transfer (ïåðâàÿ êëþ÷åâàÿ òàáëèöà ðàçäåëà ÒÓÐÛ)
CREATE TABLE IF NOT EXISTS transfers(
transfer_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
transport_id INTEGER REFERENCES transports(transport_id),
departure_city_id INTEGER REFERENCES departure_citys(city_id),
destination_city_id INTEGER REFERENCES destination_citys(city_id),
transfer_price NUMERIC(6,2) NOT NULL
);

--14additional services (äîïîëíèòåëüíûå óñëóãè - äëÿ ÒÓÐÎÏÅÐÀÒÎÐÛ)
CREATE TABLE IF NOT EXISTS additional_services(
service_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
service_name VARCHAR(80) NOT NULL,
description VARCHAR(280),
price NUMERIC(6,2) NOT NULL
);

--15tour operators (òóðîïåðàòîðû)
CREATE TABLE IF NOT EXISTS tour_operators(
operator_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
operator_name VARCHAR(80) NOT NULL,
additional_service_id INTEGER REFERENCES additional_services(service_id),
transfer_id INTEGER REFERENCES transfers(transfer_id)
);

--16tours (âòîðàÿ îñíîâíàÿ òàáëèöà áàçû äàííûõ)
CREATE TABLE IF NOT EXISTS tours(
tour_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
tour_operator_id INTEGER REFERENCES tour_operators(operator_id),
hotel_id INTEGER REFERENCES hotels(hotel_id),
departure_date TIMESTAMP NOT NULL,
destination_date TIMESTAMP NOT NULL
);

--------------------------------------------------------------------
-- ïîäãîòàâëèâàåì è çàïîëíÿåì òðåòèé îñíîâíîé ðàçäåë ÇÀÊÀÇÛ
--------------------------------------------------------------------

--17discounts(ñêèäêè äëÿ ïîñòîÿííûõ êëèåíòîâ)
CREATE TABLE IF NOT EXISTS discounts(
discount_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
discount_name VARCHAR(80) NOT NULL,
percent REAL NOT NULL
);

--18client (ðåãèñòðàöèîííûå äàííûå êëèåíòà)
CREATE TABLE IF NOT EXISTS clients(
client_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
second_name VARCHAR(80) NOT NULL,
first_name VARCHAR(80) NOT NULL,
patronymic VARCHAR(80),
birth_day DATE NOT NULL,
adress VARCHAR(280) NOT NULL,
mobil_number VARCHAR(280) NOT NULL,
email VARCHAR(80) NOT NULL,
discount_id INTEGER REFERENCES discounts(discount_id),
login VARCHAR(80) UNIQUE NOT NULL,
password VARCHAR(80) NOT NULL
);

--19access level(óðîâåíü äîñòóïà ñîòðóäíèêà)
CREATE TABLE IF NOT EXISTS access_levels(
access_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
access_name VARCHAR(80) NOT NULL,
description VARCHAR(280)
);

--20employees (ñîòðóäíèêè)
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
access_id INTEGER REFERENCES access_levels(access_id),
login VARCHAR(80) UNIQUE NOT NULL,
password VARCHAR(80) NOT NULL
);

--21orders(çàêàçû)
CREATE TABLE IF NOT EXISTS orders(
order_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
tour_id INTEGER REFERENCES tours(tour_id),
client_id INTEGER REFERENCES clients(client_id),
employee_id INTEGER REFERENCES employees(employee_id),
order_price NUMERIC(6,2) NOT NULL
);