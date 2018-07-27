SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bills (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    ilga_id integer NOT NULL,
    title character varying,
    summary character varying,
    sponsor_name character varying,
    hearing_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    human_summary character varying,
    os_id character varying,
    session_number integer,
    details_url character varying,
    actions jsonb DEFAULT '[]'::jsonb,
    steps jsonb DEFAULT '[]'::jsonb,
    number character varying NOT NULL,
    slip_url character varying,
    slip_results_url character varying,
    search_vector tsvector
);


--
-- Name: committees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE committees (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    ilga_id integer,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    chamber integer,
    os_id character varying,
    parent_id character varying,
    subcommittee character varying,
    sources character varying
);


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE documents (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    os_id character varying,
    number character varying NOT NULL,
    full_text_url character varying,
    is_amendment boolean DEFAULT false,
    bill_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hearings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hearings (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    ilga_id integer NOT NULL,
    url character varying,
    location character varying NOT NULL,
    date timestamp without time zone NOT NULL,
    is_cancelled boolean DEFAULT false,
    committee_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE legislators (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    os_id character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying,
    twitter character varying,
    district character varying NOT NULL,
    chamber character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active boolean DEFAULT false,
    middle_name character varying NOT NULL,
    suffixes character varying NOT NULL,
    party character varying NOT NULL,
    website_url character varying
);


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE members (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    os_leg_id character varying,
    os_committee_id character varying,
    role character varying,
    session_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bills bills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bills
    ADD CONSTRAINT bills_pkey PRIMARY KEY (id);


--
-- Name: committees committees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY committees
    ADD CONSTRAINT committees_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: hearings hearings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hearings
    ADD CONSTRAINT hearings_pkey PRIMARY KEY (id);


--
-- Name: legislators legislators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY legislators
    ADD CONSTRAINT legislators_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_bills_on_hearing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bills_on_hearing_id ON bills USING btree (hearing_id);


--
-- Name: index_bills_on_ilga_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bills_on_ilga_id ON bills USING btree (ilga_id);


--
-- Name: index_bills_on_last_action_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bills_on_last_action_date ON bills USING btree ((((actions -> '-1'::integer) ->> 'date'::text)) DESC NULLS LAST);


--
-- Name: index_bills_on_last_actor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bills_on_last_actor ON bills USING btree ((((steps -> '-1'::integer) ->> 'actor'::text)));


--
-- Name: index_bills_on_os_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bills_on_os_id ON bills USING btree (os_id);


--
-- Name: index_bills_on_search_vector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bills_on_search_vector ON bills USING gin (search_vector);


--
-- Name: index_committees_on_ilga_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_committees_on_ilga_id ON committees USING btree (ilga_id);


--
-- Name: index_documents_on_bill_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_bill_id ON documents USING btree (bill_id);


--
-- Name: index_hearings_on_committee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_committee_id ON hearings USING btree (committee_id);


--
-- Name: index_hearings_on_ilga_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hearings_on_ilga_id ON hearings USING btree (ilga_id);


--
-- Name: index_legislators_on_os_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_legislators_on_os_id ON legislators USING btree (os_id);


--
-- Name: title_on_bills_trgm_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX title_on_bills_trgm_idx ON bills USING gin (title gin_trgm_ops);


--
-- Name: bills update_search_vector; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_search_vector BEFORE INSERT OR UPDATE ON bills FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'title', 'summary');


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20171017225846'),
('20171205191400'),
('20171205210000'),
('20180205053824'),
('20180304185432'),
('20180307001259'),
('20180307054116'),
('20180308005925'),
('20180311040929'),
('20180426003320'),
('20180429152115'),
('20180626205700'),
('20180626210000');


