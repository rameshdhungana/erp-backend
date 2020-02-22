--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6 (Ubuntu 10.6-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.6 (Ubuntu 10.6-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_emailaddress; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.account_emailaddress
(
  id        integer                NOT NULL,
  email     character varying(254) NOT NULL,
  verified  boolean                NOT NULL,
  "primary" boolean                NOT NULL,
  user_id   integer                NOT NULL
);


ALTER TABLE public.account_emailaddress
  OWNER TO club_erp_user;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.account_emailaddress_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.account_emailaddress_id_seq
  OWNER TO club_erp_user;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.account_emailaddress_id_seq OWNED BY public.account_emailaddress.id;


--
-- Name: account_emailconfirmation; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.account_emailconfirmation
(
  id               integer                  NOT NULL,
  created          timestamp with time zone NOT NULL,
  sent             timestamp with time zone,
  key              character varying(64)    NOT NULL,
  email_address_id integer                  NOT NULL
);


ALTER TABLE public.account_emailconfirmation
  OWNER TO club_erp_user;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.account_emailconfirmation_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.account_emailconfirmation_id_seq
  OWNER TO club_erp_user;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.account_emailconfirmation_id_seq OWNED BY public.account_emailconfirmation.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.auth_group
(
  id   integer               NOT NULL,
  name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group
  OWNER TO club_erp_user;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.auth_group_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.auth_group_id_seq
  OWNER TO club_erp_user;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.auth_group_permissions
(
  id            integer NOT NULL,
  group_id      integer NOT NULL,
  permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions
  OWNER TO club_erp_user;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq
  OWNER TO club_erp_user;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.auth_permission
(
  id              integer                NOT NULL,
  name            character varying(255) NOT NULL,
  content_type_id integer                NOT NULL,
  codename        character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission
  OWNER TO club_erp_user;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.auth_permission_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.auth_permission_id_seq
  OWNER TO club_erp_user;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.authtoken_token
(
  key     character varying(40)    NOT NULL,
  created timestamp with time zone NOT NULL,
  user_id integer                  NOT NULL
);


ALTER TABLE public.authtoken_token
  OWNER TO club_erp_user;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.django_admin_log
(
  id              integer                  NOT NULL,
  action_time     timestamp with time zone NOT NULL,
  object_id       text,
  object_repr     character varying(200)   NOT NULL,
  action_flag     smallint                 NOT NULL,
  change_message  text                     NOT NULL,
  content_type_id integer,
  user_id         integer                  NOT NULL,
  CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log
  OWNER TO club_erp_user;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.django_admin_log_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.django_admin_log_id_seq
  OWNER TO club_erp_user;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.django_content_type
(
  id        integer                NOT NULL,
  app_label character varying(100) NOT NULL,
  model     character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type
  OWNER TO club_erp_user;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.django_content_type_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.django_content_type_id_seq
  OWNER TO club_erp_user;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.django_migrations
(
  id      integer                  NOT NULL,
  app     character varying(255)   NOT NULL,
  name    character varying(255)   NOT NULL,
  applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations
  OWNER TO club_erp_user;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.django_migrations_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.django_migrations_id_seq
  OWNER TO club_erp_user;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.django_session
(
  session_key  character varying(40)    NOT NULL,
  session_data text                     NOT NULL,
  expire_date  timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session
  OWNER TO club_erp_user;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.django_site
(
  id     integer                NOT NULL,
  domain character varying(100) NOT NULL,
  name   character varying(50)  NOT NULL
);


ALTER TABLE public.django_site
  OWNER TO club_erp_user;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.django_site_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.django_site_id_seq
  OWNER TO club_erp_user;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- Name: events_configuration; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_configuration
(
  id         integer                  NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  deleted_at timestamp with time zone,
  uuid       uuid                     NOT NULL,
  key        character varying(255)   NOT NULL,
  value      text                     NOT NULL
);


ALTER TABLE public.events_configuration
  OWNER TO club_erp_user;

--
-- Name: events_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_configuration_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_configuration_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_configuration_id_seq OWNED BY public.events_configuration.id;


--
-- Name: events_event; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_event
(
  id                       integer                  NOT NULL,
  created_at               timestamp with time zone NOT NULL,
  updated_at               timestamp with time zone NOT NULL,
  deleted_at               timestamp with time zone,
  title                    character varying(255)   NOT NULL,
  uuid                     uuid                     NOT NULL,
  description              text                     NOT NULL,
  start_date               timestamp with time zone NOT NULL,
  end_date                 timestamp with time zone NOT NULL,
  early_bird_date          timestamp with time zone NOT NULL,
  is_single_day_event      boolean                  NOT NULL,
  start_time               time without time zone,
  end_time                 time without time zone,
  venue_location           character varying(255)   NOT NULL,
  label                    character varying(255)   NOT NULL,
  summary                  text                     NOT NULL,
  allow_group_registration boolean                  NOT NULL,
  max_group_limit          integer                  NOT NULL,
  status                   character varying(255)   NOT NULL,
  show_total_capacity      boolean                  NOT NULL,
  show_remaining_seats     boolean                  NOT NULL,
  is_published             boolean                  NOT NULL,
  show_start_time          boolean                  NOT NULL,
  show_end_time            boolean                  NOT NULL,
  category_id              integer                  NOT NULL,
  organizer_id             integer                  NOT NULL,
  type_id                  integer                  NOT NULL,
  timezone                 character varying(128)   NOT NULL
);


ALTER TABLE public.events_event
  OWNER TO club_erp_user;

--
-- Name: events_event_description_images; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_event_description_images
(
  id        integer NOT NULL,
  event_id  integer NOT NULL,
  images_id integer NOT NULL
);


ALTER TABLE public.events_event_description_images
  OWNER TO club_erp_user;

--
-- Name: events_event_description_images_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_event_description_images_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_event_description_images_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_event_description_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_event_description_images_id_seq OWNED BY public.events_event_description_images.id;


--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_event_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_event_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_event_id_seq OWNED BY public.events_event.id;


--
-- Name: events_event_title_images; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_event_title_images
(
  id        integer NOT NULL,
  event_id  integer NOT NULL,
  images_id integer NOT NULL
);


ALTER TABLE public.events_event_title_images
  OWNER TO club_erp_user;

--
-- Name: events_event_title_images_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_event_title_images_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_event_title_images_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_event_title_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_event_title_images_id_seq OWNED BY public.events_event_title_images.id;


--
-- Name: events_eventattendee; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventattendee
(
  id                         integer                  NOT NULL,
  created_at                 timestamp with time zone NOT NULL,
  updated_at                 timestamp with time zone NOT NULL,
  deleted_at                 timestamp with time zone,
  uuid                       uuid                     NOT NULL,
  smart_card_number          character varying(6)     NOT NULL,
  alternate_email            character varying(254),
  alternate_phone_number     character varying(128),
  is_senior_citizen          boolean                  NOT NULL,
  is_pwk                     boolean                  NOT NULL,
  registration_status        character varying(20)    NOT NULL,
  group_type                 character varying(10)    NOT NULL,
  note                       text                     NOT NULL,
  event_id                   integer                  NOT NULL,
  event_registration_type_id integer                  NOT NULL,
  registered_by_id           integer,
  user_id                    integer                  NOT NULL,
  confirmation_code          character varying(64)    NOT NULL,
  changed_to_offsite         boolean                  NOT NULL,
  description                text                     NOT NULL
);


ALTER TABLE public.events_eventattendee
  OWNER TO club_erp_user;

--
-- Name: events_eventattendee_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventattendee_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventattendee_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventattendee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventattendee_id_seq OWNED BY public.events_eventattendee.id;


--
-- Name: events_eventcategory; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventcategory
(
  id          integer                  NOT NULL,
  created_at  timestamp with time zone NOT NULL,
  updated_at  timestamp with time zone NOT NULL,
  deleted_at  timestamp with time zone,
  uuid        uuid                     NOT NULL,
  name        character varying(255)   NOT NULL,
  description text                     NOT NULL
);


ALTER TABLE public.events_eventcategory
  OWNER TO club_erp_user;

--
-- Name: events_eventcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventcategory_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventcategory_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventcategory_id_seq OWNED BY public.events_eventcategory.id;


--
-- Name: events_eventitem; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventitem
(
  id                                 integer                  NOT NULL,
  created_at                         timestamp with time zone NOT NULL,
  updated_at                         timestamp with time zone NOT NULL,
  deleted_at                         timestamp with time zone,
  uuid                               uuid                     NOT NULL,
  group_type                         character varying(10)    NOT NULL,
  item_capacity                      integer                  NOT NULL,
  items_booked                       integer                  NOT NULL,
  item_sharing_count                 integer                  NOT NULL,
  discount_before_early_bird         numeric(5, 2)            NOT NULL,
  discount_after_early_bird          numeric(5, 2)            NOT NULL,
  is_day_pass_item                   boolean                  NOT NULL,
  senior_citizen_discount_applicable boolean                  NOT NULL,
  event_id                           integer                  NOT NULL,
  event_registration_type_id         integer                  NOT NULL,
  group_id                           integer                  NOT NULL,
  item_master_id                     integer                  NOT NULL,
  ask_for_arrival_datetime           boolean                  NOT NULL,
  ask_for_pickup_location            boolean                  NOT NULL,
  ask_for_departure_datetime         boolean                  NOT NULL,
  CONSTRAINT events_eventitem_item_capacity_check CHECK ((item_capacity >= 0)),
  CONSTRAINT events_eventitem_item_sharing_count_check CHECK ((item_sharing_count >= 0)),
  CONSTRAINT events_eventitem_items_booked_check CHECK ((items_booked >= 0))
);


ALTER TABLE public.events_eventitem
  OWNER TO club_erp_user;

--
-- Name: events_eventitem_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventitem_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventitem_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventitem_id_seq OWNED BY public.events_eventitem.id;


--
-- Name: events_eventitem_transportation_pickup_locations; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventitem_transportation_pickup_locations
(
  id                              integer NOT NULL,
  eventitem_id                    integer NOT NULL,
  transportationpickuplocation_id integer NOT NULL
);


ALTER TABLE public.events_eventitem_transportation_pickup_locations
  OWNER TO club_erp_user;

--
-- Name: events_eventitem_transportation_pickup_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventitem_transportation_pickup_locations_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventitem_transportation_pickup_locations_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventitem_transportation_pickup_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventitem_transportation_pickup_locations_id_seq OWNED BY public.events_eventitem_transportation_pickup_locations.id;


--
-- Name: events_eventitemcart; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventitemcart
(
  id                         integer                  NOT NULL,
  created_at                 timestamp with time zone NOT NULL,
  updated_at                 timestamp with time zone NOT NULL,
  deleted_at                 timestamp with time zone,
  uuid                       uuid                     NOT NULL,
  quantity                   integer                  NOT NULL,
  event_id                   integer                  NOT NULL,
  event_attendee_id          integer                  NOT NULL,
  event_item_id              integer,
  event_registration_type_id integer                  NOT NULL,
  item_master_id             integer                  NOT NULL,
  ordered_by_attendee_id     integer                  NOT NULL,
  ordered_by_user_id         integer                  NOT NULL,
  user_id                    integer                  NOT NULL,
  rate                       numeric(19, 2)           NOT NULL,
  is_coupon_item             boolean                  NOT NULL,
  coupon_id                  integer,
  transportation_info_id     integer,
  transaction_type           character varying(255)   NOT NULL,
  amount                     numeric(19, 2)           NOT NULL,
  canceled_ordered_item_id   integer,
  discount                   numeric(19, 2)           NOT NULL,
  amount_net                 numeric(19, 2)           NOT NULL,
  amount_final               numeric(19, 2)           NOT NULL,
  amount_taxable             numeric(19, 2)           NOT NULL,
  item_sc                    numeric(19, 2)           NOT NULL,
  item_tax                   numeric(19, 2)           NOT NULL,
  entry_from_ordered_item    boolean                  NOT NULL,
  CONSTRAINT events_eventitemcart_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.events_eventitemcart
  OWNER TO club_erp_user;

--
-- Name: events_eventitemcart_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventitemcart_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventitemcart_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventitemcart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventitemcart_id_seq OWNED BY public.events_eventitemcart.id;


--
-- Name: events_eventitemgroup; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventitemgroup
(
  id                         integer                  NOT NULL,
  created_at                 timestamp with time zone NOT NULL,
  updated_at                 timestamp with time zone NOT NULL,
  deleted_at                 timestamp with time zone,
  uuid                       uuid                     NOT NULL,
  name                       character varying(255)   NOT NULL,
  slug                       character varying(50)    NOT NULL,
  description                text                     NOT NULL,
  is_multi_select            boolean                  NOT NULL,
  icon_type                  character varying(255)   NOT NULL,
  event_id                   integer                  NOT NULL,
  event_registration_type_id integer                  NOT NULL
);


ALTER TABLE public.events_eventitemgroup
  OWNER TO club_erp_user;

--
-- Name: events_eventitemgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventitemgroup_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventitemgroup_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventitemgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventitemgroup_id_seq OWNED BY public.events_eventitemgroup.id;


--
-- Name: events_eventregistrationtype; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventregistrationtype
(
  id             integer                  NOT NULL,
  created_at     timestamp with time zone NOT NULL,
  updated_at     timestamp with time zone NOT NULL,
  deleted_at     timestamp with time zone,
  uuid           uuid                     NOT NULL,
  name           character varying(255)   NOT NULL,
  total_capacity integer                  NOT NULL,
  is_published   boolean                  NOT NULL,
  status         character varying(20)    NOT NULL,
  required_otp   boolean                  NOT NULL,
  is_public      boolean                  NOT NULL,
  event_id       integer                  NOT NULL
);


ALTER TABLE public.events_eventregistrationtype
  OWNER TO club_erp_user;

--
-- Name: events_eventregistrationtype_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventregistrationtype_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventregistrationtype_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventregistrationtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventregistrationtype_id_seq OWNED BY public.events_eventregistrationtype.id;


--
-- Name: events_eventtype; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_eventtype
(
  id          integer                  NOT NULL,
  created_at  timestamp with time zone NOT NULL,
  updated_at  timestamp with time zone NOT NULL,
  deleted_at  timestamp with time zone,
  uuid        uuid                     NOT NULL,
  name        character varying(255)   NOT NULL,
  description text                     NOT NULL
);


ALTER TABLE public.events_eventtype
  OWNER TO club_erp_user;

--
-- Name: events_eventtype_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_eventtype_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_eventtype_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_eventtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_eventtype_id_seq OWNED BY public.events_eventtype.id;


--
-- Name: events_images; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_images
(
  id         integer                  NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  deleted_at timestamp with time zone,
  title      character varying(255)   NOT NULL,
  image      character varying(100)   NOT NULL
);


ALTER TABLE public.events_images
  OWNER TO club_erp_user;

--
-- Name: events_images_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_images_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_images_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_images_id_seq OWNED BY public.events_images.id;


--
-- Name: events_organizer; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_organizer
(
  id          integer                  NOT NULL,
  created_at  timestamp with time zone NOT NULL,
  updated_at  timestamp with time zone NOT NULL,
  deleted_at  timestamp with time zone,
  uuid        uuid                     NOT NULL,
  name        character varying(255)   NOT NULL,
  location    character varying(255)   NOT NULL,
  description text                     NOT NULL
);


ALTER TABLE public.events_organizer
  OWNER TO club_erp_user;

--
-- Name: events_organizer_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_organizer_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_organizer_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_organizer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_organizer_id_seq OWNED BY public.events_organizer.id;


--
-- Name: events_organizer_logo; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_organizer_logo
(
  id           integer NOT NULL,
  organizer_id integer NOT NULL,
  images_id    integer NOT NULL
);


ALTER TABLE public.events_organizer_logo
  OWNER TO club_erp_user;

--
-- Name: events_organizer_logo_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_organizer_logo_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_organizer_logo_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_organizer_logo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_organizer_logo_id_seq OWNED BY public.events_organizer_logo.id;


--
-- Name: events_phonenumber; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_phonenumber
(
  id           integer                  NOT NULL,
  created_at   timestamp with time zone NOT NULL,
  updated_at   timestamp with time zone NOT NULL,
  deleted_at   timestamp with time zone,
  is_visible   boolean                  NOT NULL,
  phone_number character varying(128)   NOT NULL,
  country      character varying(2)     NOT NULL,
  label        text                     NOT NULL,
  event_id     integer                  NOT NULL,
  organizer_id integer                  NOT NULL
);


ALTER TABLE public.events_phonenumber
  OWNER TO club_erp_user;

--
-- Name: events_phonenumber_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_phonenumber_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_phonenumber_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_phonenumber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_phonenumber_id_seq OWNED BY public.events_phonenumber.id;


--
-- Name: events_transportationinfo; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_transportationinfo
(
  id                 integer                  NOT NULL,
  created_at         timestamp with time zone NOT NULL,
  updated_at         timestamp with time zone NOT NULL,
  deleted_at         timestamp with time zone,
  uuid               uuid                     NOT NULL,
  arrival_datetime   timestamp with time zone,
  departure_datetime timestamp with time zone,
  pickup_location_id integer
);


ALTER TABLE public.events_transportationinfo
  OWNER TO club_erp_user;

--
-- Name: events_transportationinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_transportationinfo_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_transportationinfo_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_transportationinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_transportationinfo_id_seq OWNED BY public.events_transportationinfo.id;


--
-- Name: events_transportationpickuplocation; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.events_transportationpickuplocation
(
  id            integer                  NOT NULL,
  created_at    timestamp with time zone NOT NULL,
  updated_at    timestamp with time zone NOT NULL,
  deleted_at    timestamp with time zone,
  uuid          uuid                     NOT NULL,
  location      character varying(255)   NOT NULL,
  description   text                     NOT NULL,
  latitude      numeric(9, 6),
  longitude     numeric(9, 6),
  event_id      integer                  NOT NULL,
  event_item_id integer                  NOT NULL
);


ALTER TABLE public.events_transportationpickuplocation
  OWNER TO club_erp_user;

--
-- Name: events_transportationpickuplocation_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.events_transportationpickuplocation_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.events_transportationpickuplocation_id_seq
  OWNER TO club_erp_user;

--
-- Name: events_transportationpickuplocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.events_transportationpickuplocation_id_seq OWNED BY public.events_transportationpickuplocation.id;


--
-- Name: items_coupon; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_coupon
(
  id             integer                  NOT NULL,
  created_at     timestamp with time zone NOT NULL,
  updated_at     timestamp with time zone NOT NULL,
  deleted_at     timestamp with time zone,
  uuid           uuid                     NOT NULL,
  coupon_code    character varying(64)    NOT NULL,
  amount_limit   numeric(19, 2)           NOT NULL,
  type           character varying(20)    NOT NULL,
  item_master_id integer,
  user_id        integer,
  amount_used    numeric(19, 2)           NOT NULL,
  created_by_id  integer,
  notes          text                     NOT NULL,
  status         boolean                  NOT NULL,
  updated_by_id  integer
);


ALTER TABLE public.items_coupon
  OWNER TO club_erp_user;

--
-- Name: items_coupon_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_coupon_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_coupon_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_coupon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_coupon_id_seq OWNED BY public.items_coupon.id;


--
-- Name: items_itemcategory; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_itemcategory
(
  id         integer                  NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  deleted_at timestamp with time zone,
  uuid       uuid                     NOT NULL,
  name       character varying(255)   NOT NULL
);


ALTER TABLE public.items_itemcategory
  OWNER TO club_erp_user;

--
-- Name: items_itemcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_itemcategory_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_itemcategory_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_itemcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_itemcategory_id_seq OWNED BY public.items_itemcategory.id;


--
-- Name: items_itemmaster; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_itemmaster
(
  id                          integer                  NOT NULL,
  created_at                  timestamp with time zone NOT NULL,
  updated_at                  timestamp with time zone NOT NULL,
  deleted_at                  timestamp with time zone,
  uuid                        uuid                     NOT NULL,
  name                        character varying(255)   NOT NULL,
  options                     character varying(255)[],
  item_for_booking            boolean                  NOT NULL,
  item_for_sale               boolean                  NOT NULL,
  item_for_purchase           boolean                  NOT NULL,
  item_for_stock              boolean                  NOT NULL,
  item_for_rent               boolean                  NOT NULL,
  item_for_package            boolean                  NOT NULL,
  item_has_substitute         boolean                  NOT NULL,
  item_is_veg                 boolean                  NOT NULL,
  item_is_non_veg             boolean                  NOT NULL,
  item_is_liquor              boolean                  NOT NULL,
  item_is_reward              boolean                  NOT NULL,
  item_is_discount            boolean                  NOT NULL,
  item_is_service_charge      boolean                  NOT NULL,
  item_is_tax                 boolean                  NOT NULL,
  senior_citizen_discount_per numeric(5, 2)            NOT NULL,
  ask_for_delivery            boolean                  NOT NULL,
  item_rate                   numeric(19, 2)           NOT NULL,
  item_sc_per                 numeric(5, 2)            NOT NULL,
  item_tax_per                numeric(5, 2)            NOT NULL,
  item_mrp                    numeric(19, 2)           NOT NULL,
  is_public                   boolean                  NOT NULL,
  status                      boolean                  NOT NULL,
  item_in_stock               integer                  NOT NULL,
  item_rate_deposits          numeric(19, 2)           NOT NULL,
  has_addon_items             boolean                  NOT NULL,
  description                 text                     NOT NULL,
  category_id                 integer                  NOT NULL,
  process_id                  integer                  NOT NULL,
  service_id                  integer                  NOT NULL,
  uom_id                      integer                  NOT NULL,
  is_coupon_item              boolean                  NOT NULL,
  item_is_balance_topup       boolean                  NOT NULL,
  item_is_balance_used        boolean                  NOT NULL,
  CONSTRAINT items_itemmaster_item_in_stock_check CHECK ((item_in_stock >= 0))
);


ALTER TABLE public.items_itemmaster
  OWNER TO club_erp_user;

--
-- Name: items_itemmaster_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_itemmaster_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_itemmaster_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_itemmaster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_itemmaster_id_seq OWNED BY public.items_itemmaster.id;


--
-- Name: items_itemprocessmaster; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_itemprocessmaster
(
  id         integer                  NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  deleted_at timestamp with time zone,
  uuid       uuid                     NOT NULL,
  name       character varying(32)    NOT NULL
);


ALTER TABLE public.items_itemprocessmaster
  OWNER TO club_erp_user;

--
-- Name: items_itemprocessmaster_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_itemprocessmaster_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_itemprocessmaster_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_itemprocessmaster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_itemprocessmaster_id_seq OWNED BY public.items_itemprocessmaster.id;


--
-- Name: items_itemservice; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_itemservice
(
  id         integer                  NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  deleted_at timestamp with time zone,
  uuid       uuid                     NOT NULL,
  name       character varying(255)   NOT NULL
);


ALTER TABLE public.items_itemservice
  OWNER TO club_erp_user;

--
-- Name: items_itemservice_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_itemservice_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_itemservice_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_itemservice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_itemservice_id_seq OWNED BY public.items_itemservice.id;


--
-- Name: items_order; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_order
(
  id                         integer                  NOT NULL,
  created_at                 timestamp with time zone NOT NULL,
  updated_at                 timestamp with time zone NOT NULL,
  deleted_at                 timestamp with time zone,
  uuid                       uuid                     NOT NULL,
  order_number               integer                  NOT NULL,
  order_cfy                  character varying(32)    NOT NULL,
  transaction_type           character varying(255)   NOT NULL,
  balance                    numeric(19, 2)           NOT NULL,
  device_id                  character varying(255)   NOT NULL,
  web_initiated              boolean                  NOT NULL,
  app_initiated              boolean                  NOT NULL,
  one_time_password          character varying(255)   NOT NULL,
  notes                      text                     NOT NULL,
  delivery_access            character varying(255)   NOT NULL,
  order_status               character varying(20)    NOT NULL,
  event_attendee_id          integer,
  operator_id                integer,
  event_id                   integer,
  user_id                    integer                  NOT NULL,
  previous_order_id          integer,
  balance_credit             numeric(19, 2)           NOT NULL,
  event_registration_type_id integer
);


ALTER TABLE public.items_order
  OWNER TO club_erp_user;

--
-- Name: items_order_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_order_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_order_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_order_id_seq OWNED BY public.items_order.id;


--
-- Name: items_order_order_items; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_order_order_items
(
  id             integer NOT NULL,
  order_id       integer NOT NULL,
  ordereditem_id integer NOT NULL
);


ALTER TABLE public.items_order_order_items
  OWNER TO club_erp_user;

--
-- Name: items_order_ordered_items_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_order_ordered_items_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_order_ordered_items_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_order_ordered_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_order_ordered_items_id_seq OWNED BY public.items_order_order_items.id;


--
-- Name: items_ordercfyandordernumbertracker; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_ordercfyandordernumbertracker
(
  id                  integer                  NOT NULL,
  created_at          timestamp with time zone NOT NULL,
  updated_at          timestamp with time zone NOT NULL,
  deleted_at          timestamp with time zone,
  latest_order_number integer                  NOT NULL,
  latest_order_cfy    character varying(32)    NOT NULL
);


ALTER TABLE public.items_ordercfyandordernumbertracker
  OWNER TO club_erp_user;

--
-- Name: items_ordercfyandordernumbertracker_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_ordercfyandordernumbertracker_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_ordercfyandordernumbertracker_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_ordercfyandordernumbertracker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_ordercfyandordernumbertracker_id_seq OWNED BY public.items_ordercfyandordernumbertracker.id;


--
-- Name: items_ordereditem; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_ordereditem
(
  id                       integer                  NOT NULL,
  created_at               timestamp with time zone NOT NULL,
  updated_at               timestamp with time zone NOT NULL,
  deleted_at               timestamp with time zone,
  uuid                     uuid                     NOT NULL,
  order_number             integer                  NOT NULL,
  order_cfy                character varying(32)    NOT NULL,
  transaction_type         character varying(255)   NOT NULL,
  transaction_reference_id character varying(255)   NOT NULL,
  privileged               boolean                  NOT NULL,
  quantity                 integer                  NOT NULL,
  rate                     numeric(19, 2)           NOT NULL,
  amount                   numeric(19, 2)           NOT NULL,
  discount                 numeric(19, 2)           NOT NULL,
  amount_net               numeric(19, 2)           NOT NULL,
  item_sc                  numeric(19, 2)           NOT NULL,
  amount_taxable           numeric(19, 2)           NOT NULL,
  item_tax                 numeric(19, 2)           NOT NULL,
  amount_final             numeric(19, 2)           NOT NULL,
  actual_item_master_id    integer,
  item_master_id           integer                  NOT NULL,
  parent_order_id          integer,
  user_id                  integer                  NOT NULL,
  event_attendee_id        integer,
  transportation_info_id   integer,
  event_item_id            integer,
  canceled_ordered_item_id integer,
  coupon_id                integer,
  is_coupon_item           boolean                  NOT NULL,
  notes                    text                     NOT NULL
);


ALTER TABLE public.items_ordereditem
  OWNER TO club_erp_user;

--
-- Name: items_ordereditem_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_ordereditem_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_ordereditem_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_ordereditem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_ordereditem_id_seq OWNED BY public.items_ordereditem.id;


--
-- Name: items_unitofmeasurement; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.items_unitofmeasurement
(
  id         integer                  NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  deleted_at timestamp with time zone,
  uuid       uuid                     NOT NULL,
  name       character varying(64)    NOT NULL
);


ALTER TABLE public.items_unitofmeasurement
  OWNER TO club_erp_user;

--
-- Name: items_unitofmeasurement_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.items_unitofmeasurement_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.items_unitofmeasurement_id_seq
  OWNER TO club_erp_user;

--
-- Name: items_unitofmeasurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.items_unitofmeasurement_id_seq OWNED BY public.items_unitofmeasurement.id;


--
-- Name: users_user; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.users_user
(
  id              integer                  NOT NULL,
  password        character varying(128)   NOT NULL,
  last_login      timestamp with time zone,
  is_superuser    boolean                  NOT NULL,
  username        character varying(150)   NOT NULL,
  first_name      character varying(30)    NOT NULL,
  last_name       character varying(150)   NOT NULL,
  email           character varying(254)   NOT NULL,
  is_staff        boolean                  NOT NULL,
  is_active       boolean                  NOT NULL,
  date_joined     timestamp with time zone NOT NULL,
  uuid            uuid                     NOT NULL,
  phone_number    character varying(20)    NOT NULL,
  city            character varying(255)   NOT NULL,
  country         character varying(2)     NOT NULL,
  profile_picture character varying(100),
  gender          character varying(15)    NOT NULL
);


ALTER TABLE public.users_user
  OWNER TO club_erp_user;

--
-- Name: users_user_groups; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.users_user_groups
(
  id       integer NOT NULL,
  user_id  integer NOT NULL,
  group_id integer NOT NULL
);


ALTER TABLE public.users_user_groups
  OWNER TO club_erp_user;

--
-- Name: users_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.users_user_groups_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.users_user_groups_id_seq
  OWNER TO club_erp_user;

--
-- Name: users_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.users_user_groups_id_seq OWNED BY public.users_user_groups.id;


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.users_user_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.users_user_id_seq
  OWNER TO club_erp_user;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users_user.id;


--
-- Name: users_user_user_permissions; Type: TABLE; Schema: public; Owner: club_erp_user
--

CREATE TABLE public.users_user_user_permissions
(
  id            integer NOT NULL,
  user_id       integer NOT NULL,
  permission_id integer NOT NULL
);


ALTER TABLE public.users_user_user_permissions
  OWNER TO club_erp_user;

--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: club_erp_user
--

CREATE SEQUENCE public.users_user_user_permissions_id_seq
  AS integer
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


ALTER TABLE public.users_user_user_permissions_id_seq
  OWNER TO club_erp_user;

--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: club_erp_user
--

ALTER SEQUENCE public.users_user_user_permissions_id_seq OWNED BY public.users_user_user_permissions.id;


--
-- Name: account_emailaddress id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailaddress
  ALTER COLUMN id SET DEFAULT nextval('public.account_emailaddress_id_seq'::regclass);


--
-- Name: account_emailconfirmation id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailconfirmation
  ALTER COLUMN id SET DEFAULT nextval('public.account_emailconfirmation_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group
  ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group_permissions
  ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_permission
  ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_admin_log
  ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_content_type
  ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_migrations
  ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_site
  ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- Name: events_configuration id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_configuration
  ALTER COLUMN id SET DEFAULT nextval('public.events_configuration_id_seq'::regclass);


--
-- Name: events_event id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event
  ALTER COLUMN id SET DEFAULT nextval('public.events_event_id_seq'::regclass);


--
-- Name: events_event_description_images id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_description_images
  ALTER COLUMN id SET DEFAULT nextval('public.events_event_description_images_id_seq'::regclass);


--
-- Name: events_event_title_images id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_title_images
  ALTER COLUMN id SET DEFAULT nextval('public.events_event_title_images_id_seq'::regclass);


--
-- Name: events_eventattendee id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventattendee_id_seq'::regclass);


--
-- Name: events_eventcategory id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventcategory
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventcategory_id_seq'::regclass);


--
-- Name: events_eventitem id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventitem_id_seq'::regclass);


--
-- Name: events_eventitem_transportation_pickup_locations id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventitem_transportation_pickup_locations_id_seq'::regclass);


--
-- Name: events_eventitemcart id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventitemcart_id_seq'::regclass);


--
-- Name: events_eventitemgroup id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemgroup
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventitemgroup_id_seq'::regclass);


--
-- Name: events_eventregistrationtype id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventregistrationtype
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventregistrationtype_id_seq'::regclass);


--
-- Name: events_eventtype id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventtype
  ALTER COLUMN id SET DEFAULT nextval('public.events_eventtype_id_seq'::regclass);


--
-- Name: events_images id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_images
  ALTER COLUMN id SET DEFAULT nextval('public.events_images_id_seq'::regclass);


--
-- Name: events_organizer id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_organizer
  ALTER COLUMN id SET DEFAULT nextval('public.events_organizer_id_seq'::regclass);


--
-- Name: events_organizer_logo id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_organizer_logo
  ALTER COLUMN id SET DEFAULT nextval('public.events_organizer_logo_id_seq'::regclass);


--
-- Name: events_phonenumber id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_phonenumber
  ALTER COLUMN id SET DEFAULT nextval('public.events_phonenumber_id_seq'::regclass);


--
-- Name: events_transportationinfo id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_transportationinfo
  ALTER COLUMN id SET DEFAULT nextval('public.events_transportationinfo_id_seq'::regclass);


--
-- Name: events_transportationpickuplocation id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_transportationpickuplocation
  ALTER COLUMN id SET DEFAULT nextval('public.events_transportationpickuplocation_id_seq'::regclass);


--
-- Name: items_coupon id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_coupon
  ALTER COLUMN id SET DEFAULT nextval('public.items_coupon_id_seq'::regclass);


--
-- Name: items_itemcategory id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemcategory
  ALTER COLUMN id SET DEFAULT nextval('public.items_itemcategory_id_seq'::regclass);


--
-- Name: items_itemmaster id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemmaster
  ALTER COLUMN id SET DEFAULT nextval('public.items_itemmaster_id_seq'::regclass);


--
-- Name: items_itemprocessmaster id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemprocessmaster
  ALTER COLUMN id SET DEFAULT nextval('public.items_itemprocessmaster_id_seq'::regclass);


--
-- Name: items_itemservice id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemservice
  ALTER COLUMN id SET DEFAULT nextval('public.items_itemservice_id_seq'::regclass);


--
-- Name: items_order id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ALTER COLUMN id SET DEFAULT nextval('public.items_order_id_seq'::regclass);


--
-- Name: items_order_order_items id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order_order_items
  ALTER COLUMN id SET DEFAULT nextval('public.items_order_ordered_items_id_seq'::regclass);


--
-- Name: items_ordercfyandordernumbertracker id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordercfyandordernumbertracker
  ALTER COLUMN id SET DEFAULT nextval('public.items_ordercfyandordernumbertracker_id_seq'::regclass);


--
-- Name: items_ordereditem id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ALTER COLUMN id SET DEFAULT nextval('public.items_ordereditem_id_seq'::regclass);


--
-- Name: items_unitofmeasurement id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_unitofmeasurement
  ALTER COLUMN id SET DEFAULT nextval('public.items_unitofmeasurement_id_seq'::regclass);


--
-- Name: users_user id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user
  ALTER COLUMN id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: users_user_groups id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_groups
  ALTER COLUMN id SET DEFAULT nextval('public.users_user_groups_id_seq'::regclass);


--
-- Name: users_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_user_permissions
  ALTER COLUMN id SET DEFAULT nextval('public.users_user_user_permissions_id_seq'::regclass);


--
-- Data for Name: account_emailaddress; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.account_emailaddress (id, email, verified, "primary", user_id) FROM stdin;
\.


--
-- Data for Name: account_emailconfirmation; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.account_emailconfirmation (id, created, sent, key, email_address_id) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.auth_group (id, name) FROM stdin;
1	Attendee
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add permission	2	add_permission
5	Can change permission	2	change_permission
6	Can delete permission	2	delete_permission
7	Can add group	3	add_group
8	Can change group	3	change_group
9	Can delete group	3	delete_group
10	Can add content type	4	add_contenttype
11	Can change content type	4	change_contenttype
12	Can delete content type	4	delete_contenttype
13	Can add session	5	add_session
14	Can change session	5	change_session
15	Can delete session	5	delete_session
16	Can add site	6	add_site
17	Can change site	6	change_site
18	Can delete site	6	delete_site
19	Can add social application	7	add_socialapp
20	Can change social application	7	change_socialapp
21	Can delete social application	7	delete_socialapp
22	Can add social account	8	add_socialaccount
23	Can change social account	8	change_socialaccount
24	Can delete social account	8	delete_socialaccount
25	Can add social application token	9	add_socialtoken
26	Can change social application token	9	change_socialtoken
27	Can delete social application token	9	delete_socialtoken
28	Can add email address	10	add_emailaddress
29	Can change email address	10	change_emailaddress
30	Can delete email address	10	delete_emailaddress
31	Can add email confirmation	11	add_emailconfirmation
32	Can change email confirmation	11	change_emailconfirmation
33	Can delete email confirmation	11	delete_emailconfirmation
34	Can add Token	12	add_token
35	Can change Token	12	change_token
36	Can delete Token	12	delete_token
37	Can add user	13	add_user
38	Can change user	13	change_user
39	Can delete user	13	delete_user
40	Can add item category	14	add_itemcategory
41	Can change item category	14	change_itemcategory
42	Can delete item category	14	delete_itemcategory
43	Can add item master	15	add_itemmaster
44	Can change item master	15	change_itemmaster
45	Can delete item master	15	delete_itemmaster
46	Can add item process master	16	add_itemprocessmaster
47	Can change item process master	16	change_itemprocessmaster
48	Can delete item process master	16	delete_itemprocessmaster
49	Can add item service	17	add_itemservice
50	Can change item service	17	change_itemservice
51	Can delete item service	17	delete_itemservice
52	Can add order	18	add_order
53	Can change order	18	change_order
54	Can delete order	18	delete_order
55	Can add ordered item	19	add_ordereditem
56	Can change ordered item	19	change_ordereditem
57	Can delete ordered item	19	delete_ordereditem
58	Can add unit of measurement	20	add_unitofmeasurement
59	Can change unit of measurement	20	change_unitofmeasurement
60	Can delete unit of measurement	20	delete_unitofmeasurement
61	Can add coupon	21	add_coupon
62	Can change coupon	21	change_coupon
63	Can delete coupon	21	delete_coupon
64	Can add configuration	22	add_configuration
65	Can change configuration	22	change_configuration
66	Can delete configuration	22	delete_configuration
67	Can add event	23	add_event
68	Can change event	23	change_event
69	Can delete event	23	delete_event
70	Can add event attendee	24	add_eventattendee
71	Can change event attendee	24	change_eventattendee
72	Can delete event attendee	24	delete_eventattendee
73	Can add event category	25	add_eventcategory
74	Can change event category	25	change_eventcategory
75	Can delete event category	25	delete_eventcategory
76	Can add event item	26	add_eventitem
77	Can change event item	26	change_eventitem
78	Can delete event item	26	delete_eventitem
79	Can add event item cart	27	add_eventitemcart
80	Can change event item cart	27	change_eventitemcart
81	Can delete event item cart	27	delete_eventitemcart
82	Can add event item group	28	add_eventitemgroup
83	Can change event item group	28	change_eventitemgroup
84	Can delete event item group	28	delete_eventitemgroup
85	Can add event registration type	29	add_eventregistrationtype
86	Can change event registration type	29	change_eventregistrationtype
87	Can delete event registration type	29	delete_eventregistrationtype
88	Can add event type	30	add_eventtype
89	Can change event type	30	change_eventtype
90	Can delete event type	30	delete_eventtype
91	Can add images	31	add_images
92	Can change images	31	change_images
93	Can delete images	31	delete_images
94	Can add organizer	32	add_organizer
95	Can change organizer	32	change_organizer
96	Can delete organizer	32	delete_organizer
97	Can add phone number	33	add_phonenumber
98	Can change phone number	33	change_phonenumber
99	Can delete phone number	33	delete_phonenumber
100	Can add transportation pickup location	34	add_transportationpickuplocation
101	Can change transportation pickup location	34	change_transportationpickuplocation
102	Can delete transportation pickup location	34	delete_transportationpickuplocation
103	Can add transportation info	35	add_transportationinfo
104	Can change transportation info	35	change_transportationinfo
105	Can delete transportation info	35	delete_transportationinfo
106	Can add order cfy and order number tracker	36	add_ordercfyandordernumbertracker
107	Can change order cfy and order number tracker	36	change_ordercfyandordernumbertracker
108	Can delete order cfy and order number tracker	36	delete_ordercfyandordernumbertracker
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id,
                              user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	contenttypes	contenttype
5	sessions	session
6	sites	site
7	allauth	socialapp
8	allauth	socialaccount
9	allauth	socialtoken
10	account	emailaddress
11	account	emailconfirmation
12	authtoken	token
13	users	user
14	items	itemcategory
15	items	itemmaster
16	items	itemprocessmaster
17	items	itemservice
18	items	order
19	items	ordereditem
20	items	unitofmeasurement
21	items	coupon
22	events	configuration
23	events	event
24	events	eventattendee
25	events	eventcategory
26	events	eventitem
27	events	eventitemcart
28	events	eventitemgroup
29	events	eventregistrationtype
30	events	eventtype
31	events	images
32	events	organizer
33	events	phonenumber
34	events	transportationpickuplocation
35	events	transportationinfo
36	items	ordercfyandordernumbertracker
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2019-03-11 08:12:22.911716+00
2	contenttypes	0002_remove_content_type_name	2019-03-11 08:12:22.938082+00
3	auth	0001_initial	2019-03-11 08:12:23.041105+00
4	auth	0002_alter_permission_name_max_length	2019-03-11 08:12:23.04801+00
5	auth	0003_alter_user_email_max_length	2019-03-11 08:12:23.055688+00
6	auth	0004_alter_user_username_opts	2019-03-11 08:12:23.087356+00
7	auth	0005_alter_user_last_login_null	2019-03-11 08:12:23.094476+00
8	auth	0006_require_contenttypes_0002	2019-03-11 08:12:23.096367+00
9	auth	0007_alter_validators_add_error_messages	2019-03-11 08:12:23.102702+00
10	auth	0008_alter_user_username_max_length	2019-03-11 08:12:23.109213+00
11	auth	0009_alter_user_last_name_max_length	2019-03-11 08:12:23.115826+00
12	users	0001_initial	2019-03-11 08:12:23.267896+00
13	account	0001_initial	2019-03-11 08:12:23.366771+00
14	account	0002_email_max_length	2019-03-11 08:12:23.379632+00
15	admin	0001_initial	2019-03-11 08:12:23.43163+00
16	admin	0002_logentry_remove_auto_add	2019-03-11 08:12:23.443445+00
17	authtoken	0001_initial	2019-03-11 08:12:23.485234+00
18	authtoken	0002_auto_20160226_1747	2019-03-11 08:12:23.533961+00
19	events	0001_initial	2019-03-11 08:12:24.100123+00
20	items	0001_initial	2019-03-11 08:12:24.690046+00
21	events	0002_auto_20190307_0855	2019-03-11 08:12:25.634054+00
22	events	0003_auto_20190308_0900	2019-03-11 08:12:26.118516+00
23	events	0004_auto_20190310_1211	2019-03-11 08:12:26.154833+00
24	items	0002_coupon	2019-03-11 08:12:26.251847+00
25	items	0003_auto_20190308_0531	2019-03-11 08:12:26.298043+00
26	items	0004_itemmaster_is_coupon_item	2019-03-11 08:12:26.398924+00
27	items	0005_auto_20190310_1035	2019-03-11 08:12:26.507307+00
28	items	0006_auto_20190310_1049	2019-03-11 08:12:26.542226+00
29	items	0007_auto_20190310_1059	2019-03-11 08:12:26.57697+00
30	items	0008_auto_20190310_1141	2019-03-11 08:12:26.694795+00
31	items	0009_auto_20190310_1211	2019-03-11 08:12:26.721298+00
32	items	0010_auto_20190310_1231	2019-03-11 08:12:26.755823+00
33	items	0011_auto_20190310_1237	2019-03-11 08:12:26.799918+00
34	items	0012_auto_20190310_1245	2019-03-11 08:12:26.987166+00
35	items	0013_auto_20190310_1314	2019-03-11 08:12:27.103294+00
36	items	0014_auto_20190310_1316	2019-03-11 08:12:27.150689+00
37	sessions	0001_initial	2019-03-11 08:12:27.194307+00
38	sites	0001_initial	2019-03-11 08:12:27.209955+00
39	sites	0002_alter_domain_unique	2019-03-11 08:12:27.234398+00
40	users	0002_auto_20190310_0806	2019-03-11 08:12:27.254659+00
41	items	0015_auto_20190311_1118	2019-03-12 04:19:01.440702+00
42	events	0005_auto_20190311_1118	2019-03-12 04:19:01.590956+00
43	items	0016_ordereditem_event_attendee	2019-03-12 04:19:01.653199+00
44	events	0006_eventitemcart_coupon_type	2019-03-12 06:03:50.829954+00
45	events	0007_auto_20190312_0610	2019-03-12 06:10:36.386245+00
46	events	0007_auto_20190312_0607	2019-03-15 13:48:19.914175+00
47	events	0008_transportationpickuplocation	2019-03-15 13:48:19.968711+00
48	events	0009_eventitem_pickup_location	2019-03-15 13:48:20.060137+00
49	events	0010_auto_20190313_0552	2019-03-15 13:48:20.074911+00
50	events	0011_auto_20190313_0614	2019-03-15 13:48:20.139509+00
51	events	0012_auto_20190313_0839	2019-03-15 13:48:20.361398+00
52	events	0013_remove_eventitem_transportation_pickup_locations	2019-03-15 13:48:20.406072+00
53	events	0014_auto_20190313_0912	2019-03-15 13:48:20.607272+00
54	events	0015_event_timezone	2019-03-15 13:48:20.696308+00
55	events	0016_eventitem_transportation_pickup_locations	2019-03-15 13:48:20.789342+00
56	events	0017_auto_20190314_1728	2019-03-15 13:48:20.843187+00
57	events	0018_auto_20190315_0656	2019-03-15 13:48:21.070736+00
58	events	0019_eventitemcart_transportation_info	2019-03-15 13:48:21.157422+00
59	events	0020_auto_20190315_1049	2019-03-15 13:48:21.324351+00
60	events	0021_auto_20190315_1051	2019-03-15 13:48:21.358052+00
61	events	0022_merge_20190315_1348	2019-03-15 13:48:21.360386+00
62	items	0017_ordereditem_transportation_info	2019-03-15 13:48:21.449865+00
63	items	0018_auto_20190315_1049	2019-03-15 13:48:21.546624+00
64	events	0022_eventattendee_confirmation_code	2019-03-22 08:36:46.058324+00
65	events	0023_merge_20190322_0836	2019-03-22 08:36:46.060802+00
66	events	0023_eventitemcart_transaction_type	2019-04-01 06:27:19.245754+00
67	events	0024_auto_20190326_1323	2019-04-01 06:27:19.479234+00
68	events	0025_eventitemcart_amount_final	2019-04-01 06:27:19.667153+00
69	events	0026_auto_20190329_1053	2019-04-01 06:27:19.723691+00
70	events	0027_eventitemcart_canceled_ordered_item	2019-04-01 06:27:19.807262+00
71	events	0028_auto_20190329_1304	2019-04-01 06:27:19.91434+00
72	events	0029_merge_20190401_0626	2019-04-01 06:27:19.91648+00
73	items	0019_ordereditem_event_item	2019-04-01 06:27:19.982498+00
74	items	0020_auto_20190326_1323	2019-04-01 06:27:20.074454+00
75	items	0021_auto_20190326_1329	2019-04-01 06:27:20.124391+00
76	items	0022_auto_20190328_0631	2019-04-01 06:27:20.250585+00
77	items	0023_ordereditem_canceled_ordered_item	2019-04-01 06:27:20.305193+00
78	items	0024_auto_20190329_1053	2019-04-01 06:27:20.341015+00
79	events	0029_eventattendee_changed_to_offsite	2019-04-19 13:28:37.044723+00
80	events	0030_remove_eventitemcart_event_item_group	2019-04-19 13:28:37.176116+00
81	events	0031_eventitemcart_discount	2019-04-19 13:28:37.377866+00
82	events	0032_auto_20190402_1348	2019-04-19 13:28:37.420258+00
83	events	0033_eventitemcart_amount_net	2019-04-19 13:28:37.606449+00
84	events	0034_auto_20190402_1820	2019-04-19 13:28:38.38417+00
85	events	0035_auto_20190404_0524	2019-04-19 13:28:38.428161+00
86	events	0036_auto_20190408_0538	2019-04-19 13:28:38.467265+00
87	events	0037_eventitemcart_entry_from_ordered_item	2019-04-19 13:28:38.651286+00
88	events	0038_remove_eventitemcart_coupon_type	2019-04-19 13:28:38.695406+00
89	events	0039_remove_eventitemcart_on_order_edit	2019-04-19 13:28:38.739296+00
90	events	0040_auto_20190409_0353	2019-04-19 13:28:38.782099+00
91	events	0041_auto_20190411_1016	2019-04-19 13:28:38.819613+00
92	events	0042_auto_20190419_1202	2019-04-19 13:28:38.959484+00
93	events	0043_merge_20190419_1328	2019-04-19 13:28:38.9619+00
94	items	0025_auto_20190404_0524	2019-04-19 13:28:39.222932+00
95	items	0026_coupon_amount_used	2019-04-19 13:28:39.408032+00
96	items	0027_auto_20190405_1241	2019-04-19 13:28:39.457666+00
97	items	0028_auto_20190408_0538	2019-04-19 13:28:40.211708+00
98	items	0029_auto_20190408_1042	2019-04-19 13:28:40.267655+00
99	items	0030_order_event_registration_type	2019-04-19 13:28:40.397639+00
100	items	0031_auto_20190409_0353	2019-04-19 13:28:40.659275+00
101	items	0032_ordercfyandordernumbertracker	2019-04-19 13:28:40.681512+00
102	items	0033_auto_20190419_1202	2019-04-19 13:28:40.686792+00
103	events	0043_eventattendee_description	2019-04-19 14:00:14.807742+00
104	events	0044_merge_20190419_1359	2019-04-19 14:00:14.815785+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Data for Name: events_configuration; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_configuration (id, created_at, updated_at, deleted_at, uuid, key, value) FROM stdin;
1	2019-03-11 08:12:47.045308+00	2019-03-11 08:12:47.047039+00	\N	7d7e818b-5b1c-4459-93fc-84728d9e9415	contact_number_first	+977 9876543210
2	2019-03-11 08:12:47.049627+00	2019-03-11 08:12:47.050816+00	\N	4a462342-8d24-4fa9-afa5-33baf89aa423	contact_number_second	+977 0123456789
3	2019-03-11 08:12:47.053148+00	2019-03-11 08:12:47.054366+00	\N	9d17aec5-418f-4099-bad2-95dc66e04283	contact_email	amaroo@gmail.com
4	2019-03-11 08:12:47.056635+00	2019-03-11 08:12:47.057937+00	\N	d2372957-ef98-4445-9a45-e6e2ddbdd7fd	facebook_link	https://www.facebook.com/
5	2019-03-11 08:12:47.060208+00	2019-03-11 08:12:47.061448+00	\N	55d62e44-abfb-42a0-838e-af76a384db03	instagram_link	https://www.instagram.com/
6	2019-03-11 08:12:47.06392+00	2019-03-11 08:12:47.065135+00	\N	6020f5ed-090e-4b84-8224-d815de17da16	nipuna_website_link	http://www.nipunaprabidhiksewa.com/
7	2019-03-11 08:12:47.067428+00	2019-03-11 08:12:47.068595+00	\N	43139be0-8080-45ee-b5b6-e83c6d7b69d8	youtube_link	https://www.youtube.com/
8	2019-03-11 08:12:47.070822+00	2019-03-11 08:12:47.072073+00	\N	d68687ef-2de3-402e-894b-8a913e247a2c	linkedin_link	https://www.linkedin.com/
9	2019-03-11 08:12:47.074463+00	2019-03-11 08:12:47.07567+00	\N	65daa4ea-a6c6-4b10-8799-836abdb8fa06	copyright_content	this is copyright content 
10	2019-03-11 08:12:47.077972+00	2019-03-11 08:12:47.079246+00	\N	b1a521de-dfd5-463e-87c0-b96393656fc0	powered_by	Nipuna Prabidhik sewa
11	2019-03-11 08:12:47.081491+00	2019-04-22 07:19:59.218352+00	\N	1a77762a-94e2-40e3-bd50-a97fd56de784	footer_description	<small>This Website – We will be trialling keeping amaroo.org live until the next event. This will enable you to read it at your leisure, keep abreast on event preparations, and enjoy some new pages that will be added over time.\r\nVisit the News page regularly for all the updates!\r\n\r\nThe Amaroo Event Team is now moving into planning mode for the next event. As always, events are subject to securing time in Prem Rawat’s busy global schedule.  We shall let you know if and when an event is confirmed.</small>
\.


--
-- Data for Name: events_event; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_event (id, created_at, updated_at, deleted_at, title, uuid, description, start_date, end_date,
                          early_bird_date, is_single_day_event, start_time, end_time, venue_location, label, summary,
                          allow_group_registration, max_group_limit, status, show_total_capacity, show_remaining_seats,
                          is_published, show_start_time, show_end_time, category_id, organizer_id, type_id,
                          timezone) FROM stdin;
1	2019-03-12 04:51:34.941395+00	2019-03-12 04:51:34.941417+00	\N	Amaroo 2019	9ad9a2ca-8af4-4e64-af83-3072364acec2	<div class="content-sidebar-wrap">\r\n<article class="post-744 page type-page status-publish entry"><header class="entry-header">\r\n<h1 class="entry-title">Welcome to Amaroo!</h1>\r\n</header>\r\n<div class="entry-content">\r\n<p>Thank you to everyone who contributed to the success of Amaroo 2018.<br /> A very special thank you to Prem Rawat.</p>\r\n<p>Last September for five full days, thousands of people from every corner of the globe came together with Prem to unplug, unwind &mdash; and make the most of a unique opportunity to focus on the essentials of living a fulfilled life. Amaroo provided the prefect environment.</p>\r\n<p>Prem shared his keen perspective on everything from the epic stories of the Mahabharata to love and relationships in our times. There were personal exchanges with audience members and far-ranging talks that shed new light on the life we&rsquo;ve been given&hellip;all infused with Prem&rsquo;s candour, warmth and humour.</p>\r\n<p>If you would like to know more visit <a href="https://www.premrawat.com/" target="_blank" rel="noopener">premrawat.com</a></p>\r\n<p><strong>This Website</strong> &ndash; We will be trialling keeping amaroo.org live until the next event. This will enable you to read it at your leisure, keep abreast on event preparations, and enjoy some new pages that will be added over time.<br /> Visit the <a href="https://amaroo.org/news/">News page</a> regularly for all the updates!</p>\r\n<p>The Amaroo Event Team is now moving into planning mode for the next event. As always, events are subject to securing time in Prem Rawat&rsquo;s busy global schedule.&nbsp; We shall let you know if and when an event is confirmed.</p>\r\n<p style="font-size: 2rem; font-weight: 400; font-style: italic;">&ldquo;Peace is Possible&rdquo;</p>\r\n<h3>Venue</h3>\r\n<p>Ivory&rsquo;s Rock Conventions and Events Centre<br /> 310 Mt Flinders Road<br /> Peak Crossing<br /> Queensland 4306<br /> Australia</p>\r\n<h3><strong>Stay on-site and enjoy Amaroo to the fullest!</strong></h3>\r\n<p>Amaroo is not your ordinary camping experience!</p>\r\n<p>Stay on-site and enjoy the beauty of Amaroo and it&rsquo;s first class facilities. They have been thoughtfully designed with your comfort in mind and are always being improved and added to.</p>\r\n<p>Amaroo now offers a higher level in comfort &amp; privacy &ndash; check out the new&nbsp;<a href="https://amaroo.org/sp_faq/bunkhouses-and-motorhome-spaces/">Ensuite Cabins</a>.&nbsp; Features include your own ensuite bathroom, air-conditioning, comfortable large bed, desk, &amp; tea making facilities.</p>\r\n<p>Take a look at the&nbsp;<a href="https://amaroo.org/sp_faq/jacaranda-campgrounds/">Deluxe</a> or <a href="https://amaroo.org/sp_faq/sandy-creek-campgrounds/">Pioneer Tents</a>.&nbsp; Tents with a bed &amp; linen amongst other comforts! The bathroom facilities are beyond what you would expect in a campground &ndash; beautifully designed and clean!</p>\r\n<p>Amaroo is what it is today, because of the support of people like you. By choosing to stay on-site you are financially ensuring the on-going Vision for Amaroo, enabling it to continue and to grow.</p>\r\n<p>Visit the&nbsp;&nbsp;<a href="https://amaroo.org/stay-onsite/">Stay on-site</a>&nbsp;page for all the accommodation options.</p>\r\n<p><em>&ldquo;It was beautiful from the moment I got there. It was one of the best things I&rsquo;ve done in my life! Just wonderful.&rdquo;&nbsp; Amaroo Guest</em></p>\r\n<h3>Translation Assistance</h3>\r\n<p>You can read this website in your language. Please see the drop down menu in the top right hand corner.</p>\r\n<p>Proudly organised and sponsored by&nbsp;<a class="boldlink" href="https://ivorysrock.foundation" target="_blank" rel="noopener">Ivory&rsquo;s Rock Foundation (IRF)</a></p>\r\n</div>\r\n</article>\r\n</div>	2019-04-01 00:00:00+00	2019-04-05 00:00:00+00	2019-03-17 06:00:00+00	f	06:00:00	18:00:00	Ivory	“Peace is Possible”	<p>The Amaroo Event Team is now moving into planning mode for the next event. As always, events are subject to securing time in Prem Rawat&rsquo;s busy global schedule. We shall let you know if and when an event is confirmed.</p>	t	10	Open	t	t	t	t	t	1	1	1	Australia/Melbourne
\.


--
-- Data for Name: events_event_description_images; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_event_description_images (id, event_id, images_id) FROM stdin;
\.


--
-- Data for Name: events_event_title_images; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_event_title_images (id, event_id, images_id) FROM stdin;
\.


--
-- Data for Name: events_eventattendee; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventattendee (id, created_at, updated_at, deleted_at, uuid, smart_card_number, alternate_email,
                                  alternate_phone_number, is_senior_citizen, is_pwk, registration_status, group_type,
                                  note, event_id, event_registration_type_id, registered_by_id, user_id,
                                  confirmation_code, changed_to_offsite, description) FROM stdin;
10	2019-03-12 06:04:08.98356+00	2019-03-12 06:04:08.984284+00	\N	64efb490-b3bd-4ade-bf4a-e7a692a67563	aaaaaa	\N	\N	t	t	Initiated	OnSite		1	1	10	10		f	
11	2019-03-12 06:04:09.015226+00	2019-03-12 06:04:09.015267+00	\N	b75badfa-3add-4c35-99b4-c93d5dec9275	cccccc	Test@gmail.com	+9779845653912	f	t	Initiated	OnSite		1	1	10	11		f	
12	2019-04-19 14:10:06.560563+00	2019-04-19 14:17:39.645913+00	\N	4e08c528-0669-4079-b314-a2c79471e7c4	tetete	\N	\N	t	t	Confirmed	OnSite		1	1	12	13	552dfe84	f	
13	2019-04-19 14:13:36.963204+00	2019-04-19 14:17:39.647487+00	\N	95029c0f-7ccb-4ff4-85a5-593cc2b21fbe	heyeye		+9779845634525	t	t	Confirmed	OnSite		1	1	12	14	f80f1845	f	
16	2019-04-24 09:05:13.877562+00	2019-04-24 09:13:47.960947+00	\N	dccf3a38-5d9b-4579-8e3d-993a0aecdbb2	tetege	\N	\N	t	f	Confirmed	OnSite		1	1	16	17	67c50c7a	f	
17	2019-04-24 09:10:52.023907+00	2019-04-24 09:13:47.96257+00	\N	09a1438a-f256-4e7a-8e04-922c1cc2d7d6	tetehh	hello@gmail.com	+9779845634245	t	f	Confirmed	OnSite		1	1	16	18	244bcf8f	f	
\.


--
-- Data for Name: events_eventcategory; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventcategory (id, created_at, updated_at, deleted_at, uuid, name, description) FROM stdin;
1	2019-03-12 04:50:34.815412+00	2019-03-12 04:50:34.818835+00	\N	7866b540-1ee8-47b5-9738-7520dea34a74	Philosophy	Philosophy
\.


--
-- Data for Name: events_eventitem; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventitem (id, created_at, updated_at, deleted_at, uuid, group_type, item_capacity, items_booked,
                              item_sharing_count, discount_before_early_bird, discount_after_early_bird,
                              is_day_pass_item, senior_citizen_discount_applicable, event_id,
                              event_registration_type_id, group_id, item_master_id, ask_for_arrival_datetime,
                              ask_for_pickup_location, ask_for_departure_datetime) FROM stdin;
2	2019-03-12 04:54:51.759826+00	2019-03-12 04:54:51.759855+00	\N	84091b00-d710-4dc3-b74e-9b27c22be4f0	OffSite	1000	0	1	10.00	0.00	t	f	1	1	1	9	f	f	f
3	2019-03-12 04:56:48.057025+00	2019-03-12 04:56:48.057053+00	\N	83ee5d99-0a63-4d9b-8a6c-4654530b9f1b	OffSite	1000	0	1	0.00	0.00	t	t	1	1	1	10	f	f	f
4	2019-03-12 04:57:16.462294+00	2019-03-12 04:57:16.462324+00	\N	2661a4f2-0131-4313-995f-a77b0c8d61f8	OffSite	1000	0	1	0.00	0.00	t	t	1	1	1	11	f	f	f
6	2019-03-12 04:57:48.650734+00	2019-03-12 04:57:48.650757+00	\N	3099ee77-8419-4648-9c08-8db9097b6d35	OffSite	1000	0	1	0.00	0.00	t	t	1	1	1	12	f	f	f
7	2019-03-12 04:58:09.75351+00	2019-03-12 04:58:09.753533+00	\N	80f87194-63cc-42d4-a44d-b89ccb6d351d	OffSite	1000	0	1	0.00	0.00	t	t	1	1	1	13	f	f	f
8	2019-03-12 04:58:38.284268+00	2019-03-12 04:58:38.284293+00	\N	6e5e40c4-4d86-426b-9a48-941211a13e8c	OnSite	1000	0	1	10.00	0.00	f	f	1	1	2	14	f	f	f
9	2019-03-12 04:59:11.597187+00	2019-03-12 04:59:11.597219+00	\N	b8b07eef-ffff-4e1f-a5c6-72a1e4f2962d	OnSite	1000	0	2	10.00	0.00	f	f	1	1	2	15	f	f	f
10	2019-03-12 04:59:41.681655+00	2019-03-12 04:59:41.681686+00	\N	a4d76c7c-f067-449b-b1af-96408c8094a9	OnSite	1000	0	1	10.00	0.00	f	f	1	1	2	16	f	f	f
12	2019-03-12 05:00:57.69503+00	2019-03-12 05:01:58.625564+00	\N	fe3ee2c0-4a16-45b1-a43a-44a474173c97	OnSite	1000	0	3	10.00	0.00	f	f	1	1	2	18	f	f	f
13	2019-03-12 05:02:46.020844+00	2019-03-12 05:02:46.020866+00	\N	7c167c1d-3aa5-4333-94b6-2739ed6c7bde	OnSite	1000	0	1	10.00	0.00	f	f	1	1	2	19	f	f	f
14	2019-03-12 05:03:14.853525+00	2019-03-12 05:03:14.85355+00	\N	c9c40e75-7805-43bc-afff-b11a3e6bdd18	OnSite	1000	0	2	10.00	0.00	f	f	1	1	2	20	f	f	f
15	2019-03-12 05:03:52.897043+00	2019-03-12 05:03:52.897074+00	\N	63b1365f-b700-4448-871f-3b43d77ef719	OnSite	1000	0	1	10.00	0.00	f	f	1	1	2	21	f	f	f
16	2019-03-12 05:04:20.845017+00	2019-03-12 05:04:20.845044+00	\N	0e817157-6a6b-4afe-ad51-af41f707c5d1	OnSite	1000	0	2	10.00	0.00	f	f	1	1	2	22	f	f	f
17	2019-03-12 05:04:51.680263+00	2019-03-12 05:04:51.680286+00	\N	e589676f-5cd0-41e8-9ca8-e0fbf66581a0	OnSite	1000	0	3	10.00	0.00	f	f	1	1	2	23	f	f	f
18	2019-03-12 05:05:25.339897+00	2019-03-12 05:05:25.339922+00	\N	aad38cde-9307-420e-8485-4df8cfcb5f73	OnSite	1000	0	4	10.00	0.00	f	f	1	1	2	24	f	f	f
19	2019-03-12 05:06:14.815228+00	2019-03-12 05:06:14.815252+00	\N	eb911697-632d-496c-8ae8-3b65a051e4e3	OnSite	1000	0	1	10.00	0.00	f	f	1	1	2	25	f	f	f
20	2019-03-12 05:06:47.992115+00	2019-03-12 05:06:47.992138+00	\N	c21c7a92-c9b6-4149-bc2a-6af0d3a9ce00	OnSite	1000	0	1	10.00	1.00	f	f	1	1	2	26	f	f	f
25	2019-03-12 05:09:35.76995+00	2019-03-12 05:09:35.769976+00	\N	9b40db5f-6e74-4751-85de-52c979a03c90	OnSite	1000	0	1	10.00	0.00	f	f	1	1	3	31	f	f	f
26	2019-03-12 05:09:58.613815+00	2019-03-12 05:09:58.613843+00	\N	a93c55ab-b12b-4e0b-9b77-fd61f709ed53	OnSite	1000	0	1	10.00	0.00	f	f	1	1	3	32	f	f	f
11	2019-03-12 05:00:18.888532+00	2019-03-12 05:27:51.525617+00	\N	bbd6ea39-f202-4e33-b988-a06468aa2f06	OnSite	1000	0	2	10.00	0.00	f	f	1	1	2	17	f	f	f
27	2019-03-12 05:10:20.880049+00	2019-04-19 14:17:39.627943+00	\N	61325b39-17a6-4693-9a57-54b8c3ae5846	OnSite	999	0	1	10.00	0.00	f	f	1	1	3	33	f	f	f
21	2019-03-12 05:07:17.377613+00	2019-04-19 14:22:01.488836+00	\N	ad2db21a-367b-46e8-bd17-bbbe056ed4a4	OnSite	999	0	2	10.00	0.00	f	f	1	1	2	27	f	f	f
24	2019-03-12 05:09:13.194501+00	2019-04-19 14:22:01.498495+00	\N	8ada654c-c9d4-4fa7-b954-c82f45a3ed23	OnSite	999	0	1	10.00	0.00	f	f	1	1	3	30	f	f	f
22	2019-03-12 05:08:09.402144+00	2019-04-24 09:13:47.911632+00	\N	585a48f8-f6e5-4a59-958a-a24aae0a24c7	OnSite	998	0	2	10.00	0.00	f	f	1	1	2	28	f	f	f
28	2019-03-12 05:10:41.312714+00	2019-04-24 09:13:47.922067+00	\N	3127a664-3d30-4555-996a-27dd55c33ae4	OnSite	998	0	1	10.00	0.00	f	f	1	1	3	34	f	f	f
23	2019-03-12 05:08:43.085682+00	2019-04-24 09:13:47.940906+00	\N	0a068a21-dcd6-4ab4-ad70-663b845d979c	OnSite	998	0	1	10.00	0.00	f	f	1	1	3	29	f	f	f
1	2019-03-12 04:53:59.57285+00	2019-04-24 09:13:47.951324+00	\N	59e40511-f806-43d3-a428-139ec01b6a16	Both	994	0	1	10.00	0.00	f	f	1	1	1	8	f	f	f
\.


--
-- Data for Name: events_eventitem_transportation_pickup_locations; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventitem_transportation_pickup_locations (id, eventitem_id, transportationpickuplocation_id) FROM stdin;
\.


--
-- Data for Name: events_eventitemcart; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventitemcart (id, created_at, updated_at, deleted_at, uuid, quantity, event_id, event_attendee_id,
                                  event_item_id, event_registration_type_id, item_master_id, ordered_by_attendee_id,
                                  ordered_by_user_id, user_id, rate, is_coupon_item, coupon_id, transportation_info_id,
                                  transaction_type, amount, canceled_ordered_item_id, discount, amount_net,
                                  amount_final, amount_taxable, item_sc, item_tax, entry_from_ordered_item) FROM stdin;
1	2019-03-12 06:04:08.995153+00	2019-03-12 06:04:08.995182+00	\N	6886314b-b047-49e1-82e3-8e58becca206	1	1	10	1	1	8	10	10	10	504.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
2	2019-03-12 06:04:09.01622+00	2019-03-12 06:04:09.016234+00	\N	26c7b6b0-914f-4c4e-b745-31bb9539fe6c	1	1	11	1	1	8	10	10	11	504.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
3	2019-03-12 06:04:38.885312+00	2019-03-12 06:04:38.885335+00	\N	df554899-3a6e-42f0-b746-24fb763d99e9	1	1	10	22	1	28	10	10	10	2970.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
4	2019-03-12 06:04:55.286201+00	2019-03-12 06:04:55.286222+00	\N	03b8d0ce-6e00-44bc-b093-07e43dc3045c	1	1	11	28	1	34	10	10	11	54.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
5	2019-03-12 06:04:55.299358+00	2019-03-12 06:04:55.299375+00	\N	b4fa6e26-3228-4ddd-8533-79e0e103815e	1	1	11	27	1	33	10	10	11	261.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
6	2019-03-12 06:04:55.321864+00	2019-03-12 06:04:55.321879+00	\N	6fdd1ab4-c670-44fa-9a55-d8c9062ee022	1	1	11	26	1	32	10	10	11	315.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
7	2019-03-12 06:04:55.334432+00	2019-03-12 06:04:55.334448+00	\N	92f164da-cb3d-4bae-b39e-2ce75a9dd301	1	1	10	27	1	33	10	10	10	261.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
8	2019-03-12 06:04:55.352422+00	2019-03-12 06:04:55.352439+00	\N	6361d2d1-2668-4af5-88d3-7368c1de5940	1	1	10	26	1	32	10	10	10	315.00	f	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
9	2019-03-12 06:10:45.43336+00	2019-03-12 06:10:45.433385+00	\N	80a874e7-8030-4d84-860a-05c3cfe0f83b	1	1	10	\N	1	6	10	10	10	-5184.00	t	\N	\N	Sale	0.00	\N	0.00	0.00	0.00	0.00	0.00	0.00	f
25	2019-04-24 09:11:48.424891+00	2019-04-24 09:12:32.278934+00	\N	325173aa-bc1f-4758-a7f2-e79688757a26	1	1	16	22	1	28	16	17	17	3300.00	f	\N	\N	Sale	3300.00	\N	0.00	3300.00	3300.00	3300.00	0.00	0.00	f
26	2019-04-24 09:12:30.19271+00	2019-04-24 09:12:32.282431+00	\N	0c644e99-9e70-4bc0-b9bc-1c6d854b5cd2	1	1	16	28	1	34	16	17	17	60.00	f	\N	\N	Sale	60.00	\N	0.00	60.00	60.00	60.00	0.00	0.00	f
24	2019-04-24 09:10:52.031666+00	2019-04-24 09:12:32.285593+00	\N	792d6c22-a726-4fb8-a680-cdee8ffb6292	1	1	17	1	1	8	16	17	18	560.00	f	\N	\N	Sale	560.00	\N	0.00	560.00	560.00	560.00	0.00	0.00	f
23	2019-04-24 09:10:52.00563+00	2019-04-24 09:12:32.288749+00	\N	d723c38f-ca97-4a1d-b8bd-02f1e2bca3da	1	1	16	1	1	8	16	17	17	560.00	f	\N	\N	Sale	560.00	\N	0.00	560.00	560.00	560.00	0.00	0.00	f
27	2019-04-24 09:12:30.201284+00	2019-04-24 09:12:32.291963+00	\N	dd3f9459-bc48-4ace-9b5b-2350537a7be6	1	1	16	23	1	29	16	17	17	140.00	f	\N	\N	Sale	140.00	\N	0.00	140.00	140.00	140.00	0.00	0.00	f
21	2019-04-19 14:21:02.129925+00	2019-04-19 14:21:02.12995+00	\N	d775ac51-7572-4f5f-a04e-9b58b917377b	1	1	12	28	1	34	12	13	13	-60.00	f	\N	\N	Cancel	-60.00	6	0.00	-60.00	-60.00	-60.00	0.00	0.00	f
22	2019-04-19 14:21:02.146242+00	2019-04-19 14:21:02.146264+00	\N	861c9556-391d-4e94-8039-72046354bf82	1	1	12	27	1	33	12	13	13	-290.00	f	\N	\N	Cancel	-290.00	5	0.00	-290.00	-290.00	-290.00	0.00	0.00	f
10	2019-04-19 14:13:36.950583+00	2019-04-19 14:21:08.788843+00	\N	77004aa2-c1bc-432c-a089-91ada3eeacce	1	1	12	1	1	8	12	13	13	560.00	f	\N	\N	Sale	560.00	\N	0.00	560.00	560.00	560.00	0.00	0.00	f
11	2019-04-19 14:13:36.970457+00	2019-04-19 14:21:08.792343+00	\N	994725ff-80fb-4267-be87-adb173d204cf	1	1	13	1	1	8	12	13	14	560.00	f	\N	\N	Sale	560.00	\N	0.00	560.00	560.00	560.00	0.00	0.00	f
17	2019-04-19 14:18:51.617283+00	2019-04-19 14:21:08.795433+00	\N	bdcddd49-78c4-4d51-8abd-7e5e9049a5ca	1	1	12	21	1	27	12	13	13	3300.00	f	\N	\N	Sale	3300.00	\N	0.00	3300.00	3300.00	3300.00	0.00	0.00	f
19	2019-04-19 14:19:14.069691+00	2019-04-19 14:21:08.798667+00	\N	511d7e81-e486-4335-aa27-8a333186754a	1	1	13	24	1	30	12	13	14	80.00	f	\N	\N	Sale	80.00	\N	0.00	80.00	80.00	80.00	0.00	0.00	f
20	2019-04-19 14:19:14.083466+00	2019-04-19 14:21:08.801812+00	\N	b10f8dde-cf8f-4091-90b4-1bf9b4e8e6cf	1	1	13	23	1	29	12	13	14	140.00	f	\N	\N	Sale	140.00	\N	0.00	140.00	140.00	140.00	0.00	0.00	f
\.


--
-- Data for Name: events_eventitemgroup; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventitemgroup (id, created_at, updated_at, deleted_at, uuid, name, slug, description,
                                   is_multi_select, icon_type, event_id, event_registration_type_id) FROM stdin;
1	2019-03-12 04:51:35.057294+00	2019-03-12 04:51:35.057343+00	\N	ad940271-ac43-4c91-b9e9-0d4de24a2365	Registration	Registration		f		1	1
2	2019-03-12 04:51:35.077897+00	2019-03-12 04:51:35.077915+00	\N	bc6886c2-c4ff-4e44-927d-3933c3b9e375	Accommodation	Accommodation		f		1	1
3	2019-03-12 04:51:35.087955+00	2019-03-12 04:51:35.087973+00	\N	ee0c567a-8b55-4148-9a85-6f710e0ed8f9	Transportation	Transportation		t		1	1
\.


--
-- Data for Name: events_eventregistrationtype; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventregistrationtype (id, created_at, updated_at, deleted_at, uuid, name, total_capacity,
                                          is_published, status, required_otp, is_public, event_id) FROM stdin;
1	2019-03-12 04:51:35.006625+00	2019-03-12 04:51:35.006645+00	\N	38c7363e-7da4-40c9-804d-e86bfd1c1547	PUBLIC	0	f	Testing	f	t	1
\.


--
-- Data for Name: events_eventtype; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_eventtype (id, created_at, updated_at, deleted_at, uuid, name, description) FROM stdin;
1	2019-03-12 04:50:13.313845+00	2019-03-12 04:50:13.318994+00	\N	5529ce6e-f715-4151-91f7-58de4ce05ae4	Philosophy	Philosophy
\.


--
-- Data for Name: events_images; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_images (id, created_at, updated_at, deleted_at, title, image) FROM stdin;
\.


--
-- Data for Name: events_organizer; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_organizer (id, created_at, updated_at, deleted_at, uuid, name, location, description) FROM stdin;
1	2019-03-12 04:51:22.60968+00	2019-03-12 04:51:22.609739+00	\N	a1c0d098-075a-4707-9ca4-b3d654f0ce53	Amaroo	Australia, Ivory	amaroo
\.


--
-- Data for Name: events_organizer_logo; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_organizer_logo (id, organizer_id, images_id) FROM stdin;
\.


--
-- Data for Name: events_phonenumber; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_phonenumber (id, created_at, updated_at, deleted_at, is_visible, phone_number, country, label,
                                event_id, organizer_id) FROM stdin;
\.


--
-- Data for Name: events_transportationinfo; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_transportationinfo (id, created_at, updated_at, deleted_at, uuid, arrival_datetime,
                                       departure_datetime, pickup_location_id) FROM stdin;
\.


--
-- Data for Name: events_transportationpickuplocation; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.events_transportationpickuplocation (id, created_at, updated_at, deleted_at, uuid, location, description,
                                                 latitude, longitude, event_id, event_item_id) FROM stdin;
\.


--
-- Data for Name: items_coupon; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_coupon (id, created_at, updated_at, deleted_at, uuid, coupon_code, amount_limit, type, item_master_id,
                          user_id, amount_used, created_by_id, notes, status, updated_by_id) FROM stdin;
1	2019-03-12 06:06:00.253833+00	2019-03-12 06:10:45.439957+00	\N	0da47237-8f9f-4697-ac3a-427b35ec5348	21A22523033F	5184.00	Credit-Coupon	\N	\N	0.00	\N		t	\N
\.


--
-- Data for Name: items_itemcategory; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_itemcategory (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-03-11 08:12:47.088814+00	2019-03-11 08:12:47.088832+00	\N	3b16ffca-c0db-4afa-8b48-f02bfd669e01	Receipt
2	2019-03-11 08:12:47.091024+00	2019-03-11 08:12:47.091041+00	\N	13e58741-4ddb-45b9-bc94-c3dc7f17ceb9	Refund
3	2019-03-11 08:12:47.093126+00	2019-03-11 08:12:47.093149+00	\N	8ad73250-8c26-4f77-93e1-89357e31b6db	Coupon
4	2019-03-12 04:20:40.85139+00	2019-03-12 04:20:40.851421+00	\N	f59c8948-935b-4e54-b9b4-4c730024bda8	Test
5	2019-04-19 14:16:00.812156+00	2019-04-19 14:16:00.812181+00	\N	be699510-6797-49c3-a2cd-41fc416f6108	Service Charge
6	2019-04-19 14:16:00.814865+00	2019-04-19 14:16:00.814885+00	\N	83f4e9ed-9365-46ad-aed9-99f40cc6ab09	Applicable Tax
7	2019-04-19 14:16:00.816415+00	2019-04-19 14:16:00.816436+00	\N	acc74ac5-3de6-46c8-a20f-9534243de00b	Balance
\.


--
-- Data for Name: items_itemmaster; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_itemmaster (id, created_at, updated_at, deleted_at, uuid, name, options, item_for_booking,
                              item_for_sale, item_for_purchase, item_for_stock, item_for_rent, item_for_package,
                              item_has_substitute, item_is_veg, item_is_non_veg, item_is_liquor, item_is_reward,
                              item_is_discount, item_is_service_charge, item_is_tax, senior_citizen_discount_per,
                              ask_for_delivery, item_rate, item_sc_per, item_tax_per, item_mrp, is_public, status,
                              item_in_stock, item_rate_deposits, has_addon_items, description, category_id, process_id,
                              service_id, uom_id, is_coupon_item, item_is_balance_topup,
                              item_is_balance_used) FROM stdin;
1	2019-03-11 08:12:47.135289+00	2019-03-11 08:12:47.135309+00	\N	4019aeee-bea2-4508-a908-9ebfbd2df8e4	Bank-Payment	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	1	1	1	1	f	f	f
2	2019-03-11 08:12:47.146825+00	2019-03-11 08:12:47.146843+00	\N	1bb26ca3-348b-4313-a768-b0a0c54d56ae	Cash-Payment	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	1	1	1	1	f	f	f
3	2019-03-11 08:12:47.151092+00	2019-03-11 08:12:47.151112+00	\N	118092dc-40f9-48e6-8c04-82d6d6cdb2b6	Credit-Card-Payment	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	1	1	1	1	f	f	f
4	2019-03-11 08:12:47.155455+00	2019-03-11 08:12:47.155475+00	\N	b5ab87cd-3940-4418-ba78-c007147d9756	Refund	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	2	1	2	1	f	f	f
5	2019-03-11 08:12:47.159917+00	2019-03-11 08:12:47.159936+00	\N	3b0ec1a0-2b5d-4fdf-9b2a-30d9f0c4c440	Discount-Coupon	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	3	1	3	1	t	f	f
6	2019-03-11 08:12:47.164198+00	2019-03-11 08:12:47.164217+00	\N	2c3e54df-0edc-4def-8850-60b964b93489	Credit-Coupon	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	3	1	3	1	t	f	f
7	2019-03-11 08:12:47.168623+00	2019-03-11 08:12:47.16864+00	\N	acd9c097-e9aa-43da-9cd2-06ce471642c7	Debit-Coupon	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	3	1	3	1	t	f	f
8	2019-03-12 04:21:33.581018+00	2019-03-12 04:21:33.581043+00	\N	64c2c156-6328-4a3a-b0bf-3da12f55a5bf	Conference Fee (5 days)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	560.00	0.00	0.00	560.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
9	2019-03-12 04:21:33.58715+00	2019-03-12 04:21:33.587167+00	\N	0fe29e9e-c152-403a-9503-3b6b8c672cce	Day pass -first day )	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
10	2019-03-12 04:21:33.592403+00	2019-03-12 04:21:33.592422+00	\N	52bb8f34-f9cd-44b4-b571-ef174bd5d4e1	Day pass -second day )	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
11	2019-03-12 04:21:33.596703+00	2019-03-12 04:21:33.596721+00	\N	a1874459-ee67-4d86-b65d-f1341a2f754b	Day pass -third day )	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
12	2019-03-12 04:21:33.600764+00	2019-03-12 04:21:33.600781+00	\N	43f849a7-71e1-42f0-9fc6-65b7f248ce1f	Day pass -fourth day )	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
13	2019-03-12 04:21:33.605108+00	2019-03-12 04:21:33.605126+00	\N	5130d762-1718-4912-a09d-f840bc9a175b	Day pass -fifth day )	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
14	2019-03-12 04:21:33.610092+00	2019-03-12 04:21:33.610111+00	\N	8744e369-17d8-4afc-a6c0-5733ae88d6c2	SC - Pioneer Tent Single (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	1570.00	0.00	0.00	1570.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
15	2019-03-12 04:21:33.614317+00	2019-03-12 04:21:33.614334+00	\N	661aaede-459f-490f-af3d-306c773dc790	SC - Pioneer Tent Twin. For two people (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	1760.00	0.00	0.00	1760.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
16	2019-03-12 04:21:33.618333+00	2019-03-12 04:21:33.618351+00	\N	8e00b6b3-f290-443a-a143-4119c9a059b6	SC – Motorhome Space Single. One Person (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	1350.00	0.00	0.00	1350.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
17	2019-03-12 04:21:33.624468+00	2019-03-12 04:21:33.624485+00	\N	9ea0cc5d-7021-4725-a0ea-b2a8e9663c33	SC – Motorhome Space. Two People (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	2450.00	0.00	0.00	2450.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
18	2019-03-12 04:21:33.62843+00	2019-03-12 04:21:33.628448+00	\N	17169db7-6566-4305-ae61-33dbceb6bf65	SC – Motorhome Space. Three People (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	3550.00	0.00	0.00	3550.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
19	2019-03-12 04:21:33.632604+00	2019-03-12 04:21:33.632623+00	\N	f19bfd00-7dc2-49c3-83c4-9e915fcbe0ed	SC – Yellow/ Green Bunkhouse Single (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	2400.00	0.00	0.00	2400.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
20	2019-03-12 04:21:33.636741+00	2019-03-12 04:21:33.636759+00	\N	40bf67b5-4812-40fd-a607-d1d093aa8a0f	SC – Yellow/ Green Bunkhouse Twin. Two people (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	3600.00	0.00	0.00	3600.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
21	2019-03-12 04:21:33.640769+00	2019-03-12 04:21:33.640788+00	\N	b5807798-4a48-46d2-96ee-10ce28433b90	SC - Swagman BYO tent single. One person (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	300.00	0.00	0.00	300.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
22	2019-03-12 04:21:33.64489+00	2019-03-12 04:21:33.644908+00	\N	64f4f22b-e5f4-47a3-9135-a4e4f5e8a4a1	SC - Swagman BYO tent. Two People (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	600.00	0.00	0.00	600.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
23	2019-03-12 04:21:33.648736+00	2019-03-12 04:21:33.648753+00	\N	65e472b1-d79e-46b8-8989-1b7539f159fa	SC - Swagman BYO tent. Three People (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	900.00	0.00	0.00	900.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
24	2019-03-12 04:21:33.652647+00	2019-03-12 04:21:33.652664+00	\N	51e89bdf-771f-4f15-ab2c-658cb01c7172	Swagman BYO tent. Four People (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	1200.00	0.00	0.00	1200.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
25	2019-03-12 04:21:33.657286+00	2019-03-12 04:21:33.657304+00	\N	d86f8990-8c8f-41d6-a345-b9e7a89962d8	SC – Orange Cabin single w/ Ensuite (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	3100.00	0.00	0.00	3100.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
26	2019-03-12 04:21:33.661147+00	2019-03-12 04:21:33.661165+00	\N	0ec6b08e-b8f9-41b9-858e-9506c297b024	JAC- Deluxe Tent Single (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	2980.00	0.00	0.00	2980.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
27	2019-03-12 04:21:33.665086+00	2019-03-12 04:21:33.665104+00	\N	c91d56ef-b82a-4793-a750-deb887b0e3a6	JAC - Deluxe Tent Double. Two People (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	3300.00	0.00	0.00	3300.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
28	2019-03-12 04:21:33.669158+00	2019-03-12 04:21:33.669175+00	\N	195671af-7135-45e3-b9f3-58888311de43	JAC- Deluxe Tent Twin. Two People (7 nights)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	3300.00	0.00	0.00	3300.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
29	2019-03-12 04:21:33.673284+00	2019-03-12 04:21:33.673316+00	\N	1b4e26cb-a403-4868-89ef-eaf1a730f4b2	Line 1: Brisbane Airport– Amaroo – Brisbane Airport (2 trips)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	140.00	0.00	0.00	140.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
30	2019-03-12 04:21:33.677199+00	2019-03-12 04:21:33.677216+00	\N	d34206ac-9450-4be9-95da-fa77e9a21096	Line 2: Brisbane Airport to Amaroo – (one way, Day 8th Sep or Day 9th Sep)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	80.00	0.00	0.00	80.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
31	2019-03-12 04:21:33.681031+00	2019-03-12 04:21:33.681048+00	\N	a17e911a-fb4e-4831-8bb9-655e69312305	Line 3: Amaroo to Brisbane Airport– (one way, Day 15th Sep).	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	80.00	0.00	0.00	80.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
32	2019-03-12 04:21:33.685194+00	2019-03-12 04:21:33.685225+00	\N	6f807eab-5f92-4fcb-9134-83a677dd04d5	Line 4: Brisbane Sheraton Hotel – Amaroo – Brisbane Sheraton Hotel (10 trips)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	350.00	0.00	0.00	350.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
33	2019-03-12 04:21:33.68913+00	2019-03-12 04:21:33.689147+00	\N	e69b1673-8ee1-4173-b26b-2105e912e53d	Line 5: Ipswich Pick up points – Amaroo reception– Ipswich (10 trips)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	290.00	0.00	0.00	290.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
34	2019-03-12 04:21:33.693095+00	2019-03-12 04:21:33.693113+00	\N	b93df2fc-6631-4757-b668-88ded0da6602	Line 6: Onsite Pavilion - Amphitheatre – Onsite Pavilion. (10 trips)	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	60.00	0.00	0.00	60.00	t	t	1000	0.00	f	Created Item Masters	4	1	4	1	f	f	f
35	2019-04-19 14:16:00.885744+00	2019-04-19 14:16:00.885771+00	\N	3aa35e38-77bd-46cd-a210-68acf9c1c02d	Total-Applicable-Service-Charge	\N	f	t	f	t	f	f	f	f	f	f	f	f	t	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	5	1	6	1	f	f	f
36	2019-04-19 14:16:00.890858+00	2019-04-19 14:16:00.890877+00	\N	f100f195-aa61-4ecc-9238-c7b166fdd04a	Total-Canceled-Service-Charge	\N	f	t	f	t	f	f	f	f	f	f	f	f	t	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	5	1	6	1	f	f	f
37	2019-04-19 14:16:00.893383+00	2019-04-19 14:16:00.893402+00	\N	cd8d3721-06f8-4b55-94d6-ed43e4be57fe	Total-Applicable-Tax	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	t	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	6	1	5	1	f	f	f
38	2019-04-19 14:16:00.895873+00	2019-04-19 14:16:00.895892+00	\N	bb287978-90b8-4f94-9f2f-14c33724172c	Total-Canceled-Tax	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	t	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	6	1	5	1	f	f	f
39	2019-04-19 14:16:00.898442+00	2019-04-19 14:16:00.898461+00	\N	66b945e9-3645-427d-88f6-69c9e8cd4c5b	Balance-TopUp	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	7	1	7	1	f	t	f
40	2019-04-19 14:16:00.900991+00	2019-04-19 14:16:00.90101+00	\N	8ce15bc5-8cb8-49d0-802a-eed12b0553a7	Balance-Used	\N	f	t	f	t	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	1	0.00	f	Default Created Item Masters	7	1	7	1	f	f	t
\.


--
-- Data for Name: items_itemprocessmaster; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_itemprocessmaster (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-03-11 08:12:47.103427+00	2019-03-11 08:12:47.103445+00	\N	d4f4c432-7acf-4cb3-b7b2-0ee10a17c75b	GEN
\.


--
-- Data for Name: items_itemservice; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_itemservice (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-03-11 08:12:47.096113+00	2019-03-11 08:12:47.096132+00	\N	4cdccd5d-4acb-41d7-b247-86b5fc5faa02	Receipt
2	2019-03-11 08:12:47.098432+00	2019-03-11 08:12:47.098449+00	\N	a3e94d62-cc3d-4075-8422-b6ed49fba504	Refund
3	2019-03-11 08:12:47.100443+00	2019-03-11 08:12:47.10046+00	\N	7b87a992-c1c1-4f6e-b45d-fc52ffbe2da1	Coupon
4	2019-03-12 04:20:53.483222+00	2019-03-12 04:20:53.483255+00	\N	acc172f4-2ad9-4aab-8902-c404c026d307	Test
5	2019-04-19 14:16:00.822062+00	2019-04-19 14:16:00.822082+00	\N	216f68a7-adde-4c56-9cb6-512649b2c91a	Applicable Tax
6	2019-04-19 14:16:00.824092+00	2019-04-19 14:16:00.824123+00	\N	1503591b-82df-4e18-8c41-ac8347595d68	Service Charge
7	2019-04-19 14:16:00.825726+00	2019-04-19 14:16:00.825749+00	\N	6c1ed52d-0f1e-452a-a8f2-6f11a91735a8	Balance
\.


--
-- Data for Name: items_order; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_order (id, created_at, updated_at, deleted_at, uuid, order_number, order_cfy, transaction_type,
                         balance, device_id, web_initiated, app_initiated, one_time_password, notes, delivery_access,
                         order_status, event_attendee_id, operator_id, event_id, user_id, previous_order_id,
                         balance_credit, event_registration_type_id) FROM stdin;
1	2019-04-19 14:17:39.570171+00	2019-04-19 14:17:39.641206+00	\N	217ff44e-7849-4705-b08f-a410a868e722	1	2019	e-registration	0.00		f	f				Approved	12	\N	1	13	\N	0.00	\N
2	2019-04-19 14:22:01.435032+00	2019-04-19 14:22:01.51535+00	\N	d73a2a69-8fb3-46c8-9adf-2a7910b92b97	2	2019	e-registration	0.00		f	f				Approved	12	\N	1	13	1	0.00	\N
3	2019-04-24 09:13:47.864885+00	2019-04-24 09:13:47.954427+00	\N	e4550afb-0a64-4722-a0a6-d8ae4746f19c	3	2019	e-registration	0.00		f	f				Approved	16	\N	1	17	\N	0.00	\N
\.


--
-- Data for Name: items_order_order_items; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_order_order_items (id, order_id, ordereditem_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	2	7
8	2	8
9	2	9
10	2	10
11	2	11
12	2	12
13	2	13
14	2	14
15	3	15
16	3	16
17	3	17
18	3	18
19	3	19
20	3	20
\.


--
-- Data for Name: items_ordercfyandordernumbertracker; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_ordercfyandordernumbertracker (id, created_at, updated_at, deleted_at, latest_order_number,
                                                 latest_order_cfy) FROM stdin;
1	2019-04-19 14:17:39.568191+00	2019-04-24 09:13:47.86356+00	\N	3	2019
\.


--
-- Data for Name: items_ordereditem; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_ordereditem (id, created_at, updated_at, deleted_at, uuid, order_number, order_cfy, transaction_type,
                               transaction_reference_id, privileged, quantity, rate, amount, discount, amount_net,
                               item_sc, amount_taxable, item_tax, amount_final, actual_item_master_id, item_master_id,
                               parent_order_id, user_id, event_attendee_id, transportation_info_id, event_item_id,
                               canceled_ordered_item_id, coupon_id, is_coupon_item, notes) FROM stdin;
1	2019-04-19 14:17:39.574697+00	2019-04-19 14:17:39.574715+00	\N	4c115b50-d3df-4ffb-a91c-85f909caf14c	1	2019	Receipt	ch_1EQxX52eZvKYlo2CoXUUKYkM	f	1	-4770.00	-4770.00	0.00	-4770.00	0.00	-4770.00	0.00	-4770.00	\N	3	\N	13	\N	\N	\N	\N	\N	f	
2	2019-04-19 14:17:39.596777+00	2019-04-19 14:17:39.596797+00	\N	868cb9de-194e-40d4-9392-e859fff6beec	1	2019	Sale		f	1	560.00	560.00	0.00	560.00	0.00	560.00	0.00	560.00	\N	8	\N	13	12	\N	1	\N	\N	f	
3	2019-04-19 14:17:39.607358+00	2019-04-19 14:17:39.607375+00	\N	bbd7e2f4-a01d-4905-9376-5fda13dbac9c	1	2019	Sale		f	1	560.00	560.00	0.00	560.00	0.00	560.00	0.00	560.00	\N	8	\N	14	13	\N	1	\N	\N	f	
4	2019-04-19 14:17:39.617491+00	2019-04-19 14:17:39.61752+00	\N	f0a03ec3-a685-4b30-9458-3364fae450ee	1	2019	Sale		f	1	3300.00	3300.00	0.00	3300.00	0.00	3300.00	0.00	3300.00	\N	28	\N	13	12	\N	22	\N	\N	f	
5	2019-04-19 14:17:39.627184+00	2019-04-19 14:17:39.627203+00	\N	c65c1931-0cd2-4037-a670-872a386bade7	1	2019	Sale		f	1	290.00	290.00	0.00	290.00	0.00	290.00	0.00	290.00	\N	33	\N	13	12	\N	27	\N	\N	f	
6	2019-04-19 14:17:39.636534+00	2019-04-19 14:17:39.636552+00	\N	45baac96-b250-4773-92cd-e0955d7f05e9	1	2019	Sale		f	1	60.00	60.00	0.00	60.00	0.00	60.00	0.00	60.00	\N	34	\N	13	12	\N	28	\N	\N	f	
7	2019-04-19 14:22:01.438169+00	2019-04-19 14:22:01.438187+00	\N	2393b5e4-c0b3-4391-9beb-42630abade74	2	2019	Receipt	ch_1EQxbI2eZvKYlo2CWQNtXbPM	f	1	-4290.00	-4290.00	0.00	-4290.00	0.00	-4290.00	0.00	-4290.00	\N	3	\N	13	\N	\N	\N	\N	\N	f	
8	2019-04-19 14:22:01.450928+00	2019-04-19 14:22:01.450947+00	\N	fe6dc2cc-d896-46b1-8e35-eddb092c91b8	2	2019	Cancel		f	1	-60.00	-60.00	0.00	-60.00	0.00	-60.00	0.00	-60.00	\N	34	\N	13	12	\N	28	6	\N	f	
9	2019-04-19 14:22:01.460508+00	2019-04-19 14:22:01.460528+00	\N	76f91d31-4675-45bf-9862-1b206657f436	2	2019	Cancel		f	1	-290.00	-290.00	0.00	-290.00	0.00	-290.00	0.00	-290.00	\N	33	\N	13	12	\N	27	5	\N	f	
10	2019-04-19 14:22:01.469031+00	2019-04-19 14:22:01.469049+00	\N	59757793-3d5a-4d32-93a5-d091ac743354	2	2019	Sale		f	1	560.00	560.00	0.00	560.00	0.00	560.00	0.00	560.00	\N	8	\N	13	12	\N	1	\N	\N	f	
11	2019-04-19 14:22:01.478731+00	2019-04-19 14:22:01.478749+00	\N	7c4c1a3c-3dd9-4ffc-915e-3bf4655bacc3	2	2019	Sale		f	1	560.00	560.00	0.00	560.00	0.00	560.00	0.00	560.00	\N	8	\N	14	13	\N	1	\N	\N	f	
12	2019-04-19 14:22:01.488086+00	2019-04-19 14:22:01.488105+00	\N	06a9a430-51a0-4806-81b7-5445fcd52bf9	2	2019	Sale		f	1	3300.00	3300.00	0.00	3300.00	0.00	3300.00	0.00	3300.00	\N	27	\N	13	12	\N	21	\N	\N	f	
13	2019-04-19 14:22:01.497751+00	2019-04-19 14:22:01.497772+00	\N	84cb7b48-01db-4c50-9095-ade1f0a80626	2	2019	Sale		f	1	80.00	80.00	0.00	80.00	0.00	80.00	0.00	80.00	\N	30	\N	14	13	\N	24	\N	\N	f	
14	2019-04-19 14:22:01.507305+00	2019-04-19 14:22:01.507322+00	\N	9d13350e-aed3-48dd-b7bf-ec2455f80727	2	2019	Sale		f	1	140.00	140.00	0.00	140.00	0.00	140.00	0.00	140.00	\N	29	\N	14	13	\N	23	\N	\N	f	
15	2019-04-24 09:13:47.878916+00	2019-04-24 09:13:47.878933+00	\N	aad3b59b-486a-4f03-bf6d-2125677655c2	3	2019	Receipt	ch_1EShAl2eZvKYlo2Cp05DZoLt	f	1	-4620.00	-4620.00	0.00	-4620.00	0.00	-4620.00	0.00	-4620.00	\N	3	\N	17	\N	\N	\N	\N	\N	f	
16	2019-04-24 09:13:47.910822+00	2019-04-24 09:13:47.91084+00	\N	8498d300-e7f6-4b0c-8506-620883d00c3e	3	2019	Sale		f	1	3300.00	3300.00	0.00	3300.00	0.00	3300.00	0.00	3300.00	\N	28	\N	17	16	\N	22	\N	\N	f	
17	2019-04-24 09:13:47.921341+00	2019-04-24 09:13:47.921359+00	\N	45129088-3c20-4414-a8a3-c62cc1b2845d	3	2019	Sale		f	1	60.00	60.00	0.00	60.00	0.00	60.00	0.00	60.00	\N	34	\N	17	16	\N	28	\N	\N	f	
18	2019-04-24 09:13:47.930683+00	2019-04-24 09:13:47.930701+00	\N	69ccaebd-698a-4300-af27-ca49a6fd1a15	3	2019	Sale		f	1	560.00	560.00	0.00	560.00	0.00	560.00	0.00	560.00	\N	8	\N	17	16	\N	1	\N	\N	f	
19	2019-04-24 09:13:47.940128+00	2019-04-24 09:13:47.940147+00	\N	9189ad76-659d-4538-95ee-3a83a90257d2	3	2019	Sale		f	1	140.00	140.00	0.00	140.00	0.00	140.00	0.00	140.00	\N	29	\N	17	16	\N	23	\N	\N	f	
20	2019-04-24 09:13:47.950192+00	2019-04-24 09:13:47.950209+00	\N	857b040d-faf3-414f-adbf-6e940d95b424	3	2019	Sale		f	1	560.00	560.00	0.00	560.00	0.00	560.00	0.00	560.00	\N	8	\N	18	17	\N	1	\N	\N	f	
\.


--
-- Data for Name: items_unitofmeasurement; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.items_unitofmeasurement (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-03-11 08:12:47.106617+00	2019-03-11 08:12:47.106635+00	\N	8f24550a-b604-4b06-8ff1-14ce4e93bd23	units
\.


--
-- Data for Name: users_user; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.users_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff,
                        is_active, date_joined, uuid, phone_number, city, country, profile_picture, gender) FROM stdin;
10		\N	f	8a644f84-b4ab-487c-96d9-b0820c858f94	Test	Test	Test@gmail.com	f	f	2019-03-12 06:04:08.972159+00	fd293b0c-10fd-4c08-8fb4-956a0b29a7e1	+977 984-5653912	aaaaa	AF		Not-Specified
11		\N	f	a2af014d-4bc5-4e82-8294-c4a647e9a027	test2	test2	c12c88b9-b2c1-4341-b5fb-345619adcd65@dummy.com	f	f	2019-03-12 06:04:08.975898+00	01b3fb75-44c9-444f-bf21-7985bb90e7ba	058c45ffdf65@ph	ktm	AX		Not-Specified
13		\N	f	a6597b9c-7081-4cbb-b1dd-138812ae0e4b	testing	testing		f	f	2019-04-19 14:10:06.540186+00	a9f4ff72-b1b2-4a77-bc3a-35f9256ad91e	+977 984-5634525	test	AL		Not-Specified
14		\N	f	d66d5946-d53b-45cd-8680-5960108ed194	testing2	testing2	a6e1421d-8bbd-41e1-bdde-c1226bfe9545@dummy.com	f	f	2019-04-19 14:13:36.917474+00	3a6085cb-d150-460e-b475-073f9990164e	+977 985-3535353	testing	AD		Not-Specified
17		\N	f	3f14dddb-6622-4142-a94c-d9712165f676	Hello	Hello	hello@gmail.com	f	f	2019-04-24 09:05:13.850575+00	ca54c8ae-ddb3-4de7-96e9-19079dbe4081	+977 984-5634245	ktm	HU		Not-Specified
18		\N	f	05570d4f-880d-411a-942e-4aadf4110e12	test	test	test@gmail.com	f	f	2019-04-24 09:10:51.977122+00	5ea13e63-b999-4531-8b3c-f3e9045d0b18	+977 984-5324242	ktm	AX		Not-Specified
\.


--
-- Data for Name: users_user_groups; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.users_user_groups (id, user_id, group_id) FROM stdin;
10	10	1
11	11	1
13	13	1
14	14	1
17	17	1
18	18	1
\.


--
-- Data for Name: users_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: club_erp_user
--

COPY public.users_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.account_emailaddress_id_seq', 1, false);


--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.account_emailconfirmation_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 108, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 36, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 104, true);


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- Name: events_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_configuration_id_seq', 11, true);


--
-- Name: events_event_description_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_event_description_images_id_seq', 1, false);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_event_id_seq', 1, true);


--
-- Name: events_event_title_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_event_title_images_id_seq', 1, false);


--
-- Name: events_eventattendee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventattendee_id_seq', 17, true);


--
-- Name: events_eventcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventcategory_id_seq', 1, true);


--
-- Name: events_eventitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventitem_id_seq', 28, true);


--
-- Name: events_eventitem_transportation_pickup_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventitem_transportation_pickup_locations_id_seq', 1, false);


--
-- Name: events_eventitemcart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventitemcart_id_seq', 27, true);


--
-- Name: events_eventitemgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventitemgroup_id_seq', 3, true);


--
-- Name: events_eventregistrationtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventregistrationtype_id_seq', 1, true);


--
-- Name: events_eventtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_eventtype_id_seq', 1, true);


--
-- Name: events_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_images_id_seq', 1, false);


--
-- Name: events_organizer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_organizer_id_seq', 1, true);


--
-- Name: events_organizer_logo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_organizer_logo_id_seq', 1, false);


--
-- Name: events_phonenumber_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_phonenumber_id_seq', 1, false);


--
-- Name: events_transportationinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_transportationinfo_id_seq', 1, false);


--
-- Name: events_transportationpickuplocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.events_transportationpickuplocation_id_seq', 1, false);


--
-- Name: items_coupon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_coupon_id_seq', 1, true);


--
-- Name: items_itemcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_itemcategory_id_seq', 7, true);


--
-- Name: items_itemmaster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_itemmaster_id_seq', 40, true);


--
-- Name: items_itemprocessmaster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_itemprocessmaster_id_seq', 1, true);


--
-- Name: items_itemservice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_itemservice_id_seq', 7, true);


--
-- Name: items_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_order_id_seq', 3, true);


--
-- Name: items_order_ordered_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_order_ordered_items_id_seq', 20, true);


--
-- Name: items_ordercfyandordernumbertracker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_ordercfyandordernumbertracker_id_seq', 1, true);


--
-- Name: items_ordereditem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_ordereditem_id_seq', 20, true);


--
-- Name: items_unitofmeasurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.items_unitofmeasurement_id_seq', 1, true);


--
-- Name: users_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.users_user_groups_id_seq', 18, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.users_user_id_seq', 18, true);


--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: club_erp_user
--

SELECT pg_catalog.setval('public.users_user_user_permissions_id_seq', 1, false);


--
-- Name: account_emailaddress account_emailaddress_email_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailaddress
  ADD CONSTRAINT account_emailaddress_email_key UNIQUE (email);


--
-- Name: account_emailaddress account_emailaddress_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailaddress
  ADD CONSTRAINT account_emailaddress_pkey PRIMARY KEY (id);


--
-- Name: account_emailconfirmation account_emailconfirmation_key_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailconfirmation
  ADD CONSTRAINT account_emailconfirmation_key_key UNIQUE (key);


--
-- Name: account_emailconfirmation account_emailconfirmation_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailconfirmation
  ADD CONSTRAINT account_emailconfirmation_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group
  ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group_permissions
  ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group_permissions
  ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group
  ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_permission
  ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_permission
  ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.authtoken_token
  ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.authtoken_token
  ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_admin_log
  ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_content_type
  ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_content_type
  ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_migrations
  ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_session
  ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_site
  ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_site
  ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: events_configuration events_configuration_key_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_configuration
  ADD CONSTRAINT events_configuration_key_key UNIQUE (key);


--
-- Name: events_configuration events_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_configuration
  ADD CONSTRAINT events_configuration_pkey PRIMARY KEY (id);


--
-- Name: events_event_description_images events_event_description_event_id_images_id_e06d0b33_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_description_images
  ADD CONSTRAINT events_event_description_event_id_images_id_e06d0b33_uniq UNIQUE (event_id, images_id);


--
-- Name: events_event_description_images events_event_description_images_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_description_images
  ADD CONSTRAINT events_event_description_images_pkey PRIMARY KEY (id);


--
-- Name: events_event events_event_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event
  ADD CONSTRAINT events_event_pkey PRIMARY KEY (id);


--
-- Name: events_event_title_images events_event_title_images_event_id_images_id_6c00599b_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_title_images
  ADD CONSTRAINT events_event_title_images_event_id_images_id_6c00599b_uniq UNIQUE (event_id, images_id);


--
-- Name: events_event_title_images events_event_title_images_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_title_images
  ADD CONSTRAINT events_event_title_images_pkey PRIMARY KEY (id);


--
-- Name: events_eventattendee events_eventattendee_event_id_user_id_da8d1711_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ADD CONSTRAINT events_eventattendee_event_id_user_id_da8d1711_uniq UNIQUE (event_id, user_id);


--
-- Name: events_eventattendee events_eventattendee_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ADD CONSTRAINT events_eventattendee_pkey PRIMARY KEY (id);


--
-- Name: events_eventattendee events_eventattendee_smart_card_number_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ADD CONSTRAINT events_eventattendee_smart_card_number_key UNIQUE (smart_card_number);


--
-- Name: events_eventcategory events_eventcategory_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventcategory
  ADD CONSTRAINT events_eventcategory_name_key UNIQUE (name);


--
-- Name: events_eventcategory events_eventcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventcategory
  ADD CONSTRAINT events_eventcategory_pkey PRIMARY KEY (id);


--
-- Name: events_eventitem events_eventitem_item_master_id_event_reg_8368f83e_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem
  ADD CONSTRAINT events_eventitem_item_master_id_event_reg_8368f83e_uniq UNIQUE (item_master_id, event_registration_type_id, event_id, group_type);


--
-- Name: events_eventitem events_eventitem_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem
  ADD CONSTRAINT events_eventitem_pkey PRIMARY KEY (id);


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_transpo_eventitem_id_transportat_39b277e4_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
  ADD CONSTRAINT events_eventitem_transpo_eventitem_id_transportat_39b277e4_uniq UNIQUE (eventitem_id, transportationpickuplocation_id);


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_transportation_pickup_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
  ADD CONSTRAINT events_eventitem_transportation_pickup_locations_pkey PRIMARY KEY (id);


--
-- Name: events_eventitemcart events_eventitemcart_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_pkey PRIMARY KEY (id);


--
-- Name: events_eventitemgroup events_eventitemgroup_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemgroup
  ADD CONSTRAINT events_eventitemgroup_name_key UNIQUE (name);


--
-- Name: events_eventitemgroup events_eventitemgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemgroup
  ADD CONSTRAINT events_eventitemgroup_pkey PRIMARY KEY (id);


--
-- Name: events_eventitemgroup events_eventitemgroup_slug_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemgroup
  ADD CONSTRAINT events_eventitemgroup_slug_key UNIQUE (slug);


--
-- Name: events_eventregistrationtype events_eventregistrationtype_name_event_id_ca2aa05d_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventregistrationtype
  ADD CONSTRAINT events_eventregistrationtype_name_event_id_ca2aa05d_uniq UNIQUE (name, event_id);


--
-- Name: events_eventregistrationtype events_eventregistrationtype_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventregistrationtype
  ADD CONSTRAINT events_eventregistrationtype_pkey PRIMARY KEY (id);


--
-- Name: events_eventtype events_eventtype_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventtype
  ADD CONSTRAINT events_eventtype_name_key UNIQUE (name);


--
-- Name: events_eventtype events_eventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventtype
  ADD CONSTRAINT events_eventtype_pkey PRIMARY KEY (id);


--
-- Name: events_images events_images_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_images
  ADD CONSTRAINT events_images_pkey PRIMARY KEY (id);


--
-- Name: events_organizer_logo events_organizer_logo_organizer_id_images_id_b680dffd_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_organizer_logo
  ADD CONSTRAINT events_organizer_logo_organizer_id_images_id_b680dffd_uniq UNIQUE (organizer_id, images_id);


--
-- Name: events_organizer_logo events_organizer_logo_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_organizer_logo
  ADD CONSTRAINT events_organizer_logo_pkey PRIMARY KEY (id);


--
-- Name: events_organizer events_organizer_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_organizer
  ADD CONSTRAINT events_organizer_pkey PRIMARY KEY (id);


--
-- Name: events_phonenumber events_phonenumber_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_phonenumber
  ADD CONSTRAINT events_phonenumber_pkey PRIMARY KEY (id);


--
-- Name: events_transportationinfo events_transportationinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_transportationinfo
  ADD CONSTRAINT events_transportationinfo_pkey PRIMARY KEY (id);


--
-- Name: events_transportationpickuplocation events_transportationpickuplocation_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_transportationpickuplocation
  ADD CONSTRAINT events_transportationpickuplocation_pkey PRIMARY KEY (id);


--
-- Name: items_coupon items_coupon_coupon_code_5030bd0f_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_coupon
  ADD CONSTRAINT items_coupon_coupon_code_5030bd0f_uniq UNIQUE (coupon_code);


--
-- Name: items_coupon items_coupon_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_coupon
  ADD CONSTRAINT items_coupon_pkey PRIMARY KEY (id);


--
-- Name: items_itemcategory items_itemcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemcategory
  ADD CONSTRAINT items_itemcategory_pkey PRIMARY KEY (id);


--
-- Name: items_itemmaster items_itemmaster_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemmaster
  ADD CONSTRAINT items_itemmaster_name_key UNIQUE (name);


--
-- Name: items_itemmaster items_itemmaster_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemmaster
  ADD CONSTRAINT items_itemmaster_pkey PRIMARY KEY (id);


--
-- Name: items_itemprocessmaster items_itemprocessmaster_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemprocessmaster
  ADD CONSTRAINT items_itemprocessmaster_name_key UNIQUE (name);


--
-- Name: items_itemprocessmaster items_itemprocessmaster_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemprocessmaster
  ADD CONSTRAINT items_itemprocessmaster_pkey PRIMARY KEY (id);


--
-- Name: items_itemservice items_itemservice_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemservice
  ADD CONSTRAINT items_itemservice_name_key UNIQUE (name);


--
-- Name: items_itemservice items_itemservice_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemservice
  ADD CONSTRAINT items_itemservice_pkey PRIMARY KEY (id);


--
-- Name: items_order_order_items items_order_ordered_items_order_id_ordereditem_id_60cec7f2_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order_order_items
  ADD CONSTRAINT items_order_ordered_items_order_id_ordereditem_id_60cec7f2_uniq UNIQUE (order_id, ordereditem_id);


--
-- Name: items_order_order_items items_order_ordered_items_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order_order_items
  ADD CONSTRAINT items_order_ordered_items_pkey PRIMARY KEY (id);


--
-- Name: items_order items_order_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_pkey PRIMARY KEY (id);


--
-- Name: items_order items_order_previous_order_id_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_previous_order_id_key UNIQUE (previous_order_id);


--
-- Name: items_ordercfyandordernumbertracker items_ordercfyandordernumbertracker_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordercfyandordernumbertracker
  ADD CONSTRAINT items_ordercfyandordernumbertracker_pkey PRIMARY KEY (id);


--
-- Name: items_ordereditem items_ordereditem_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_pkey PRIMARY KEY (id);


--
-- Name: items_unitofmeasurement items_unitofmeasurement_name_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_unitofmeasurement
  ADD CONSTRAINT items_unitofmeasurement_name_key UNIQUE (name);


--
-- Name: items_unitofmeasurement items_unitofmeasurement_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_unitofmeasurement
  ADD CONSTRAINT items_unitofmeasurement_pkey PRIMARY KEY (id);


--
-- Name: users_user_groups users_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_groups
  ADD CONSTRAINT users_user_groups_pkey PRIMARY KEY (id);


--
-- Name: users_user_groups users_user_groups_user_id_group_id_b88eab82_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_groups
  ADD CONSTRAINT users_user_groups_user_id_group_id_b88eab82_uniq UNIQUE (user_id, group_id);


--
-- Name: users_user users_user_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user
  ADD CONSTRAINT users_user_phone_number_key UNIQUE (phone_number);


--
-- Name: users_user users_user_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user
  ADD CONSTRAINT users_user_pkey PRIMARY KEY (id);


--
-- Name: users_user_user_permissions users_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_user_permissions
  ADD CONSTRAINT users_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: users_user_user_permissions users_user_user_permissions_user_id_permission_id_43338c45_uniq; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_user_permissions
  ADD CONSTRAINT users_user_user_permissions_user_id_permission_id_43338c45_uniq UNIQUE (user_id, permission_id);


--
-- Name: users_user users_user_username_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user
  ADD CONSTRAINT users_user_username_key UNIQUE (username);


--
-- Name: users_user users_user_uuid_key; Type: CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user
  ADD CONSTRAINT users_user_uuid_key UNIQUE (uuid);


--
-- Name: account_emailaddress_email_03be32b2_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX account_emailaddress_email_03be32b2_like ON public.account_emailaddress USING btree (email varchar_pattern_ops);


--
-- Name: account_emailaddress_user_id_2c513194; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX account_emailaddress_user_id_2c513194 ON public.account_emailaddress USING btree (user_id);


--
-- Name: account_emailconfirmation_email_address_id_5b7f8c58; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX account_emailconfirmation_email_address_id_5b7f8c58 ON public.account_emailconfirmation USING btree (email_address_id);


--
-- Name: account_emailconfirmation_key_f43612bd_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX account_emailconfirmation_key_f43612bd_like ON public.account_emailconfirmation USING btree (key varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- Name: events_configuration_key_5679fb06_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_configuration_key_5679fb06_like ON public.events_configuration USING btree (key varchar_pattern_ops);


--
-- Name: events_configuration_uuid_f1a7f95b; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_configuration_uuid_f1a7f95b ON public.events_configuration USING btree (uuid);


--
-- Name: events_event_category_id_01d3a3ab; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_category_id_01d3a3ab ON public.events_event USING btree (category_id);


--
-- Name: events_event_description_images_event_id_71121a0c; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_description_images_event_id_71121a0c ON public.events_event_description_images USING btree (event_id);


--
-- Name: events_event_description_images_images_id_d2988044; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_description_images_images_id_d2988044 ON public.events_event_description_images USING btree (images_id);


--
-- Name: events_event_organizer_id_3afa7809; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_organizer_id_3afa7809 ON public.events_event USING btree (organizer_id);


--
-- Name: events_event_title_images_event_id_7368d00e; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_title_images_event_id_7368d00e ON public.events_event_title_images USING btree (event_id);


--
-- Name: events_event_title_images_images_id_30d76ec5; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_title_images_images_id_30d76ec5 ON public.events_event_title_images USING btree (images_id);


--
-- Name: events_event_type_id_04a81abf; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_type_id_04a81abf ON public.events_event USING btree (type_id);


--
-- Name: events_event_uuid_995d6a76; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_event_uuid_995d6a76 ON public.events_event USING btree (uuid);


--
-- Name: events_eventattendee_event_id_33c2c3c3; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventattendee_event_id_33c2c3c3 ON public.events_eventattendee USING btree (event_id);


--
-- Name: events_eventattendee_event_registration_type_id_2832b659; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventattendee_event_registration_type_id_2832b659 ON public.events_eventattendee USING btree (event_registration_type_id);


--
-- Name: events_eventattendee_registered_by_id_bab87466; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventattendee_registered_by_id_bab87466 ON public.events_eventattendee USING btree (registered_by_id);


--
-- Name: events_eventattendee_smart_card_number_a6a6a168_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventattendee_smart_card_number_a6a6a168_like ON public.events_eventattendee USING btree (smart_card_number varchar_pattern_ops);


--
-- Name: events_eventattendee_user_id_c7184780; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventattendee_user_id_c7184780 ON public.events_eventattendee USING btree (user_id);


--
-- Name: events_eventattendee_uuid_9043a359; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventattendee_uuid_9043a359 ON public.events_eventattendee USING btree (uuid);


--
-- Name: events_eventcategory_name_35473597_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventcategory_name_35473597_like ON public.events_eventcategory USING btree (name varchar_pattern_ops);


--
-- Name: events_eventcategory_uuid_4a02c778; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventcategory_uuid_4a02c778 ON public.events_eventcategory USING btree (uuid);


--
-- Name: events_eventitem_event_id_cf2bf671; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitem_event_id_cf2bf671 ON public.events_eventitem USING btree (event_id);


--
-- Name: events_eventitem_event_registration_type_id_ec0ad176; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitem_event_registration_type_id_ec0ad176 ON public.events_eventitem USING btree (event_registration_type_id);


--
-- Name: events_eventitem_group_id_858c2af0; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitem_group_id_858c2af0 ON public.events_eventitem USING btree (group_id);


--
-- Name: events_eventitem_item_master_id_c4a33dc0; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitem_item_master_id_c4a33dc0 ON public.events_eventitem USING btree (item_master_id);


--
-- Name: events_eventitem_transport_eventitem_id_e9bdec6b; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitem_transport_eventitem_id_e9bdec6b ON public.events_eventitem_transportation_pickup_locations USING btree (eventitem_id);


--
-- Name: events_eventitem_transport_transportationpickuplocati_6a4d3e80; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitem_transport_transportationpickuplocati_6a4d3e80 ON public.events_eventitem_transportation_pickup_locations USING btree (transportationpickuplocation_id);


--
-- Name: events_eventitem_uuid_73535b85; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitem_uuid_73535b85 ON public.events_eventitem USING btree (uuid);


--
-- Name: events_eventitemcart_canceled_ordered_item_id_fc425d75; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_canceled_ordered_item_id_fc425d75 ON public.events_eventitemcart USING btree (canceled_ordered_item_id);


--
-- Name: events_eventitemcart_coupon_id_5feed3f9; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_coupon_id_5feed3f9 ON public.events_eventitemcart USING btree (coupon_id);


--
-- Name: events_eventitemcart_event_attendee_id_f4e31e00; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_event_attendee_id_f4e31e00 ON public.events_eventitemcart USING btree (event_attendee_id);


--
-- Name: events_eventitemcart_event_id_23a5017f; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_event_id_23a5017f ON public.events_eventitemcart USING btree (event_id);


--
-- Name: events_eventitemcart_event_item_id_5656c961; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_event_item_id_5656c961 ON public.events_eventitemcart USING btree (event_item_id);


--
-- Name: events_eventitemcart_event_registration_type_id_921db3a7; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_event_registration_type_id_921db3a7 ON public.events_eventitemcart USING btree (event_registration_type_id);


--
-- Name: events_eventitemcart_item_master_id_97c3bb1f; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_item_master_id_97c3bb1f ON public.events_eventitemcart USING btree (item_master_id);


--
-- Name: events_eventitemcart_ordered_by_attendee_id_43ce7e24; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_ordered_by_attendee_id_43ce7e24 ON public.events_eventitemcart USING btree (ordered_by_attendee_id);


--
-- Name: events_eventitemcart_ordered_by_user_id_de7616a9; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_ordered_by_user_id_de7616a9 ON public.events_eventitemcart USING btree (ordered_by_user_id);


--
-- Name: events_eventitemcart_transportation_info_id_86ad5705; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_transportation_info_id_86ad5705 ON public.events_eventitemcart USING btree (transportation_info_id);


--
-- Name: events_eventitemcart_user_id_ac23f275; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_user_id_ac23f275 ON public.events_eventitemcart USING btree (user_id);


--
-- Name: events_eventitemcart_uuid_12a5a513; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemcart_uuid_12a5a513 ON public.events_eventitemcart USING btree (uuid);


--
-- Name: events_eventitemgroup_event_id_f04f589f; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemgroup_event_id_f04f589f ON public.events_eventitemgroup USING btree (event_id);


--
-- Name: events_eventitemgroup_event_registration_type_id_21c7d3eb; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemgroup_event_registration_type_id_21c7d3eb ON public.events_eventitemgroup USING btree (event_registration_type_id);


--
-- Name: events_eventitemgroup_name_5d8ba6ad_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemgroup_name_5d8ba6ad_like ON public.events_eventitemgroup USING btree (name varchar_pattern_ops);


--
-- Name: events_eventitemgroup_slug_824706c8_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemgroup_slug_824706c8_like ON public.events_eventitemgroup USING btree (slug varchar_pattern_ops);


--
-- Name: events_eventitemgroup_uuid_7a9158b4; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventitemgroup_uuid_7a9158b4 ON public.events_eventitemgroup USING btree (uuid);


--
-- Name: events_eventregistrationtype_event_id_66aa3ce3; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventregistrationtype_event_id_66aa3ce3 ON public.events_eventregistrationtype USING btree (event_id);


--
-- Name: events_eventregistrationtype_uuid_108d0080; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventregistrationtype_uuid_108d0080 ON public.events_eventregistrationtype USING btree (uuid);


--
-- Name: events_eventtype_name_cce2755e_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventtype_name_cce2755e_like ON public.events_eventtype USING btree (name varchar_pattern_ops);


--
-- Name: events_eventtype_uuid_8e3add22; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_eventtype_uuid_8e3add22 ON public.events_eventtype USING btree (uuid);


--
-- Name: events_organizer_logo_images_id_4faa7e9b; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_organizer_logo_images_id_4faa7e9b ON public.events_organizer_logo USING btree (images_id);


--
-- Name: events_organizer_logo_organizer_id_fa0d7e56; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_organizer_logo_organizer_id_fa0d7e56 ON public.events_organizer_logo USING btree (organizer_id);


--
-- Name: events_organizer_uuid_b006dddb; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_organizer_uuid_b006dddb ON public.events_organizer USING btree (uuid);


--
-- Name: events_phonenumber_event_id_8605cfa0; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_phonenumber_event_id_8605cfa0 ON public.events_phonenumber USING btree (event_id);


--
-- Name: events_phonenumber_organizer_id_123667e6; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_phonenumber_organizer_id_123667e6 ON public.events_phonenumber USING btree (organizer_id);


--
-- Name: events_transportationinfo_pickup_location_id_097c0787; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_transportationinfo_pickup_location_id_097c0787 ON public.events_transportationinfo USING btree (pickup_location_id);


--
-- Name: events_transportationinfo_uuid_54434a67; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_transportationinfo_uuid_54434a67 ON public.events_transportationinfo USING btree (uuid);


--
-- Name: events_transportationpickuplocation_event_id_d4b381ff; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_transportationpickuplocation_event_id_d4b381ff ON public.events_transportationpickuplocation USING btree (event_id);


--
-- Name: events_transportationpickuplocation_event_item_id_94fb3885; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_transportationpickuplocation_event_item_id_94fb3885 ON public.events_transportationpickuplocation USING btree (event_item_id);


--
-- Name: events_transportationpickuplocation_uuid_07a2ad37; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX events_transportationpickuplocation_uuid_07a2ad37 ON public.events_transportationpickuplocation USING btree (uuid);


--
-- Name: items_coupon_coupon_code_5030bd0f_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_coupon_coupon_code_5030bd0f_like ON public.items_coupon USING btree (coupon_code varchar_pattern_ops);


--
-- Name: items_coupon_created_by_id_8726ad75; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_coupon_created_by_id_8726ad75 ON public.items_coupon USING btree (created_by_id);


--
-- Name: items_coupon_item_master_id_7305adc0; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_coupon_item_master_id_7305adc0 ON public.items_coupon USING btree (item_master_id);


--
-- Name: items_coupon_updated_by_id_b49b85c2; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_coupon_updated_by_id_b49b85c2 ON public.items_coupon USING btree (updated_by_id);


--
-- Name: items_coupon_user_id_81285e03; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_coupon_user_id_81285e03 ON public.items_coupon USING btree (user_id);


--
-- Name: items_coupon_uuid_c0599666; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_coupon_uuid_c0599666 ON public.items_coupon USING btree (uuid);


--
-- Name: items_itemcategory_uuid_7983b435; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemcategory_uuid_7983b435 ON public.items_itemcategory USING btree (uuid);


--
-- Name: items_itemmaster_category_id_afc81150; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemmaster_category_id_afc81150 ON public.items_itemmaster USING btree (category_id);


--
-- Name: items_itemmaster_name_b59b3ed6_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemmaster_name_b59b3ed6_like ON public.items_itemmaster USING btree (name varchar_pattern_ops);


--
-- Name: items_itemmaster_process_id_515be385; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemmaster_process_id_515be385 ON public.items_itemmaster USING btree (process_id);


--
-- Name: items_itemmaster_service_id_3378e529; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemmaster_service_id_3378e529 ON public.items_itemmaster USING btree (service_id);


--
-- Name: items_itemmaster_uom_id_6770be75; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemmaster_uom_id_6770be75 ON public.items_itemmaster USING btree (uom_id);


--
-- Name: items_itemmaster_uuid_cf2c74e2; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemmaster_uuid_cf2c74e2 ON public.items_itemmaster USING btree (uuid);


--
-- Name: items_itemprocessmaster_name_5381fda9_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemprocessmaster_name_5381fda9_like ON public.items_itemprocessmaster USING btree (name varchar_pattern_ops);


--
-- Name: items_itemprocessmaster_uuid_2b76e3d0; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemprocessmaster_uuid_2b76e3d0 ON public.items_itemprocessmaster USING btree (uuid);


--
-- Name: items_itemservice_name_ca838a67_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemservice_name_ca838a67_like ON public.items_itemservice USING btree (name varchar_pattern_ops);


--
-- Name: items_itemservice_uuid_fe1cfce7; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_itemservice_uuid_fe1cfce7 ON public.items_itemservice USING btree (uuid);


--
-- Name: items_order_event_registration_id_f87c529d; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_event_registration_id_f87c529d ON public.items_order USING btree (event_attendee_id);


--
-- Name: items_order_event_registration_type_id_d04718f4; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_event_registration_type_id_d04718f4 ON public.items_order USING btree (event_registration_type_id);


--
-- Name: items_order_operator_id_1fa79804; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_operator_id_1fa79804 ON public.items_order USING btree (operator_id);


--
-- Name: items_order_ordered_items_order_id_208656c2; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_ordered_items_order_id_208656c2 ON public.items_order_order_items USING btree (order_id);


--
-- Name: items_order_ordered_items_ordereditem_id_0c8308c2; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_ordered_items_ordereditem_id_0c8308c2 ON public.items_order_order_items USING btree (ordereditem_id);


--
-- Name: items_order_transaction_reference_id_c388e13c; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_transaction_reference_id_c388e13c ON public.items_order USING btree (event_id);


--
-- Name: items_order_user_id_fabdb1ca; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_user_id_fabdb1ca ON public.items_order USING btree (user_id);


--
-- Name: items_order_uuid_f9cb51a4; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_order_uuid_f9cb51a4 ON public.items_order USING btree (uuid);


--
-- Name: items_ordereditem_actual_item_master_id_a02b4a72; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_actual_item_master_id_a02b4a72 ON public.items_ordereditem USING btree (actual_item_master_id);


--
-- Name: items_ordereditem_canceled_ordered_item_id_6b9a5f2b; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_canceled_ordered_item_id_6b9a5f2b ON public.items_ordereditem USING btree (canceled_ordered_item_id);


--
-- Name: items_ordereditem_coupon_id_b2e75b56; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_coupon_id_b2e75b56 ON public.items_ordereditem USING btree (coupon_id);


--
-- Name: items_ordereditem_event_attendee_id_9c566201; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_event_attendee_id_9c566201 ON public.items_ordereditem USING btree (event_attendee_id);


--
-- Name: items_ordereditem_event_item_id_23f9edf3; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_event_item_id_23f9edf3 ON public.items_ordereditem USING btree (event_item_id);


--
-- Name: items_ordereditem_item_master_id_b50a761b; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_item_master_id_b50a761b ON public.items_ordereditem USING btree (item_master_id);


--
-- Name: items_ordereditem_parent_order_id_7394d341; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_parent_order_id_7394d341 ON public.items_ordereditem USING btree (parent_order_id);


--
-- Name: items_ordereditem_transportation_info_id_5068c38c; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_transportation_info_id_5068c38c ON public.items_ordereditem USING btree (transportation_info_id);


--
-- Name: items_ordereditem_user_id_883b5d1e; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_user_id_883b5d1e ON public.items_ordereditem USING btree (user_id);


--
-- Name: items_ordereditem_uuid_e5bbc4bd; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_ordereditem_uuid_e5bbc4bd ON public.items_ordereditem USING btree (uuid);


--
-- Name: items_unitofmeasurement_name_6ea49bb6_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_unitofmeasurement_name_6ea49bb6_like ON public.items_unitofmeasurement USING btree (name varchar_pattern_ops);


--
-- Name: items_unitofmeasurement_uuid_07a29426; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX items_unitofmeasurement_uuid_07a29426 ON public.items_unitofmeasurement USING btree (uuid);


--
-- Name: users_user_groups_group_id_9afc8d0e; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX users_user_groups_group_id_9afc8d0e ON public.users_user_groups USING btree (group_id);


--
-- Name: users_user_groups_user_id_5f6f5a90; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX users_user_groups_user_id_5f6f5a90 ON public.users_user_groups USING btree (user_id);


--
-- Name: users_user_phone_number_aff54ffd_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX users_user_phone_number_aff54ffd_like ON public.users_user USING btree (phone_number varchar_pattern_ops);


--
-- Name: users_user_user_permissions_permission_id_0b93982e; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX users_user_user_permissions_permission_id_0b93982e ON public.users_user_user_permissions USING btree (permission_id);


--
-- Name: users_user_user_permissions_user_id_20aca447; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX users_user_user_permissions_user_id_20aca447 ON public.users_user_user_permissions USING btree (user_id);


--
-- Name: users_user_username_06e46fe6_like; Type: INDEX; Schema: public; Owner: club_erp_user
--

CREATE INDEX users_user_username_06e46fe6_like ON public.users_user USING btree (username varchar_pattern_ops);


--
-- Name: account_emailaddress account_emailaddress_user_id_2c513194_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailaddress
  ADD CONSTRAINT account_emailaddress_user_id_2c513194_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_emailconfirmation account_emailconfirm_email_address_id_5b7f8c58_fk_account_e; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.account_emailconfirmation
  ADD CONSTRAINT account_emailconfirm_email_address_id_5b7f8c58_fk_account_e FOREIGN KEY (email_address_id) REFERENCES public.account_emailaddress (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group_permissions
  ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_group_permissions
  ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.auth_permission
  ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.authtoken_token
  ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_admin_log
  ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.django_admin_log
  ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_category_id_01d3a3ab_fk_events_eventcategory_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event
  ADD CONSTRAINT events_event_category_id_01d3a3ab_fk_events_eventcategory_id FOREIGN KEY (category_id) REFERENCES public.events_eventcategory (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_description_images events_event_descrip_event_id_71121a0c_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_description_images
  ADD CONSTRAINT events_event_descrip_event_id_71121a0c_fk_events_ev FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_description_images events_event_descrip_images_id_d2988044_fk_events_im; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_description_images
  ADD CONSTRAINT events_event_descrip_images_id_d2988044_fk_events_im FOREIGN KEY (images_id) REFERENCES public.events_images (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_organizer_id_3afa7809_fk_events_organizer_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event
  ADD CONSTRAINT events_event_organizer_id_3afa7809_fk_events_organizer_id FOREIGN KEY (organizer_id) REFERENCES public.events_organizer (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_title_images events_event_title_i_images_id_30d76ec5_fk_events_im; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_title_images
  ADD CONSTRAINT events_event_title_i_images_id_30d76ec5_fk_events_im FOREIGN KEY (images_id) REFERENCES public.events_images (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_title_images events_event_title_images_event_id_7368d00e_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event_title_images
  ADD CONSTRAINT events_event_title_images_event_id_7368d00e_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_type_id_04a81abf_fk_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_event
  ADD CONSTRAINT events_event_type_id_04a81abf_fk_events_eventtype_id FOREIGN KEY (type_id) REFERENCES public.events_eventtype (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_event_id_33c2c3c3_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ADD CONSTRAINT events_eventattendee_event_id_33c2c3c3_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_event_registration_t_2832b659_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ADD CONSTRAINT events_eventattendee_event_registration_t_2832b659_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_registered_by_id_bab87466_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ADD CONSTRAINT events_eventattendee_registered_by_id_bab87466_fk_events_ev FOREIGN KEY (registered_by_id) REFERENCES public.events_eventattendee (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_user_id_c7184780_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventattendee
  ADD CONSTRAINT events_eventattendee_user_id_c7184780_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_event_id_cf2bf671_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem
  ADD CONSTRAINT events_eventitem_event_id_cf2bf671_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_event_registration_t_ec0ad176_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem
  ADD CONSTRAINT events_eventitem_event_registration_t_ec0ad176_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_group_id_858c2af0_fk_events_eventitemgroup_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem
  ADD CONSTRAINT events_eventitem_group_id_858c2af0_fk_events_eventitemgroup_id FOREIGN KEY (group_id) REFERENCES public.events_eventitemgroup (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_item_master_id_c4a33dc0_fk_items_itemmaster_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem
  ADD CONSTRAINT events_eventitem_item_master_id_c4a33dc0_fk_items_itemmaster_id FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_tra_eventitem_id_e9bdec6b_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
  ADD CONSTRAINT events_eventitem_tra_eventitem_id_e9bdec6b_fk_events_ev FOREIGN KEY (eventitem_id) REFERENCES public.events_eventitem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_tra_transportationpickup_6a4d3e80_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
  ADD CONSTRAINT events_eventitem_tra_transportationpickup_6a4d3e80_fk_events_tr FOREIGN KEY (transportationpickuplocation_id) REFERENCES public.events_transportationpickuplocation (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_canceled_ordered_ite_fc425d75_fk_items_ord; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_canceled_ordered_ite_fc425d75_fk_items_ord FOREIGN KEY (canceled_ordered_item_id) REFERENCES public.items_ordereditem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_coupon_id_5feed3f9_fk_items_coupon_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_coupon_id_5feed3f9_fk_items_coupon_id FOREIGN KEY (coupon_id) REFERENCES public.items_coupon (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_event_attendee_id_f4e31e00_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_event_attendee_id_f4e31e00_fk_events_ev FOREIGN KEY (event_attendee_id) REFERENCES public.events_eventattendee (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_event_id_23a5017f_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_event_id_23a5017f_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_event_item_id_5656c961_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_event_item_id_5656c961_fk_events_ev FOREIGN KEY (event_item_id) REFERENCES public.events_eventitem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_event_registration_t_921db3a7_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_event_registration_t_921db3a7_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_item_master_id_97c3bb1f_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_item_master_id_97c3bb1f_fk_items_ite FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_ordered_by_attendee__43ce7e24_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_ordered_by_attendee__43ce7e24_fk_events_ev FOREIGN KEY (ordered_by_attendee_id) REFERENCES public.events_eventattendee (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_ordered_by_user_id_de7616a9_fk_users_use; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_ordered_by_user_id_de7616a9_fk_users_use FOREIGN KEY (ordered_by_user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_transportation_info__86ad5705_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_transportation_info__86ad5705_fk_events_tr FOREIGN KEY (transportation_info_id) REFERENCES public.events_transportationinfo (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemcart events_eventitemcart_user_id_ac23f275_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemcart
  ADD CONSTRAINT events_eventitemcart_user_id_ac23f275_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemgroup events_eventitemgrou_event_registration_t_21c7d3eb_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemgroup
  ADD CONSTRAINT events_eventitemgrou_event_registration_t_21c7d3eb_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemgroup events_eventitemgroup_event_id_f04f589f_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventitemgroup
  ADD CONSTRAINT events_eventitemgroup_event_id_f04f589f_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventregistrationtype events_eventregistra_event_id_66aa3ce3_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_eventregistrationtype
  ADD CONSTRAINT events_eventregistra_event_id_66aa3ce3_fk_events_ev FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_organizer_logo events_organizer_log_organizer_id_fa0d7e56_fk_events_or; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_organizer_logo
  ADD CONSTRAINT events_organizer_log_organizer_id_fa0d7e56_fk_events_or FOREIGN KEY (organizer_id) REFERENCES public.events_organizer (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_organizer_logo events_organizer_logo_images_id_4faa7e9b_fk_events_images_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_organizer_logo
  ADD CONSTRAINT events_organizer_logo_images_id_4faa7e9b_fk_events_images_id FOREIGN KEY (images_id) REFERENCES public.events_images (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_phonenumber events_phonenumber_event_id_8605cfa0_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_phonenumber
  ADD CONSTRAINT events_phonenumber_event_id_8605cfa0_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_phonenumber events_phonenumber_organizer_id_123667e6_fk_events_organizer_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_phonenumber
  ADD CONSTRAINT events_phonenumber_organizer_id_123667e6_fk_events_organizer_id FOREIGN KEY (organizer_id) REFERENCES public.events_organizer (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_transportationpickuplocation events_transportatio_event_id_d4b381ff_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_transportationpickuplocation
  ADD CONSTRAINT events_transportatio_event_id_d4b381ff_fk_events_ev FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_transportationpickuplocation events_transportatio_event_item_id_94fb3885_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_transportationpickuplocation
  ADD CONSTRAINT events_transportatio_event_item_id_94fb3885_fk_events_ev FOREIGN KEY (event_item_id) REFERENCES public.events_eventitem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_transportationinfo events_transportatio_pickup_location_id_097c0787_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.events_transportationinfo
  ADD CONSTRAINT events_transportatio_pickup_location_id_097c0787_fk_events_tr FOREIGN KEY (pickup_location_id) REFERENCES public.events_transportationpickuplocation (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_coupon items_coupon_created_by_id_8726ad75_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_coupon
  ADD CONSTRAINT items_coupon_created_by_id_8726ad75_fk_users_user_id FOREIGN KEY (created_by_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_coupon items_coupon_item_master_id_7305adc0_fk_items_itemmaster_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_coupon
  ADD CONSTRAINT items_coupon_item_master_id_7305adc0_fk_items_itemmaster_id FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_coupon items_coupon_updated_by_id_b49b85c2_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_coupon
  ADD CONSTRAINT items_coupon_updated_by_id_b49b85c2_fk_users_user_id FOREIGN KEY (updated_by_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_coupon items_coupon_user_id_81285e03_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_coupon
  ADD CONSTRAINT items_coupon_user_id_81285e03_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_category_id_afc81150_fk_items_itemcategory_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemmaster
  ADD CONSTRAINT items_itemmaster_category_id_afc81150_fk_items_itemcategory_id FOREIGN KEY (category_id) REFERENCES public.items_itemcategory (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_process_id_515be385_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemmaster
  ADD CONSTRAINT items_itemmaster_process_id_515be385_fk_items_ite FOREIGN KEY (process_id) REFERENCES public.items_itemprocessmaster (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_service_id_3378e529_fk_items_itemservice_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemmaster
  ADD CONSTRAINT items_itemmaster_service_id_3378e529_fk_items_itemservice_id FOREIGN KEY (service_id) REFERENCES public.items_itemservice (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_uom_id_6770be75_fk_items_unitofmeasurement_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_itemmaster
  ADD CONSTRAINT items_itemmaster_uom_id_6770be75_fk_items_unitofmeasurement_id FOREIGN KEY (uom_id) REFERENCES public.items_unitofmeasurement (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order items_order_event_attendee_id_fcda25ce_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_event_attendee_id_fcda25ce_fk_events_ev FOREIGN KEY (event_attendee_id) REFERENCES public.events_eventattendee (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order items_order_event_id_508b85cf_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_event_id_508b85cf_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order items_order_event_registration_t_d04718f4_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_event_registration_t_d04718f4_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order items_order_operator_id_1fa79804_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_operator_id_1fa79804_fk_users_user_id FOREIGN KEY (operator_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order_order_items items_order_order_it_ordereditem_id_e57c97b6_fk_items_ord; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order_order_items
  ADD CONSTRAINT items_order_order_it_ordereditem_id_e57c97b6_fk_items_ord FOREIGN KEY (ordereditem_id) REFERENCES public.items_ordereditem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order_order_items items_order_order_items_order_id_03fb6b7c_fk_items_order_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order_order_items
  ADD CONSTRAINT items_order_order_items_order_id_03fb6b7c_fk_items_order_id FOREIGN KEY (order_id) REFERENCES public.items_order (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order items_order_previous_order_id_8e5db8c6_fk_items_order_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_previous_order_id_8e5db8c6_fk_items_order_id FOREIGN KEY (previous_order_id) REFERENCES public.items_order (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_order items_order_user_id_fabdb1ca_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_order
  ADD CONSTRAINT items_order_user_id_fabdb1ca_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_actual_item_master_i_a02b4a72_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_actual_item_master_i_a02b4a72_fk_items_ite FOREIGN KEY (actual_item_master_id) REFERENCES public.items_itemmaster (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_canceled_ordered_ite_6b9a5f2b_fk_items_ord; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_canceled_ordered_ite_6b9a5f2b_fk_items_ord FOREIGN KEY (canceled_ordered_item_id) REFERENCES public.items_ordereditem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_coupon_id_b2e75b56_fk_items_coupon_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_coupon_id_b2e75b56_fk_items_coupon_id FOREIGN KEY (coupon_id) REFERENCES public.items_coupon (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_event_attendee_id_9c566201_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_event_attendee_id_9c566201_fk_events_ev FOREIGN KEY (event_attendee_id) REFERENCES public.events_eventattendee (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_event_item_id_23f9edf3_fk_events_eventitem_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_event_item_id_23f9edf3_fk_events_eventitem_id FOREIGN KEY (event_item_id) REFERENCES public.events_eventitem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_item_master_id_b50a761b_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_item_master_id_b50a761b_fk_items_ite FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_parent_order_id_7394d341_fk_items_ord; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_parent_order_id_7394d341_fk_items_ord FOREIGN KEY (parent_order_id) REFERENCES public.items_ordereditem (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_transportation_info__5068c38c_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_transportation_info__5068c38c_fk_events_tr FOREIGN KEY (transportation_info_id) REFERENCES public.events_transportationinfo (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_ordereditem items_ordereditem_user_id_883b5d1e_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.items_ordereditem
  ADD CONSTRAINT items_ordereditem_user_id_883b5d1e_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_groups users_user_groups_group_id_9afc8d0e_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_groups
  ADD CONSTRAINT users_user_groups_group_id_9afc8d0e_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_groups users_user_groups_user_id_5f6f5a90_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_groups
  ADD CONSTRAINT users_user_groups_user_id_5f6f5a90_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_user_permissions users_user_user_perm_permission_id_0b93982e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_user_permissions
  ADD CONSTRAINT users_user_user_perm_permission_id_0b93982e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission (id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_user_permissions users_user_user_permissions_user_id_20aca447_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: club_erp_user
--

ALTER TABLE ONLY public.users_user_user_permissions
  ADD CONSTRAINT users_user_user_permissions_user_id_20aca447_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user (id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

