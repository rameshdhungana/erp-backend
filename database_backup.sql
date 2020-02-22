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
-- Name: account_emailaddress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_emailaddress (
    id integer NOT NULL,
    email character varying(254) NOT NULL,
    verified boolean NOT NULL,
    "primary" boolean NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.account_emailaddress OWNER TO postgres;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_emailaddress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailaddress_id_seq OWNER TO postgres;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_emailaddress_id_seq OWNED BY public.account_emailaddress.id;


--
-- Name: account_emailconfirmation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_emailconfirmation (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    sent timestamp with time zone,
    key character varying(64) NOT NULL,
    email_address_id integer NOT NULL
);


ALTER TABLE public.account_emailconfirmation OWNER TO postgres;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_emailconfirmation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_emailconfirmation_id_seq OWNER TO postgres;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_emailconfirmation_id_seq OWNED BY public.account_emailconfirmation.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO postgres;

--
-- Name: carts_itemcart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts_itemcart (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    transaction_type character varying(255) NOT NULL,
    quantity integer NOT NULL,
    rate numeric(19,2) NOT NULL,
    amount numeric(19,2) NOT NULL,
    discount numeric(19,2) NOT NULL,
    amount_net numeric(19,2) NOT NULL,
    item_sc numeric(19,2) NOT NULL,
    amount_taxable numeric(19,2) NOT NULL,
    item_tax numeric(19,2) NOT NULL,
    amount_final numeric(19,2) NOT NULL,
    is_coupon_item boolean NOT NULL,
    entry_from_ordered_item boolean NOT NULL,
    canceled_ordered_item_id integer,
    coupon_id integer,
    event_id integer NOT NULL,
    event_attendee_id integer NOT NULL,
    event_item_id integer,
    event_registration_type_id integer NOT NULL,
    item_master_id integer NOT NULL,
    ordered_by_attendee_id integer NOT NULL,
    ordered_by_user_id integer NOT NULL,
    transportation_info_id integer,
    user_id integer NOT NULL,
    apply_cancellation_policy boolean NOT NULL,
    CONSTRAINT carts_itemcart_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.carts_itemcart OWNER TO postgres;

--
-- Name: carts_itemcart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_itemcart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carts_itemcart_id_seq OWNER TO postgres;

--
-- Name: carts_itemcart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_itemcart_id_seq OWNED BY public.carts_itemcart.id;


--
-- Name: coupons_coupon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupons_coupon (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    coupon_code character varying(64) NOT NULL,
    amount_limit numeric(19,2) NOT NULL,
    amount_used numeric(19,2) NOT NULL,
    type character varying(32) NOT NULL,
    status boolean NOT NULL,
    notes text NOT NULL,
    created_by_id integer,
    item_master_id integer,
    updated_by_id integer,
    user_id integer
);


ALTER TABLE public.coupons_coupon OWNER TO postgres;

--
-- Name: coupons_coupon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coupons_coupon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupons_coupon_id_seq OWNER TO postgres;

--
-- Name: coupons_coupon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coupons_coupon_id_seq OWNED BY public.coupons_coupon.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO postgres;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO postgres;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- Name: events_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_configuration (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.events_configuration OWNER TO postgres;

--
-- Name: events_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_configuration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_configuration_id_seq OWNER TO postgres;

--
-- Name: events_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_configuration_id_seq OWNED BY public.events_configuration.id;


--
-- Name: events_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_event (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    title character varying(255) NOT NULL,
    uuid uuid NOT NULL,
    description text NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    early_bird_date timestamp with time zone NOT NULL,
    is_single_day_event boolean NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    venue_location character varying(255) NOT NULL,
    label character varying(255) NOT NULL,
    summary text NOT NULL,
    allow_group_registration boolean NOT NULL,
    max_group_limit integer NOT NULL,
    status character varying(255) NOT NULL,
    show_total_capacity boolean NOT NULL,
    show_remaining_seats boolean NOT NULL,
    is_published boolean NOT NULL,
    show_start_time boolean NOT NULL,
    show_end_time boolean NOT NULL,
    timezone character varying(128) NOT NULL,
    category_id integer NOT NULL,
    organizer_id integer NOT NULL,
    type_id integer NOT NULL,
    only_offsite_registration boolean NOT NULL
);


ALTER TABLE public.events_event OWNER TO postgres;

--
-- Name: events_event_description_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_event_description_images (
    id integer NOT NULL,
    event_id integer NOT NULL,
    images_id integer NOT NULL
);


ALTER TABLE public.events_event_description_images OWNER TO postgres;

--
-- Name: events_event_description_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_event_description_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_description_images_id_seq OWNER TO postgres;

--
-- Name: events_event_description_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_event_description_images_id_seq OWNED BY public.events_event_description_images.id;


--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_id_seq OWNER TO postgres;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_event_id_seq OWNED BY public.events_event.id;


--
-- Name: events_event_title_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_event_title_images (
    id integer NOT NULL,
    event_id integer NOT NULL,
    images_id integer NOT NULL
);


ALTER TABLE public.events_event_title_images OWNER TO postgres;

--
-- Name: events_event_title_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_event_title_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_title_images_id_seq OWNER TO postgres;

--
-- Name: events_event_title_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_event_title_images_id_seq OWNED BY public.events_event_title_images.id;


--
-- Name: events_eventattendee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_eventattendee (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    smart_card_number character varying(6),
    name_in_smart_card character varying(255),
    alternate_email character varying(254),
    alternate_phone_number character varying(128),
    is_senior_citizen boolean NOT NULL,
    is_pwk boolean NOT NULL,
    registration_status character varying(20) NOT NULL,
    group_type character varying(10) NOT NULL,
    confirmation_code character varying(64) NOT NULL,
    changed_to_offsite boolean NOT NULL,
    note text NOT NULL,
    event_id integer NOT NULL,
    event_registration_type_id integer NOT NULL,
    registered_by_id integer,
    user_id integer NOT NULL,
    registration_is_cancelled boolean NOT NULL
);


ALTER TABLE public.events_eventattendee OWNER TO postgres;

--
-- Name: events_eventattendee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_eventattendee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventattendee_id_seq OWNER TO postgres;

--
-- Name: events_eventattendee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_eventattendee_id_seq OWNED BY public.events_eventattendee.id;


--
-- Name: events_eventcategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_eventcategory (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.events_eventcategory OWNER TO postgres;

--
-- Name: events_eventcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_eventcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventcategory_id_seq OWNER TO postgres;

--
-- Name: events_eventcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_eventcategory_id_seq OWNED BY public.events_eventcategory.id;


--
-- Name: events_eventitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_eventitem (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    group_type character varying(10) NOT NULL,
    item_capacity integer NOT NULL,
    items_booked integer NOT NULL,
    item_sharing_count integer NOT NULL,
    discount_before_early_bird numeric(5,2) NOT NULL,
    discount_after_early_bird numeric(5,2) NOT NULL,
    is_day_pass_item boolean NOT NULL,
    senior_citizen_discount_applicable boolean NOT NULL,
    ask_for_arrival_datetime boolean NOT NULL,
    ask_for_departure_datetime boolean NOT NULL,
    ask_for_pickup_location boolean NOT NULL,
    event_id integer NOT NULL,
    event_registration_type_id integer NOT NULL,
    group_id integer NOT NULL,
    item_master_id integer NOT NULL,
    CONSTRAINT events_eventitem_item_capacity_check CHECK ((item_capacity >= 0)),
    CONSTRAINT events_eventitem_item_sharing_count_check CHECK ((item_sharing_count >= 0)),
    CONSTRAINT events_eventitem_items_booked_check CHECK ((items_booked >= 0))
);


ALTER TABLE public.events_eventitem OWNER TO postgres;

--
-- Name: events_eventitem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_eventitem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventitem_id_seq OWNER TO postgres;

--
-- Name: events_eventitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_eventitem_id_seq OWNED BY public.events_eventitem.id;


--
-- Name: events_eventitem_transportation_pickup_locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_eventitem_transportation_pickup_locations (
    id integer NOT NULL,
    eventitem_id integer NOT NULL,
    transportationpickuplocation_id integer NOT NULL
);


ALTER TABLE public.events_eventitem_transportation_pickup_locations OWNER TO postgres;

--
-- Name: events_eventitem_transportation_pickup_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_eventitem_transportation_pickup_locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventitem_transportation_pickup_locations_id_seq OWNER TO postgres;

--
-- Name: events_eventitem_transportation_pickup_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_eventitem_transportation_pickup_locations_id_seq OWNED BY public.events_eventitem_transportation_pickup_locations.id;


--
-- Name: events_eventitemgroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_eventitemgroup (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(50) NOT NULL,
    description text NOT NULL,
    is_multi_select boolean NOT NULL,
    icon_type character varying(255) NOT NULL,
    event_id integer NOT NULL,
    event_registration_type_id integer NOT NULL
);


ALTER TABLE public.events_eventitemgroup OWNER TO postgres;

--
-- Name: events_eventitemgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_eventitemgroup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventitemgroup_id_seq OWNER TO postgres;

--
-- Name: events_eventitemgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_eventitemgroup_id_seq OWNED BY public.events_eventitemgroup.id;


--
-- Name: events_eventregistrationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_eventregistrationtype (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL,
    total_capacity integer NOT NULL,
    is_published boolean NOT NULL,
    status character varying(20) NOT NULL,
    required_otp boolean NOT NULL,
    is_public boolean NOT NULL,
    event_id integer NOT NULL
);


ALTER TABLE public.events_eventregistrationtype OWNER TO postgres;

--
-- Name: events_eventregistrationtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_eventregistrationtype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventregistrationtype_id_seq OWNER TO postgres;

--
-- Name: events_eventregistrationtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_eventregistrationtype_id_seq OWNED BY public.events_eventregistrationtype.id;


--
-- Name: events_eventtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_eventtype (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.events_eventtype OWNER TO postgres;

--
-- Name: events_eventtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_eventtype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_eventtype_id_seq OWNER TO postgres;

--
-- Name: events_eventtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_eventtype_id_seq OWNED BY public.events_eventtype.id;


--
-- Name: events_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_images (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    title character varying(255) NOT NULL,
    image character varying(100) NOT NULL
);


ALTER TABLE public.events_images OWNER TO postgres;

--
-- Name: events_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_images_id_seq OWNER TO postgres;

--
-- Name: events_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_images_id_seq OWNED BY public.events_images.id;


--
-- Name: events_organizer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_organizer (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.events_organizer OWNER TO postgres;

--
-- Name: events_organizer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_organizer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_organizer_id_seq OWNER TO postgres;

--
-- Name: events_organizer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_organizer_id_seq OWNED BY public.events_organizer.id;


--
-- Name: events_organizer_logo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_organizer_logo (
    id integer NOT NULL,
    organizer_id integer NOT NULL,
    images_id integer NOT NULL
);


ALTER TABLE public.events_organizer_logo OWNER TO postgres;

--
-- Name: events_organizer_logo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_organizer_logo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_organizer_logo_id_seq OWNER TO postgres;

--
-- Name: events_organizer_logo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_organizer_logo_id_seq OWNED BY public.events_organizer_logo.id;


--
-- Name: events_phonenumber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_phonenumber (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    is_visible boolean NOT NULL,
    phone_number character varying(128) NOT NULL,
    country character varying(2) NOT NULL,
    label text NOT NULL,
    event_id integer NOT NULL,
    organizer_id integer NOT NULL
);


ALTER TABLE public.events_phonenumber OWNER TO postgres;

--
-- Name: events_phonenumber_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_phonenumber_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_phonenumber_id_seq OWNER TO postgres;

--
-- Name: events_phonenumber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_phonenumber_id_seq OWNED BY public.events_phonenumber.id;


--
-- Name: events_transportationinfo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_transportationinfo (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    arrival_datetime timestamp with time zone,
    departure_datetime timestamp with time zone,
    pickup_location_id integer
);


ALTER TABLE public.events_transportationinfo OWNER TO postgres;

--
-- Name: events_transportationinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_transportationinfo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_transportationinfo_id_seq OWNER TO postgres;

--
-- Name: events_transportationinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_transportationinfo_id_seq OWNED BY public.events_transportationinfo.id;


--
-- Name: events_transportationpickuplocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events_transportationpickuplocation (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    location character varying(255) NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    description text NOT NULL,
    event_id integer NOT NULL,
    event_item_id integer NOT NULL
);


ALTER TABLE public.events_transportationpickuplocation OWNER TO postgres;

--
-- Name: events_transportationpickuplocation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_transportationpickuplocation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_transportationpickuplocation_id_seq OWNER TO postgres;

--
-- Name: events_transportationpickuplocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_transportationpickuplocation_id_seq OWNED BY public.events_transportationpickuplocation.id;


--
-- Name: items_itemcategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_itemcategory (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.items_itemcategory OWNER TO postgres;

--
-- Name: items_itemcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_itemcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_itemcategory_id_seq OWNER TO postgres;

--
-- Name: items_itemcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_itemcategory_id_seq OWNED BY public.items_itemcategory.id;


--
-- Name: items_itemmaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_itemmaster (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL,
    options character varying(255) NOT NULL,
    item_for_booking boolean NOT NULL,
    item_for_sale boolean NOT NULL,
    item_for_purchase boolean NOT NULL,
    item_for_stock boolean NOT NULL,
    item_for_rent boolean NOT NULL,
    item_for_package boolean NOT NULL,
    item_has_substitute boolean NOT NULL,
    item_is_veg boolean NOT NULL,
    item_is_non_veg boolean NOT NULL,
    item_is_liquor boolean NOT NULL,
    item_is_balance_topup boolean NOT NULL,
    item_is_balance_used boolean NOT NULL,
    item_is_reward boolean NOT NULL,
    item_is_discount boolean NOT NULL,
    item_is_service_charge boolean NOT NULL,
    item_is_tax boolean NOT NULL,
    senior_citizen_discount_per numeric(5,2) NOT NULL,
    ask_for_delivery boolean NOT NULL,
    item_rate numeric(19,2) NOT NULL,
    item_sc_per numeric(5,2) NOT NULL,
    item_tax_per numeric(5,2) NOT NULL,
    item_mrp numeric(19,2) NOT NULL,
    is_public boolean NOT NULL,
    status boolean NOT NULL,
    is_coupon_item boolean NOT NULL,
    item_in_stock integer NOT NULL,
    item_rate_deposits numeric(19,2) NOT NULL,
    has_addon_items boolean NOT NULL,
    description text NOT NULL,
    category_id integer NOT NULL,
    process_id integer NOT NULL,
    service_id integer NOT NULL,
    uom_id integer NOT NULL,
    CONSTRAINT items_itemmaster_item_in_stock_check CHECK ((item_in_stock >= 0))
);


ALTER TABLE public.items_itemmaster OWNER TO postgres;

--
-- Name: items_itemmaster_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_itemmaster_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_itemmaster_id_seq OWNER TO postgres;

--
-- Name: items_itemmaster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_itemmaster_id_seq OWNED BY public.items_itemmaster.id;


--
-- Name: items_itemprocessmaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_itemprocessmaster (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.items_itemprocessmaster OWNER TO postgres;

--
-- Name: items_itemprocessmaster_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_itemprocessmaster_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_itemprocessmaster_id_seq OWNER TO postgres;

--
-- Name: items_itemprocessmaster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_itemprocessmaster_id_seq OWNED BY public.items_itemprocessmaster.id;


--
-- Name: items_itemservice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_itemservice (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.items_itemservice OWNER TO postgres;

--
-- Name: items_itemservice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_itemservice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_itemservice_id_seq OWNER TO postgres;

--
-- Name: items_itemservice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_itemservice_id_seq OWNED BY public.items_itemservice.id;


--
-- Name: items_unitofmeasurement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_unitofmeasurement (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.items_unitofmeasurement OWNER TO postgres;

--
-- Name: items_unitofmeasurement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_unitofmeasurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_unitofmeasurement_id_seq OWNER TO postgres;

--
-- Name: items_unitofmeasurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_unitofmeasurement_id_seq OWNED BY public.items_unitofmeasurement.id;


--
-- Name: orders_cancellationpolicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_cancellationpolicy (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    period_from timestamp with time zone NOT NULL,
    period_to timestamp with time zone NOT NULL,
    cancellation_per numeric(5,2) NOT NULL,
    event_id integer,
    event_item_id integer,
    item_master_id integer NOT NULL
);


ALTER TABLE public.orders_cancellationpolicy OWNER TO postgres;

--
-- Name: orders_cancellationpolicy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_cancellationpolicy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_cancellationpolicy_id_seq OWNER TO postgres;

--
-- Name: orders_cancellationpolicy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_cancellationpolicy_id_seq OWNED BY public.orders_cancellationpolicy.id;


--
-- Name: orders_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_order (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    order_number integer NOT NULL,
    order_cfy character varying(32) NOT NULL,
    transaction_type character varying(255) NOT NULL,
    balance numeric(19,2) NOT NULL,
    balance_credit numeric(19,2) NOT NULL,
    device_id character varying(255) NOT NULL,
    web_initiated boolean NOT NULL,
    app_initiated boolean NOT NULL,
    one_time_password character varying(255) NOT NULL,
    notes text NOT NULL,
    delivery_access character varying(255) NOT NULL,
    order_status character varying(20) NOT NULL,
    event_id integer,
    event_attendee_id integer,
    event_registration_type_id integer,
    operator_id integer,
    previous_order_id integer,
    user_id integer NOT NULL
);


ALTER TABLE public.orders_order OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders_order.id;


--
-- Name: orders_order_order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_order_order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    ordereditem_id integer NOT NULL
);


ALTER TABLE public.orders_order_order_items OWNER TO postgres;

--
-- Name: orders_order_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_order_items_id_seq OWNER TO postgres;

--
-- Name: orders_order_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_order_items_id_seq OWNED BY public.orders_order_order_items.id;


--
-- Name: orders_ordercfyandordernumbertracker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_ordercfyandordernumbertracker (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    latest_order_number integer NOT NULL,
    latest_order_cfy character varying(32) NOT NULL
);


ALTER TABLE public.orders_ordercfyandordernumbertracker OWNER TO postgres;

--
-- Name: orders_ordercfyandordernumbertracker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_ordercfyandordernumbertracker_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_ordercfyandordernumbertracker_id_seq OWNER TO postgres;

--
-- Name: orders_ordercfyandordernumbertracker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_ordercfyandordernumbertracker_id_seq OWNED BY public.orders_ordercfyandordernumbertracker.id;


--
-- Name: orders_ordereditem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_ordereditem (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    uuid uuid NOT NULL,
    order_number integer NOT NULL,
    order_cfy character varying(32) NOT NULL,
    transaction_type character varying(255) NOT NULL,
    transaction_reference_id character varying(255) NOT NULL,
    privileged boolean NOT NULL,
    quantity integer NOT NULL,
    rate numeric(19,2) NOT NULL,
    amount numeric(19,2) NOT NULL,
    discount numeric(19,2) NOT NULL,
    amount_net numeric(19,2) NOT NULL,
    item_sc numeric(19,2) NOT NULL,
    amount_taxable numeric(19,2) NOT NULL,
    item_tax numeric(19,2) NOT NULL,
    amount_final numeric(19,2) NOT NULL,
    is_coupon_item boolean NOT NULL,
    notes text NOT NULL,
    actual_item_master_id integer,
    canceled_ordered_item_id integer,
    coupon_id integer,
    event_attendee_id integer,
    event_item_id integer,
    item_master_id integer NOT NULL,
    parent_order_id integer,
    transportation_info_id integer,
    user_id integer NOT NULL
);


ALTER TABLE public.orders_ordereditem OWNER TO postgres;

--
-- Name: orders_ordereditem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_ordereditem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_ordereditem_id_seq OWNER TO postgres;

--
-- Name: orders_ordereditem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_ordereditem_id_seq OWNED BY public.orders_ordereditem.id;


--
-- Name: users_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    uuid uuid NOT NULL,
    phone_number character varying(20) NOT NULL,
    city character varying(255) NOT NULL,
    country character varying(2) NOT NULL,
    profile_picture character varying(100),
    gender character varying(15) NOT NULL
);


ALTER TABLE public.users_user OWNER TO postgres;

--
-- Name: users_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.users_user_groups OWNER TO postgres;

--
-- Name: users_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_groups_id_seq OWNER TO postgres;

--
-- Name: users_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_groups_id_seq OWNED BY public.users_user_groups.id;


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users_user.id;


--
-- Name: users_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.users_user_user_permissions OWNER TO postgres;

--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_user_permissions_id_seq OWNED BY public.users_user_user_permissions.id;


--
-- Name: account_emailaddress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailaddress ALTER COLUMN id SET DEFAULT nextval('public.account_emailaddress_id_seq'::regclass);


--
-- Name: account_emailconfirmation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailconfirmation ALTER COLUMN id SET DEFAULT nextval('public.account_emailconfirmation_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: carts_itemcart id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart ALTER COLUMN id SET DEFAULT nextval('public.carts_itemcart_id_seq'::regclass);


--
-- Name: coupons_coupon id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons_coupon ALTER COLUMN id SET DEFAULT nextval('public.coupons_coupon_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- Name: events_configuration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_configuration ALTER COLUMN id SET DEFAULT nextval('public.events_configuration_id_seq'::regclass);


--
-- Name: events_event id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event ALTER COLUMN id SET DEFAULT nextval('public.events_event_id_seq'::regclass);


--
-- Name: events_event_description_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_description_images ALTER COLUMN id SET DEFAULT nextval('public.events_event_description_images_id_seq'::regclass);


--
-- Name: events_event_title_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_title_images ALTER COLUMN id SET DEFAULT nextval('public.events_event_title_images_id_seq'::regclass);


--
-- Name: events_eventattendee id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventattendee ALTER COLUMN id SET DEFAULT nextval('public.events_eventattendee_id_seq'::regclass);


--
-- Name: events_eventcategory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventcategory ALTER COLUMN id SET DEFAULT nextval('public.events_eventcategory_id_seq'::regclass);


--
-- Name: events_eventitem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem ALTER COLUMN id SET DEFAULT nextval('public.events_eventitem_id_seq'::regclass);


--
-- Name: events_eventitem_transportation_pickup_locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations ALTER COLUMN id SET DEFAULT nextval('public.events_eventitem_transportation_pickup_locations_id_seq'::regclass);


--
-- Name: events_eventitemgroup id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitemgroup ALTER COLUMN id SET DEFAULT nextval('public.events_eventitemgroup_id_seq'::regclass);


--
-- Name: events_eventregistrationtype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventregistrationtype ALTER COLUMN id SET DEFAULT nextval('public.events_eventregistrationtype_id_seq'::regclass);


--
-- Name: events_eventtype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventtype ALTER COLUMN id SET DEFAULT nextval('public.events_eventtype_id_seq'::regclass);


--
-- Name: events_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_images ALTER COLUMN id SET DEFAULT nextval('public.events_images_id_seq'::regclass);


--
-- Name: events_organizer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_organizer ALTER COLUMN id SET DEFAULT nextval('public.events_organizer_id_seq'::regclass);


--
-- Name: events_organizer_logo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_organizer_logo ALTER COLUMN id SET DEFAULT nextval('public.events_organizer_logo_id_seq'::regclass);


--
-- Name: events_phonenumber id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_phonenumber ALTER COLUMN id SET DEFAULT nextval('public.events_phonenumber_id_seq'::regclass);


--
-- Name: events_transportationinfo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_transportationinfo ALTER COLUMN id SET DEFAULT nextval('public.events_transportationinfo_id_seq'::regclass);


--
-- Name: events_transportationpickuplocation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_transportationpickuplocation ALTER COLUMN id SET DEFAULT nextval('public.events_transportationpickuplocation_id_seq'::regclass);


--
-- Name: items_itemcategory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemcategory ALTER COLUMN id SET DEFAULT nextval('public.items_itemcategory_id_seq'::regclass);


--
-- Name: items_itemmaster id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemmaster ALTER COLUMN id SET DEFAULT nextval('public.items_itemmaster_id_seq'::regclass);


--
-- Name: items_itemprocessmaster id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemprocessmaster ALTER COLUMN id SET DEFAULT nextval('public.items_itemprocessmaster_id_seq'::regclass);


--
-- Name: items_itemservice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemservice ALTER COLUMN id SET DEFAULT nextval('public.items_itemservice_id_seq'::regclass);


--
-- Name: items_unitofmeasurement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_unitofmeasurement ALTER COLUMN id SET DEFAULT nextval('public.items_unitofmeasurement_id_seq'::regclass);


--
-- Name: orders_cancellationpolicy id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_cancellationpolicy ALTER COLUMN id SET DEFAULT nextval('public.orders_cancellationpolicy_id_seq'::regclass);


--
-- Name: orders_order id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order ALTER COLUMN id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: orders_order_order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order_order_items ALTER COLUMN id SET DEFAULT nextval('public.orders_order_order_items_id_seq'::regclass);


--
-- Name: orders_ordercfyandordernumbertracker id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordercfyandordernumbertracker ALTER COLUMN id SET DEFAULT nextval('public.orders_ordercfyandordernumbertracker_id_seq'::regclass);


--
-- Name: orders_ordereditem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem ALTER COLUMN id SET DEFAULT nextval('public.orders_ordereditem_id_seq'::regclass);


--
-- Name: users_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user ALTER COLUMN id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: users_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_groups ALTER COLUMN id SET DEFAULT nextval('public.users_user_groups_id_seq'::regclass);


--
-- Name: users_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.users_user_user_permissions_id_seq'::regclass);


--
-- Data for Name: account_emailaddress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_emailaddress (id, email, verified, "primary", user_id) FROM stdin;
\.


--
-- Data for Name: account_emailconfirmation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_emailconfirmation (id, created, sent, key, email_address_id) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
1	Attendee
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
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
52	Can add unit of measurement	18	add_unitofmeasurement
53	Can change unit of measurement	18	change_unitofmeasurement
54	Can delete unit of measurement	18	delete_unitofmeasurement
55	Can add configuration	19	add_configuration
56	Can change configuration	19	change_configuration
57	Can delete configuration	19	delete_configuration
58	Can add event	20	add_event
59	Can change event	20	change_event
60	Can delete event	20	delete_event
61	Can add event attendee	21	add_eventattendee
62	Can change event attendee	21	change_eventattendee
63	Can delete event attendee	21	delete_eventattendee
64	Can add event category	22	add_eventcategory
65	Can change event category	22	change_eventcategory
66	Can delete event category	22	delete_eventcategory
67	Can add event item	23	add_eventitem
68	Can change event item	23	change_eventitem
69	Can delete event item	23	delete_eventitem
70	Can add event item group	24	add_eventitemgroup
71	Can change event item group	24	change_eventitemgroup
72	Can delete event item group	24	delete_eventitemgroup
73	Can add event registration type	25	add_eventregistrationtype
74	Can change event registration type	25	change_eventregistrationtype
75	Can delete event registration type	25	delete_eventregistrationtype
76	Can add event type	26	add_eventtype
77	Can change event type	26	change_eventtype
78	Can delete event type	26	delete_eventtype
79	Can add images	27	add_images
80	Can change images	27	change_images
81	Can delete images	27	delete_images
82	Can add organizer	28	add_organizer
83	Can change organizer	28	change_organizer
84	Can delete organizer	28	delete_organizer
85	Can add phone number	29	add_phonenumber
86	Can change phone number	29	change_phonenumber
87	Can delete phone number	29	delete_phonenumber
88	Can add transportation info	30	add_transportationinfo
89	Can change transportation info	30	change_transportationinfo
90	Can delete transportation info	30	delete_transportationinfo
91	Can add transportation pickup location	31	add_transportationpickuplocation
92	Can change transportation pickup location	31	change_transportationpickuplocation
93	Can delete transportation pickup location	31	delete_transportationpickuplocation
94	Can add coupon	32	add_coupon
95	Can change coupon	32	change_coupon
96	Can delete coupon	32	delete_coupon
97	Can add item cart	33	add_itemcart
98	Can change item cart	33	change_itemcart
99	Can delete item cart	33	delete_itemcart
100	Can add cancellation policy	34	add_cancellationpolicy
101	Can change cancellation policy	34	change_cancellationpolicy
102	Can delete cancellation policy	34	delete_cancellationpolicy
103	Can add order	35	add_order
104	Can change order	35	change_order
105	Can delete order	35	delete_order
106	Can add order cfy and order number tracker	36	add_ordercfyandordernumbertracker
107	Can change order cfy and order number tracker	36	change_ordercfyandordernumbertracker
108	Can delete order cfy and order number tracker	36	delete_ordercfyandordernumbertracker
109	Can add ordered item	37	add_ordereditem
110	Can change ordered item	37	change_ordereditem
111	Can delete ordered item	37	delete_ordereditem
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
\.


--
-- Data for Name: carts_itemcart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts_itemcart (id, created_at, updated_at, deleted_at, uuid, transaction_type, quantity, rate, amount, discount, amount_net, item_sc, amount_taxable, item_tax, amount_final, is_coupon_item, entry_from_ordered_item, canceled_ordered_item_id, coupon_id, event_id, event_attendee_id, event_item_id, event_registration_type_id, item_master_id, ordered_by_attendee_id, ordered_by_user_id, transportation_info_id, user_id, apply_cancellation_policy) FROM stdin;
\.


--
-- Data for Name: coupons_coupon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupons_coupon (id, created_at, updated_at, deleted_at, uuid, coupon_code, amount_limit, amount_used, type, status, notes, created_by_id, item_master_id, updated_by_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
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
18	items	unitofmeasurement
19	events	configuration
20	events	event
21	events	eventattendee
22	events	eventcategory
23	events	eventitem
24	events	eventitemgroup
25	events	eventregistrationtype
26	events	eventtype
27	events	images
28	events	organizer
29	events	phonenumber
30	events	transportationinfo
31	events	transportationpickuplocation
32	coupons	coupon
33	carts	itemcart
34	orders	cancellationpolicy
35	orders	order
36	orders	ordercfyandordernumbertracker
37	orders	ordereditem
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2019-05-03 13:21:24.599958+05:45
2	contenttypes	0002_remove_content_type_name	2019-05-03 13:21:24.675686+05:45
3	auth	0001_initial	2019-05-03 13:21:25.466455+05:45
4	auth	0002_alter_permission_name_max_length	2019-05-03 13:21:25.520945+05:45
5	auth	0003_alter_user_email_max_length	2019-05-03 13:21:25.559254+05:45
6	auth	0004_alter_user_username_opts	2019-05-03 13:21:25.598137+05:45
7	auth	0005_alter_user_last_login_null	2019-05-03 13:21:25.641414+05:45
8	auth	0006_require_contenttypes_0002	2019-05-03 13:21:25.654082+05:45
9	auth	0007_alter_validators_add_error_messages	2019-05-03 13:21:25.695421+05:45
10	auth	0008_alter_user_username_max_length	2019-05-03 13:21:25.738744+05:45
11	auth	0009_alter_user_last_name_max_length	2019-05-03 13:21:25.778427+05:45
12	users	0001_initial	2019-05-03 13:21:26.577382+05:45
13	account	0001_initial	2019-05-03 13:21:27.209706+05:45
14	account	0002_email_max_length	2019-05-03 13:21:27.297853+05:45
15	admin	0001_initial	2019-05-03 13:21:27.609415+05:45
16	admin	0002_logentry_remove_auto_add	2019-05-03 13:21:27.674994+05:45
17	authtoken	0001_initial	2019-05-03 13:21:28.053298+05:45
18	authtoken	0002_auto_20160226_1747	2019-05-03 13:21:28.295519+05:45
19	items	0001_initial	2019-05-03 13:21:29.831869+05:45
20	events	0001_initial	2019-05-03 13:21:37.120698+05:45
21	coupons	0001_initial	2019-05-03 13:21:37.937344+05:45
22	orders	0001_initial	2019-05-03 13:21:40.914183+05:45
23	carts	0001_initial	2019-05-03 13:21:42.846558+05:45
24	carts	0002_auto_20190428_1133	2019-05-03 13:21:43.768942+05:45
25	events	0002_auto_20190426_1130	2019-05-03 13:21:43.921443+05:45
26	events	0003_eventattendee_registration_is_cancelled	2019-05-03 13:21:44.677027+05:45
27	events	0004_auto_20190501_1711	2019-05-03 13:21:45.042534+05:45
28	events	0005_event_only_offsite_registration	2019-05-03 13:21:45.489479+05:45
29	orders	0002_auto_20190428_1133	2019-05-03 13:21:45.863614+05:45
30	sessions	0001_initial	2019-05-03 13:21:46.089479+05:45
31	sites	0001_initial	2019-05-03 13:21:46.196622+05:45
32	sites	0002_alter_domain_unique	2019-05-03 13:21:46.351879+05:45
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Data for Name: events_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_configuration (id, created_at, updated_at, deleted_at, uuid, key, value) FROM stdin;
1	2019-05-03 13:21:57.780206+05:45	2019-05-03 13:21:57.780321+05:45	\N	e7b60d97-41a5-423c-9481-bfe7b232716c	contact_number_first	 (07) 3077 9668 
2	2019-05-03 13:21:57.790379+05:45	2019-05-03 13:21:57.790472+05:45	\N	48d8e2f1-11f0-4beb-ae72-b5dad8f0276c	contact_number_second	
3	2019-05-03 13:21:57.801017+05:45	2019-05-03 13:21:57.801143+05:45	\N	9f64b00b-a559-4882-9b0d-6b04277e4df6	contact_email	amaroo@gmail.com
4	2019-05-03 13:21:57.813819+05:45	2019-05-03 13:21:57.813945+05:45	\N	ae8c1c60-3b9b-441f-bb19-0a726e9676b9	facebook_link	https://www.facebook.com/
5	2019-05-03 13:21:57.824972+05:45	2019-05-03 13:21:57.82509+05:45	\N	b6dfa894-0447-4e87-a2d4-fecf76fa7001	instagram_link	https://www.instagram.com/
6	2019-05-03 13:21:57.835728+05:45	2019-05-03 13:21:57.835848+05:45	\N	48a79ac0-cdcf-4a23-988a-0eb592f44198	nipuna_website_link	http://www.nipunaprabidhiksewa.com/
7	2019-05-03 13:21:57.846142+05:45	2019-05-03 13:21:57.846257+05:45	\N	b6ffa23f-f2c9-4bf7-a3ed-c6f05b008edd	youtube_link	https://www.youtube.com/
8	2019-05-03 13:21:57.856784+05:45	2019-05-03 13:21:57.856902+05:45	\N	67c01a58-b898-4985-a583-f24bd40a1b8c	linkedin_link	https://www.linkedin.com/
9	2019-05-03 13:21:57.867523+05:45	2019-05-03 13:21:57.867643+05:45	\N	8339180b-297d-4970-868a-82bb4306f5a4	copyright_content	<small>Ivory's Rock Conventions and Events, 310 Mount Flinders Rd, Peak Crossing QLD 4306 '</small>
10	2019-05-03 13:21:57.878276+05:45	2019-05-03 13:21:57.878395+05:45	\N	d44334ad-4853-426e-bfab-5efcd0f2d48b	powered_by	Nipuna Prabidhik sewa
11	2019-05-03 13:21:57.888556+05:45	2019-05-03 13:21:57.888671+05:45	\N	ff392ff5-abd6-48ab-b569-cf66dfb316ff	footer_description	<small>"Peace will be mankind’s greatest achievement” <br>Prem Rawat</small>
\.


--
-- Data for Name: events_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_event (id, created_at, updated_at, deleted_at, title, uuid, description, start_date, end_date, early_bird_date, is_single_day_event, start_time, end_time, venue_location, label, summary, allow_group_registration, max_group_limit, status, show_total_capacity, show_remaining_seats, is_published, show_start_time, show_end_time, timezone, category_id, organizer_id, type_id, only_offsite_registration) FROM stdin;
1	2019-05-03 13:28:59.955946+05:45	2019-05-03 13:28:59.956046+05:45	\N	Positive Peace WorkShop	67f4a840-0bba-44d2-b513-24e02612a477		2019-05-26 11:45:00+05:45	2012-06-01 11:45:00+05:45	2019-04-26 11:45:00+05:45	f	06:00:00	18:00:00	Ivory	“Peace is Possible”	<p>You are invited to a Positive Peace Workshop in Queensland, hosted by The Institute of Economics and Peace (IEP) together with Ivory’s Rock Foundation (IRF). It will be held on the weekend of 23rd &amp; 24th August 2019 (dates to be confirmed) at Ivory’s Rock.</p>	t	1000	Open	t	t	t	t	t	Australia/Lord_Howe	1	1	2	f
\.


--
-- Data for Name: events_event_description_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_event_description_images (id, event_id, images_id) FROM stdin;
\.


--
-- Data for Name: events_event_title_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_event_title_images (id, event_id, images_id) FROM stdin;
\.


--
-- Data for Name: events_eventattendee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_eventattendee (id, created_at, updated_at, deleted_at, uuid, smart_card_number, name_in_smart_card, alternate_email, alternate_phone_number, is_senior_citizen, is_pwk, registration_status, group_type, confirmation_code, changed_to_offsite, note, event_id, event_registration_type_id, registered_by_id, user_id, registration_is_cancelled) FROM stdin;
\.


--
-- Data for Name: events_eventcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_eventcategory (id, created_at, updated_at, deleted_at, uuid, name, description) FROM stdin;
1	2019-05-03 13:27:37.596951+05:45	2019-05-03 13:27:37.597026+05:45	\N	b39cce9a-6cb2-492a-8953-7d09a813c699	Amaroo	
\.


--
-- Data for Name: events_eventitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_eventitem (id, created_at, updated_at, deleted_at, uuid, group_type, item_capacity, items_booked, item_sharing_count, discount_before_early_bird, discount_after_early_bird, is_day_pass_item, senior_citizen_discount_applicable, ask_for_arrival_datetime, ask_for_departure_datetime, ask_for_pickup_location, event_id, event_registration_type_id, group_id, item_master_id) FROM stdin;
1	2019-05-03 13:48:31.713095+05:45	2019-05-03 13:48:51.282874+05:45	\N	7e6eb0f3-1211-44eb-80ba-606287bd2aad	Both	1000	0	1	10.00	0.00	f	t	f	f	f	1	1	1	15
2	2019-05-03 13:48:31.742726+05:45	2019-05-03 13:48:51.355869+05:45	\N	d3f8e0b4-107c-4f6f-bba0-f59b7f73709b	OnSite	1000	0	1	10.00	0.00	f	f	f	f	f	1	1	2	16
3	2019-05-03 13:48:31.765424+05:45	2019-05-03 13:48:51.377855+05:45	\N	9f2ee8c5-201f-43b3-a09e-6712786a4152	OnSite	1000	0	2	10.00	0.00	f	f	f	f	f	1	1	2	17
4	2019-05-03 13:48:31.787223+05:45	2019-05-03 13:48:51.399712+05:45	\N	58d4e18a-00cf-4bc0-8bcf-3864a699cc1b	OnSite	1000	0	1	10.00	0.00	f	f	f	f	f	1	1	2	18
5	2019-05-03 13:48:31.808733+05:45	2019-05-03 13:48:51.422397+05:45	\N	11fb79dd-ddf5-4737-ae7d-41baf12cbc8d	OnSite	1000	0	2	10.00	0.00	f	f	f	f	f	1	1	2	19
6	2019-05-03 13:48:31.831238+05:45	2019-05-03 13:48:51.444762+05:45	\N	2d69494a-5f09-4d4a-8b28-cd9e07b5ae4a	OnSite	1000	0	3	10.00	0.00	f	f	f	f	f	1	1	2	20
7	2019-05-03 13:48:31.854559+05:45	2019-05-03 13:48:51.466237+05:45	\N	9fc21cae-1199-4c0a-a3c7-d90881d6ee96	OnSite	1000	0	1	10.00	0.00	f	f	f	f	f	1	1	2	21
8	2019-05-03 13:48:31.875733+05:45	2019-05-03 13:48:51.488282+05:45	\N	c0b71f20-f7e7-4960-90a7-1f576a97e989	OnSite	1000	0	2	10.00	0.00	f	f	f	f	f	1	1	2	22
9	2019-05-03 13:48:31.89806+05:45	2019-05-03 13:48:51.510496+05:45	\N	e9c002d1-10fe-4829-bf41-22924542f86d	OnSite	1000	0	1	10.00	0.00	f	f	f	f	f	1	1	2	23
10	2019-05-03 13:48:31.919602+05:45	2019-05-03 13:48:51.532723+05:45	\N	1d79f043-4666-47bb-98d6-a99cb8c8b93f	OnSite	1000	0	2	10.00	0.00	f	f	f	f	f	1	1	2	24
11	2019-05-03 13:48:31.942265+05:45	2019-05-03 13:48:51.554984+05:45	\N	cbedaf0a-4d97-488f-a533-0915a8c7a6db	OnSite	1000	0	3	10.00	0.00	f	f	f	f	f	1	1	2	25
12	2019-05-03 13:48:31.964287+05:45	2019-05-03 13:48:51.577701+05:45	\N	c1220771-a802-4c3f-8e19-d5e249f5dd5d	OnSite	1000	0	4	10.00	0.00	f	f	f	f	f	1	1	2	26
13	2019-05-03 13:48:31.98722+05:45	2019-05-03 13:48:51.600748+05:45	\N	fbd5a5df-2802-4d09-b3a8-e8d115679bc3	OnSite	1000	0	1	10.00	0.00	f	f	f	f	f	1	1	2	27
14	2019-05-03 13:48:32.008569+05:45	2019-05-03 13:48:51.622064+05:45	\N	bb4c239c-2fc5-4cc9-9670-4d64ac7d5c54	OnSite	1000	0	1	10.00	0.00	f	f	f	f	f	1	1	2	28
15	2019-05-03 13:48:32.030829+05:45	2019-05-03 13:48:51.644177+05:45	\N	73dd6cc2-9007-4835-9cf1-46bcf7a64f0e	OnSite	1000	0	2	10.00	0.00	f	f	f	f	f	1	1	2	29
16	2019-05-03 13:48:32.053564+05:45	2019-05-03 13:48:51.665944+05:45	\N	0b5549da-f2a6-41f3-a509-133a16929869	OnSite	1000	0	2	10.00	0.00	f	f	f	f	f	1	1	2	30
17	2019-05-03 13:48:32.07862+05:45	2019-05-03 13:48:51.688045+05:45	\N	44352148-87fa-4f20-ae29-9515f3f34d7a	OnSite	1000	0	1	10.00	0.00	f	f	t	t	f	1	1	3	31
18	2019-05-03 13:48:32.0974+05:45	2019-05-03 13:48:51.710155+05:45	\N	8327044e-5e77-4fc5-8d23-f7d2842214a1	OnSite	1000	0	1	10.00	0.00	f	f	t	f	t	1	1	3	32
19	2019-05-03 13:48:32.119766+05:45	2019-05-03 13:48:51.73263+05:45	\N	2efa570f-ec8b-4bcc-9cf0-dc7742096656	OnSite	1000	0	1	10.00	0.00	f	f	t	t	t	1	1	3	33
20	2019-05-03 13:48:32.144104+05:45	2019-05-03 13:48:51.754521+05:45	\N	2f8be3d8-4c8d-416b-9f3c-319b9692b795	OnSite	1000	0	1	10.00	0.00	f	f	f	t	t	1	1	3	34
21	2019-05-03 13:48:32.164201+05:45	2019-05-03 13:48:51.776807+05:45	\N	f24ff5ee-a340-4333-adb3-adb1aeb9e869	OnSite	1000	0	1	10.00	0.00	f	f	t	t	t	1	1	3	35
22	2019-05-03 13:48:32.187292+05:45	2019-05-03 13:48:51.798997+05:45	\N	94ed8df8-3cb2-43a0-991e-7bf052698575	OnSite	1000	0	1	10.00	0.00	f	f	t	t	t	1	1	3	36
23	2019-05-03 13:48:32.20878+05:45	2019-05-03 13:48:51.82086+05:45	\N	9c0fbf60-0574-4b11-8329-40e862052d6c	OffSite	1000	0	1	10.00	0.00	t	f	f	f	f	1	1	1	37
24	2019-05-03 13:48:32.230446+05:45	2019-05-03 13:48:51.851005+05:45	\N	581cbe3b-890b-4449-8c79-465d486759e5	OffSite	1000	0	1	10.00	0.00	t	f	f	f	f	1	1	1	38
25	2019-05-03 13:48:32.252754+05:45	2019-05-03 13:48:51.876687+05:45	\N	9c542593-6124-4742-8717-aca927012673	OffSite	1000	0	1	10.00	0.00	t	f	f	f	f	1	1	1	39
26	2019-05-03 13:48:32.274863+05:45	2019-05-03 13:48:51.898665+05:45	\N	2e3b4370-4c3a-4253-a3b3-6b0a09fb21a7	OffSite	1000	0	1	10.00	0.00	t	f	f	f	f	1	1	1	40
27	2019-05-03 13:48:32.299434+05:45	2019-05-03 13:48:51.923296+05:45	\N	d55e0a5d-7298-466b-bbc8-c262cd870cc2	OffSite	1000	0	1	10.00	0.00	t	f	f	f	f	1	1	1	41
\.


--
-- Data for Name: events_eventitem_transportation_pickup_locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_eventitem_transportation_pickup_locations (id, eventitem_id, transportationpickuplocation_id) FROM stdin;
\.


--
-- Data for Name: events_eventitemgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_eventitemgroup (id, created_at, updated_at, deleted_at, uuid, name, slug, description, is_multi_select, icon_type, event_id, event_registration_type_id) FROM stdin;
1	2019-05-03 13:48:31.277435+05:45	2019-05-03 13:48:50.904989+05:45	\N	d0328ec5-c695-455c-9d64-13479a30d7ca	Registration	Registration		f		1	1
2	2019-05-03 13:48:31.309124+05:45	2019-05-03 13:48:50.931694+05:45	\N	220c4877-0479-4d68-8ea7-3e0f03b3f707	Accommodation	Accommodation		f		1	1
3	2019-05-03 13:48:31.331596+05:45	2019-05-03 13:48:50.953874+05:45	\N	4deec061-1015-4f25-b286-6f5f8d6ecdc4	Transportation	Transportation		f		1	1
\.


--
-- Data for Name: events_eventregistrationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_eventregistrationtype (id, created_at, updated_at, deleted_at, uuid, name, total_capacity, is_published, status, required_otp, is_public, event_id) FROM stdin;
1	2019-05-03 13:29:00.131193+05:45	2019-05-03 13:29:00.131281+05:45	\N	38e162ef-f3a9-4bd5-ab6c-efe2e902ef33		0	f	Testing	f	t	1
\.


--
-- Data for Name: events_eventtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_eventtype (id, created_at, updated_at, deleted_at, uuid, name, description) FROM stdin;
2	2019-05-03 13:27:37.618662+05:45	2019-05-03 13:27:37.61875+05:45	\N	be8a08c0-2323-4fd9-873a-69a2361634ee	Test Type	
\.


--
-- Data for Name: events_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_images (id, created_at, updated_at, deleted_at, title, image) FROM stdin;
\.


--
-- Data for Name: events_organizer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_organizer (id, created_at, updated_at, deleted_at, uuid, name, location, description) FROM stdin;
1	2019-05-03 13:27:37.561724+05:45	2019-05-03 13:27:37.561802+05:45	\N	6d0f493b-bca7-421c-8785-8b9114adceaa	Amaroo Test		
\.


--
-- Data for Name: events_organizer_logo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_organizer_logo (id, organizer_id, images_id) FROM stdin;
\.


--
-- Data for Name: events_phonenumber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_phonenumber (id, created_at, updated_at, deleted_at, is_visible, phone_number, country, label, event_id, organizer_id) FROM stdin;
\.


--
-- Data for Name: events_transportationinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_transportationinfo (id, created_at, updated_at, deleted_at, uuid, arrival_datetime, departure_datetime, pickup_location_id) FROM stdin;
\.


--
-- Data for Name: events_transportationpickuplocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events_transportationpickuplocation (id, created_at, updated_at, deleted_at, uuid, location, latitude, longitude, description, event_id, event_item_id) FROM stdin;
\.


--
-- Data for Name: items_itemcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_itemcategory (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-05-03 13:21:57.917143+05:45	2019-05-03 13:21:57.91728+05:45	\N	f4f9b9e8-575a-4f8d-a696-3eb5a1a02e2e	Receipt
2	2019-05-03 13:21:57.929168+05:45	2019-05-03 13:21:57.929342+05:45	\N	8c22143f-5e50-4715-a0a7-ef5e0f9ee5d9	Refund
3	2019-05-03 13:21:57.937935+05:45	2019-05-03 13:21:57.938016+05:45	\N	ee52229e-e315-4a5a-a13d-f2b050bbaec4	Coupon
4	2019-05-03 13:21:57.945113+05:45	2019-05-03 13:21:57.945314+05:45	\N	2cd09b82-e75e-4c9d-b773-a1ce8abf2c16	Service Charge
5	2019-05-03 13:21:57.958216+05:45	2019-05-03 13:21:57.958339+05:45	\N	e67ca15c-a2e6-44cc-8a39-17ae67b71c60	Applicable Tax
6	2019-05-03 13:21:57.96741+05:45	2019-05-03 13:21:57.967527+05:45	\N	c3e3ef2d-efa6-4f23-ba1d-570d01a346a0	Balance
7	2019-05-03 13:22:11.868035+05:45	2019-05-03 13:22:11.868121+05:45	\N	66db2206-06e2-4f76-8eea-bc59456a90ff	Event-Test-Category
\.


--
-- Data for Name: items_itemmaster; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_itemmaster (id, created_at, updated_at, deleted_at, uuid, name, options, item_for_booking, item_for_sale, item_for_purchase, item_for_stock, item_for_rent, item_for_package, item_has_substitute, item_is_veg, item_is_non_veg, item_is_liquor, item_is_balance_topup, item_is_balance_used, item_is_reward, item_is_discount, item_is_service_charge, item_is_tax, senior_citizen_discount_per, ask_for_delivery, item_rate, item_sc_per, item_tax_per, item_mrp, is_public, status, is_coupon_item, item_in_stock, item_rate_deposits, has_addon_items, description, category_id, process_id, service_id, uom_id) FROM stdin;
1	2019-05-03 13:21:58.382858+05:45	2019-05-03 13:21:58.382955+05:45	\N	23178ef2-51ab-485a-a26b-d76d425ac266	Bank-Payment		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	1	1	1	1
2	2019-05-03 13:21:58.397261+05:45	2019-05-03 13:21:58.397347+05:45	\N	3e7657c0-43ed-408e-95da-5efaf7e9c40d	Cash-Payment		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	1	1	1	1
3	2019-05-03 13:21:58.409804+05:45	2019-05-03 13:21:58.409885+05:45	\N	1660b4e2-69e3-4a5d-b08a-a49448b6b0b5	Credit-Card-Payment		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	1	1	1	1
4	2019-05-03 13:21:58.422068+05:45	2019-05-03 13:21:58.422164+05:45	\N	80082f2d-b067-4f00-b95d-2842fcd7d358	Refund		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	2	1	2	1
5	2019-05-03 13:21:58.43597+05:45	2019-05-03 13:21:58.436052+05:45	\N	5d631e9f-9587-4431-9758-ce3b8186f299	Discount-Coupon		f	t	f	t	f	f	f	f	f	f	f	f	f	t	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	t	1	0.00	f	Default Created Item Masters	3	1	3	1
6	2019-05-03 13:21:58.449364+05:45	2019-05-03 13:21:58.449495+05:45	\N	e5c1f400-6a62-4fd2-a115-01ba33bc9306	Credit-Coupon		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	t	1	0.00	f	Default Created Item Masters	3	1	3	1
7	2019-05-03 13:21:58.467777+05:45	2019-05-03 13:21:58.467939+05:45	\N	71e58bc8-8ad9-436b-8a73-1339e2fbe28d	Debit-Coupon		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	t	1	0.00	f	Default Created Item Masters	3	1	3	1
8	2019-05-03 13:21:58.486184+05:45	2019-05-03 13:21:58.486318+05:45	\N	105b2b0a-0c1a-4854-96f0-8612311bdd91	Senior-Citizen-Discount		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	t	1	0.00	f	Default Created Item Masters	3	1	3	1
9	2019-05-03 13:21:58.500357+05:45	2019-05-03 13:21:58.500461+05:45	\N	3e38e6c5-67b2-4bef-be60-bcf443166fef	Total-Applicable-Service-Charge		f	t	f	t	f	f	f	f	f	f	f	f	f	f	t	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	4	1	5	1
10	2019-05-03 13:21:58.513087+05:45	2019-05-03 13:21:58.513168+05:45	\N	05dda850-9dea-4e39-bb20-265f6902c3bf	Total-Canceled-Service-Charge		f	t	f	t	f	f	f	f	f	f	f	f	f	f	t	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	4	1	5	1
11	2019-05-03 13:21:58.52471+05:45	2019-05-03 13:21:58.524791+05:45	\N	713a0ac4-5e1e-4978-838c-88b5018be8a5	Total-Applicable-Tax		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	t	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	5	1	4	1
12	2019-05-03 13:21:58.536243+05:45	2019-05-03 13:21:58.536323+05:45	\N	79d98770-bbed-4ce8-ba46-d6340e8ac881	Total-Canceled-Tax		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	t	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	5	1	4	1
13	2019-05-03 13:21:58.548661+05:45	2019-05-03 13:21:58.548752+05:45	\N	7e63ad1e-63e4-4d8f-b37b-2c6a07b55c03	Balance-TopUp		f	t	f	t	f	f	f	f	f	f	t	f	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	6	1	6	1
14	2019-05-03 13:21:58.56192+05:45	2019-05-03 13:21:58.562042+05:45	\N	7fdcea0d-30fc-44ec-8a96-b8d3a9ff55cc	Balance-Used		f	t	f	t	f	f	f	f	f	f	f	t	f	f	f	f	0.00	f	0.00	0.00	0.00	0.00	t	t	f	1	0.00	f	Default Created Item Masters	6	1	6	1
19	2019-05-03 13:27:36.973194+05:45	2019-05-03 13:48:50.334823+05:45	\N	421eced5-d039-4af0-9c31-d717dabf21ed	SC – Motorhome Space. Two People (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	2450.00	10.00	10.00	2940.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
20	2019-05-03 13:27:36.994239+05:45	2019-05-03 13:48:50.358081+05:45	\N	60866922-a224-42ff-a740-11a23b896fee	SC – Motorhome Space. Three People (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	3550.00	10.00	10.00	4260.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
21	2019-05-03 13:27:37.018253+05:45	2019-05-03 13:48:50.379578+05:45	\N	83914287-d817-4ebc-ba23-7a1708e5401b	SC – Yellow/ Green Bunkhouse Single (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	2400.00	10.00	10.00	2880.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
22	2019-05-03 13:27:37.03916+05:45	2019-05-03 13:48:50.40239+05:45	\N	bfd13c1e-cdcf-402c-b2ae-e951e3a263ce	SC – Yellow/ Green Bunkhouse Twin. Two people (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	3600.00	10.00	10.00	4320.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
23	2019-05-03 13:27:37.073083+05:45	2019-05-03 13:48:50.424111+05:45	\N	2ac9e041-0c09-4507-803b-5bc4188adbb4	SC - Swagman BYO tent single. One person (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	300.00	10.00	10.00	360.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
24	2019-05-03 13:27:37.105798+05:45	2019-05-03 13:48:50.446192+05:45	\N	d176e5ed-4bb0-4085-a54e-20c447a1cdb5	SC - Swagman BYO tent. Two People (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	600.00	10.00	10.00	720.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
25	2019-05-03 13:27:37.130037+05:45	2019-05-03 13:48:50.468536+05:45	\N	69fa3347-1bcc-4bd9-ba98-c18742116c3e	SC - Swagman BYO tent. Three People (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	900.00	10.00	10.00	1080.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
26	2019-05-03 13:27:37.161734+05:45	2019-05-03 13:48:50.490323+05:45	\N	014c61cc-6cd2-45af-93b9-13f773075ad7	Swagman BYO tent. Four People (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	1200.00	10.00	10.00	1440.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
27	2019-05-03 13:27:37.193839+05:45	2019-05-03 13:48:50.51229+05:45	\N	78f4ab99-6677-4a9e-96e6-135ea3ddb603	SC – Orange Cabin single w/ Ensuite (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	3100.00	10.00	10.00	3720.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
28	2019-05-03 13:27:37.21495+05:45	2019-05-03 13:48:50.534991+05:45	\N	72b01116-c6b7-4987-b6de-05fec7f8df90	JAC- Deluxe Tent Single (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	2980.00	10.00	10.00	3576.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
29	2019-05-03 13:27:37.237948+05:45	2019-05-03 13:48:50.557049+05:45	\N	4b259b02-94b4-4e6e-9224-d8b7150097b8	JAC - Deluxe Tent Double. Two People (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	3300.00	10.00	10.00	3960.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
30	2019-05-03 13:27:37.261182+05:45	2019-05-03 13:48:50.579622+05:45	\N	a24e014f-f9c6-4a8b-a974-c7ddb5c81d70	JAC- Deluxe Tent Twin. Two People (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	3300.00	10.00	10.00	3960.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
31	2019-05-03 13:27:37.283258+05:45	2019-05-03 13:48:50.601906+05:45	\N	a9a4f768-9f01-4309-90ea-4fc55dc35f4e	Line 1: Brisbane Airport– Amaroo – Brisbane Airport (2 trips)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	140.00	10.00	10.00	168.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
32	2019-05-03 13:27:37.303266+05:45	2019-05-03 13:48:50.623606+05:45	\N	9db41d76-79a8-4a09-9b18-d9bfb1e46609	Line 2: Brisbane Airport to Amaroo – (one way, Day 8th Sep or Day 9th Sep)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	80.00	10.00	10.00	96.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
33	2019-05-03 13:27:37.328192+05:45	2019-05-03 13:48:50.645793+05:45	\N	5bea18e0-7850-4be7-901e-69d06c1e3eb5	Line 3: Amaroo to Brisbane Airport– (one way, Day 15th Sep).		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	80.00	10.00	10.00	96.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
34	2019-05-03 13:27:37.350082+05:45	2019-05-03 13:48:50.668415+05:45	\N	185aba99-d8f2-4b26-a8c0-61b22af73397	Line 4: Brisbane Sheraton Hotel – Amaroo – Brisbane Sheraton Hotel (10 trips)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	350.00	10.00	10.00	420.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
35	2019-05-03 13:27:37.370762+05:45	2019-05-03 13:48:50.690695+05:45	\N	75888458-f6c9-43bb-9161-c25b130b21df	Line 5: Ipswich Pick up points – Amaroo reception– Ipswich (10 trips)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	290.00	10.00	10.00	348.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
36	2019-05-03 13:27:37.39436+05:45	2019-05-03 13:48:50.712413+05:45	\N	80ede7da-9f5c-4d36-b8ad-5598905fab08	Line 6: Onsite Pavilion - Amphitheatre – Onsite Pavilion. (10 trips)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	60.00	10.00	10.00	72.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
37	2019-05-03 13:27:37.418275+05:45	2019-05-03 13:48:50.734416+05:45	\N	ea4a502e-5572-461a-9f95-a7e2ecbc2556	Day pass -first day )		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
38	2019-05-03 13:27:37.448472+05:45	2019-05-03 13:48:50.756576+05:45	\N	3d50a88d-f3aa-4eb2-98a3-77dbbc3aea26	Day pass -second day )		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
16	2019-05-03 13:27:36.85145+05:45	2019-05-03 13:48:50.25087+05:45	\N	ad673330-4403-4147-b68c-a17fa3554123	SC - Pioneer Tent Single (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	1570.00	10.00	10.00	1884.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
17	2019-05-03 13:27:36.884623+05:45	2019-05-03 13:48:50.290626+05:45	\N	4cae4a56-f5cb-45d2-adc9-3d2bc8e906e0	SC - Pioneer Tent Twin. For two people (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	1760.00	10.00	10.00	2112.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
18	2019-05-03 13:27:36.905467+05:45	2019-05-03 13:48:50.312596+05:45	\N	bdb5244a-23c1-4a35-926d-1ebead1a9f47	SC – Motorhome Space Single. One Person (7 nights)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	1350.00	10.00	10.00	1620.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
15	2019-05-03 13:27:36.756346+05:45	2019-05-03 13:48:50.156501+05:45	\N	36a325a4-a2a8-4b61-a696-077db82e8d95	Conference Fee (5 days)		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	10.00	f	560.00	0.00	0.00	560.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
39	2019-05-03 13:27:37.473915+05:45	2019-05-03 13:48:50.778875+05:45	\N	f5e9777d-c2e9-4303-bf90-8e1844114c1a	Day pass -third day )		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
40	2019-05-03 13:27:37.505369+05:45	2019-05-03 13:48:50.800951+05:45	\N	8ae8607e-ce2c-48cb-bf77-1ae4379d1360	Day pass -fourth day )		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
41	2019-05-03 13:27:37.528322+05:45	2019-05-03 13:48:50.823263+05:45	\N	e96e0230-4a72-4bcc-af69-83e3fd7e68db	Day pass -fifth day )		f	t	f	t	f	f	f	f	f	f	f	f	f	f	f	f	0.00	f	120.00	0.00	0.00	120.00	t	t	f	1000	0.00	f	Created Item Masters	7	1	7	1
\.


--
-- Data for Name: items_itemprocessmaster; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_itemprocessmaster (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-05-03 13:21:58.045571+05:45	2019-05-03 13:21:58.045649+05:45	\N	f0821ab1-bbf7-48ae-b0c8-0e2106b9691c	GEN
\.


--
-- Data for Name: items_itemservice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_itemservice (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-05-03 13:21:57.982712+05:45	2019-05-03 13:21:57.982787+05:45	\N	637bc113-d627-42e0-938f-51bcd0a7670d	Receipt
2	2019-05-03 13:21:57.990185+05:45	2019-05-03 13:21:57.990284+05:45	\N	470529ae-53fd-4e88-bb85-5ce86284a7e4	Refund
3	2019-05-03 13:21:57.998658+05:45	2019-05-03 13:21:57.998766+05:45	\N	8af260b8-da85-4628-b39f-d8d49c5974ea	Coupon
4	2019-05-03 13:21:58.007188+05:45	2019-05-03 13:21:58.007309+05:45	\N	78f6c1ea-6a53-466d-8c04-7c90b97779c3	Applicable Tax
5	2019-05-03 13:21:58.017482+05:45	2019-05-03 13:21:58.017613+05:45	\N	200775a5-4e29-4c83-a37e-e8c5dc1da083	Service Charge
6	2019-05-03 13:21:58.027984+05:45	2019-05-03 13:21:58.028109+05:45	\N	ba26e3c4-8d06-4f50-a089-95f689002724	Balance
7	2019-05-03 13:27:36.135805+05:45	2019-05-03 13:27:36.135898+05:45	\N	7d2c16ad-0383-48a1-90c3-7a9330e6d9ad	Event-Test-Service
\.


--
-- Data for Name: items_unitofmeasurement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_unitofmeasurement (id, created_at, updated_at, deleted_at, uuid, name) FROM stdin;
1	2019-05-03 13:21:58.05991+05:45	2019-05-03 13:21:58.06+05:45	\N	6093657f-88c2-4968-a91c-fca8a8be41db	units
\.


--
-- Data for Name: orders_cancellationpolicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_cancellationpolicy (id, created_at, updated_at, deleted_at, uuid, period_from, period_to, cancellation_per, event_id, event_item_id, item_master_id) FROM stdin;
\.


--
-- Data for Name: orders_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_order (id, created_at, updated_at, deleted_at, uuid, order_number, order_cfy, transaction_type, balance, balance_credit, device_id, web_initiated, app_initiated, one_time_password, notes, delivery_access, order_status, event_id, event_attendee_id, event_registration_type_id, operator_id, previous_order_id, user_id) FROM stdin;
\.


--
-- Data for Name: orders_order_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_order_order_items (id, order_id, ordereditem_id) FROM stdin;
\.


--
-- Data for Name: orders_ordercfyandordernumbertracker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_ordercfyandordernumbertracker (id, created_at, updated_at, deleted_at, latest_order_number, latest_order_cfy) FROM stdin;
\.


--
-- Data for Name: orders_ordereditem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_ordereditem (id, created_at, updated_at, deleted_at, uuid, order_number, order_cfy, transaction_type, transaction_reference_id, privileged, quantity, rate, amount, discount, amount_net, item_sc, amount_taxable, item_tax, amount_final, is_coupon_item, notes, actual_item_master_id, canceled_ordered_item_id, coupon_id, event_attendee_id, event_item_id, item_master_id, parent_order_id, transportation_info_id, user_id) FROM stdin;
\.


--
-- Data for Name: users_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined, uuid, phone_number, city, country, profile_picture, gender) FROM stdin;
\.


--
-- Data for Name: users_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: users_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_emailaddress_id_seq', 1, false);


--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_emailconfirmation_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 111, true);


--
-- Name: carts_itemcart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_itemcart_id_seq', 1, false);


--
-- Name: coupons_coupon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupons_coupon_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 37, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 32, true);


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- Name: events_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_configuration_id_seq', 11, true);


--
-- Name: events_event_description_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_event_description_images_id_seq', 1, false);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_event_id_seq', 1, true);


--
-- Name: events_event_title_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_event_title_images_id_seq', 1, false);


--
-- Name: events_eventattendee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_eventattendee_id_seq', 1, false);


--
-- Name: events_eventcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_eventcategory_id_seq', 1, true);


--
-- Name: events_eventitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_eventitem_id_seq', 27, true);


--
-- Name: events_eventitem_transportation_pickup_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_eventitem_transportation_pickup_locations_id_seq', 1, false);


--
-- Name: events_eventitemgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_eventitemgroup_id_seq', 3, true);


--
-- Name: events_eventregistrationtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_eventregistrationtype_id_seq', 1, true);


--
-- Name: events_eventtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_eventtype_id_seq', 2, true);


--
-- Name: events_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_images_id_seq', 1, false);


--
-- Name: events_organizer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_organizer_id_seq', 1, true);


--
-- Name: events_organizer_logo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_organizer_logo_id_seq', 1, false);


--
-- Name: events_phonenumber_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_phonenumber_id_seq', 1, false);


--
-- Name: events_transportationinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_transportationinfo_id_seq', 1, false);


--
-- Name: events_transportationpickuplocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_transportationpickuplocation_id_seq', 1, false);


--
-- Name: items_itemcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_itemcategory_id_seq', 7, true);


--
-- Name: items_itemmaster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_itemmaster_id_seq', 41, true);


--
-- Name: items_itemprocessmaster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_itemprocessmaster_id_seq', 1, true);


--
-- Name: items_itemservice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_itemservice_id_seq', 7, true);


--
-- Name: items_unitofmeasurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_unitofmeasurement_id_seq', 1, true);


--
-- Name: orders_cancellationpolicy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_cancellationpolicy_id_seq', 1, false);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 1, false);


--
-- Name: orders_order_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_order_items_id_seq', 1, false);


--
-- Name: orders_ordercfyandordernumbertracker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_ordercfyandordernumbertracker_id_seq', 1, false);


--
-- Name: orders_ordereditem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_ordereditem_id_seq', 1, false);


--
-- Name: users_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_groups_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_user_permissions_id_seq', 1, false);


--
-- Name: account_emailaddress account_emailaddress_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_email_key UNIQUE (email);


--
-- Name: account_emailaddress account_emailaddress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_pkey PRIMARY KEY (id);


--
-- Name: account_emailconfirmation account_emailconfirmation_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_key_key UNIQUE (key);


--
-- Name: account_emailconfirmation account_emailconfirmation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: carts_itemcart carts_itemcart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_pkey PRIMARY KEY (id);


--
-- Name: coupons_coupon coupons_coupon_coupon_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons_coupon
    ADD CONSTRAINT coupons_coupon_coupon_code_key UNIQUE (coupon_code);


--
-- Name: coupons_coupon coupons_coupon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons_coupon
    ADD CONSTRAINT coupons_coupon_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: events_configuration events_configuration_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_configuration
    ADD CONSTRAINT events_configuration_key_key UNIQUE (key);


--
-- Name: events_configuration events_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_configuration
    ADD CONSTRAINT events_configuration_pkey PRIMARY KEY (id);


--
-- Name: events_event_description_images events_event_description_event_id_images_id_e06d0b33_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_description_images
    ADD CONSTRAINT events_event_description_event_id_images_id_e06d0b33_uniq UNIQUE (event_id, images_id);


--
-- Name: events_event_description_images events_event_description_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_description_images
    ADD CONSTRAINT events_event_description_images_pkey PRIMARY KEY (id);


--
-- Name: events_event events_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_pkey PRIMARY KEY (id);


--
-- Name: events_event_title_images events_event_title_images_event_id_images_id_6c00599b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_title_images
    ADD CONSTRAINT events_event_title_images_event_id_images_id_6c00599b_uniq UNIQUE (event_id, images_id);


--
-- Name: events_event_title_images events_event_title_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_title_images
    ADD CONSTRAINT events_event_title_images_pkey PRIMARY KEY (id);


--
-- Name: events_eventattendee events_eventattendee_event_id_user_id_da8d1711_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventattendee
    ADD CONSTRAINT events_eventattendee_event_id_user_id_da8d1711_uniq UNIQUE (event_id, user_id);


--
-- Name: events_eventattendee events_eventattendee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventattendee
    ADD CONSTRAINT events_eventattendee_pkey PRIMARY KEY (id);


--
-- Name: events_eventcategory events_eventcategory_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventcategory
    ADD CONSTRAINT events_eventcategory_name_key UNIQUE (name);


--
-- Name: events_eventcategory events_eventcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventcategory
    ADD CONSTRAINT events_eventcategory_pkey PRIMARY KEY (id);


--
-- Name: events_eventitem events_eventitem_item_master_id_event_reg_8368f83e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem
    ADD CONSTRAINT events_eventitem_item_master_id_event_reg_8368f83e_uniq UNIQUE (item_master_id, event_registration_type_id, event_id, group_type);


--
-- Name: events_eventitem events_eventitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem
    ADD CONSTRAINT events_eventitem_pkey PRIMARY KEY (id);


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_transpo_eventitem_id_transportat_39b277e4_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
    ADD CONSTRAINT events_eventitem_transpo_eventitem_id_transportat_39b277e4_uniq UNIQUE (eventitem_id, transportationpickuplocation_id);


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_transportation_pickup_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
    ADD CONSTRAINT events_eventitem_transportation_pickup_locations_pkey PRIMARY KEY (id);


--
-- Name: events_eventitemgroup events_eventitemgroup_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitemgroup
    ADD CONSTRAINT events_eventitemgroup_name_key UNIQUE (name);


--
-- Name: events_eventitemgroup events_eventitemgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitemgroup
    ADD CONSTRAINT events_eventitemgroup_pkey PRIMARY KEY (id);


--
-- Name: events_eventitemgroup events_eventitemgroup_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitemgroup
    ADD CONSTRAINT events_eventitemgroup_slug_key UNIQUE (slug);


--
-- Name: events_eventregistrationtype events_eventregistrationtype_name_event_id_ca2aa05d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventregistrationtype
    ADD CONSTRAINT events_eventregistrationtype_name_event_id_ca2aa05d_uniq UNIQUE (name, event_id);


--
-- Name: events_eventregistrationtype events_eventregistrationtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventregistrationtype
    ADD CONSTRAINT events_eventregistrationtype_pkey PRIMARY KEY (id);


--
-- Name: events_eventtype events_eventtype_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventtype
    ADD CONSTRAINT events_eventtype_name_key UNIQUE (name);


--
-- Name: events_eventtype events_eventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventtype
    ADD CONSTRAINT events_eventtype_pkey PRIMARY KEY (id);


--
-- Name: events_images events_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_images
    ADD CONSTRAINT events_images_pkey PRIMARY KEY (id);


--
-- Name: events_organizer_logo events_organizer_logo_organizer_id_images_id_b680dffd_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_organizer_logo
    ADD CONSTRAINT events_organizer_logo_organizer_id_images_id_b680dffd_uniq UNIQUE (organizer_id, images_id);


--
-- Name: events_organizer_logo events_organizer_logo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_organizer_logo
    ADD CONSTRAINT events_organizer_logo_pkey PRIMARY KEY (id);


--
-- Name: events_organizer events_organizer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_organizer
    ADD CONSTRAINT events_organizer_pkey PRIMARY KEY (id);


--
-- Name: events_phonenumber events_phonenumber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_phonenumber
    ADD CONSTRAINT events_phonenumber_pkey PRIMARY KEY (id);


--
-- Name: events_transportationinfo events_transportationinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_transportationinfo
    ADD CONSTRAINT events_transportationinfo_pkey PRIMARY KEY (id);


--
-- Name: events_transportationpickuplocation events_transportationpickuplocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_transportationpickuplocation
    ADD CONSTRAINT events_transportationpickuplocation_pkey PRIMARY KEY (id);


--
-- Name: items_itemcategory items_itemcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemcategory
    ADD CONSTRAINT items_itemcategory_pkey PRIMARY KEY (id);


--
-- Name: items_itemmaster items_itemmaster_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemmaster
    ADD CONSTRAINT items_itemmaster_name_key UNIQUE (name);


--
-- Name: items_itemmaster items_itemmaster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemmaster
    ADD CONSTRAINT items_itemmaster_pkey PRIMARY KEY (id);


--
-- Name: items_itemprocessmaster items_itemprocessmaster_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemprocessmaster
    ADD CONSTRAINT items_itemprocessmaster_name_key UNIQUE (name);


--
-- Name: items_itemprocessmaster items_itemprocessmaster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemprocessmaster
    ADD CONSTRAINT items_itemprocessmaster_pkey PRIMARY KEY (id);


--
-- Name: items_itemservice items_itemservice_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemservice
    ADD CONSTRAINT items_itemservice_name_key UNIQUE (name);


--
-- Name: items_itemservice items_itemservice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemservice
    ADD CONSTRAINT items_itemservice_pkey PRIMARY KEY (id);


--
-- Name: items_unitofmeasurement items_unitofmeasurement_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_unitofmeasurement
    ADD CONSTRAINT items_unitofmeasurement_name_key UNIQUE (name);


--
-- Name: items_unitofmeasurement items_unitofmeasurement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_unitofmeasurement
    ADD CONSTRAINT items_unitofmeasurement_pkey PRIMARY KEY (id);


--
-- Name: orders_cancellationpolicy orders_cancellationpolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_cancellationpolicy
    ADD CONSTRAINT orders_cancellationpolicy_pkey PRIMARY KEY (id);


--
-- Name: orders_order_order_items orders_order_order_items_order_id_ordereditem_id_e0859148_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order_order_items
    ADD CONSTRAINT orders_order_order_items_order_id_ordereditem_id_e0859148_uniq UNIQUE (order_id, ordereditem_id);


--
-- Name: orders_order_order_items orders_order_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order_order_items
    ADD CONSTRAINT orders_order_order_items_pkey PRIMARY KEY (id);


--
-- Name: orders_order orders_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_pkey PRIMARY KEY (id);


--
-- Name: orders_order orders_order_previous_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_previous_order_id_key UNIQUE (previous_order_id);


--
-- Name: orders_ordercfyandordernumbertracker orders_ordercfyandordernumbertracker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordercfyandordernumbertracker
    ADD CONSTRAINT orders_ordercfyandordernumbertracker_pkey PRIMARY KEY (id);


--
-- Name: orders_ordereditem orders_ordereditem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_pkey PRIMARY KEY (id);


--
-- Name: users_user_groups users_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_pkey PRIMARY KEY (id);


--
-- Name: users_user_groups users_user_groups_user_id_group_id_b88eab82_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_user_id_group_id_b88eab82_uniq UNIQUE (user_id, group_id);


--
-- Name: users_user users_user_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user
    ADD CONSTRAINT users_user_phone_number_key UNIQUE (phone_number);


--
-- Name: users_user users_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user
    ADD CONSTRAINT users_user_pkey PRIMARY KEY (id);


--
-- Name: users_user_user_permissions users_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: users_user_user_permissions users_user_user_permissions_user_id_permission_id_43338c45_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_permissions_user_id_permission_id_43338c45_uniq UNIQUE (user_id, permission_id);


--
-- Name: users_user users_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user
    ADD CONSTRAINT users_user_username_key UNIQUE (username);


--
-- Name: users_user users_user_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user
    ADD CONSTRAINT users_user_uuid_key UNIQUE (uuid);


--
-- Name: account_emailaddress_email_03be32b2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailaddress_email_03be32b2_like ON public.account_emailaddress USING btree (email varchar_pattern_ops);


--
-- Name: account_emailaddress_user_id_2c513194; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailaddress_user_id_2c513194 ON public.account_emailaddress USING btree (user_id);


--
-- Name: account_emailconfirmation_email_address_id_5b7f8c58; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailconfirmation_email_address_id_5b7f8c58 ON public.account_emailconfirmation USING btree (email_address_id);


--
-- Name: account_emailconfirmation_key_f43612bd_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailconfirmation_key_f43612bd_like ON public.account_emailconfirmation USING btree (key varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: carts_itemcart_canceled_ordered_item_id_c280e8f6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_canceled_ordered_item_id_c280e8f6 ON public.carts_itemcart USING btree (canceled_ordered_item_id);


--
-- Name: carts_itemcart_coupon_id_a7574b90; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_coupon_id_a7574b90 ON public.carts_itemcart USING btree (coupon_id);


--
-- Name: carts_itemcart_event_attendee_id_7db9b6e4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_event_attendee_id_7db9b6e4 ON public.carts_itemcart USING btree (event_attendee_id);


--
-- Name: carts_itemcart_event_id_0d0e4026; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_event_id_0d0e4026 ON public.carts_itemcart USING btree (event_id);


--
-- Name: carts_itemcart_event_item_id_8b1fb48e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_event_item_id_8b1fb48e ON public.carts_itemcart USING btree (event_item_id);


--
-- Name: carts_itemcart_event_registration_type_id_56d6d387; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_event_registration_type_id_56d6d387 ON public.carts_itemcart USING btree (event_registration_type_id);


--
-- Name: carts_itemcart_item_master_id_5bd78ba2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_item_master_id_5bd78ba2 ON public.carts_itemcart USING btree (item_master_id);


--
-- Name: carts_itemcart_ordered_by_attendee_id_1eece008; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_ordered_by_attendee_id_1eece008 ON public.carts_itemcart USING btree (ordered_by_attendee_id);


--
-- Name: carts_itemcart_ordered_by_user_id_029a65e3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_ordered_by_user_id_029a65e3 ON public.carts_itemcart USING btree (ordered_by_user_id);


--
-- Name: carts_itemcart_transportation_info_id_916348b1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_transportation_info_id_916348b1 ON public.carts_itemcart USING btree (transportation_info_id);


--
-- Name: carts_itemcart_user_id_991b5985; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_user_id_991b5985 ON public.carts_itemcart USING btree (user_id);


--
-- Name: carts_itemcart_uuid_a61670bc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carts_itemcart_uuid_a61670bc ON public.carts_itemcart USING btree (uuid);


--
-- Name: coupons_coupon_coupon_code_3740035b_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coupons_coupon_coupon_code_3740035b_like ON public.coupons_coupon USING btree (coupon_code varchar_pattern_ops);


--
-- Name: coupons_coupon_created_by_id_fe24d2f8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coupons_coupon_created_by_id_fe24d2f8 ON public.coupons_coupon USING btree (created_by_id);


--
-- Name: coupons_coupon_item_master_id_b872032a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coupons_coupon_item_master_id_b872032a ON public.coupons_coupon USING btree (item_master_id);


--
-- Name: coupons_coupon_updated_by_id_4c1b9fe1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coupons_coupon_updated_by_id_4c1b9fe1 ON public.coupons_coupon USING btree (updated_by_id);


--
-- Name: coupons_coupon_user_id_869fbce6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coupons_coupon_user_id_869fbce6 ON public.coupons_coupon USING btree (user_id);


--
-- Name: coupons_coupon_uuid_fbff0065; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX coupons_coupon_uuid_fbff0065 ON public.coupons_coupon USING btree (uuid);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- Name: events_configuration_key_5679fb06_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_configuration_key_5679fb06_like ON public.events_configuration USING btree (key varchar_pattern_ops);


--
-- Name: events_configuration_uuid_f1a7f95b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_configuration_uuid_f1a7f95b ON public.events_configuration USING btree (uuid);


--
-- Name: events_event_category_id_01d3a3ab; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_category_id_01d3a3ab ON public.events_event USING btree (category_id);


--
-- Name: events_event_description_images_event_id_71121a0c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_description_images_event_id_71121a0c ON public.events_event_description_images USING btree (event_id);


--
-- Name: events_event_description_images_images_id_d2988044; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_description_images_images_id_d2988044 ON public.events_event_description_images USING btree (images_id);


--
-- Name: events_event_organizer_id_3afa7809; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_organizer_id_3afa7809 ON public.events_event USING btree (organizer_id);


--
-- Name: events_event_title_images_event_id_7368d00e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_title_images_event_id_7368d00e ON public.events_event_title_images USING btree (event_id);


--
-- Name: events_event_title_images_images_id_30d76ec5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_title_images_images_id_30d76ec5 ON public.events_event_title_images USING btree (images_id);


--
-- Name: events_event_type_id_04a81abf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_type_id_04a81abf ON public.events_event USING btree (type_id);


--
-- Name: events_event_uuid_995d6a76; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_event_uuid_995d6a76 ON public.events_event USING btree (uuid);


--
-- Name: events_eventattendee_event_id_33c2c3c3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventattendee_event_id_33c2c3c3 ON public.events_eventattendee USING btree (event_id);


--
-- Name: events_eventattendee_event_registration_type_id_2832b659; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventattendee_event_registration_type_id_2832b659 ON public.events_eventattendee USING btree (event_registration_type_id);


--
-- Name: events_eventattendee_registered_by_id_bab87466; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventattendee_registered_by_id_bab87466 ON public.events_eventattendee USING btree (registered_by_id);


--
-- Name: events_eventattendee_user_id_c7184780; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventattendee_user_id_c7184780 ON public.events_eventattendee USING btree (user_id);


--
-- Name: events_eventattendee_uuid_9043a359; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventattendee_uuid_9043a359 ON public.events_eventattendee USING btree (uuid);


--
-- Name: events_eventcategory_name_35473597_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventcategory_name_35473597_like ON public.events_eventcategory USING btree (name varchar_pattern_ops);


--
-- Name: events_eventcategory_uuid_4a02c778; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventcategory_uuid_4a02c778 ON public.events_eventcategory USING btree (uuid);


--
-- Name: events_eventitem_event_id_cf2bf671; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitem_event_id_cf2bf671 ON public.events_eventitem USING btree (event_id);


--
-- Name: events_eventitem_event_registration_type_id_ec0ad176; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitem_event_registration_type_id_ec0ad176 ON public.events_eventitem USING btree (event_registration_type_id);


--
-- Name: events_eventitem_group_id_858c2af0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitem_group_id_858c2af0 ON public.events_eventitem USING btree (group_id);


--
-- Name: events_eventitem_item_master_id_c4a33dc0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitem_item_master_id_c4a33dc0 ON public.events_eventitem USING btree (item_master_id);


--
-- Name: events_eventitem_transport_eventitem_id_e9bdec6b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitem_transport_eventitem_id_e9bdec6b ON public.events_eventitem_transportation_pickup_locations USING btree (eventitem_id);


--
-- Name: events_eventitem_transport_transportationpickuplocati_6a4d3e80; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitem_transport_transportationpickuplocati_6a4d3e80 ON public.events_eventitem_transportation_pickup_locations USING btree (transportationpickuplocation_id);


--
-- Name: events_eventitem_uuid_73535b85; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitem_uuid_73535b85 ON public.events_eventitem USING btree (uuid);


--
-- Name: events_eventitemgroup_event_id_f04f589f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitemgroup_event_id_f04f589f ON public.events_eventitemgroup USING btree (event_id);


--
-- Name: events_eventitemgroup_event_registration_type_id_21c7d3eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitemgroup_event_registration_type_id_21c7d3eb ON public.events_eventitemgroup USING btree (event_registration_type_id);


--
-- Name: events_eventitemgroup_name_5d8ba6ad_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitemgroup_name_5d8ba6ad_like ON public.events_eventitemgroup USING btree (name varchar_pattern_ops);


--
-- Name: events_eventitemgroup_slug_824706c8_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitemgroup_slug_824706c8_like ON public.events_eventitemgroup USING btree (slug varchar_pattern_ops);


--
-- Name: events_eventitemgroup_uuid_7a9158b4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventitemgroup_uuid_7a9158b4 ON public.events_eventitemgroup USING btree (uuid);


--
-- Name: events_eventregistrationtype_event_id_66aa3ce3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventregistrationtype_event_id_66aa3ce3 ON public.events_eventregistrationtype USING btree (event_id);


--
-- Name: events_eventregistrationtype_uuid_108d0080; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventregistrationtype_uuid_108d0080 ON public.events_eventregistrationtype USING btree (uuid);


--
-- Name: events_eventtype_name_cce2755e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventtype_name_cce2755e_like ON public.events_eventtype USING btree (name varchar_pattern_ops);


--
-- Name: events_eventtype_uuid_8e3add22; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_eventtype_uuid_8e3add22 ON public.events_eventtype USING btree (uuid);


--
-- Name: events_organizer_logo_images_id_4faa7e9b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_organizer_logo_images_id_4faa7e9b ON public.events_organizer_logo USING btree (images_id);


--
-- Name: events_organizer_logo_organizer_id_fa0d7e56; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_organizer_logo_organizer_id_fa0d7e56 ON public.events_organizer_logo USING btree (organizer_id);


--
-- Name: events_organizer_uuid_b006dddb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_organizer_uuid_b006dddb ON public.events_organizer USING btree (uuid);


--
-- Name: events_phonenumber_event_id_8605cfa0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_phonenumber_event_id_8605cfa0 ON public.events_phonenumber USING btree (event_id);


--
-- Name: events_phonenumber_organizer_id_123667e6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_phonenumber_organizer_id_123667e6 ON public.events_phonenumber USING btree (organizer_id);


--
-- Name: events_transportationinfo_pickup_location_id_097c0787; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_transportationinfo_pickup_location_id_097c0787 ON public.events_transportationinfo USING btree (pickup_location_id);


--
-- Name: events_transportationinfo_uuid_54434a67; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_transportationinfo_uuid_54434a67 ON public.events_transportationinfo USING btree (uuid);


--
-- Name: events_transportationpickuplocation_event_id_d4b381ff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_transportationpickuplocation_event_id_d4b381ff ON public.events_transportationpickuplocation USING btree (event_id);


--
-- Name: events_transportationpickuplocation_event_item_id_94fb3885; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_transportationpickuplocation_event_item_id_94fb3885 ON public.events_transportationpickuplocation USING btree (event_item_id);


--
-- Name: events_transportationpickuplocation_uuid_07a2ad37; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_transportationpickuplocation_uuid_07a2ad37 ON public.events_transportationpickuplocation USING btree (uuid);


--
-- Name: items_itemcategory_uuid_7983b435; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemcategory_uuid_7983b435 ON public.items_itemcategory USING btree (uuid);


--
-- Name: items_itemmaster_category_id_afc81150; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemmaster_category_id_afc81150 ON public.items_itemmaster USING btree (category_id);


--
-- Name: items_itemmaster_name_b59b3ed6_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemmaster_name_b59b3ed6_like ON public.items_itemmaster USING btree (name varchar_pattern_ops);


--
-- Name: items_itemmaster_process_id_515be385; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemmaster_process_id_515be385 ON public.items_itemmaster USING btree (process_id);


--
-- Name: items_itemmaster_service_id_3378e529; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemmaster_service_id_3378e529 ON public.items_itemmaster USING btree (service_id);


--
-- Name: items_itemmaster_uom_id_6770be75; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemmaster_uom_id_6770be75 ON public.items_itemmaster USING btree (uom_id);


--
-- Name: items_itemmaster_uuid_cf2c74e2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemmaster_uuid_cf2c74e2 ON public.items_itemmaster USING btree (uuid);


--
-- Name: items_itemprocessmaster_name_5381fda9_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemprocessmaster_name_5381fda9_like ON public.items_itemprocessmaster USING btree (name varchar_pattern_ops);


--
-- Name: items_itemprocessmaster_uuid_2b76e3d0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemprocessmaster_uuid_2b76e3d0 ON public.items_itemprocessmaster USING btree (uuid);


--
-- Name: items_itemservice_name_ca838a67_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemservice_name_ca838a67_like ON public.items_itemservice USING btree (name varchar_pattern_ops);


--
-- Name: items_itemservice_uuid_fe1cfce7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_itemservice_uuid_fe1cfce7 ON public.items_itemservice USING btree (uuid);


--
-- Name: items_unitofmeasurement_name_6ea49bb6_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_unitofmeasurement_name_6ea49bb6_like ON public.items_unitofmeasurement USING btree (name varchar_pattern_ops);


--
-- Name: items_unitofmeasurement_uuid_07a29426; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX items_unitofmeasurement_uuid_07a29426 ON public.items_unitofmeasurement USING btree (uuid);


--
-- Name: orders_cancellationpolicy_event_id_53e11aed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_cancellationpolicy_event_id_53e11aed ON public.orders_cancellationpolicy USING btree (event_id);


--
-- Name: orders_cancellationpolicy_event_item_id_33cc800f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_cancellationpolicy_event_item_id_33cc800f ON public.orders_cancellationpolicy USING btree (event_item_id);


--
-- Name: orders_cancellationpolicy_item_master_id_7d608eea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_cancellationpolicy_item_master_id_7d608eea ON public.orders_cancellationpolicy USING btree (item_master_id);


--
-- Name: orders_cancellationpolicy_uuid_73189d9f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_cancellationpolicy_uuid_73189d9f ON public.orders_cancellationpolicy USING btree (uuid);


--
-- Name: orders_order_event_attendee_id_faa52c0e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_event_attendee_id_faa52c0e ON public.orders_order USING btree (event_attendee_id);


--
-- Name: orders_order_event_id_93dbcf6a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_event_id_93dbcf6a ON public.orders_order USING btree (event_id);


--
-- Name: orders_order_event_registration_type_id_9ece983e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_event_registration_type_id_9ece983e ON public.orders_order USING btree (event_registration_type_id);


--
-- Name: orders_order_operator_id_cf8860d8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_operator_id_cf8860d8 ON public.orders_order USING btree (operator_id);


--
-- Name: orders_order_order_items_order_id_c7cd9418; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_order_items_order_id_c7cd9418 ON public.orders_order_order_items USING btree (order_id);


--
-- Name: orders_order_order_items_ordereditem_id_3b0a2c09; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_order_items_ordereditem_id_3b0a2c09 ON public.orders_order_order_items USING btree (ordereditem_id);


--
-- Name: orders_order_user_id_e9b59eb1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_user_id_e9b59eb1 ON public.orders_order USING btree (user_id);


--
-- Name: orders_order_uuid_3ed97bb1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_uuid_3ed97bb1 ON public.orders_order USING btree (uuid);


--
-- Name: orders_ordereditem_actual_item_master_id_8f570a98; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_actual_item_master_id_8f570a98 ON public.orders_ordereditem USING btree (actual_item_master_id);


--
-- Name: orders_ordereditem_canceled_ordered_item_id_0b9fab98; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_canceled_ordered_item_id_0b9fab98 ON public.orders_ordereditem USING btree (canceled_ordered_item_id);


--
-- Name: orders_ordereditem_coupon_id_40995887; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_coupon_id_40995887 ON public.orders_ordereditem USING btree (coupon_id);


--
-- Name: orders_ordereditem_event_attendee_id_cecdd7bd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_event_attendee_id_cecdd7bd ON public.orders_ordereditem USING btree (event_attendee_id);


--
-- Name: orders_ordereditem_event_item_id_59c562fe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_event_item_id_59c562fe ON public.orders_ordereditem USING btree (event_item_id);


--
-- Name: orders_ordereditem_item_master_id_88693c8a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_item_master_id_88693c8a ON public.orders_ordereditem USING btree (item_master_id);


--
-- Name: orders_ordereditem_parent_order_id_c9cd4fd1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_parent_order_id_c9cd4fd1 ON public.orders_ordereditem USING btree (parent_order_id);


--
-- Name: orders_ordereditem_transportation_info_id_24ea98ee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_transportation_info_id_24ea98ee ON public.orders_ordereditem USING btree (transportation_info_id);


--
-- Name: orders_ordereditem_user_id_415dc09b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_user_id_415dc09b ON public.orders_ordereditem USING btree (user_id);


--
-- Name: orders_ordereditem_uuid_0041bf46; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_ordereditem_uuid_0041bf46 ON public.orders_ordereditem USING btree (uuid);


--
-- Name: users_user_groups_group_id_9afc8d0e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_user_groups_group_id_9afc8d0e ON public.users_user_groups USING btree (group_id);


--
-- Name: users_user_groups_user_id_5f6f5a90; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_user_groups_user_id_5f6f5a90 ON public.users_user_groups USING btree (user_id);


--
-- Name: users_user_phone_number_aff54ffd_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_user_phone_number_aff54ffd_like ON public.users_user USING btree (phone_number varchar_pattern_ops);


--
-- Name: users_user_user_permissions_permission_id_0b93982e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_user_user_permissions_permission_id_0b93982e ON public.users_user_user_permissions USING btree (permission_id);


--
-- Name: users_user_user_permissions_user_id_20aca447; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_user_user_permissions_user_id_20aca447 ON public.users_user_user_permissions USING btree (user_id);


--
-- Name: users_user_username_06e46fe6_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_user_username_06e46fe6_like ON public.users_user USING btree (username varchar_pattern_ops);


--
-- Name: account_emailaddress account_emailaddress_user_id_2c513194_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_user_id_2c513194_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_emailconfirmation account_emailconfirm_email_address_id_5b7f8c58_fk_account_e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirm_email_address_id_5b7f8c58_fk_account_e FOREIGN KEY (email_address_id) REFERENCES public.account_emailaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_canceled_ordered_ite_c280e8f6_fk_orders_or; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_canceled_ordered_ite_c280e8f6_fk_orders_or FOREIGN KEY (canceled_ordered_item_id) REFERENCES public.orders_ordereditem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_coupon_id_a7574b90_fk_coupons_coupon_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_coupon_id_a7574b90_fk_coupons_coupon_id FOREIGN KEY (coupon_id) REFERENCES public.coupons_coupon(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_event_attendee_id_7db9b6e4_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_event_attendee_id_7db9b6e4_fk_events_ev FOREIGN KEY (event_attendee_id) REFERENCES public.events_eventattendee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_event_id_0d0e4026_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_event_id_0d0e4026_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_event_item_id_8b1fb48e_fk_events_eventitem_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_event_item_id_8b1fb48e_fk_events_eventitem_id FOREIGN KEY (event_item_id) REFERENCES public.events_eventitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_event_registration_t_56d6d387_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_event_registration_t_56d6d387_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_item_master_id_5bd78ba2_fk_items_itemmaster_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_item_master_id_5bd78ba2_fk_items_itemmaster_id FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_ordered_by_attendee__1eece008_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_ordered_by_attendee__1eece008_fk_events_ev FOREIGN KEY (ordered_by_attendee_id) REFERENCES public.events_eventattendee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_ordered_by_user_id_029a65e3_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_ordered_by_user_id_029a65e3_fk_users_user_id FOREIGN KEY (ordered_by_user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_transportation_info__916348b1_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_transportation_info__916348b1_fk_events_tr FOREIGN KEY (transportation_info_id) REFERENCES public.events_transportationinfo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: carts_itemcart carts_itemcart_user_id_991b5985_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts_itemcart
    ADD CONSTRAINT carts_itemcart_user_id_991b5985_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: coupons_coupon coupons_coupon_created_by_id_fe24d2f8_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons_coupon
    ADD CONSTRAINT coupons_coupon_created_by_id_fe24d2f8_fk_users_user_id FOREIGN KEY (created_by_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: coupons_coupon coupons_coupon_item_master_id_b872032a_fk_items_itemmaster_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons_coupon
    ADD CONSTRAINT coupons_coupon_item_master_id_b872032a_fk_items_itemmaster_id FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: coupons_coupon coupons_coupon_updated_by_id_4c1b9fe1_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons_coupon
    ADD CONSTRAINT coupons_coupon_updated_by_id_4c1b9fe1_fk_users_user_id FOREIGN KEY (updated_by_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: coupons_coupon coupons_coupon_user_id_869fbce6_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons_coupon
    ADD CONSTRAINT coupons_coupon_user_id_869fbce6_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_category_id_01d3a3ab_fk_events_eventcategory_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_category_id_01d3a3ab_fk_events_eventcategory_id FOREIGN KEY (category_id) REFERENCES public.events_eventcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_description_images events_event_descrip_event_id_71121a0c_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_description_images
    ADD CONSTRAINT events_event_descrip_event_id_71121a0c_fk_events_ev FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_description_images events_event_descrip_images_id_d2988044_fk_events_im; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_description_images
    ADD CONSTRAINT events_event_descrip_images_id_d2988044_fk_events_im FOREIGN KEY (images_id) REFERENCES public.events_images(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_organizer_id_3afa7809_fk_events_organizer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_organizer_id_3afa7809_fk_events_organizer_id FOREIGN KEY (organizer_id) REFERENCES public.events_organizer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_title_images events_event_title_i_images_id_30d76ec5_fk_events_im; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_title_images
    ADD CONSTRAINT events_event_title_i_images_id_30d76ec5_fk_events_im FOREIGN KEY (images_id) REFERENCES public.events_images(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event_title_images events_event_title_images_event_id_7368d00e_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event_title_images
    ADD CONSTRAINT events_event_title_images_event_id_7368d00e_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_event events_event_type_id_04a81abf_fk_events_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_event
    ADD CONSTRAINT events_event_type_id_04a81abf_fk_events_eventtype_id FOREIGN KEY (type_id) REFERENCES public.events_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_event_id_33c2c3c3_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventattendee
    ADD CONSTRAINT events_eventattendee_event_id_33c2c3c3_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_event_registration_t_2832b659_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventattendee
    ADD CONSTRAINT events_eventattendee_event_registration_t_2832b659_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_registered_by_id_bab87466_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventattendee
    ADD CONSTRAINT events_eventattendee_registered_by_id_bab87466_fk_events_ev FOREIGN KEY (registered_by_id) REFERENCES public.events_eventattendee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventattendee events_eventattendee_user_id_c7184780_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventattendee
    ADD CONSTRAINT events_eventattendee_user_id_c7184780_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_event_id_cf2bf671_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem
    ADD CONSTRAINT events_eventitem_event_id_cf2bf671_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_event_registration_t_ec0ad176_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem
    ADD CONSTRAINT events_eventitem_event_registration_t_ec0ad176_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_group_id_858c2af0_fk_events_eventitemgroup_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem
    ADD CONSTRAINT events_eventitem_group_id_858c2af0_fk_events_eventitemgroup_id FOREIGN KEY (group_id) REFERENCES public.events_eventitemgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem events_eventitem_item_master_id_c4a33dc0_fk_items_itemmaster_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem
    ADD CONSTRAINT events_eventitem_item_master_id_c4a33dc0_fk_items_itemmaster_id FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_tra_eventitem_id_e9bdec6b_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
    ADD CONSTRAINT events_eventitem_tra_eventitem_id_e9bdec6b_fk_events_ev FOREIGN KEY (eventitem_id) REFERENCES public.events_eventitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitem_transportation_pickup_locations events_eventitem_tra_transportationpickup_6a4d3e80_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitem_transportation_pickup_locations
    ADD CONSTRAINT events_eventitem_tra_transportationpickup_6a4d3e80_fk_events_tr FOREIGN KEY (transportationpickuplocation_id) REFERENCES public.events_transportationpickuplocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemgroup events_eventitemgrou_event_registration_t_21c7d3eb_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitemgroup
    ADD CONSTRAINT events_eventitemgrou_event_registration_t_21c7d3eb_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventitemgroup events_eventitemgroup_event_id_f04f589f_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventitemgroup
    ADD CONSTRAINT events_eventitemgroup_event_id_f04f589f_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_eventregistrationtype events_eventregistra_event_id_66aa3ce3_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_eventregistrationtype
    ADD CONSTRAINT events_eventregistra_event_id_66aa3ce3_fk_events_ev FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_organizer_logo events_organizer_log_organizer_id_fa0d7e56_fk_events_or; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_organizer_logo
    ADD CONSTRAINT events_organizer_log_organizer_id_fa0d7e56_fk_events_or FOREIGN KEY (organizer_id) REFERENCES public.events_organizer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_organizer_logo events_organizer_logo_images_id_4faa7e9b_fk_events_images_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_organizer_logo
    ADD CONSTRAINT events_organizer_logo_images_id_4faa7e9b_fk_events_images_id FOREIGN KEY (images_id) REFERENCES public.events_images(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_phonenumber events_phonenumber_event_id_8605cfa0_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_phonenumber
    ADD CONSTRAINT events_phonenumber_event_id_8605cfa0_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_phonenumber events_phonenumber_organizer_id_123667e6_fk_events_organizer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_phonenumber
    ADD CONSTRAINT events_phonenumber_organizer_id_123667e6_fk_events_organizer_id FOREIGN KEY (organizer_id) REFERENCES public.events_organizer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_transportationpickuplocation events_transportatio_event_id_d4b381ff_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_transportationpickuplocation
    ADD CONSTRAINT events_transportatio_event_id_d4b381ff_fk_events_ev FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_transportationpickuplocation events_transportatio_event_item_id_94fb3885_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_transportationpickuplocation
    ADD CONSTRAINT events_transportatio_event_item_id_94fb3885_fk_events_ev FOREIGN KEY (event_item_id) REFERENCES public.events_eventitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: events_transportationinfo events_transportatio_pickup_location_id_097c0787_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events_transportationinfo
    ADD CONSTRAINT events_transportatio_pickup_location_id_097c0787_fk_events_tr FOREIGN KEY (pickup_location_id) REFERENCES public.events_transportationpickuplocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_category_id_afc81150_fk_items_itemcategory_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemmaster
    ADD CONSTRAINT items_itemmaster_category_id_afc81150_fk_items_itemcategory_id FOREIGN KEY (category_id) REFERENCES public.items_itemcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_process_id_515be385_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemmaster
    ADD CONSTRAINT items_itemmaster_process_id_515be385_fk_items_ite FOREIGN KEY (process_id) REFERENCES public.items_itemprocessmaster(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_service_id_3378e529_fk_items_itemservice_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemmaster
    ADD CONSTRAINT items_itemmaster_service_id_3378e529_fk_items_itemservice_id FOREIGN KEY (service_id) REFERENCES public.items_itemservice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: items_itemmaster items_itemmaster_uom_id_6770be75_fk_items_unitofmeasurement_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_itemmaster
    ADD CONSTRAINT items_itemmaster_uom_id_6770be75_fk_items_unitofmeasurement_id FOREIGN KEY (uom_id) REFERENCES public.items_unitofmeasurement(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_cancellationpolicy orders_cancellationp_event_item_id_33cc800f_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_cancellationpolicy
    ADD CONSTRAINT orders_cancellationp_event_item_id_33cc800f_fk_events_ev FOREIGN KEY (event_item_id) REFERENCES public.events_eventitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_cancellationpolicy orders_cancellationp_item_master_id_7d608eea_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_cancellationpolicy
    ADD CONSTRAINT orders_cancellationp_item_master_id_7d608eea_fk_items_ite FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_cancellationpolicy orders_cancellationpolicy_event_id_53e11aed_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_cancellationpolicy
    ADD CONSTRAINT orders_cancellationpolicy_event_id_53e11aed_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order orders_order_event_attendee_id_faa52c0e_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_event_attendee_id_faa52c0e_fk_events_ev FOREIGN KEY (event_attendee_id) REFERENCES public.events_eventattendee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order orders_order_event_id_93dbcf6a_fk_events_event_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_event_id_93dbcf6a_fk_events_event_id FOREIGN KEY (event_id) REFERENCES public.events_event(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order orders_order_event_registration_t_9ece983e_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_event_registration_t_9ece983e_fk_events_ev FOREIGN KEY (event_registration_type_id) REFERENCES public.events_eventregistrationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order orders_order_operator_id_cf8860d8_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_operator_id_cf8860d8_fk_users_user_id FOREIGN KEY (operator_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order_order_items orders_order_order_i_ordereditem_id_3b0a2c09_fk_orders_or; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order_order_items
    ADD CONSTRAINT orders_order_order_i_ordereditem_id_3b0a2c09_fk_orders_or FOREIGN KEY (ordereditem_id) REFERENCES public.orders_ordereditem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order_order_items orders_order_order_items_order_id_c7cd9418_fk_orders_order_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order_order_items
    ADD CONSTRAINT orders_order_order_items_order_id_c7cd9418_fk_orders_order_id FOREIGN KEY (order_id) REFERENCES public.orders_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order orders_order_previous_order_id_32f0c54d_fk_orders_order_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_previous_order_id_32f0c54d_fk_orders_order_id FOREIGN KEY (previous_order_id) REFERENCES public.orders_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order orders_order_user_id_e9b59eb1_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_user_id_e9b59eb1_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_actual_item_master_i_8f570a98_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_actual_item_master_i_8f570a98_fk_items_ite FOREIGN KEY (actual_item_master_id) REFERENCES public.items_itemmaster(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_canceled_ordered_ite_0b9fab98_fk_orders_or; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_canceled_ordered_ite_0b9fab98_fk_orders_or FOREIGN KEY (canceled_ordered_item_id) REFERENCES public.orders_ordereditem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_coupon_id_40995887_fk_coupons_coupon_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_coupon_id_40995887_fk_coupons_coupon_id FOREIGN KEY (coupon_id) REFERENCES public.coupons_coupon(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_event_attendee_id_cecdd7bd_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_event_attendee_id_cecdd7bd_fk_events_ev FOREIGN KEY (event_attendee_id) REFERENCES public.events_eventattendee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_event_item_id_59c562fe_fk_events_ev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_event_item_id_59c562fe_fk_events_ev FOREIGN KEY (event_item_id) REFERENCES public.events_eventitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_item_master_id_88693c8a_fk_items_ite; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_item_master_id_88693c8a_fk_items_ite FOREIGN KEY (item_master_id) REFERENCES public.items_itemmaster(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_parent_order_id_c9cd4fd1_fk_orders_or; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_parent_order_id_c9cd4fd1_fk_orders_or FOREIGN KEY (parent_order_id) REFERENCES public.orders_ordereditem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_transportation_info__24ea98ee_fk_events_tr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_transportation_info__24ea98ee_fk_events_tr FOREIGN KEY (transportation_info_id) REFERENCES public.events_transportationinfo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_ordereditem orders_ordereditem_user_id_415dc09b_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_ordereditem
    ADD CONSTRAINT orders_ordereditem_user_id_415dc09b_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_groups users_user_groups_group_id_9afc8d0e_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_group_id_9afc8d0e_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_groups users_user_groups_user_id_5f6f5a90_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_user_id_5f6f5a90_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_user_permissions users_user_user_perm_permission_id_0b93982e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_perm_permission_id_0b93982e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_user_permissions users_user_user_permissions_user_id_20aca447_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_permissions_user_id_20aca447_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

