create database salon;
create table customers (
    customer_id serial primary key,
    phone varchar(20) unique,
    name text
);
create table appointments (
    appointment_id serial primary key,
    customer_id integer not null,
    service_id integer not null,
    time varchar
);
create table services (
    service_id serial primary key,
    name text
);
alter table appointments add foreign key(customer_id) references customers(customer_id);
alter table appointments add foreign key(service_id) references services(service_id);
insert into services values(1, 'manicure'), (2, 'pedicure'), (3, 'acrylics'), (4, 'lamination');
