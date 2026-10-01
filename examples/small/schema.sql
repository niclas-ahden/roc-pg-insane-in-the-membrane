\restrict FD5byedeLAgimCTz7cKrsoHum6UphKKWoqVvw8VeyGa1yIf6UMwunu3yIIT8hgK
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
CREATE TYPE public.allegiance AS ENUM (
    'rebel_alliance',
    'galactic_empire',
    'hutt_cartel',
    'independent',
    'jedi_order',
    'sith'
);
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE public.planets (
    id integer NOT NULL,
    star_system_id integer NOT NULL,
    name character varying NOT NULL,
    climate character varying,
    terrain character varying,
    diameter_km double precision,
    gravity_standard double precision,
    rotation_period_hours double precision,
    orbital_period_days double precision,
    surface_water_pct double precision,
    population bigint,
    capital_city character varying,
    allegiance public.allegiance DEFAULT 'independent'::public.allegiance NOT NULL,
    imperial_garrison boolean DEFAULT false NOT NULL,
    rebel_cell boolean DEFAULT false NOT NULL,
    breathable_atmosphere boolean DEFAULT true NOT NULL,
    hyperspace_beacon_code character varying,
    spaceport_count integer DEFAULT 0 NOT NULL,
    threat_level integer DEFAULT 0 NOT NULL,
    last_patrol_at timestamp(6) without time zone,
    liberated_at timestamp(6) without time zone,
    occupied_at timestamp(6) without time zone,
    description text,
    holonet_entry_url character varying,
    map_image_key character varying,
    first_contact_on date,
    archived_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT planets_threat_level_range CHECK (((threat_level >= 0) AND (threat_level <= 10)))
);
CREATE SEQUENCE public.planets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.planets_id_seq OWNED BY public.planets.id;
ALTER TABLE ONLY public.planets ALTER COLUMN id SET DEFAULT nextval('public.planets_id_seq'::regclass);
ALTER TABLE ONLY public.planets
    ADD CONSTRAINT planets_pkey PRIMARY KEY (id);
\unrestrict FD5byedeLAgimCTz7cKrsoHum6UphKKWoqVvw8VeyGa1yIf6UMwunu3yIIT8hgK
