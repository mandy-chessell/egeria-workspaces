create user egeria_admin with superuser login password 'admin4egeria';
create user egeria_user with login password 'user4egeria';
create database egeria_observations;

grant all privileges on database egeria_observations to egeria_admin, egeria_user;


\c egeria_observations;
create schema open_metadata;
create schema audit_log;
create schema surveys;
grant all on schema open_metadata, audit_log, surveys to egeria_admin, egeria_user;


DROP TABLE IF EXISTS audit_log.al_api_calls;
CREATE TABLE audit_log.al_api_calls (thread_id BIGINT NOT NULL, server_name TEXT NOT NULL, user_name TEXT NOT NULL, operation_name TEXT NOT NULL, service_name TEXT NOT NULL, call_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL);
COMMENT ON TABLE audit_log.al_api_calls IS 'Calls to Egeria REST APIs';
COMMENT ON COLUMN audit_log.al_api_calls.thread_id IS 'Thread running the request';
COMMENT ON COLUMN audit_log.al_api_calls.server_name IS 'Name of the called server';
COMMENT ON COLUMN audit_log.al_api_calls.user_name IS 'Identifier of calling user';
COMMENT ON COLUMN audit_log.al_api_calls.operation_name IS 'Name of the called method';
COMMENT ON COLUMN audit_log.al_api_calls.service_name IS 'The service supporting the called method';
COMMENT ON COLUMN audit_log.al_api_calls.call_time IS 'Time that the request was made.';
DROP TABLE IF EXISTS audit_log.al_asset_activity;
CREATE TABLE audit_log.al_asset_activity (thread_id BIGINT NOT NULL, server_name TEXT NOT NULL, call_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, asset_operation TEXT NOT NULL, asset_guid TEXT NOT NULL, asset_type TEXT NOT NULL, operation_name TEXT NOT NULL, service_name TEXT NOT NULL, user_name TEXT NOT NULL);
COMMENT ON TABLE audit_log.al_asset_activity IS 'User activity around an om_asset';
COMMENT ON COLUMN audit_log.al_asset_activity.thread_id IS 'Thread where the request ran';
COMMENT ON COLUMN audit_log.al_asset_activity.server_name IS 'Name of the called server';
COMMENT ON COLUMN audit_log.al_asset_activity.call_time IS 'Time that the request was made';
COMMENT ON COLUMN audit_log.al_asset_activity.asset_operation IS 'Create, Update, Delete, Attachment, Feedback';
COMMENT ON COLUMN audit_log.al_asset_activity.asset_guid IS 'Unique identifier of the om_asset';
COMMENT ON COLUMN audit_log.al_asset_activity.asset_type IS 'Type of the om_asset';
COMMENT ON COLUMN audit_log.al_asset_activity.operation_name IS 'Called method';
COMMENT ON COLUMN audit_log.al_asset_activity.service_name IS 'Name of the called service';
COMMENT ON COLUMN audit_log.al_asset_activity.user_name IS 'Name of the requesting user.';
DROP TABLE IF EXISTS audit_log.al_audit_events;
CREATE TABLE audit_log.al_audit_events (message_ts TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, server_name TEXT, action_description TEXT, severity_code TEXT, severity TEXT, message_id TEXT, message_text TEXT, message_parameters TEXT, system_action TEXT, user_action TEXT, exception_class_name TEXT, exception_message TEXT, exception_stacktrace TEXT, organization TEXT, component_name TEXT, additional_info TEXT, log_record_id TEXT NOT NULL, thread_id BIGINT, CONSTRAINT audit_events_pk PRIMARY KEY (log_record_id, message_ts));
COMMENT ON COLUMN audit_log.al_audit_events.thread_id IS 'Thread where the request ran';
DROP TABLE IF EXISTS audit_log.al_egeria_components;
CREATE TABLE audit_log.al_egeria_components (component_id INTEGER NOT NULL, development_status CHARACTER VARYING(20), component_name TEXT, component_description TEXT, component_wiki_url TEXT, CONSTRAINT egeriacomponents_ix1 UNIQUE (component_id));
DROP TABLE IF EXISTS audit_log.al_egeria_exceptions;
CREATE TABLE audit_log.al_egeria_exceptions (exception_class_name TEXT NOT NULL, exception_message TEXT NOT NULL, system_action TEXT NOT NULL, user_action TEXT NOT NULL, message_ts TEXT NOT NULL, log_record_id TEXT NOT NULL, CONSTRAINT egeria_exceptions_pk PRIMARY KEY (log_record_id));
COMMENT ON COLUMN audit_log.al_egeria_exceptions.message_ts IS 'Timestamp of log record';
COMMENT ON COLUMN audit_log.al_egeria_exceptions.log_record_id IS 'Unique identifier of the reporting log record.';
DROP TABLE IF EXISTS audit_log.al_omag_servers;
CREATE TABLE audit_log.al_omag_servers (server_name TEXT NOT NULL, server_type TEXT, organization TEXT, metadata_collection_id TEXT, CONSTRAINT omag_servers_pk PRIMARY KEY (server_name));
COMMENT ON COLUMN audit_log.al_omag_servers.server_name IS 'Name of the server';
COMMENT ON COLUMN audit_log.al_omag_servers.server_type IS 'Type of server';
COMMENT ON COLUMN audit_log.al_omag_servers.organization IS 'Name ofthe organization that runs this server.';
COMMENT ON COLUMN audit_log.al_omag_servers.metadata_collection_id IS 'Identifier for the metadata collection beinf maintained by this server';

DROP TABLE IF EXISTS open_metadata.om_asset;
CREATE TABLE open_metadata.om_asset (resource_name TEXT, resource_description TEXT, version_id TEXT, display_name TEXT, display_description TEXT, asset_guid TEXT NOT NULL, qualified_name TEXT NOT NULL, display_summary TEXT, abbrev TEXT, usage TEXT, additional_properties TEXT, owner_guid TEXT, owner_type TEXT, origin_org_guid TEXT, origin_biz_cap_guid TEXT, zone_names TEXT, asset_type TEXT NOT NULL, resource_loc_guid TEXT, confidentiality INTEGER, confidence INTEGER, criticality INTEGER, metadata_collection_id TEXT NOT NULL, license_guid TEXT, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, last_update_timestamp TIMESTAMP(6) WITHOUT TIME ZONE, last_updated_by TEXT, creation_timestamp TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, created_by TEXT, maintained_by TEXT, archived TIMESTAMP(6) WITHOUT TIME ZONE, tags TEXT, semantic_term TEXT, PRIMARY KEY (asset_guid, sync_time));
COMMENT ON TABLE open_metadata.om_asset IS 'Assets catalogued in the Egeria ecosystem';
COMMENT ON COLUMN open_metadata.om_asset.sync_time IS 'The time at which egeria update this row.';
DROP TABLE IF EXISTS open_metadata.om_asset_types;
CREATE TABLE open_metadata.om_asset_types (leaf_type TEXT NOT NULL, type_description TEXT, super_types JSONB, CONSTRAINT asset_types_pk PRIMARY KEY (leaf_type));
DROP TABLE IF EXISTS open_metadata.om_certification_type;
CREATE TABLE open_metadata.om_certification_type (certification_type_guid TEXT NOT NULL, certification_title TEXT NOT NULL, certification_summary TEXT, PRIMARY KEY (certification_type_guid));
COMMENT ON TABLE open_metadata.om_certification_type IS 'map certification guids to names';
DROP TABLE IF EXISTS open_metadata.om_certifications;
CREATE TABLE open_metadata.om_certifications (referenceable_guid TEXT NOT NULL, certification_guid TEXT NOT NULL, certification_type_guid TEXT NOT NULL, start_date DATE, end_date DATE, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY (certification_guid, sync_time));
COMMENT ON TABLE open_metadata.om_certifications IS 'om_certifications associated wtih assets';
DROP TABLE IF EXISTS open_metadata.om_collaboration_activity;
CREATE TABLE open_metadata.om_collaboration_activity (element_guid TEXT NOT NULL, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, num_comments INTEGER, num_ratings INTEGER, avg_rating INTEGER, num_tags INTEGER, num_likes INTEGER, PRIMARY KEY (element_guid, sync_time));
COMMENT ON TABLE open_metadata.om_collaboration_activity IS 'Track the user feedback over time';
COMMENT ON COLUMN open_metadata.om_collaboration_activity.element_guid IS 'Either an om_asset or glossary element';
COMMENT ON COLUMN open_metadata.om_collaboration_activity.sync_time IS 'The last time that the information was updated in the database by Egeria.';
DROP TABLE IF EXISTS open_metadata.om_context_event_types;
CREATE TABLE open_metadata.om_context_event_types (guid TEXT NOT NULL, qualified_name TEXT NOT NULL, ce_type_name TEXT NOT NULL, description TEXT);
DROP TABLE IF EXISTS open_metadata.om_context_events;
CREATE TABLE open_metadata.om_context_events (guid TEXT NOT NULL, qualified_name TEXT NOT NULL, display_name TEXT NOT NULL, description TEXT, event_effect TEXT, context_event_type TEXT NOT NULL, planned_start_date DATE, planned_duration NUMERIC, actual_duration NUMERIC, repeat_interval NUMERIC, planned_completion_date DATE, actual_completion_date DATE, reference_effective_from DATE, reference_effective_to DATE, additional_properties TEXT);
DROP TABLE IF EXISTS open_metadata.om_contributions;
CREATE TABLE open_metadata.om_contributions (user_guid TEXT NOT NULL, snapshot_timestamp TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, karma_points BIGINT, PRIMARY KEY (user_guid, snapshot_timestamp));
COMMENT ON TABLE open_metadata.om_contributions IS 'This reflects the om_contributions per user over time.';
DROP TABLE IF EXISTS open_metadata.om_correlation_properties;
CREATE TABLE open_metadata.om_correlation_properties (external_identifier TEXT NOT NULL, last_updated_by TEXT, last_update_time TIMESTAMP(6) WITHOUT TIME ZONE, created_by TEXT, version BIGINT, creation_time TIMESTAMP(6) WITHOUT TIME ZONE, type_name TEXT, egeria_owned BOOLEAN NOT NULL, additional_properties TEXT, element_guid TEXT NOT NULL, external_source_guid TEXT NOT NULL, last_confirmed_sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY (external_identifier, element_guid, external_source_guid, last_confirmed_sync_time));
COMMENT ON TABLE open_metadata.om_correlation_properties IS 'most of the information comes from  external_id entity that represents an instance in a 3rd party catalog. This includes the user information from that third party.';
DROP TABLE IF EXISTS open_metadata.om_data_fields;
CREATE TABLE open_metadata.om_data_fields (data_field_guid TEXT NOT NULL, data_field_name TEXT, version_id CHARACTER VARYING(80), semantic_term CHARACTER VARYING(80), has_profile BOOLEAN, confidentiality_level INTEGER, asset_qualified_name TEXT, asset_guid TEXT NOT NULL, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY (data_field_guid, sync_time));
DROP TABLE IF EXISTS open_metadata.om_department;
CREATE TABLE open_metadata.om_department (dep_id CHARACTER VARYING(40) NOT NULL, dep_name TEXT, manager CHARACTER VARYING(40), parent_department TEXT, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY (dep_id, sync_time));
COMMENT ON TABLE open_metadata.om_department IS 'Maps Department codes to Department names';
DROP TABLE IF EXISTS open_metadata.om_external_audit_logs;
CREATE TABLE open_metadata.om_external_audit_logs (metadata_collection_id TEXT NOT NULL, external_identifier TEXT NOT NULL, activity_timestamp TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, activity_type TEXT, user_id TEXT, event_key TEXT, PRIMARY KEY (metadata_collection_id, external_identifier, activity_timestamp));
DROP TABLE IF EXISTS open_metadata.om_external_user;
CREATE TABLE open_metadata.om_external_user (metadata_collection_id TEXT NOT NULL, external_user TEXT NOT NULL, user_id_guid TEXT, start_time TIMESTAMP(6) WITHOUT TIME ZONE, end_time TIMESTAMP(6) WITHOUT TIME ZONE, PRIMARY KEY (metadata_collection_id, external_user));
COMMENT ON TABLE open_metadata.om_external_user IS 'Capture the user information from external systems that may or may not have mapped identities with Egeria.';
DROP TABLE IF EXISTS open_metadata.om_glossary;
CREATE TABLE open_metadata.om_glossary (glossary_name TEXT, glossary_language TEXT, classifications TEXT, glossary_description TEXT, glossary_guid TEXT NOT NULL, qualified_name TEXT NOT NULL, number_terms BIGINT, number_categories INTEGER, num_linked_terms BIGINT, usage TEXT, additional_properties TEXT, owner_guid TEXT, owner_type TEXT, metadata_collection_id TEXT, license_guid TEXT, last_update_timestamp TIMESTAMP(6) WITHOUT TIME ZONE, creation_timestamp TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY (glossary_guid, sync_time));
COMMENT ON TABLE open_metadata.om_glossary IS 'Glossaries catalogued in the Egeria ecosystem';
COMMENT ON COLUMN open_metadata.om_glossary.last_update_timestamp IS 'This is the last update time from the glossary element.';
DROP TABLE IF EXISTS open_metadata.om_license;
CREATE TABLE open_metadata.om_license (license_guid TEXT NOT NULL, license_name TEXT, license_description TEXT, PRIMARY KEY (license_guid));
DROP TABLE IF EXISTS open_metadata.om_location;
CREATE TABLE open_metadata.om_location (location_guid TEXT NOT NULL, location_name TEXT, location_type TEXT, PRIMARY KEY (location_guid));
DROP TABLE IF EXISTS open_metadata.om_metadata_collection;
CREATE TABLE open_metadata.om_metadata_collection (metadata_collection_id TEXT NOT NULL, metadata_collection_name TEXT, metadata_collection_type CHARACTER VARYING(40), deployed_impl_type TEXT, PRIMARY KEY (metadata_collection_id));
COMMENT ON COLUMN open_metadata.om_metadata_collection.metadata_collection_type IS 'local cohort vs external source etc - instance provenance type';
COMMENT ON COLUMN open_metadata.om_metadata_collection.deployed_impl_type IS 'This is the type of system (postgres vs db2 vs atlas)';
DROP TABLE IF EXISTS open_metadata.om_reference_levels;
CREATE TABLE open_metadata.om_reference_levels (identifier INTEGER NOT NULL, classification_name TEXT NOT NULL, display_name TEXT, text TEXT, PRIMARY KEY (identifier, classification_name));
COMMENT ON TABLE open_metadata.om_reference_levels IS 'A table to hold the different reference levels for confidentiality, confidence, criticality etc.';
DROP TABLE IF EXISTS open_metadata.om_related_assets;
CREATE TABLE open_metadata.om_related_assets (end1_guid TEXT NOT NULL, end2_guid TEXT NOT NULL, end1_attribute_nm TEXT, end2_attribute_nm TEXT, rel_type_nm TEXT, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, relationship_guid TEXT NOT NULL, PRIMARY KEY (relationship_guid, sync_time));
DROP TABLE IF EXISTS open_metadata.om_role;
CREATE TABLE open_metadata.om_role (role_guid TEXT NOT NULL, role_name TEXT, role_type TEXT, headcount INTEGER, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY (role_guid, sync_time));
DROP TABLE IF EXISTS open_metadata.om_role2user;
CREATE TABLE open_metadata.om_role2user (role_guid TEXT NOT NULL, user_guid TEXT NOT NULL, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, start_date TIMESTAMP(6) WITHOUT TIME ZONE, end_date TIMESTAMP(6) WITHOUT TIME ZONE, relationship_guid TEXT NOT NULL, PRIMARY KEY (relationship_guid, sync_time));
COMMENT ON TABLE open_metadata.om_role2user IS 'Mapping of roles to users';
DROP TABLE IF EXISTS open_metadata.om_term_activity;
CREATE TABLE open_metadata.om_term_activity (term_name TEXT, term_guid TEXT NOT NULL, qualified_name TEXT NOT NULL, term_summary TEXT, version_id TEXT, owner_guid TEXT, owner_type TEXT, confidentiality INTEGER, confidence INTEGER, criticality INTEGER, last_feedback_timestamp TIMESTAMP(6) WITHOUT TIME ZONE, creation_timestamp TIMESTAMP(6) WITHOUT TIME ZONE, number_linked_element INTEGER, last_link_timestamp TIMESTAMP(6) WITHOUT TIME ZONE, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, glossary_guid TEXT NOT NULL, PRIMARY KEY (term_guid, sync_time));
COMMENT ON TABLE open_metadata.om_term_activity IS 'Term activity - ';
COMMENT ON COLUMN open_metadata.om_term_activity.last_feedback_timestamp IS 'Time of last feedback update on this term';
COMMENT ON COLUMN open_metadata.om_term_activity.glossary_guid IS 'This is the owning glossary rather than where the term might show up.';
DROP TABLE IF EXISTS open_metadata.om_todo;
CREATE TABLE open_metadata.om_todo (todo_guid TEXT NOT NULL, qualified_name TEXT, display_name TEXT, creation_time TIMESTAMP(6) WITHOUT TIME ZONE, todo_type TEXT, priority INTEGER, due_time TIMESTAMP(6) WITHOUT TIME ZONE, completion_time TIMESTAMP(6) WITHOUT TIME ZONE, status TEXT, todo_source_guid TEXT, todo_source_type TEXT, last_reviewed_time TIMESTAMP(6) WITHOUT TIME ZONE, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, actor_guid TEXT, actor_type TEXT, CONSTRAINT om_todo_pk PRIMARY KEY (sync_time, todo_guid));
COMMENT ON TABLE open_metadata.om_todo IS 'Represent all todos independent of source. The actual implementation of the todo might be in an external system, in which case we would map their external identifiers to our todos through the om_correlation_properties table.';
COMMENT ON COLUMN open_metadata.om_todo.actor_guid IS 'The unique identifier of the actor assigned to perform this ToDo.  An Actor is either a UserId, Profile, or PersonRole.';
COMMENT ON COLUMN open_metadata.om_todo.actor_type IS 'Type name of actor';
DROP TABLE IF EXISTS open_metadata.om_user_identity;
CREATE TABLE open_metadata.om_user_identity (employee_num CHARACTER VARYING(80), user_id CHARACTER VARYING(80) NOT NULL, preferred_name CHARACTER VARYING(80), org_name CHARACTER VARYING(80), resident_country CHARACTER VARYING(80), location CHARACTER VARYING(80), distinguished_name CHARACTER VARYING(80), user_id_guid CHARACTER VARYING(80) NOT NULL, profile_guid CHARACTER VARYING(80), department_id CHARACTER VARYING(40), sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY (user_id_guid, sync_time));
COMMENT ON TABLE open_metadata.om_user_identity IS 'registered users';
DROP TABLE IF EXISTS open_metadata.rd_file_classifiers;
CREATE TABLE open_metadata.rd_file_classifiers (sr_guid TEXT NOT NULL, filename TEXT NOT NULL, file_extension TEXT, pathname TEXT NOT NULL, file_type TEXT, asset_type TEXT, deployed_implementation_type TEXT, encoding TEXT, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, CONSTRAINT rd_file_classifiers_pk PRIMARY KEY (pathname, sync_time));


DROP TABLE IF EXISTS surveys.sr_database_measurements;
CREATE TABLE surveys.sr_database_measurements (sr_guid TEXT NOT NULL, metadata_collection_id TEXT NOT NULL, subject_guid TEXT, creation_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, annotation_guid TEXT NOT NULL, subject_type TEXT);
COMMENT ON TABLE surveys.sr_database_measurements IS 'Information about a database and its use.';
COMMENT ON COLUMN surveys.sr_database_measurements.metadata_collection_id IS 'This is the metadata_collection_id of the annotation';
DROP TABLE IF EXISTS surveys.sr_file_measurements;
CREATE TABLE surveys.sr_file_measurements (sr_guid TEXT NOT NULL, metadata_collection_id TEXT NOT NULL, subject_guid TEXT, creation_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, annotation_guid TEXT NOT NULL, file_system TEXT, filename TEXT NOT NULL, pathname TEXT NOT NULL, file_extension TEXT, file_type TEXT, deployed_implementation_type TEXT, encoding TEXT, asset_type_name TEXT, can_read BOOLEAN, can_write BOOLEAN, can_execute BOOLEAN, is_sym_link BOOLEAN, file_creation_time TIMESTAMP(6) WITHOUT TIME ZONE, last_modified_time TIMESTAMP(6) WITHOUT TIME ZONE, last_accessed_time TIMESTAMP(6) WITHOUT TIME ZONE, file_size NUMERIC, record_count NUMERIC, is_hidden BOOLEAN, subject_type TEXT, PRIMARY KEY (sr_guid, creation_time, annotation_guid, pathname));
COMMENT ON TABLE surveys.sr_file_measurements IS 'Capturing details about a specific file';
COMMENT ON COLUMN surveys.sr_file_measurements.metadata_collection_id IS 'This is the metadata_collection_id of the annotation';
DROP TABLE IF EXISTS surveys.sr_folder_measurements;
CREATE TABLE surveys.sr_folder_measurements (sr_guid TEXT NOT NULL, metadata_collection_id TEXT NOT NULL, subject_guid TEXT, creation_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, annotation_guid TEXT NOT NULL, file_system TEXT, directory_name TEXT NOT NULL, file_count NUMERIC, total_file_size NUMERIC, sub_directory_count NUMERIC, readable_file_count NUMERIC, writeable_file_count NUMERIC, executable_file_count NUMERIC, sym_link_file_count NUMERIC, hidden_file_count NUMERIC, file_name_count NUMERIC, file_extension_count NUMERIC, file_type_count NUMERIC, asset_type_count NUMERIC, deployed_implementation_type_count NUMERIC, unclassified_file_count NUMERIC, inaccessible_file_count NUMERIC, last_file_creation_time TIMESTAMP(6) WITHOUT TIME ZONE, last_file_modification_time TIMESTAMP(6) WITHOUT TIME ZONE, last_file_accessed_time TIMESTAMP(6) WITHOUT TIME ZONE, subject_type TEXT, PRIMARY KEY (sr_guid, annotation_guid, directory_name, creation_time));
COMMENT ON TABLE surveys.sr_folder_measurements IS 'Measurements describing a directory (file folder).';
COMMENT ON COLUMN surveys.sr_folder_measurements.metadata_collection_id IS 'This is the metadata_collection_id of the annotation';
DROP TABLE IF EXISTS surveys.sr_missing_file_classifiers;
CREATE TABLE surveys.sr_missing_file_classifiers (sr_guid TEXT NOT NULL, file_system TEXT, filename TEXT NOT NULL, file_extension TEXT, pathname TEXT NOT NULL, file_type TEXT, asset_type TEXT, deployed_implementation_type TEXT, file_encoding TEXT, sync_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, CONSTRAINT rd_file_classifiers_pk PRIMARY KEY (pathname, sync_time));
COMMENT ON TABLE surveys.sr_missing_file_classifiers IS 'Different kinds of classifiers for files';
DROP TABLE IF EXISTS surveys.sr_profile_measures;
CREATE TABLE surveys.sr_profile_measures (sr_guid TEXT NOT NULL, metadata_collection_id TEXT NOT NULL, subject_guid TEXT NOT NULL, creation_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, annotation_guid TEXT NOT NULL, measurement_name TEXT NOT NULL, measurement_category TEXT NOT NULL, subject_type TEXT, measurement_value NUMERIC, json_properties JSON, PRIMARY KEY (sr_guid, annotation_guid, measurement_category));
COMMENT ON TABLE surveys.sr_profile_measures IS 'Holds statistics that classify or describe elements within the resource.';
COMMENT ON COLUMN surveys.sr_profile_measures.metadata_collection_id IS 'This is the metadata_collection_id of the annotation';
DROP TABLE IF EXISTS surveys.sr_report;
CREATE TABLE surveys.sr_report (metadata_collection_id TEXT NOT NULL, sr_guid TEXT NOT NULL, qualified_name TEXT NOT NULL, asset_guid TEXT NOT NULL, asset_type TEXT NOT NULL, end_timestamp TIMESTAMP(6) WITHOUT TIME ZONE, start_timestamp TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, engine_action_guid TEXT NOT NULL, initiator TEXT, governance_engine_name TEXT, display_name TEXT, description TEXT, purpose TEXT, request_type TEXT, engine_host_user_id TEXT, CONSTRAINT sr_report_pk PRIMARY KEY (sr_guid));
COMMENT ON TABLE surveys.sr_report IS 'Core information about a survey report';
COMMENT ON COLUMN surveys.sr_report.sr_guid IS 'Unique identifier of a survey report.';
COMMENT ON COLUMN surveys.sr_report.initiator IS 'We are assuming that this is the user_id of the requestor.';
DROP TABLE IF EXISTS surveys.sr_request_for_action;
CREATE TABLE surveys.sr_request_for_action (metadata_collection_id TEXT NOT NULL, sr_guid TEXT NOT NULL, subject_guid TEXT NOT NULL, creation_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, annotation_guid TEXT NOT NULL, action_request_name TEXT NOT NULL, action_target_guid TEXT NOT NULL, subject_type TEXT, action_target_type TEXT, CONSTRAINT sr_request_for_action_pk PRIMARY KEY (annotation_guid, sr_guid));
COMMENT ON TABLE surveys.sr_request_for_action IS 'Describes a request for action annotation generated by a survey report. The result of this annotation will link to triage prioritization and further activity.';
COMMENT ON COLUMN surveys.sr_request_for_action.metadata_collection_id IS 'This is the metadata_collection_id of the annotation';
DROP TABLE IF EXISTS surveys.sr_resource_measurement;
CREATE TABLE surveys.sr_resource_measurement (metadata_collection_id TEXT NOT NULL, sr_guid TEXT NOT NULL, subject_guid TEXT, creation_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, annotation_guid TEXT NOT NULL, measurement_name TEXT NOT NULL, subject_type TEXT, measurement_category TEXT NOT NULL, measurement_value NUMERIC, measurement_display_value TEXT, resource_creation_time TIMESTAMP(6) WITHOUT TIME ZONE, last_modified_time TIMESTAMP(6) WITHOUT TIME ZONE, resource_size NUMERIC, PRIMARY KEY (sr_guid, annotation_guid, measurement_category, metadata_collection_id));
COMMENT ON TABLE surveys.sr_resource_measurement IS 'Holds summary statistics about the whole resource surveyed.';
COMMENT ON COLUMN surveys.sr_resource_measurement.metadata_collection_id IS 'This is the metadata_collection_id of the annotation';
COMMENT ON COLUMN surveys.sr_resource_measurement.measurement_display_value IS 'String version of the display value';

