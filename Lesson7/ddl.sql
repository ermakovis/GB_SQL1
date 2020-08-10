create table entity_type
(
    id   int auto_increment
        primary key,
    name varchar(40) null
);

create table user
(
    id   int auto_increment
        primary key,
    name varchar(40) not null
);

create table entity
(
    id             int auto_increment
        primary key,
    title          varchar(40)  null,
    url            varchar(255) null,
    entity_type_id int          null,
    owner_id       int          null,
    constraint entity_type_id_fk
        foreign key (entity_type_id) references entity_type (id),
    constraint owner_fk
        foreign key (owner_id) references user (id)
);

create table `like`
(
    id                    int auto_increment
        primary key,
    source_user_id        int null,
    destination_entity_id int null,
    constraint destination_entity_id_fk
        foreign key (destination_entity_id) references entity (id),
    constraint source_user_id_fk
        foreign key (source_user_id) references user (id)
);