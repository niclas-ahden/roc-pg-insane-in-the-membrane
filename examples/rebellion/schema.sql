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
CREATE COLLATION public.case_insensitive (provider = icu, deterministic = false, locale = 'und-u-ks-level2');
CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;
COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE TYPE public.alert_channel AS ENUM (
    'comlink',
    'holonet',
    'datapad'
);
CREATE TYPE public.allegiance AS ENUM (
    'rebel_alliance',
    'galactic_empire',
    'hutt_cartel',
    'independent',
    'jedi_order',
    'sith'
);
CREATE TYPE public.bounty_status AS ENUM (
    'posted',
    'accepted',
    'collected',
    'cancelled',
    'expired'
);
CREATE TYPE public.credit_currency AS ENUM (
    'galactic_credit'
);
CREATE TYPE public.droid_class AS ENUM (
    'astromech',
    'protocol',
    'medical',
    'battle'
);
CREATE TYPE public.force_side AS ENUM (
    'light',
    'dark'
);
CREATE TYPE public.hangar_access AS ENUM (
    'open',
    'restricted'
);
CREATE TYPE public.intel_reliability AS ENUM (
    'unverified',
    'plausible',
    'confirmed',
    'disinformation'
);
CREATE TYPE public.kyber_origin AS ENUM (
    'ilum',
    'jedha',
    'lothal'
);
CREATE TYPE public.lane_status AS ENUM (
    'open',
    'blockaded',
    'collapsed'
);
CREATE TYPE public.mission_status AS ENUM (
    'planned',
    'active',
    'completed',
    'aborted',
    'failed'
);
CREATE TYPE public.ship_condition AS ENUM (
    'operational',
    'damaged',
    'under_repair',
    'destroyed',
    'missing'
);
CREATE TYPE public.sighting_confidence AS ENUM (
    'low',
    'medium',
    'high'
);
CREATE TYPE public.starship_class AS ENUM (
    'starfighter',
    'bomber',
    'freighter',
    'corvette',
    'frigate',
    'cruiser',
    'star_destroyer',
    'shuttle',
    'transport',
    'gunship',
    'space_station'
);
CREATE TYPE public.supply_request_status AS ENUM (
    'draft',
    'submitted',
    'approved',
    'packed',
    'in_transit',
    'delivered',
    'rejected',
    'cancelled'
);
CREATE TYPE public.transfer_direction AS ENUM (
    'incoming',
    'outgoing'
);
CREATE TYPE public.transmission_band AS ENUM (
    'subspace',
    'holonet'
);
CREATE FUNCTION public.normalize_callsign() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if new.callsign is not null then
        new.callsign := upper(btrim(new.callsign));
    end if;
    return new;
end;
$$;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE public.alert_subscriptions (
    id integer NOT NULL,
    operator_id integer NOT NULL,
    channel public.alert_channel NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.alert_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.alert_subscriptions_id_seq OWNED BY public.alert_subscriptions.id;
CREATE TABLE public.api_clients (
    id integer NOT NULL,
    name character varying NOT NULL,
    token character varying DEFAULT encode(public.gen_random_bytes(24), 'hex'::text) NOT NULL,
    scopes character varying DEFAULT 'read'::character varying NOT NULL,
    last_used_at timestamp(6) without time zone,
    revoked_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.api_clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.api_clients_id_seq OWNED BY public.api_clients.id;
CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE TABLE public.audit_events (
    id integer NOT NULL,
    operator_id integer,
    action character varying NOT NULL,
    ip_address inet,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.audit_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.audit_events_id_seq OWNED BY public.audit_events.id;
CREATE TABLE public.bases (
    id integer NOT NULL,
    name character varying NOT NULL,
    code_name character varying NOT NULL,
    planet_id integer NOT NULL,
    commander_id integer,
    capacity integer DEFAULT 0 NOT NULL,
    shield_generator boolean DEFAULT false NOT NULL,
    ion_cannon boolean DEFAULT false NOT NULL,
    established_at timestamp(6) without time zone,
    evacuated_at timestamp(6) without time zone,
    compromised boolean DEFAULT false NOT NULL,
    coordinates character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.bases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bases_id_seq OWNED BY public.bases.id;
CREATE TABLE public.battle_participants (
    id integer NOT NULL,
    battle_id integer NOT NULL,
    character_id integer,
    starship_id integer,
    side public.allegiance NOT NULL,
    kills integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.battle_participants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.battle_participants_id_seq OWNED BY public.battle_participants.id;
CREATE TABLE public.battles (
    id integer NOT NULL,
    name character varying NOT NULL,
    planet_id integer,
    star_system_id integer,
    mission_id integer,
    started_at timestamp(6) without time zone,
    ended_at timestamp(6) without time zone,
    year_aby integer,
    space_battle boolean DEFAULT false NOT NULL,
    ground_battle boolean DEFAULT false NOT NULL,
    rebel_commander_id integer,
    imperial_commander character varying,
    rebel_ships integer DEFAULT 0 NOT NULL,
    imperial_ships integer DEFAULT 0 NOT NULL,
    rebel_troops integer DEFAULT 0 NOT NULL,
    imperial_troops integer DEFAULT 0 NOT NULL,
    rebel_losses integer DEFAULT 0 NOT NULL,
    imperial_losses integer DEFAULT 0 NOT NULL,
    outcome character varying,
    decisive boolean DEFAULT false NOT NULL,
    superweapon_involved boolean DEFAULT false NOT NULL,
    superweapon_name character varying,
    summary text,
    holonet_coverage boolean DEFAULT false NOT NULL,
    propaganda_value integer DEFAULT 0 NOT NULL,
    source_reliability public.intel_reliability DEFAULT 'unverified'::public.intel_reliability NOT NULL,
    archived_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.battles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.battles_id_seq OWNED BY public.battles.id;
CREATE TABLE public.bounties (
    id integer NOT NULL,
    target_id integer NOT NULL,
    posted_by character varying NOT NULL,
    posted_by_allegiance public.allegiance NOT NULL,
    reward numeric(14,2) NOT NULL,
    currency public.credit_currency DEFAULT 'galactic_credit'::public.credit_currency NOT NULL,
    dead_or_alive boolean DEFAULT false NOT NULL,
    status public.bounty_status DEFAULT 'posted'::public.bounty_status NOT NULL,
    hunter_id integer,
    accepted_at timestamp(6) without time zone,
    collected_at timestamp(6) without time zone,
    expires_at timestamp(6) without time zone,
    last_known_planet_id integer,
    last_known_at timestamp(6) without time zone,
    disintegrations_allowed boolean DEFAULT false NOT NULL,
    guild_registered boolean DEFAULT true NOT NULL,
    guild_code character varying,
    contact_frequency character varying,
    description text,
    threat_assessment text,
    hunters_engaged integer DEFAULT 0 NOT NULL,
    hunters_lost integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT bounties_reward_positive CHECK ((reward > (0)::numeric))
);
CREATE SEQUENCE public.bounties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bounties_id_seq OWNED BY public.bounties.id;
CREATE TABLE public.bounty_hunters (
    id integer NOT NULL,
    character_id integer NOT NULL,
    guild_rank integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.bounty_hunters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bounty_hunters_id_seq OWNED BY public.bounty_hunters.id;
CREATE TABLE public.casualties (
    id integer NOT NULL,
    battle_id integer NOT NULL,
    character_id integer NOT NULL,
    fatal boolean DEFAULT false NOT NULL,
    description character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.casualties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.casualties_id_seq OWNED BY public.casualties.id;
CREATE TABLE public.character_languages (
    character_id integer NOT NULL,
    language_id integer NOT NULL,
    fluency integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE TABLE public.characters (
    id integer NOT NULL,
    name character varying NOT NULL,
    alias character varying,
    callsign character varying,
    species_id integer,
    homeworld_id integer,
    rank_id integer,
    allegiance public.allegiance DEFAULT 'independent'::public.allegiance NOT NULL,
    force_sensitive boolean DEFAULT false NOT NULL,
    force_side public.force_side,
    midichlorian_count bigint,
    birth_year_bby integer,
    death_year_aby integer,
    height_cm double precision,
    mass_kg double precision,
    eye_color character varying,
    hair_color character varying,
    skin_color character varying,
    gender character varying,
    cybernetic_parts integer DEFAULT 0 NOT NULL,
    clearance_level integer DEFAULT 0 NOT NULL,
    comlink_frequency character varying,
    holonet_handle character varying,
    service_number character varying,
    enlisted_by_id integer,
    enlisted_at timestamp(6) without time zone,
    deserted_at timestamp(6) without time zone,
    captured_at timestamp(6) without time zone,
    rescued_at timestamp(6) without time zone,
    deceased_at timestamp(6) without time zone,
    last_seen_at timestamp(6) without time zone,
    last_seen_planet_id integer,
    last_debriefed_at timestamp(6) without time zone,
    medical_clearance_at timestamp(6) without time zone,
    flight_certified boolean DEFAULT false NOT NULL,
    flight_hours double precision DEFAULT 0 NOT NULL,
    confirmed_kills integer DEFAULT 0 NOT NULL,
    missions_flown integer DEFAULT 0 NOT NULL,
    commendations integer DEFAULT 0 NOT NULL,
    reprimands integer DEFAULT 0 NOT NULL,
    piloting_score integer,
    marksmanship_score integer,
    tactics_score integer,
    diplomacy_score integer,
    engineering_score integer,
    slicing_score integer,
    medical_score integer,
    stealth_score integer,
    languages_spoken integer DEFAULT 1 NOT NULL,
    preferred_weapon character varying,
    signature_ship character varying,
    bounty_on_head numeric(14,2),
    imperial_dossier_code character varying,
    wanted_by_empire boolean DEFAULT false NOT NULL,
    wanted_by_hutts boolean DEFAULT false NOT NULL,
    double_agent boolean DEFAULT false NOT NULL,
    under_investigation boolean DEFAULT false NOT NULL,
    quarters character varying,
    base_id integer,
    squadron_role character varying,
    next_of_kin character varying,
    next_of_kin_planet character varying,
    biography text,
    psych_profile text,
    medical_notes text,
    handler_notes text,
    portrait_key character varying,
    hologram_key character varying,
    voiceprint_key character varying,
    retina_scan_key character varying,
    rescue_priority integer DEFAULT 0 NOT NULL,
    extraction_code character varying,
    cover_identity character varying,
    cover_occupation character varying,
    cover_planet character varying,
    cover_established_on date,
    cover_blown_at timestamp(6) without time zone,
    credits_balance bigint DEFAULT 0 NOT NULL,
    monthly_stipend bigint DEFAULT 0 NOT NULL,
    stipend_paid_through date,
    leave_starts_on date,
    leave_ends_on date,
    on_leave boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL,
    archived_at timestamp(6) without time zone,
    archived_reason character varying,
    merged_into_id integer,
    import_source character varying,
    import_ref character varying,
    imported_at timestamp(6) without time zone,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT characters_clearance_range CHECK (((clearance_level >= 0) AND (clearance_level <= 9)))
);
CREATE SEQUENCE public.characters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;
CREATE TABLE public.credit_transfers (
    id integer NOT NULL,
    direction public.transfer_direction NOT NULL,
    amount numeric(14,2) NOT NULL,
    counterparty character varying NOT NULL,
    character_id integer,
    smuggler_id integer,
    mission_id integer,
    supply_request_id integer,
    memo character varying,
    laundered boolean DEFAULT false NOT NULL,
    cleared_at timestamp(6) without time zone,
    reference_code character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT credit_transfers_amount_positive CHECK ((amount > (0)::numeric))
);
CREATE SEQUENCE public.credit_transfers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.credit_transfers_id_seq OWNED BY public.credit_transfers.id;
CREATE TABLE public.droid_memory_wipes (
    id integer NOT NULL,
    droid_id integer NOT NULL,
    performed_by_id integer,
    reason character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.droid_memory_wipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.droid_memory_wipes_id_seq OWNED BY public.droid_memory_wipes.id;
CREATE TABLE public.droid_models (
    id integer NOT NULL,
    manufacturer_id integer,
    name character varying NOT NULL,
    droid_class public.droid_class NOT NULL,
    height_m double precision,
    languages_known integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.droid_models_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.droid_models_id_seq OWNED BY public.droid_models.id;
CREATE TABLE public.droids (
    id integer NOT NULL,
    droid_model_id integer NOT NULL,
    designation character varying NOT NULL,
    nickname character varying,
    owner_id integer,
    starship_id integer,
    base_id integer,
    restraining_bolt boolean DEFAULT false NOT NULL,
    memory_wiped_count integer DEFAULT 0 NOT NULL,
    last_memory_wipe_at timestamp(6) without time zone,
    personality_quirks text,
    plating_color character varying,
    serial_number character varying,
    carries_secret_plans boolean DEFAULT false NOT NULL,
    secret_payload character varying,
    activated_at timestamp(6) without time zone,
    deactivated_at timestamp(6) without time zone,
    operational boolean DEFAULT true NOT NULL,
    oil_bath_due_on date,
    repair_count integer DEFAULT 0 NOT NULL,
    stolen boolean DEFAULT false NOT NULL,
    jawa_salvaged boolean DEFAULT false NOT NULL,
    purchase_price bigint,
    purchased_from character varying,
    purchased_at timestamp(6) without time zone,
    notes text,
    archived_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.droids_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.droids_id_seq OWNED BY public.droids.id;
CREATE TABLE public.encryption_keys (
    id integer NOT NULL,
    key_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    label character varying NOT NULL,
    retired_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.encryption_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.encryption_keys_id_seq OWNED BY public.encryption_keys.id;
CREATE TABLE public.hangars (
    id integer NOT NULL,
    base_id integer NOT NULL,
    name character varying NOT NULL,
    bay_count integer NOT NULL,
    access public.hangar_access DEFAULT 'open'::public.hangar_access NOT NULL,
    blast_doors boolean DEFAULT true NOT NULL,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.hangars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.hangars_id_seq OWNED BY public.hangars.id;
CREATE TABLE public.holocrons (
    id integer NOT NULL,
    title character varying NOT NULL,
    side public.force_side NOT NULL,
    keeper_id integer,
    gatekeeper_name character varying,
    recovered_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.holocrons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.holocrons_id_seq OWNED BY public.holocrons.id;
CREATE TABLE public.holonet_messages (
    id integer NOT NULL,
    transmission_id integer NOT NULL,
    delivered_at timestamp with time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.holonet_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.holonet_messages_id_seq OWNED BY public.holonet_messages.id;
CREATE TABLE public.hyperspace_lanes (
    id integer NOT NULL,
    name character varying NOT NULL,
    origin_system_id integer NOT NULL,
    destination_system_id integer NOT NULL,
    length_parsecs double precision NOT NULL,
    status public.lane_status DEFAULT 'open'::public.lane_status NOT NULL,
    patrolled boolean DEFAULT false NOT NULL,
    charted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.hyperspace_lanes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.hyperspace_lanes_id_seq OWNED BY public.hyperspace_lanes.id;
CREATE TABLE public.informants (
    id integer NOT NULL,
    code_name character varying NOT NULL,
    character_id integer,
    planet_id integer,
    paid_credits bigint DEFAULT 0 NOT NULL,
    burned boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.informants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.informants_id_seq OWNED BY public.informants.id;
CREATE TABLE public.intel_reports (
    id integer NOT NULL,
    informant_id integer,
    received_by_id integer,
    planet_id integer,
    mission_id integer,
    subject character varying NOT NULL,
    body text NOT NULL,
    reliability public.intel_reliability DEFAULT 'unverified'::public.intel_reliability NOT NULL,
    received_at timestamp(6) without time zone NOT NULL,
    verified_at timestamp(6) without time zone,
    verified_by_id integer,
    actionable boolean DEFAULT false NOT NULL,
    acted_on boolean DEFAULT false NOT NULL,
    clearance_required integer DEFAULT 3 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.intel_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.intel_reports_id_seq OWNED BY public.intel_reports.id;
CREATE TABLE public.kyber_crystals (
    id integer NOT NULL,
    origin public.kyber_origin NOT NULL,
    color character varying NOT NULL,
    bled boolean DEFAULT false NOT NULL,
    resonance_hz double precision,
    found_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.kyber_crystals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.kyber_crystals_id_seq OWNED BY public.kyber_crystals.id;
CREATE TABLE public.lane_segments (
    id integer NOT NULL,
    hyperspace_lane_id integer NOT NULL,
    "position" integer NOT NULL,
    star_system_id integer NOT NULL,
    jump_hours double precision NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.lane_segments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.lane_segments_id_seq OWNED BY public.lane_segments.id;
CREATE TABLE public.languages (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;
CREATE TABLE public.lightsabers (
    id integer NOT NULL,
    owner_id integer,
    kyber_crystal_id integer,
    hilt_style character varying NOT NULL,
    blade_color character varying NOT NULL,
    double_bladed boolean DEFAULT false NOT NULL,
    lost_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.lightsabers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.lightsabers_id_seq OWNED BY public.lightsabers.id;
CREATE TABLE public.maintenance_logs (
    id integer NOT NULL,
    starship_id integer NOT NULL,
    technician_id integer,
    performed_at timestamp(6) without time zone NOT NULL,
    summary character varying NOT NULL,
    parts_replaced text,
    hours_spent double precision,
    passed_inspection boolean DEFAULT true NOT NULL,
    next_due_on date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.maintenance_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.maintenance_logs_id_seq OWNED BY public.maintenance_logs.id;
CREATE TABLE public.manufacturers (
    id integer NOT NULL,
    name character varying NOT NULL,
    short_name character varying,
    headquarters_planet_id integer,
    founded_bby integer,
    imperial_contractor boolean DEFAULT false NOT NULL,
    sells_to_rebels boolean DEFAULT false NOT NULL,
    website character varying,
    contact_frequency character varying,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.manufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.manufacturers_id_seq OWNED BY public.manufacturers.id;
CREATE TABLE public.mission_participants (
    id integer NOT NULL,
    mission_id integer NOT NULL,
    character_id integer NOT NULL,
    role character varying NOT NULL,
    starship_id integer,
    joined_at timestamp(6) without time zone,
    left_at timestamp(6) without time zone,
    wounded boolean DEFAULT false NOT NULL,
    killed boolean DEFAULT false NOT NULL,
    captured boolean DEFAULT false NOT NULL,
    commended boolean DEFAULT false NOT NULL,
    performance_score integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.mission_participants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.mission_participants_id_seq OWNED BY public.mission_participants.id;
CREATE TABLE public.mission_reports (
    id integer NOT NULL,
    mission_id integer NOT NULL,
    author_id integer NOT NULL,
    body text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.mission_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.mission_reports_id_seq OWNED BY public.mission_reports.id;
CREATE TABLE public.missions (
    id integer NOT NULL,
    code_name character varying NOT NULL,
    objective text NOT NULL,
    status public.mission_status DEFAULT 'planned'::public.mission_status NOT NULL,
    priority integer DEFAULT 3 NOT NULL,
    target_planet_id integer,
    staging_base_id integer,
    commander_id integer,
    approved_by_id integer,
    approved_at timestamp(6) without time zone,
    planned_on date,
    launched_at timestamp(6) without time zone,
    completed_at timestamp(6) without time zone,
    aborted_at timestamp(6) without time zone,
    abort_reason character varying,
    casualties_count integer DEFAULT 0 NOT NULL,
    ships_lost integer DEFAULT 0 NOT NULL,
    intel_gained boolean DEFAULT false NOT NULL,
    success_score double precision,
    budget_credits bigint,
    spent_credits bigint DEFAULT 0 NOT NULL,
    classified boolean DEFAULT true NOT NULL,
    clearance_required integer DEFAULT 3 NOT NULL,
    debrief_summary text,
    lessons_learned text,
    parent_mission_id integer,
    holotable_map_key character varying,
    extraction_point character varying,
    rendezvous_code character varying,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.missions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.missions_id_seq OWNED BY public.missions.id;
CREATE TABLE public.moons (
    id integer NOT NULL,
    planet_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.moons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.moons_id_seq OWNED BY public.moons.id;
CREATE TABLE public.operator_sessions (
    id integer NOT NULL,
    operator_id integer NOT NULL,
    token character varying DEFAULT encode(public.gen_random_bytes(24), 'hex'::text) NOT NULL,
    ip_address inet,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.operator_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.operator_sessions_id_seq OWNED BY public.operator_sessions.id;
CREATE TABLE public.operators (
    id integer NOT NULL,
    character_id integer,
    username character varying NOT NULL COLLATE public.case_insensitive,
    email character varying NOT NULL COLLATE public.case_insensitive,
    password_digest character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    clearance_level integer DEFAULT 1 NOT NULL,
    otp_secret character varying,
    otp_enabled boolean DEFAULT false NOT NULL,
    failed_logins integer DEFAULT 0 NOT NULL,
    locked_at timestamp(6) without time zone,
    last_login_at timestamp(6) without time zone,
    last_login_ip character varying,
    password_changed_at timestamp(6) without time zone,
    reset_token character varying,
    reset_sent_at timestamp(6) without time zone,
    time_zone character varying DEFAULT 'Galactic Standard'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.operators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.operators_id_seq OWNED BY public.operators.id;
CREATE TABLE public.planet_neighbors (
    planet_id integer NOT NULL,
    neighbor_id integer NOT NULL
);
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
CREATE TABLE public.ranks (
    id integer NOT NULL,
    title character varying NOT NULL,
    abbreviation character varying NOT NULL,
    seniority integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.ranks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.ranks_id_seq OWNED BY public.ranks.id;
CREATE TABLE public.regions (
    id integer NOT NULL,
    name character varying NOT NULL,
    slug_code character varying NOT NULL,
    distance_from_core double precision,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;
CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
CREATE TABLE public.sectors (
    id integer NOT NULL,
    region_id integer NOT NULL,
    name character varying NOT NULL,
    grid_code character varying NOT NULL,
    imperial_presence boolean DEFAULT false NOT NULL,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.sectors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.sectors_id_seq OWNED BY public.sectors.id;
CREATE TABLE public.settings (
    id integer NOT NULL,
    key character varying NOT NULL,
    value text,
    ttl_seconds integer DEFAULT 86400 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;
CREATE TABLE public.ship_assignments (
    id integer NOT NULL,
    starship_id integer NOT NULL,
    mission_id integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.ship_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.ship_assignments_id_seq OWNED BY public.ship_assignments.id;
CREATE TABLE public.ship_loadouts (
    id integer NOT NULL,
    starship_id integer NOT NULL,
    weapon_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.ship_loadouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.ship_loadouts_id_seq OWNED BY public.ship_loadouts.id;
CREATE TABLE public.shipments (
    id integer NOT NULL,
    supply_request_id integer NOT NULL,
    starship_id integer,
    smuggler_id integer,
    origin_planet_id integer,
    destination_base_id integer NOT NULL,
    hyperspace_lane_id integer,
    declared_value numeric(14,2),
    manifest_code character varying NOT NULL,
    departed_at timestamp(6) without time zone,
    arrived_at timestamp(6) without time zone,
    intercepted boolean DEFAULT false NOT NULL,
    jettisoned boolean DEFAULT false NOT NULL,
    tracking_code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.shipments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.shipments_id_seq OWNED BY public.shipments.id;
CREATE TABLE public.sightings (
    id integer NOT NULL,
    character_id integer NOT NULL,
    planet_id integer,
    reported_by_id integer,
    seen_at timestamp(6) without time zone NOT NULL,
    confidence public.sighting_confidence DEFAULT 'low'::public.sighting_confidence NOT NULL,
    details text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.sightings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.sightings_id_seq OWNED BY public.sightings.id;
CREATE TABLE public.smugglers (
    id integer NOT NULL,
    character_id integer NOT NULL,
    starship_id integer,
    commission_rate numeric(5,4) DEFAULT 0.1 NOT NULL,
    trusted boolean DEFAULT false NOT NULL,
    owes_hutts boolean DEFAULT false NOT NULL,
    kessel_run_parsecs double precision,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.smugglers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.smugglers_id_seq OWNED BY public.smugglers.id;
CREATE TABLE public.species (
    id integer NOT NULL,
    name character varying NOT NULL,
    classification character varying,
    designation character varying,
    average_height_cm double precision,
    average_lifespan_years double precision,
    homeworld_id integer,
    language character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.species_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.species_id_seq OWNED BY public.species.id;
CREATE TABLE public.squadron_assignments (
    id integer NOT NULL,
    squadron_id integer NOT NULL,
    character_id integer NOT NULL,
    position_number integer NOT NULL,
    role character varying,
    starts_on date NOT NULL,
    ends_on date,
    wingmate_id integer,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.squadron_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.squadron_assignments_id_seq OWNED BY public.squadron_assignments.id;
CREATE TABLE public.squadrons (
    id integer NOT NULL,
    name character varying NOT NULL,
    callsign_prefix character varying NOT NULL,
    base_id integer,
    commander_id integer,
    starship_class public.starship_class NOT NULL,
    motto character varying,
    active boolean DEFAULT true NOT NULL,
    disbanded_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.squadrons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.squadrons_id_seq OWNED BY public.squadrons.id;
CREATE TABLE public.star_systems (
    id integer NOT NULL,
    sector_id integer NOT NULL,
    name character varying NOT NULL,
    star_name character varying,
    star_type character varying,
    grid_x double precision NOT NULL,
    grid_y double precision NOT NULL,
    planet_count integer DEFAULT 0 NOT NULL,
    has_asteroid_field boolean DEFAULT false NOT NULL,
    surveyed_at timestamp(6) without time zone,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.star_systems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.star_systems_id_seq OWNED BY public.star_systems.id;
CREATE TABLE public.starship_models (
    id integer NOT NULL,
    manufacturer_id integer NOT NULL,
    name character varying NOT NULL,
    model_code character varying NOT NULL,
    starship_class public.starship_class NOT NULL,
    length_m double precision,
    crew_min integer,
    crew_max integer,
    passengers integer,
    cargo_capacity_tons double precision,
    consumables_days integer,
    hyperdrive_rating double precision,
    backup_hyperdrive_rating double precision,
    max_atmosphere_speed_kph double precision,
    mglt integer,
    shielded boolean DEFAULT true NOT NULL,
    shield_rating integer,
    hull_rating integer,
    cost_credits bigint,
    used_cost_credits bigint,
    in_production boolean DEFAULT true NOT NULL,
    introduced_bby integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.starship_models_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.starship_models_id_seq OWNED BY public.starship_models.id;
CREATE TABLE public.starships (
    id integer NOT NULL,
    starship_model_id integer NOT NULL,
    name character varying NOT NULL,
    registry_code character varying NOT NULL,
    transponder_code character varying,
    false_transponder_code character varying,
    hangar_id integer,
    squadron_id integer,
    pilot_id integer,
    condition public.ship_condition DEFAULT 'operational'::public.ship_condition NOT NULL,
    hull_integrity integer DEFAULT 100 NOT NULL,
    shield_integrity integer DEFAULT 100 NOT NULL,
    fuel_pct integer DEFAULT 100 NOT NULL,
    hyperdrive_operational boolean DEFAULT true NOT NULL,
    stolen boolean DEFAULT false NOT NULL,
    stolen_from character varying,
    acquired_at timestamp(6) without time zone,
    acquired_from character varying,
    acquisition_cost bigint,
    last_jump_at timestamp(6) without time zone,
    last_jump_system_id integer,
    last_maintenance_at timestamp(6) without time zone,
    next_maintenance_due_on date,
    flight_hours double precision DEFAULT 0 NOT NULL,
    jumps_count integer DEFAULT 0 NOT NULL,
    kills_count integer DEFAULT 0 NOT NULL,
    destroyed_at timestamp(6) without time zone,
    destroyed_in_battle_id integer,
    decommissioned_at timestamp(6) without time zone,
    paint_scheme character varying,
    nickname character varying,
    notes text,
    lock_version integer DEFAULT 0 NOT NULL,
    archived_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT starships_hull_integrity_range CHECK (((hull_integrity >= 0) AND (hull_integrity <= 100)))
);
CREATE SEQUENCE public.starships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.starships_id_seq OWNED BY public.starships.id;
CREATE TABLE public.supply_items (
    id integer NOT NULL,
    name character varying NOT NULL,
    category character varying NOT NULL,
    unit character varying DEFAULT 'crate'::character varying NOT NULL,
    unit_cost numeric(12,2),
    restricted boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.supply_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.supply_items_id_seq OWNED BY public.supply_items.id;
CREATE TABLE public.supply_request_lines (
    id integer NOT NULL,
    supply_request_id integer NOT NULL,
    supply_item_id integer NOT NULL,
    quantity integer NOT NULL,
    quantity_shipped integer DEFAULT 0 NOT NULL,
    quantity_received integer DEFAULT 0 NOT NULL,
    unit_cost numeric(12,2),
    substitute_item_id integer,
    backordered boolean DEFAULT false NOT NULL,
    notes character varying,
    packed_at timestamp(6) without time zone,
    received_at timestamp(6) without time zone,
    damaged_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT supply_request_lines_quantity_positive CHECK ((quantity > 0))
);
CREATE SEQUENCE public.supply_request_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.supply_request_lines_id_seq OWNED BY public.supply_request_lines.id;
CREATE TABLE public.supply_requests (
    id integer NOT NULL,
    base_id integer NOT NULL,
    requested_by_id integer NOT NULL,
    approved_by_id integer,
    status public.supply_request_status DEFAULT 'draft'::public.supply_request_status NOT NULL,
    priority integer DEFAULT 3 NOT NULL,
    needed_by date,
    justification text,
    submitted_at timestamp(6) without time zone,
    approved_at timestamp(6) without time zone,
    rejected_at timestamp(6) without time zone,
    rejection_reason character varying,
    delivered_at timestamp(6) without time zone,
    total_cost bigint DEFAULT 0 NOT NULL,
    smuggler_id integer,
    reference_code character varying NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    archived_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.supply_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.supply_requests_id_seq OWNED BY public.supply_requests.id;
CREATE TABLE public.training_sessions (
    id integer NOT NULL,
    student_id integer NOT NULL,
    master_id integer NOT NULL,
    topic character varying NOT NULL,
    duration_hours double precision NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.training_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.training_sessions_id_seq OWNED BY public.training_sessions.id;
CREATE TABLE public.transmissions (
    id integer NOT NULL,
    sender_id integer,
    recipient_id integer,
    base_id integer,
    band public.transmission_band DEFAULT 'subspace'::public.transmission_band NOT NULL,
    encryption_key_id integer,
    frequency_khz bigint,
    subject character varying,
    body text,
    priority integer DEFAULT 0 NOT NULL,
    intercepted boolean DEFAULT false NOT NULL,
    acknowledged boolean DEFAULT false NOT NULL,
    acknowledged_at timestamp(6) without time zone,
    sent_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.transmissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.transmissions_id_seq OWNED BY public.transmissions.id;
CREATE TABLE public.weapons (
    id integer NOT NULL,
    name character varying NOT NULL,
    kind character varying NOT NULL,
    damage_rating integer NOT NULL,
    range_km double precision,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.weapons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.weapons_id_seq OWNED BY public.weapons.id;
ALTER TABLE ONLY public.alert_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.alert_subscriptions_id_seq'::regclass);
ALTER TABLE ONLY public.api_clients ALTER COLUMN id SET DEFAULT nextval('public.api_clients_id_seq'::regclass);
ALTER TABLE ONLY public.audit_events ALTER COLUMN id SET DEFAULT nextval('public.audit_events_id_seq'::regclass);
ALTER TABLE ONLY public.bases ALTER COLUMN id SET DEFAULT nextval('public.bases_id_seq'::regclass);
ALTER TABLE ONLY public.battle_participants ALTER COLUMN id SET DEFAULT nextval('public.battle_participants_id_seq'::regclass);
ALTER TABLE ONLY public.battles ALTER COLUMN id SET DEFAULT nextval('public.battles_id_seq'::regclass);
ALTER TABLE ONLY public.bounties ALTER COLUMN id SET DEFAULT nextval('public.bounties_id_seq'::regclass);
ALTER TABLE ONLY public.bounty_hunters ALTER COLUMN id SET DEFAULT nextval('public.bounty_hunters_id_seq'::regclass);
ALTER TABLE ONLY public.casualties ALTER COLUMN id SET DEFAULT nextval('public.casualties_id_seq'::regclass);
ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);
ALTER TABLE ONLY public.credit_transfers ALTER COLUMN id SET DEFAULT nextval('public.credit_transfers_id_seq'::regclass);
ALTER TABLE ONLY public.droid_memory_wipes ALTER COLUMN id SET DEFAULT nextval('public.droid_memory_wipes_id_seq'::regclass);
ALTER TABLE ONLY public.droid_models ALTER COLUMN id SET DEFAULT nextval('public.droid_models_id_seq'::regclass);
ALTER TABLE ONLY public.droids ALTER COLUMN id SET DEFAULT nextval('public.droids_id_seq'::regclass);
ALTER TABLE ONLY public.encryption_keys ALTER COLUMN id SET DEFAULT nextval('public.encryption_keys_id_seq'::regclass);
ALTER TABLE ONLY public.hangars ALTER COLUMN id SET DEFAULT nextval('public.hangars_id_seq'::regclass);
ALTER TABLE ONLY public.holocrons ALTER COLUMN id SET DEFAULT nextval('public.holocrons_id_seq'::regclass);
ALTER TABLE ONLY public.holonet_messages ALTER COLUMN id SET DEFAULT nextval('public.holonet_messages_id_seq'::regclass);
ALTER TABLE ONLY public.hyperspace_lanes ALTER COLUMN id SET DEFAULT nextval('public.hyperspace_lanes_id_seq'::regclass);
ALTER TABLE ONLY public.informants ALTER COLUMN id SET DEFAULT nextval('public.informants_id_seq'::regclass);
ALTER TABLE ONLY public.intel_reports ALTER COLUMN id SET DEFAULT nextval('public.intel_reports_id_seq'::regclass);
ALTER TABLE ONLY public.kyber_crystals ALTER COLUMN id SET DEFAULT nextval('public.kyber_crystals_id_seq'::regclass);
ALTER TABLE ONLY public.lane_segments ALTER COLUMN id SET DEFAULT nextval('public.lane_segments_id_seq'::regclass);
ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);
ALTER TABLE ONLY public.lightsabers ALTER COLUMN id SET DEFAULT nextval('public.lightsabers_id_seq'::regclass);
ALTER TABLE ONLY public.maintenance_logs ALTER COLUMN id SET DEFAULT nextval('public.maintenance_logs_id_seq'::regclass);
ALTER TABLE ONLY public.manufacturers ALTER COLUMN id SET DEFAULT nextval('public.manufacturers_id_seq'::regclass);
ALTER TABLE ONLY public.mission_participants ALTER COLUMN id SET DEFAULT nextval('public.mission_participants_id_seq'::regclass);
ALTER TABLE ONLY public.mission_reports ALTER COLUMN id SET DEFAULT nextval('public.mission_reports_id_seq'::regclass);
ALTER TABLE ONLY public.missions ALTER COLUMN id SET DEFAULT nextval('public.missions_id_seq'::regclass);
ALTER TABLE ONLY public.moons ALTER COLUMN id SET DEFAULT nextval('public.moons_id_seq'::regclass);
ALTER TABLE ONLY public.operator_sessions ALTER COLUMN id SET DEFAULT nextval('public.operator_sessions_id_seq'::regclass);
ALTER TABLE ONLY public.operators ALTER COLUMN id SET DEFAULT nextval('public.operators_id_seq'::regclass);
ALTER TABLE ONLY public.planets ALTER COLUMN id SET DEFAULT nextval('public.planets_id_seq'::regclass);
ALTER TABLE ONLY public.ranks ALTER COLUMN id SET DEFAULT nextval('public.ranks_id_seq'::regclass);
ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);
ALTER TABLE ONLY public.sectors ALTER COLUMN id SET DEFAULT nextval('public.sectors_id_seq'::regclass);
ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);
ALTER TABLE ONLY public.ship_assignments ALTER COLUMN id SET DEFAULT nextval('public.ship_assignments_id_seq'::regclass);
ALTER TABLE ONLY public.ship_loadouts ALTER COLUMN id SET DEFAULT nextval('public.ship_loadouts_id_seq'::regclass);
ALTER TABLE ONLY public.shipments ALTER COLUMN id SET DEFAULT nextval('public.shipments_id_seq'::regclass);
ALTER TABLE ONLY public.sightings ALTER COLUMN id SET DEFAULT nextval('public.sightings_id_seq'::regclass);
ALTER TABLE ONLY public.smugglers ALTER COLUMN id SET DEFAULT nextval('public.smugglers_id_seq'::regclass);
ALTER TABLE ONLY public.species ALTER COLUMN id SET DEFAULT nextval('public.species_id_seq'::regclass);
ALTER TABLE ONLY public.squadron_assignments ALTER COLUMN id SET DEFAULT nextval('public.squadron_assignments_id_seq'::regclass);
ALTER TABLE ONLY public.squadrons ALTER COLUMN id SET DEFAULT nextval('public.squadrons_id_seq'::regclass);
ALTER TABLE ONLY public.star_systems ALTER COLUMN id SET DEFAULT nextval('public.star_systems_id_seq'::regclass);
ALTER TABLE ONLY public.starship_models ALTER COLUMN id SET DEFAULT nextval('public.starship_models_id_seq'::regclass);
ALTER TABLE ONLY public.starships ALTER COLUMN id SET DEFAULT nextval('public.starships_id_seq'::regclass);
ALTER TABLE ONLY public.supply_items ALTER COLUMN id SET DEFAULT nextval('public.supply_items_id_seq'::regclass);
ALTER TABLE ONLY public.supply_request_lines ALTER COLUMN id SET DEFAULT nextval('public.supply_request_lines_id_seq'::regclass);
ALTER TABLE ONLY public.supply_requests ALTER COLUMN id SET DEFAULT nextval('public.supply_requests_id_seq'::regclass);
ALTER TABLE ONLY public.training_sessions ALTER COLUMN id SET DEFAULT nextval('public.training_sessions_id_seq'::regclass);
ALTER TABLE ONLY public.transmissions ALTER COLUMN id SET DEFAULT nextval('public.transmissions_id_seq'::regclass);
ALTER TABLE ONLY public.weapons ALTER COLUMN id SET DEFAULT nextval('public.weapons_id_seq'::regclass);
ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.api_clients
    ADD CONSTRAINT api_clients_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.bases
    ADD CONSTRAINT bases_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.battle_participants
    ADD CONSTRAINT battle_participants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.battles
    ADD CONSTRAINT battles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.bounties
    ADD CONSTRAINT bounties_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.bounty_hunters
    ADD CONSTRAINT bounty_hunters_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.casualties
    ADD CONSTRAINT casualties_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.character_languages
    ADD CONSTRAINT character_languages_pkey PRIMARY KEY (character_id, language_id);
ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.credit_transfers
    ADD CONSTRAINT credit_transfers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.droid_memory_wipes
    ADD CONSTRAINT droid_memory_wipes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.droid_models
    ADD CONSTRAINT droid_models_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.droids
    ADD CONSTRAINT droids_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.encryption_keys
    ADD CONSTRAINT encryption_keys_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.hangars
    ADD CONSTRAINT hangars_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.holocrons
    ADD CONSTRAINT holocrons_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.holonet_messages
    ADD CONSTRAINT holonet_messages_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.hyperspace_lanes
    ADD CONSTRAINT hyperspace_lanes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.informants
    ADD CONSTRAINT informants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.intel_reports
    ADD CONSTRAINT intel_reports_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.kyber_crystals
    ADD CONSTRAINT kyber_crystals_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.lane_segments
    ADD CONSTRAINT lane_segments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.lightsabers
    ADD CONSTRAINT lightsabers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.maintenance_logs
    ADD CONSTRAINT maintenance_logs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.mission_participants
    ADD CONSTRAINT mission_participants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.mission_reports
    ADD CONSTRAINT mission_reports_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.missions
    ADD CONSTRAINT missions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.moons
    ADD CONSTRAINT moons_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.operator_sessions
    ADD CONSTRAINT operator_sessions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.operators
    ADD CONSTRAINT operators_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.planets
    ADD CONSTRAINT planets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ranks
    ADD CONSTRAINT ranks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
ALTER TABLE ONLY public.sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ship_assignments
    ADD CONSTRAINT ship_assignments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ship_loadouts
    ADD CONSTRAINT ship_loadouts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sightings
    ADD CONSTRAINT sightings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.smugglers
    ADD CONSTRAINT smugglers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.squadron_assignments
    ADD CONSTRAINT squadron_assignments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.squadrons
    ADD CONSTRAINT squadrons_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.star_systems
    ADD CONSTRAINT star_systems_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.starship_models
    ADD CONSTRAINT starship_models_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.starships
    ADD CONSTRAINT starships_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.supply_items
    ADD CONSTRAINT supply_items_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.supply_request_lines
    ADD CONSTRAINT supply_request_lines_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.supply_requests
    ADD CONSTRAINT supply_requests_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.training_sessions
    ADD CONSTRAINT training_sessions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.transmissions
    ADD CONSTRAINT transmissions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (id);
CREATE INDEX index_audit_events_on_operator_id ON public.audit_events USING btree (operator_id);
CREATE UNIQUE INDEX index_bases_on_code_name ON public.bases USING btree (code_name);
CREATE INDEX index_bases_on_planet_id ON public.bases USING btree (planet_id);
CREATE INDEX index_battle_participants_on_battle_id ON public.battle_participants USING btree (battle_id);
CREATE INDEX index_battles_on_mission_id ON public.battles USING btree (mission_id);
CREATE INDEX index_battles_on_planet_id ON public.battles USING btree (planet_id);
CREATE INDEX index_bounties_on_status ON public.bounties USING btree (status);
CREATE INDEX index_bounties_on_target_id ON public.bounties USING btree (target_id);
CREATE UNIQUE INDEX index_bounty_hunters_on_character_id ON public.bounty_hunters USING btree (character_id);
CREATE INDEX index_casualties_on_battle_id ON public.casualties USING btree (battle_id);
CREATE INDEX index_characters_active ON public.characters USING btree (id) WHERE (active AND (archived_at IS NULL));
CREATE INDEX index_characters_on_allegiance ON public.characters USING btree (allegiance);
CREATE INDEX index_characters_on_base_id ON public.characters USING btree (base_id);
CREATE INDEX index_characters_on_homeworld_id ON public.characters USING btree (homeworld_id);
CREATE INDEX index_characters_on_last_seen_at ON public.characters USING btree (last_seen_at);
CREATE UNIQUE INDEX index_characters_on_lower_callsign ON public.characters USING btree (lower((callsign)::text)) WHERE (callsign IS NOT NULL);
CREATE INDEX index_characters_on_lower_name ON public.characters USING btree (lower((name)::text));
CREATE INDEX index_characters_on_rank_id ON public.characters USING btree (rank_id);
CREATE UNIQUE INDEX index_characters_on_service_number ON public.characters USING btree (service_number) WHERE (service_number IS NOT NULL);
CREATE INDEX index_characters_on_species_id ON public.characters USING btree (species_id);
CREATE UNIQUE INDEX index_credit_transfers_on_reference_code ON public.credit_transfers USING btree (reference_code);
CREATE INDEX index_droids_on_droid_model_id ON public.droids USING btree (droid_model_id);
CREATE INDEX index_droids_on_owner_id ON public.droids USING btree (owner_id);
CREATE UNIQUE INDEX index_droids_on_serial_number ON public.droids USING btree (serial_number);
CREATE INDEX index_droids_on_starship_id ON public.droids USING btree (starship_id);
CREATE UNIQUE INDEX index_encryption_keys_on_key_uuid ON public.encryption_keys USING btree (key_uuid);
CREATE UNIQUE INDEX index_hangars_on_base_id_and_name ON public.hangars USING btree (base_id, name);
CREATE INDEX index_hyperspace_lanes_on_destination_system_id ON public.hyperspace_lanes USING btree (destination_system_id);
CREATE UNIQUE INDEX index_hyperspace_lanes_on_name ON public.hyperspace_lanes USING btree (name);
CREATE INDEX index_hyperspace_lanes_on_origin_system_id ON public.hyperspace_lanes USING btree (origin_system_id);
CREATE UNIQUE INDEX index_informants_on_code_name ON public.informants USING btree (code_name);
CREATE INDEX index_intel_reports_on_planet_id ON public.intel_reports USING btree (planet_id);
CREATE INDEX index_intel_reports_on_received_at ON public.intel_reports USING btree (received_at);
CREATE UNIQUE INDEX index_lane_segments_on_lane_and_position ON public.lane_segments USING btree (hyperspace_lane_id, "position");
CREATE UNIQUE INDEX index_languages_on_name ON public.languages USING btree (name);
CREATE INDEX index_lightsabers_on_owner_id ON public.lightsabers USING btree (owner_id);
CREATE INDEX index_maintenance_logs_on_starship_id_and_performed_at ON public.maintenance_logs USING btree (starship_id, performed_at);
CREATE UNIQUE INDEX index_manufacturers_on_name ON public.manufacturers USING btree (name);
CREATE INDEX index_mission_participants_on_character_id ON public.mission_participants USING btree (character_id);
CREATE UNIQUE INDEX index_mission_participants_on_mission_and_character ON public.mission_participants USING btree (mission_id, character_id);
CREATE INDEX index_mission_reports_on_mission_id ON public.mission_reports USING btree (mission_id);
CREATE UNIQUE INDEX index_missions_on_code_name ON public.missions USING btree (code_name);
CREATE INDEX index_missions_on_commander_id ON public.missions USING btree (commander_id);
CREATE INDEX index_missions_on_status ON public.missions USING btree (status);
CREATE INDEX index_missions_on_target_planet_id ON public.missions USING btree (target_planet_id);
CREATE INDEX index_moons_on_planet_id ON public.moons USING btree (planet_id);
CREATE INDEX index_operators_on_lower_email ON public.operators USING btree (lower((email)::text));
CREATE UNIQUE INDEX index_operators_on_username ON public.operators USING btree (username);
CREATE UNIQUE INDEX index_planet_neighbors_on_planet_id_and_neighbor_id ON public.planet_neighbors USING btree (planet_id, neighbor_id);
CREATE INDEX index_planets_on_allegiance ON public.planets USING btree (allegiance);
CREATE UNIQUE INDEX index_planets_on_name ON public.planets USING btree (name);
CREATE INDEX index_planets_on_star_system_id ON public.planets USING btree (star_system_id);
CREATE UNIQUE INDEX index_ranks_on_abbreviation ON public.ranks USING btree (abbreviation);
CREATE UNIQUE INDEX index_regions_on_name ON public.regions USING btree (name);
CREATE UNIQUE INDEX index_regions_on_slug_code ON public.regions USING btree (slug_code);
CREATE UNIQUE INDEX index_sectors_on_grid_code ON public.sectors USING btree (grid_code);
CREATE INDEX index_sectors_on_region_id ON public.sectors USING btree (region_id);
CREATE UNIQUE INDEX index_settings_on_key ON public.settings USING btree (key);
CREATE INDEX index_ship_loadouts_on_starship_id ON public.ship_loadouts USING btree (starship_id);
CREATE UNIQUE INDEX index_shipments_on_manifest_code ON public.shipments USING btree (manifest_code);
CREATE INDEX index_shipments_on_supply_request_id ON public.shipments USING btree (supply_request_id);
CREATE INDEX index_sightings_on_character_id_and_seen_at ON public.sightings USING btree (character_id, seen_at);
CREATE UNIQUE INDEX index_smugglers_on_character_id ON public.smugglers USING btree (character_id);
CREATE UNIQUE INDEX index_species_on_name ON public.species USING btree (name);
CREATE INDEX index_squadron_assignments_on_character_id ON public.squadron_assignments USING btree (character_id);
CREATE INDEX index_squadron_assignments_on_squadron_id ON public.squadron_assignments USING btree (squadron_id);
CREATE UNIQUE INDEX index_squadrons_on_name ON public.squadrons USING btree (name);
CREATE UNIQUE INDEX index_star_systems_on_name ON public.star_systems USING btree (name);
CREATE INDEX index_star_systems_on_sector_id ON public.star_systems USING btree (sector_id);
CREATE INDEX index_starship_models_on_manufacturer_id ON public.starship_models USING btree (manufacturer_id);
CREATE UNIQUE INDEX index_starship_models_on_model_code ON public.starship_models USING btree (model_code);
CREATE INDEX index_starships_needing_maintenance ON public.starships USING btree (next_maintenance_due_on) WHERE (destroyed_at IS NULL);
CREATE INDEX index_starships_on_hangar_id ON public.starships USING btree (hangar_id);
CREATE INDEX index_starships_on_lower_name ON public.starships USING btree (lower((name)::text));
CREATE INDEX index_starships_on_pilot_id ON public.starships USING btree (pilot_id);
CREATE UNIQUE INDEX index_starships_on_registry_code ON public.starships USING btree (registry_code);
CREATE INDEX index_starships_on_squadron_id ON public.starships USING btree (squadron_id);
CREATE INDEX index_starships_on_starship_model_id ON public.starships USING btree (starship_model_id);
CREATE UNIQUE INDEX index_supply_items_on_name ON public.supply_items USING btree (name);
CREATE INDEX index_supply_request_lines_on_supply_request_id ON public.supply_request_lines USING btree (supply_request_id);
CREATE INDEX index_supply_requests_on_base_id ON public.supply_requests USING btree (base_id);
CREATE UNIQUE INDEX index_supply_requests_on_reference_code ON public.supply_requests USING btree (reference_code);
CREATE INDEX index_supply_requests_on_status ON public.supply_requests USING btree (status);
CREATE INDEX index_transmissions_on_recipient_id ON public.transmissions USING btree (recipient_id);
CREATE INDEX index_transmissions_unacknowledged ON public.transmissions USING btree (recipient_id, sent_at) WHERE (NOT acknowledged);
CREATE UNIQUE INDEX index_weapons_on_name ON public.weapons USING btree (name);
CREATE TRIGGER characters_normalize_callsign BEFORE INSERT ON public.characters FOR EACH ROW EXECUTE FUNCTION public.normalize_callsign();
ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_operator_id_fkey FOREIGN KEY (operator_id) REFERENCES public.operators(id);
ALTER TABLE ONLY public.bases
    ADD CONSTRAINT bases_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planets(id);
ALTER TABLE ONLY public.battle_participants
    ADD CONSTRAINT battle_participants_battle_id_fkey FOREIGN KEY (battle_id) REFERENCES public.battles(id);
ALTER TABLE ONLY public.battles
    ADD CONSTRAINT battles_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planets(id);
ALTER TABLE ONLY public.bounties
    ADD CONSTRAINT bounties_hunter_id_fkey FOREIGN KEY (hunter_id) REFERENCES public.bounty_hunters(id);
ALTER TABLE ONLY public.bounties
    ADD CONSTRAINT bounties_target_id_fkey FOREIGN KEY (target_id) REFERENCES public.characters(id);
ALTER TABLE ONLY public.casualties
    ADD CONSTRAINT casualties_battle_id_fkey FOREIGN KEY (battle_id) REFERENCES public.battles(id);
ALTER TABLE ONLY public.casualties
    ADD CONSTRAINT casualties_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);
ALTER TABLE ONLY public.character_languages
    ADD CONSTRAINT character_languages_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);
ALTER TABLE ONLY public.character_languages
    ADD CONSTRAINT character_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id);
ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_homeworld_id_fkey FOREIGN KEY (homeworld_id) REFERENCES public.planets(id);
ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_rank_id_fkey FOREIGN KEY (rank_id) REFERENCES public.ranks(id);
ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(id);
ALTER TABLE ONLY public.droid_memory_wipes
    ADD CONSTRAINT droid_memory_wipes_droid_id_fkey FOREIGN KEY (droid_id) REFERENCES public.droids(id);
ALTER TABLE ONLY public.droids
    ADD CONSTRAINT droids_droid_model_id_fkey FOREIGN KEY (droid_model_id) REFERENCES public.droid_models(id);
ALTER TABLE ONLY public.droids
    ADD CONSTRAINT droids_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.characters(id);
ALTER TABLE ONLY public.hangars
    ADD CONSTRAINT hangars_base_id_fkey FOREIGN KEY (base_id) REFERENCES public.bases(id);
ALTER TABLE ONLY public.lightsabers
    ADD CONSTRAINT lightsabers_kyber_crystal_id_fkey FOREIGN KEY (kyber_crystal_id) REFERENCES public.kyber_crystals(id);
ALTER TABLE ONLY public.maintenance_logs
    ADD CONSTRAINT maintenance_logs_starship_id_fkey FOREIGN KEY (starship_id) REFERENCES public.starships(id);
ALTER TABLE ONLY public.mission_participants
    ADD CONSTRAINT mission_participants_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);
ALTER TABLE ONLY public.mission_participants
    ADD CONSTRAINT mission_participants_mission_id_fkey FOREIGN KEY (mission_id) REFERENCES public.missions(id);
ALTER TABLE ONLY public.mission_reports
    ADD CONSTRAINT mission_reports_mission_id_fkey FOREIGN KEY (mission_id) REFERENCES public.missions(id);
ALTER TABLE ONLY public.missions
    ADD CONSTRAINT missions_target_planet_id_fkey FOREIGN KEY (target_planet_id) REFERENCES public.planets(id);
ALTER TABLE ONLY public.moons
    ADD CONSTRAINT moons_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planets(id);
ALTER TABLE ONLY public.operator_sessions
    ADD CONSTRAINT operator_sessions_operator_id_fkey FOREIGN KEY (operator_id) REFERENCES public.operators(id);
ALTER TABLE ONLY public.planets
    ADD CONSTRAINT planets_star_system_id_fkey FOREIGN KEY (star_system_id) REFERENCES public.star_systems(id);
ALTER TABLE ONLY public.sectors
    ADD CONSTRAINT sectors_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);
ALTER TABLE ONLY public.ship_loadouts
    ADD CONSTRAINT ship_loadouts_starship_id_fkey FOREIGN KEY (starship_id) REFERENCES public.starships(id);
ALTER TABLE ONLY public.ship_loadouts
    ADD CONSTRAINT ship_loadouts_weapon_id_fkey FOREIGN KEY (weapon_id) REFERENCES public.weapons(id);
ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_supply_request_id_fkey FOREIGN KEY (supply_request_id) REFERENCES public.supply_requests(id);
ALTER TABLE ONLY public.sightings
    ADD CONSTRAINT sightings_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);
ALTER TABLE ONLY public.squadron_assignments
    ADD CONSTRAINT squadron_assignments_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);
ALTER TABLE ONLY public.squadron_assignments
    ADD CONSTRAINT squadron_assignments_squadron_id_fkey FOREIGN KEY (squadron_id) REFERENCES public.squadrons(id);
ALTER TABLE ONLY public.star_systems
    ADD CONSTRAINT star_systems_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES public.sectors(id);
ALTER TABLE ONLY public.starship_models
    ADD CONSTRAINT starship_models_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id);
ALTER TABLE ONLY public.starships
    ADD CONSTRAINT starships_squadron_id_fkey FOREIGN KEY (squadron_id) REFERENCES public.squadrons(id);
ALTER TABLE ONLY public.starships
    ADD CONSTRAINT starships_starship_model_id_fkey FOREIGN KEY (starship_model_id) REFERENCES public.starship_models(id);
ALTER TABLE ONLY public.supply_request_lines
    ADD CONSTRAINT supply_request_lines_supply_item_id_fkey FOREIGN KEY (supply_item_id) REFERENCES public.supply_items(id);
ALTER TABLE ONLY public.supply_request_lines
    ADD CONSTRAINT supply_request_lines_supply_request_id_fkey FOREIGN KEY (supply_request_id) REFERENCES public.supply_requests(id);
ALTER TABLE ONLY public.supply_requests
    ADD CONSTRAINT supply_requests_base_id_fkey FOREIGN KEY (base_id) REFERENCES public.bases(id);
\unrestrict FD5byedeLAgimCTz7cKrsoHum6UphKKWoqVvw8VeyGa1yIf6UMwunu3yIIT8hgK
\restrict og4hgV0lyf8UQ7TSbnJNUle77UXJpKoQzZ9JObfe9uy6F23vypvya45FAtTt3D0
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
INSERT INTO public.schema_migrations VALUES ('20190304091200');
INSERT INTO public.schema_migrations VALUES ('20190312203507');
INSERT INTO public.schema_migrations VALUES ('20190321075814');
INSERT INTO public.schema_migrations VALUES ('20190329192121');
INSERT INTO public.schema_migrations VALUES ('20190407064428');
INSERT INTO public.schema_migrations VALUES ('20190415180735');
INSERT INTO public.schema_migrations VALUES ('20190424053042');
INSERT INTO public.schema_migrations VALUES ('20190502165349');
INSERT INTO public.schema_migrations VALUES ('20190511041656');
INSERT INTO public.schema_migrations VALUES ('20190519154003');
INSERT INTO public.schema_migrations VALUES ('20190528030310');
INSERT INTO public.schema_migrations VALUES ('20190605142617');
INSERT INTO public.schema_migrations VALUES ('20190614014924');
INSERT INTO public.schema_migrations VALUES ('20190622131231');
INSERT INTO public.schema_migrations VALUES ('20190701003538');
INSERT INTO public.schema_migrations VALUES ('20190709115845');
INSERT INTO public.schema_migrations VALUES ('20190717232152');
INSERT INTO public.schema_migrations VALUES ('20190726104459');
INSERT INTO public.schema_migrations VALUES ('20190803220806');
INSERT INTO public.schema_migrations VALUES ('20190812093113');
INSERT INTO public.schema_migrations VALUES ('20190820205420');
INSERT INTO public.schema_migrations VALUES ('20190829081727');
INSERT INTO public.schema_migrations VALUES ('20190906194034');
INSERT INTO public.schema_migrations VALUES ('20190915070341');
INSERT INTO public.schema_migrations VALUES ('20190923182648');
INSERT INTO public.schema_migrations VALUES ('20191002054955');
INSERT INTO public.schema_migrations VALUES ('20191010171302');
INSERT INTO public.schema_migrations VALUES ('20191019043609');
INSERT INTO public.schema_migrations VALUES ('20191027155916');
INSERT INTO public.schema_migrations VALUES ('20191105032223');
INSERT INTO public.schema_migrations VALUES ('20191113144530');
INSERT INTO public.schema_migrations VALUES ('20191122020837');
INSERT INTO public.schema_migrations VALUES ('20191130133144');
INSERT INTO public.schema_migrations VALUES ('20191209005451');
INSERT INTO public.schema_migrations VALUES ('20191217121758');
INSERT INTO public.schema_migrations VALUES ('20191225234105');
INSERT INTO public.schema_migrations VALUES ('20200103110412');
INSERT INTO public.schema_migrations VALUES ('20200111222719');
INSERT INTO public.schema_migrations VALUES ('20200120095026');
INSERT INTO public.schema_migrations VALUES ('20200128211333');
INSERT INTO public.schema_migrations VALUES ('20200206083640');
INSERT INTO public.schema_migrations VALUES ('20200214195947');
INSERT INTO public.schema_migrations VALUES ('20200223072254');
INSERT INTO public.schema_migrations VALUES ('20200302184601');
INSERT INTO public.schema_migrations VALUES ('20200311060908');
INSERT INTO public.schema_migrations VALUES ('20200319173215');
INSERT INTO public.schema_migrations VALUES ('20200328045522');
INSERT INTO public.schema_migrations VALUES ('20200405161829');
INSERT INTO public.schema_migrations VALUES ('20200414034136');
INSERT INTO public.schema_migrations VALUES ('20200422150443');
INSERT INTO public.schema_migrations VALUES ('20200501022750');
INSERT INTO public.schema_migrations VALUES ('20200509135057');
INSERT INTO public.schema_migrations VALUES ('20200518011404');
INSERT INTO public.schema_migrations VALUES ('20200526123711');
INSERT INTO public.schema_migrations VALUES ('20200604000018');
INSERT INTO public.schema_migrations VALUES ('20200612112325');
INSERT INTO public.schema_migrations VALUES ('20200620224632');
INSERT INTO public.schema_migrations VALUES ('20200629100939');
INSERT INTO public.schema_migrations VALUES ('20200707213246');
INSERT INTO public.schema_migrations VALUES ('20200716085553');
INSERT INTO public.schema_migrations VALUES ('20200724201900');
INSERT INTO public.schema_migrations VALUES ('20200802074207');
INSERT INTO public.schema_migrations VALUES ('20200810190514');
INSERT INTO public.schema_migrations VALUES ('20200819062821');
INSERT INTO public.schema_migrations VALUES ('20200827175128');
INSERT INTO public.schema_migrations VALUES ('20200905051435');
INSERT INTO public.schema_migrations VALUES ('20200913163742');
INSERT INTO public.schema_migrations VALUES ('20200922040049');
INSERT INTO public.schema_migrations VALUES ('20200930152356');
INSERT INTO public.schema_migrations VALUES ('20201009024703');
INSERT INTO public.schema_migrations VALUES ('20201017141010');
INSERT INTO public.schema_migrations VALUES ('20201026013317');
INSERT INTO public.schema_migrations VALUES ('20201103125624');
INSERT INTO public.schema_migrations VALUES ('20201112001931');
INSERT INTO public.schema_migrations VALUES ('20201120114238');
INSERT INTO public.schema_migrations VALUES ('20201128230545');
INSERT INTO public.schema_migrations VALUES ('20201207102852');
INSERT INTO public.schema_migrations VALUES ('20201215215159');
INSERT INTO public.schema_migrations VALUES ('20201224091506');
INSERT INTO public.schema_migrations VALUES ('20210101203813');
INSERT INTO public.schema_migrations VALUES ('20210110080120');
INSERT INTO public.schema_migrations VALUES ('20210118192427');
INSERT INTO public.schema_migrations VALUES ('20210127064734');
INSERT INTO public.schema_migrations VALUES ('20210204181041');
INSERT INTO public.schema_migrations VALUES ('20210213053348');
INSERT INTO public.schema_migrations VALUES ('20210221165655');
INSERT INTO public.schema_migrations VALUES ('20210302042002');
INSERT INTO public.schema_migrations VALUES ('20210310154309');
INSERT INTO public.schema_migrations VALUES ('20210319030616');
INSERT INTO public.schema_migrations VALUES ('20210327142923');
INSERT INTO public.schema_migrations VALUES ('20210405015230');
INSERT INTO public.schema_migrations VALUES ('20210413131537');
INSERT INTO public.schema_migrations VALUES ('20210422003844');
INSERT INTO public.schema_migrations VALUES ('20210430120151');
INSERT INTO public.schema_migrations VALUES ('20210508232458');
INSERT INTO public.schema_migrations VALUES ('20210517104805');
INSERT INTO public.schema_migrations VALUES ('20210525221112');
INSERT INTO public.schema_migrations VALUES ('20210603093419');
INSERT INTO public.schema_migrations VALUES ('20210611205726');
INSERT INTO public.schema_migrations VALUES ('20210620082033');
INSERT INTO public.schema_migrations VALUES ('20210628194340');
INSERT INTO public.schema_migrations VALUES ('20210707070647');
INSERT INTO public.schema_migrations VALUES ('20210715182954');
INSERT INTO public.schema_migrations VALUES ('20210724055301');
INSERT INTO public.schema_migrations VALUES ('20210801171608');
INSERT INTO public.schema_migrations VALUES ('20210810043915');
INSERT INTO public.schema_migrations VALUES ('20210818160222');
INSERT INTO public.schema_migrations VALUES ('20210827032529');
INSERT INTO public.schema_migrations VALUES ('20210904144836');
INSERT INTO public.schema_migrations VALUES ('20210913021143');
INSERT INTO public.schema_migrations VALUES ('20210921133450');
INSERT INTO public.schema_migrations VALUES ('20210930005757');
INSERT INTO public.schema_migrations VALUES ('20211008122104');
INSERT INTO public.schema_migrations VALUES ('20211016234411');
INSERT INTO public.schema_migrations VALUES ('20211025110718');
INSERT INTO public.schema_migrations VALUES ('20211102223025');
INSERT INTO public.schema_migrations VALUES ('20211111095332');
INSERT INTO public.schema_migrations VALUES ('20211119211639');
INSERT INTO public.schema_migrations VALUES ('20211128083946');
INSERT INTO public.schema_migrations VALUES ('20211206200253');
INSERT INTO public.schema_migrations VALUES ('20211215072600');
INSERT INTO public.schema_migrations VALUES ('20211223184907');
INSERT INTO public.schema_migrations VALUES ('20220101061214');
INSERT INTO public.schema_migrations VALUES ('20220109173521');
INSERT INTO public.schema_migrations VALUES ('20220118045828');
INSERT INTO public.schema_migrations VALUES ('20220126162135');
INSERT INTO public.schema_migrations VALUES ('20220204034442');
INSERT INTO public.schema_migrations VALUES ('20220212150749');
INSERT INTO public.schema_migrations VALUES ('20220221023056');
INSERT INTO public.schema_migrations VALUES ('20220301135403');
INSERT INTO public.schema_migrations VALUES ('20220310011710');
INSERT INTO public.schema_migrations VALUES ('20220318124017');
INSERT INTO public.schema_migrations VALUES ('20220327000324');
INSERT INTO public.schema_migrations VALUES ('20220404112631');
INSERT INTO public.schema_migrations VALUES ('20220412224938');
INSERT INTO public.schema_migrations VALUES ('20220421101245');
INSERT INTO public.schema_migrations VALUES ('20220429213552');
INSERT INTO public.schema_migrations VALUES ('20220508085859');
INSERT INTO public.schema_migrations VALUES ('20220516202206');
INSERT INTO public.schema_migrations VALUES ('20220525074513');
INSERT INTO public.schema_migrations VALUES ('20220602190820');
INSERT INTO public.schema_migrations VALUES ('20220611063127');
INSERT INTO public.schema_migrations VALUES ('20220619175434');
INSERT INTO public.schema_migrations VALUES ('20220628051741');
INSERT INTO public.schema_migrations VALUES ('20220706164048');
INSERT INTO public.schema_migrations VALUES ('20220715040355');
INSERT INTO public.schema_migrations VALUES ('20220723152702');
INSERT INTO public.schema_migrations VALUES ('20220801025009');
INSERT INTO public.schema_migrations VALUES ('20220809141316');
INSERT INTO public.schema_migrations VALUES ('20220818013623');
INSERT INTO public.schema_migrations VALUES ('20220826125930');
INSERT INTO public.schema_migrations VALUES ('20220904002237');
INSERT INTO public.schema_migrations VALUES ('20220912114544');
INSERT INTO public.schema_migrations VALUES ('20220920230851');
INSERT INTO public.schema_migrations VALUES ('20220929103158');
INSERT INTO public.schema_migrations VALUES ('20221007215505');
INSERT INTO public.schema_migrations VALUES ('20221016091812');
INSERT INTO public.schema_migrations VALUES ('20221024204119');
INSERT INTO public.schema_migrations VALUES ('20221102080426');
INSERT INTO public.schema_migrations VALUES ('20221110192733');
INSERT INTO public.schema_migrations VALUES ('20221119065040');
INSERT INTO public.schema_migrations VALUES ('20221127181347');
INSERT INTO public.schema_migrations VALUES ('20221206053654');
INSERT INTO public.schema_migrations VALUES ('20221214170001');
INSERT INTO public.schema_migrations VALUES ('20221223042308');
INSERT INTO public.schema_migrations VALUES ('20221231154615');
INSERT INTO public.schema_migrations VALUES ('20230109030922');
INSERT INTO public.schema_migrations VALUES ('20230117143229');
INSERT INTO public.schema_migrations VALUES ('20230126015536');
INSERT INTO public.schema_migrations VALUES ('20230203131843');
INSERT INTO public.schema_migrations VALUES ('20230212004150');
INSERT INTO public.schema_migrations VALUES ('20230220120457');
INSERT INTO public.schema_migrations VALUES ('20230228232804');
INSERT INTO public.schema_migrations VALUES ('20230309105111');
INSERT INTO public.schema_migrations VALUES ('20230317221418');
INSERT INTO public.schema_migrations VALUES ('20230326093725');
INSERT INTO public.schema_migrations VALUES ('20230403210032');
INSERT INTO public.schema_migrations VALUES ('20230412082339');
INSERT INTO public.schema_migrations VALUES ('20230420194646');
INSERT INTO public.schema_migrations VALUES ('20230429070953');
INSERT INTO public.schema_migrations VALUES ('20230507183300');
INSERT INTO public.schema_migrations VALUES ('20230516055607');
INSERT INTO public.schema_migrations VALUES ('20230524171914');
INSERT INTO public.schema_migrations VALUES ('20230602044221');
INSERT INTO public.schema_migrations VALUES ('20230610160528');
INSERT INTO public.schema_migrations VALUES ('20230619032835');
INSERT INTO public.schema_migrations VALUES ('20230627145142');
INSERT INTO public.schema_migrations VALUES ('20230706021449');
INSERT INTO public.schema_migrations VALUES ('20230714133756');
INSERT INTO public.schema_migrations VALUES ('20230723010103');
INSERT INTO public.schema_migrations VALUES ('20230731122410');
INSERT INTO public.schema_migrations VALUES ('20230808234717');
INSERT INTO public.schema_migrations VALUES ('20230817111024');
INSERT INTO public.schema_migrations VALUES ('20230825223331');
INSERT INTO public.schema_migrations VALUES ('20230903095638');
INSERT INTO public.schema_migrations VALUES ('20230911211945');
INSERT INTO public.schema_migrations VALUES ('20230920084252');
INSERT INTO public.schema_migrations VALUES ('20230928200559');
INSERT INTO public.schema_migrations VALUES ('20231007072906');
INSERT INTO public.schema_migrations VALUES ('20231015185213');
INSERT INTO public.schema_migrations VALUES ('20231024061520');
INSERT INTO public.schema_migrations VALUES ('20231101173827');
INSERT INTO public.schema_migrations VALUES ('20231110050134');
INSERT INTO public.schema_migrations VALUES ('20231118162441');
INSERT INTO public.schema_migrations VALUES ('20231127034748');
INSERT INTO public.schema_migrations VALUES ('20231205151055');
INSERT INTO public.schema_migrations VALUES ('20231214023402');
INSERT INTO public.schema_migrations VALUES ('20231222135709');
INSERT INTO public.schema_migrations VALUES ('20231231012016');
INSERT INTO public.schema_migrations VALUES ('20240108124323');
INSERT INTO public.schema_migrations VALUES ('20240117000630');
INSERT INTO public.schema_migrations VALUES ('20240125112937');
INSERT INTO public.schema_migrations VALUES ('20240202225244');
INSERT INTO public.schema_migrations VALUES ('20240211101551');
INSERT INTO public.schema_migrations VALUES ('20240219213858');
INSERT INTO public.schema_migrations VALUES ('20240228090205');
INSERT INTO public.schema_migrations VALUES ('20240307202512');
INSERT INTO public.schema_migrations VALUES ('20240316074819');
INSERT INTO public.schema_migrations VALUES ('20240324191126');
INSERT INTO public.schema_migrations VALUES ('20240402063433');
INSERT INTO public.schema_migrations VALUES ('20240410175740');
INSERT INTO public.schema_migrations VALUES ('20240419052047');
INSERT INTO public.schema_migrations VALUES ('20240427164354');
INSERT INTO public.schema_migrations VALUES ('20240506040701');
INSERT INTO public.schema_migrations VALUES ('20240514153008');
INSERT INTO public.schema_migrations VALUES ('20240523025315');
INSERT INTO public.schema_migrations VALUES ('20240531141622');
INSERT INTO public.schema_migrations VALUES ('20240609013929');
INSERT INTO public.schema_migrations VALUES ('20240617130236');
INSERT INTO public.schema_migrations VALUES ('20240626002543');
INSERT INTO public.schema_migrations VALUES ('20240704114850');
INSERT INTO public.schema_migrations VALUES ('20240712231157');
INSERT INTO public.schema_migrations VALUES ('20240721103504');
INSERT INTO public.schema_migrations VALUES ('20240729215811');
INSERT INTO public.schema_migrations VALUES ('20240807092118');
INSERT INTO public.schema_migrations VALUES ('20240815204425');
INSERT INTO public.schema_migrations VALUES ('20240824080732');
INSERT INTO public.schema_migrations VALUES ('20240901193039');
INSERT INTO public.schema_migrations VALUES ('20240910065346');
INSERT INTO public.schema_migrations VALUES ('20240918181653');
INSERT INTO public.schema_migrations VALUES ('20240927054000');
INSERT INTO public.schema_migrations VALUES ('20241005170307');
INSERT INTO public.schema_migrations VALUES ('20241014042614');
INSERT INTO public.schema_migrations VALUES ('20241022154921');
INSERT INTO public.schema_migrations VALUES ('20241031031228');
INSERT INTO public.schema_migrations VALUES ('20241108143535');
INSERT INTO public.schema_migrations VALUES ('20241117015842');
INSERT INTO public.schema_migrations VALUES ('20241125132149');
INSERT INTO public.schema_migrations VALUES ('20241204004456');
INSERT INTO public.schema_migrations VALUES ('20241212120803');
INSERT INTO public.schema_migrations VALUES ('20241220233110');
INSERT INTO public.schema_migrations VALUES ('20241229105417');
INSERT INTO public.schema_migrations VALUES ('20250106221724');
INSERT INTO public.schema_migrations VALUES ('20250115094031');
INSERT INTO public.schema_migrations VALUES ('20250123210338');
INSERT INTO public.schema_migrations VALUES ('20250201082645');
INSERT INTO public.schema_migrations VALUES ('20250209194952');
INSERT INTO public.schema_migrations VALUES ('20250218071259');
INSERT INTO public.schema_migrations VALUES ('20250226183606');
INSERT INTO public.schema_migrations VALUES ('20250307055913');
INSERT INTO public.schema_migrations VALUES ('20250315172220');
INSERT INTO public.schema_migrations VALUES ('20250324044527');
INSERT INTO public.schema_migrations VALUES ('20250401160834');
INSERT INTO public.schema_migrations VALUES ('20250410033141');
INSERT INTO public.schema_migrations VALUES ('20250418145448');
INSERT INTO public.schema_migrations VALUES ('20250427021755');
INSERT INTO public.schema_migrations VALUES ('20250505134102');
INSERT INTO public.schema_migrations VALUES ('20250514010409');
INSERT INTO public.schema_migrations VALUES ('20250522122716');
INSERT INTO public.schema_migrations VALUES ('20250530235023');
INSERT INTO public.schema_migrations VALUES ('20250608111330');
INSERT INTO public.schema_migrations VALUES ('20250616223637');
INSERT INTO public.schema_migrations VALUES ('20250625095944');
INSERT INTO public.schema_migrations VALUES ('20250703212251');
INSERT INTO public.schema_migrations VALUES ('20250712084558');
INSERT INTO public.schema_migrations VALUES ('20250720200905');
INSERT INTO public.schema_migrations VALUES ('20250729073212');
INSERT INTO public.schema_migrations VALUES ('20250806185519');
INSERT INTO public.schema_migrations VALUES ('20250815061826');
INSERT INTO public.schema_migrations VALUES ('20250823174133');
INSERT INTO public.schema_migrations VALUES ('20250901050440');
INSERT INTO public.schema_migrations VALUES ('20250909162747');
INSERT INTO public.schema_migrations VALUES ('20250918035054');
INSERT INTO public.schema_migrations VALUES ('20250926151401');
INSERT INTO public.schema_migrations VALUES ('20251005023708');
INSERT INTO public.schema_migrations VALUES ('20251013140015');
INSERT INTO public.schema_migrations VALUES ('20251022012322');
INSERT INTO public.schema_migrations VALUES ('20251030124629');
INSERT INTO public.schema_migrations VALUES ('20251108000936');
INSERT INTO public.schema_migrations VALUES ('20251116113243');
INSERT INTO public.schema_migrations VALUES ('20251124225550');
INSERT INTO public.schema_migrations VALUES ('20251203101857');
INSERT INTO public.schema_migrations VALUES ('20251211214204');
INSERT INTO public.schema_migrations VALUES ('20251220090511');
INSERT INTO public.schema_migrations VALUES ('20251228202818');
INSERT INTO public.schema_migrations VALUES ('20260106075125');
INSERT INTO public.schema_migrations VALUES ('20260114191432');
INSERT INTO public.schema_migrations VALUES ('20260123063739');
INSERT INTO public.schema_migrations VALUES ('20260131180046');
INSERT INTO public.schema_migrations VALUES ('20260209052353');
INSERT INTO public.schema_migrations VALUES ('20260217164700');
INSERT INTO public.schema_migrations VALUES ('20260226041007');
INSERT INTO public.schema_migrations VALUES ('20260306153314');
INSERT INTO public.schema_migrations VALUES ('20260315025621');
INSERT INTO public.schema_migrations VALUES ('20260323141928');
INSERT INTO public.schema_migrations VALUES ('20260401014235');
INSERT INTO public.schema_migrations VALUES ('20260409130542');
INSERT INTO public.schema_migrations VALUES ('20260418002849');
INSERT INTO public.schema_migrations VALUES ('20260426115156');
INSERT INTO public.schema_migrations VALUES ('20260504231503');
INSERT INTO public.schema_migrations VALUES ('20260513103810');
INSERT INTO public.schema_migrations VALUES ('20260521220117');
INSERT INTO public.schema_migrations VALUES ('20260530092424');
INSERT INTO public.schema_migrations VALUES ('20260607204731');
INSERT INTO public.schema_migrations VALUES ('20260616081038');
INSERT INTO public.schema_migrations VALUES ('20260624193345');
INSERT INTO public.schema_migrations VALUES ('20260703065652');
INSERT INTO public.schema_migrations VALUES ('20260711181959');
INSERT INTO public.schema_migrations VALUES ('20260720054306');
INSERT INTO public.schema_migrations VALUES ('20260728170613');
INSERT INTO public.schema_migrations VALUES ('20260806042920');
INSERT INTO public.schema_migrations VALUES ('20260814155227');
INSERT INTO public.schema_migrations VALUES ('20260823031534');
\unrestrict og4hgV0lyf8UQ7TSbnJNUle77UXJpKoQzZ9JObfe9uy6F23vypvya45FAtTt3D0
