BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "directus_migrations" (
	"version"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"timestamp"	datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("version")
);
CREATE TABLE IF NOT EXISTS "directus_folders" (
	"id"	char(36) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"parent"	char(36),
	PRIMARY KEY("id"),
	FOREIGN KEY("parent") REFERENCES "directus_folders"("id")
);
CREATE TABLE IF NOT EXISTS "directus_relations" (
	"id"	integer NOT NULL,
	"many_collection"	varchar(64) NOT NULL,
	"many_field"	varchar(64) NOT NULL,
	"one_collection"	varchar(64),
	"one_field"	varchar(64),
	"one_collection_field"	varchar(64),
	"one_allowed_collections"	text,
	"junction_field"	varchar(64),
	"sort_field"	varchar(64),
	"one_deselect_action"	varchar(255) NOT NULL DEFAULT 'nullify',
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "directus_revisions" (
	"id"	integer NOT NULL,
	"activity"	integer NOT NULL,
	"collection"	varchar(64) NOT NULL,
	"item"	varchar(255) NOT NULL,
	"data"	json,
	"delta"	json,
	"parent"	integer,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("parent") REFERENCES "directus_revisions"("id"),
	FOREIGN KEY("activity") REFERENCES "directus_activity"("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "directus_dashboards" (
	"id"	char(36) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"icon"	varchar(30) NOT NULL DEFAULT 'dashboard',
	"note"	text,
	"date_created"	datetime DEFAULT CURRENT_TIMESTAMP,
	"user_created"	char(36),
	"color"	varchar(255),
	PRIMARY KEY("id"),
	FOREIGN KEY("user_created") REFERENCES "directus_users"("id") on delete SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_files" (
	"id"	char(36) NOT NULL,
	"storage"	varchar(255) NOT NULL,
	"filename_disk"	varchar(255),
	"filename_download"	varchar(255) NOT NULL,
	"title"	varchar(255),
	"type"	varchar(255),
	"folder"	char(36),
	"uploaded_by"	char(36),
	"uploaded_on"	datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"modified_by"	char(36),
	"modified_on"	datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"charset"	varchar(50),
	"filesize"	bigint DEFAULT null,
	"width"	integer,
	"height"	integer,
	"duration"	integer,
	"embed"	varchar(200),
	"description"	text,
	"location"	text,
	"tags"	text,
	"metadata"	json,
	PRIMARY KEY("id"),
	FOREIGN KEY("uploaded_by") REFERENCES "directus_users"("id"),
	FOREIGN KEY("modified_by") REFERENCES "directus_users"("id"),
	FOREIGN KEY("folder") REFERENCES "directus_folders"("id") ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_permissions" (
	"id"	integer NOT NULL,
	"role"	char(36),
	"collection"	varchar(64) NOT NULL,
	"action"	varchar(10) NOT NULL,
	"permissions"	json,
	"validation"	json,
	"presets"	json,
	"fields"	text,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("role") REFERENCES "directus_roles"("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "directus_webhooks" (
	"id"	integer NOT NULL,
	"name"	varchar(255) NOT NULL,
	"method"	varchar(10) NOT NULL DEFAULT 'POST',
	"url"	varchar(255) NOT NULL,
	"status"	varchar(10) NOT NULL DEFAULT 'active',
	"data"	boolean NOT NULL DEFAULT '1',
	"actions"	varchar(100) NOT NULL,
	"collections"	varchar(255) NOT NULL,
	"headers"	json,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "directus_collections" (
	"collection"	varchar(64) NOT NULL,
	"icon"	varchar(30),
	"note"	text,
	"display_template"	varchar(255),
	"hidden"	boolean NOT NULL DEFAULT '0',
	"singleton"	boolean NOT NULL DEFAULT '0',
	"translations"	json,
	"archive_field"	varchar(64),
	"archive_app_filter"	boolean NOT NULL DEFAULT '1',
	"archive_value"	varchar(255),
	"unarchive_value"	varchar(255),
	"sort_field"	varchar(64),
	"accountability"	varchar(255) DEFAULT 'all',
	"color"	varchar(255),
	"item_duplication_fields"	json,
	"sort"	integer,
	"group"	varchar(64),
	"collapse"	varchar(255) NOT NULL DEFAULT 'open',
	PRIMARY KEY("collection"),
	FOREIGN KEY("group") REFERENCES "directus_collections"("collection")
);
CREATE TABLE IF NOT EXISTS "directus_fields" (
	"id"	integer NOT NULL,
	"collection"	varchar(64) NOT NULL,
	"field"	varchar(64) NOT NULL,
	"special"	varchar(64),
	"interface"	varchar(64),
	"options"	json,
	"display"	varchar(64),
	"display_options"	json,
	"readonly"	boolean NOT NULL DEFAULT '0',
	"hidden"	boolean NOT NULL DEFAULT '0',
	"sort"	integer,
	"width"	varchar(30) DEFAULT 'full',
	"translations"	json,
	"note"	text,
	"conditions"	json,
	"required"	boolean DEFAULT '0',
	"group"	varchar(64),
	"validation"	json,
	"validation_message"	text,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "directus_presets" (
	"id"	integer NOT NULL,
	"bookmark"	varchar(255),
	"user"	char(36),
	"role"	char(36),
	"collection"	varchar(64),
	"search"	varchar(100),
	"layout"	varchar(100) DEFAULT 'tabular',
	"layout_query"	json,
	"layout_options"	json,
	"refresh_interval"	integer,
	"filter"	json,
	"icon"	varchar(30) NOT NULL DEFAULT 'bookmark_outline',
	"color"	varchar(255),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user") REFERENCES "directus_users"("id") ON DELETE CASCADE,
	FOREIGN KEY("role") REFERENCES "directus_roles"("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "directus_roles" (
	"id"	char(36) NOT NULL,
	"name"	varchar(100) NOT NULL,
	"icon"	varchar(30) NOT NULL DEFAULT 'supervised_user_circle',
	"description"	text,
	"ip_access"	text,
	"enforce_tfa"	boolean NOT NULL DEFAULT '0',
	"admin_access"	boolean NOT NULL DEFAULT '0',
	"app_access"	boolean NOT NULL DEFAULT '1',
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "directus_shares" (
	"id"	char(36) NOT NULL,
	"name"	varchar(255),
	"collection"	varchar(64),
	"item"	varchar(255),
	"role"	char(36),
	"password"	varchar(255),
	"user_created"	char(36),
	"date_created"	datetime DEFAULT CURRENT_TIMESTAMP,
	"date_start"	datetime DEFAULT null,
	"date_end"	datetime DEFAULT null,
	"times_used"	integer DEFAULT '0',
	"max_uses"	integer,
	PRIMARY KEY("id"),
	FOREIGN KEY("collection") REFERENCES "directus_collections"("collection") on delete CASCADE,
	FOREIGN KEY("role") REFERENCES "directus_roles"("id") on delete CASCADE,
	FOREIGN KEY("user_created") REFERENCES "directus_users"("id") on delete SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_sessions" (
	"token"	varchar(64) NOT NULL,
	"user"	char(36),
	"expires"	datetime NOT NULL,
	"ip"	varchar(255),
	"user_agent"	varchar(255),
	"share"	char(36),
	"origin"	varchar(255),
	PRIMARY KEY("token"),
	FOREIGN KEY("user") REFERENCES "directus_users"("id") ON DELETE CASCADE,
	FOREIGN KEY("share") REFERENCES "directus_shares"("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "directus_users" (
	"id"	char(36) NOT NULL,
	"first_name"	varchar(50),
	"last_name"	varchar(50),
	"email"	varchar(128),
	"password"	varchar(255),
	"location"	varchar(255),
	"title"	varchar(50),
	"description"	text,
	"tags"	json,
	"avatar"	char(36),
	"language"	varchar(255) DEFAULT null,
	"theme"	varchar(20) DEFAULT 'auto',
	"tfa_secret"	varchar(255),
	"status"	varchar(16) NOT NULL DEFAULT 'active',
	"role"	char(36),
	"token"	varchar(255),
	"last_access"	datetime,
	"last_page"	varchar(255),
	"provider"	varchar(128) NOT NULL DEFAULT 'default',
	"external_identifier"	varchar(255),
	"auth_data"	json,
	"email_notifications"	boolean DEFAULT '1',
	PRIMARY KEY("id"),
	FOREIGN KEY("role") REFERENCES "directus_roles"("id") ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_panels" (
	"id"	char(36) NOT NULL,
	"dashboard"	char(36) NOT NULL,
	"name"	varchar(255),
	"icon"	varchar(30) DEFAULT null,
	"color"	varchar(10),
	"show_header"	boolean NOT NULL DEFAULT '0',
	"note"	text,
	"type"	varchar(255) NOT NULL,
	"position_x"	integer NOT NULL,
	"position_y"	integer NOT NULL,
	"width"	integer NOT NULL,
	"height"	integer NOT NULL,
	"options"	json,
	"date_created"	datetime DEFAULT CURRENT_TIMESTAMP,
	"user_created"	char(36),
	PRIMARY KEY("id"),
	FOREIGN KEY("dashboard") REFERENCES "directus_dashboards"("id") ON DELETE CASCADE,
	FOREIGN KEY("user_created") REFERENCES "directus_users"("id") ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_flows" (
	"id"	char(36) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"icon"	varchar(30),
	"color"	varchar(255),
	"description"	text,
	"status"	varchar(255) NOT NULL DEFAULT 'active',
	"trigger"	varchar(255),
	"accountability"	varchar(255) DEFAULT 'all',
	"options"	json,
	"operation"	char(36),
	"date_created"	datetime DEFAULT CURRENT_TIMESTAMP,
	"user_created"	char(36),
	PRIMARY KEY("id"),
	FOREIGN KEY("user_created") REFERENCES "directus_users"("id") on delete SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_operations" (
	"id"	char(36) NOT NULL,
	"name"	varchar(255),
	"key"	varchar(255) NOT NULL,
	"type"	varchar(255) NOT NULL,
	"position_x"	integer NOT NULL,
	"position_y"	integer NOT NULL,
	"options"	json,
	"resolve"	char(36),
	"reject"	char(36),
	"flow"	char(36) NOT NULL,
	"date_created"	datetime DEFAULT CURRENT_TIMESTAMP,
	"user_created"	char(36),
	PRIMARY KEY("id"),
	FOREIGN KEY("resolve") REFERENCES "directus_operations"("id"),
	FOREIGN KEY("reject") REFERENCES "directus_operations"("id"),
	FOREIGN KEY("flow") REFERENCES "directus_flows"("id") on delete CASCADE,
	FOREIGN KEY("user_created") REFERENCES "directus_users"("id") on delete SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_activity" (
	"id"	integer NOT NULL,
	"action"	varchar(45) NOT NULL,
	"user"	char(36),
	"timestamp"	datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"ip"	varchar(50),
	"user_agent"	varchar(255),
	"collection"	varchar(64) NOT NULL,
	"item"	varchar(255) NOT NULL,
	"comment"	text,
	"origin"	varchar(255),
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "directus_notifications" (
	"id"	integer NOT NULL,
	"timestamp"	datetime DEFAULT CURRENT_TIMESTAMP,
	"status"	varchar(255) DEFAULT 'inbox',
	"recipient"	char(36) NOT NULL,
	"sender"	char(36),
	"subject"	varchar(255) NOT NULL,
	"message"	text,
	"collection"	varchar(64),
	"item"	varchar(255),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("recipient") REFERENCES "directus_users"("id") ON DELETE CASCADE,
	FOREIGN KEY("sender") REFERENCES "directus_users"("id")
);
CREATE TABLE IF NOT EXISTS "sayfalar" (
	"id"	integer NOT NULL,
	"status"	varchar(255) NOT NULL DEFAULT 'draft',
	"sort"	integer,
	"user_created"	char(36),
	"date_created"	datetime,
	"user_updated"	char(36),
	"date_updated"	datetime,
	"baslik"	varchar(255),
	"aciklama"	text,
	"slug"	char(36),
	"summary"	text,
	PRIMARY KEY("id" AUTOINCREMENT),
	CONSTRAINT "sayfalar_user_created_foreign" FOREIGN KEY("user_created") REFERENCES "directus_users"("id"),
	CONSTRAINT "sayfalar_user_updated_foreign" FOREIGN KEY("user_updated") REFERENCES "directus_users"("id")
);
CREATE TABLE IF NOT EXISTS "cars" (
	"id"	integer NOT NULL,
	"status"	varchar(255) NOT NULL DEFAULT 'draft',
	"date_created"	datetime,
	"Marka"	varchar(255),
	"Model"	varchar(255),
	"Paket"	varchar(255),
	"Km"	varchar(255),
	"Fiyat"	varchar(255),
	"img"	char(36) NOT NULL DEFAULT null,
	"Vites"	varchar(255),
	PRIMARY KEY("id" AUTOINCREMENT),
	CONSTRAINT "cars_img_foreign" FOREIGN KEY("img") REFERENCES "directus_files"("id") ON DELETE NO ACTION
);
CREATE TABLE IF NOT EXISTS "mainPage" (
	"id"	integer NOT NULL,
	"mainTitle"	text,
	"carsTitle"	varchar(255),
	"aboutImg"	char(36),
	"experianceTitle"	varchar(255),
	PRIMARY KEY("id" AUTOINCREMENT),
	CONSTRAINT "mainpage_aboutimg_foreign" FOREIGN KEY("aboutImg") REFERENCES "directus_files"("id") ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS "directus_settings" (
	"id"	integer NOT NULL,
	"project_name"	varchar(100) NOT NULL DEFAULT 'Directus',
	"project_url"	varchar(255),
	"project_color"	varchar(50) DEFAULT null,
	"project_logo"	char(36),
	"public_foreground"	char(36),
	"public_background"	char(36),
	"public_note"	text,
	"auth_login_attempts"	integer DEFAULT '25',
	"auth_password_policy"	varchar(100),
	"storage_asset_transform"	varchar(7) DEFAULT 'all',
	"storage_asset_presets"	json,
	"custom_css"	text,
	"storage_default_folder"	char(36),
	"basemaps"	json,
	"mapbox_key"	varchar(255),
	"module_bar"	json,
	"project_descriptor"	varchar(100),
	"translation_strings"	json,
	"default_language"	varchar(255) NOT NULL DEFAULT 'en-US',
	"custom_aspect_ratios"	json,
	"email"	varchar(255),
	"phone"	varchar(255),
	"map"	Polygon,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("project_logo") REFERENCES "directus_files"("id"),
	FOREIGN KEY("public_foreground") REFERENCES "directus_files"("id"),
	FOREIGN KEY("public_background") REFERENCES "directus_files"("id"),
	CONSTRAINT "directus_settings_storage_default_folder_foreign" FOREIGN KEY("storage_default_folder") REFERENCES "directus_folders"("id") ON DELETE SET NULL
);
INSERT INTO "directus_migrations" VALUES ('20201028A','Remove Collection Foreign Keys','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20201029A','Remove System Relations','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20201029B','Remove System Collections','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20201029C','Remove System Fields','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20201105A','Add Cascade System Relations','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20201105B','Change Webhook URL Type','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210225A','Add Relations Sort Field','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210304A','Remove Locked Fields','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210312A','Webhooks Collections Text','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210331A','Add Refresh Interval','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210415A','Make Filesize Nullable','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210416A','Add Collections Accountability','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210422A','Remove Files Interface','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210506A','Rename Interfaces','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210510A','Restructure Relations','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210518A','Add Foreign Key Constraints','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210519A','Add System Fk Triggers','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210521A','Add Collections Icon Color','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210525A','Add Insights','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210608A','Add Deep Clone Config','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210626A','Change Filesize Bigint','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210716A','Add Conditions to Fields','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210721A','Add Default Folder','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210802A','Replace Groups','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210803A','Add Required to Fields','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210805A','Update Groups','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210805B','Change Image Metadata Structure','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210811A','Add Geometry Config','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210831A','Remove Limit Column','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210903A','Add Auth Provider','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210907A','Webhooks Collections Not Null','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210910A','Move Module Setup','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210920A','Webhooks URL Not Null','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210924A','Add Collection Organization','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210927A','Replace Fields Group','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210927B','Replace M2M Interface','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20210929A','Rename Login Action','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211007A','Update Presets','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211009A','Add Auth Data','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211016A','Add Webhook Headers','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211103A','Set Unique to User Token','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211103B','Update Special Geometry','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211104A','Remove Collections Listing','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211118A','Add Notifications','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211211A','Add Shares','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20211230A','Add Project Descriptor','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220303A','Remove Default Project Color','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220308A','Add Bookmark Icon and Color','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220314A','Add Translation Strings','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220322A','Rename Field Typecast Flags','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220323A','Add Field Validation','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220325A','Fix Typecast Flags','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220325B','Add Default Language','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220402A','Remove Default Value Panel Icon','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220429A','Add Flows','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220429B','Add Color to Insights Icon','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220429C','Drop Non Null From IP of Activity','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220429D','Drop Non Null From Sender of Notifications','2023-02-09 13:03:51');
INSERT INTO "directus_migrations" VALUES ('20220614A','Rename Hook Trigger to Event','2023-02-09 13:03:52');
INSERT INTO "directus_migrations" VALUES ('20220801A','Update Notifications Timestamp Column','2023-02-09 13:03:52');
INSERT INTO "directus_migrations" VALUES ('20220802A','Add Custom Aspect Ratios','2023-02-09 13:03:52');
INSERT INTO "directus_migrations" VALUES ('20220826A','Add Origin to Accountability','2023-02-09 13:03:52');
INSERT INTO "directus_relations" VALUES (1,'sayfalar','user_created','directus_users',NULL,NULL,NULL,NULL,NULL,'nullify');
INSERT INTO "directus_relations" VALUES (2,'sayfalar','user_updated','directus_users',NULL,NULL,NULL,NULL,NULL,'nullify');
INSERT INTO "directus_relations" VALUES (3,'cars','img','directus_files',NULL,NULL,NULL,NULL,NULL,'nullify');
INSERT INTO "directus_relations" VALUES (5,'mainPage','aboutImg','directus_files',NULL,NULL,NULL,NULL,NULL,'nullify');
INSERT INTO "directus_revisions" VALUES (1,2,'directus_settings','1','{"project_name":"Deneme","default_language":"tr-TR"}','{"project_name":"Deneme","default_language":"tr-TR"}',NULL);
INSERT INTO "directus_revisions" VALUES (2,3,'directus_fields','1','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"sayfalar"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (3,4,'directus_fields','2','{"width":"full","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"field":"status","collection":"sayfalar"}','{"width":"full","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"field":"status","collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (4,5,'directus_fields','3','{"interface":"input","hidden":true,"field":"sort","collection":"sayfalar"}','{"interface":"input","hidden":true,"field":"sort","collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (5,6,'directus_fields','4','{"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sayfalar"}','{"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (6,7,'directus_fields','5','{"special":["date-created","cast-timestamp"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sayfalar"}','{"special":["date-created","cast-timestamp"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (7,8,'directus_fields','6','{"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated","collection":"sayfalar"}','{"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated","collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (8,9,'directus_fields','7','{"special":["date-updated","cast-timestamp"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sayfalar"}','{"special":["date-updated","cast-timestamp"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (9,10,'directus_collections','sayfalar','{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sayfalar"}','{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sayfalar"}',NULL);
INSERT INTO "directus_revisions" VALUES (10,11,'directus_fields','8','{"interface":"input","special":null,"collection":"sayfalar","field":"baslik"}','{"interface":"input","special":null,"collection":"sayfalar","field":"baslik"}',NULL);
INSERT INTO "directus_revisions" VALUES (11,12,'directus_fields','9','{"interface":"input-rich-text-html","special":null,"collection":"sayfalar","field":"aciklama"}','{"interface":"input-rich-text-html","special":null,"collection":"sayfalar","field":"aciklama"}',NULL);
INSERT INTO "directus_revisions" VALUES (12,13,'sayfalar','1','{"baslik":"Hakkımızda ","aciklama":"<p>Deneeme</p>","status":"published"}','{"baslik":"Hakkımızda ","aciklama":"<p>Deneeme</p>","status":"published"}',NULL);
INSERT INTO "directus_revisions" VALUES (13,14,'sayfalar','2','{"baslik":"Iletısım","aciklama":"<p>Iletısım bılgılerı</p>","status":"published"}','{"baslik":"Iletısım","aciklama":"<p>Iletısım bılgılerı</p>","status":"published"}',NULL);
INSERT INTO "directus_revisions" VALUES (14,15,'directus_permissions','1','{"role":null,"collection":"sayfalar","action":"create","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"sayfalar","action":"create","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (15,17,'directus_permissions','2','{"role":null,"collection":"sayfalar","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"sayfalar","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (16,18,'sayfalar','3','{"baslik":"Denemeeee","aciklama":"<p>sdsdsd</p>"}','{"baslik":"Denemeeee","aciklama":"<p>sdsdsd</p>"}',NULL);
INSERT INTO "directus_revisions" VALUES (17,19,'sayfalar','4','{"baslik":"dsddsdsds","aciklama":"<p>dsdsd</p>"}','{"baslik":"dsddsdsds","aciklama":"<p>dsdsd</p>"}',NULL);
INSERT INTO "directus_revisions" VALUES (18,20,'sayfalar','5','{"baslik":"dffdsfsdf","aciklama":"<p>sdffd</p>"}','{"baslik":"dffdsfsdf","aciklama":"<p>sdffd</p>"}',NULL);
INSERT INTO "directus_revisions" VALUES (19,25,'sayfalar','6','{"baslik":"Yakup","aciklama":"<p>Kaslı Yakup</p>"}','{"baslik":"Yakup","aciklama":"<p>Kaslı Yakup</p>"}',NULL);
INSERT INTO "directus_revisions" VALUES (20,26,'sayfalar','7','{"baslik":"İhsan","aciklama":"<p>Yakışıklı İhsan</p>"}','{"baslik":"İhsan","aciklama":"<p>Yakışıklı İhsan</p>"}',NULL);
INSERT INTO "directus_revisions" VALUES (21,27,'directus_fields','10','{"interface":"input","special":["uuid"],"collection":"sayfalar","field":"slug"}','{"interface":"input","special":["uuid"],"collection":"sayfalar","field":"slug"}',NULL);
INSERT INTO "directus_revisions" VALUES (22,28,'directus_fields','1','{"id":1,"collection":"sayfalar","field":"id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"id","sort":1,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (23,29,'directus_fields','10','{"id":10,"collection":"sayfalar","field":"slug","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"slug","sort":2,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (24,30,'directus_fields','2','{"id":2,"collection":"sayfalar","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"status","sort":3,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (25,31,'directus_fields','3','{"id":3,"collection":"sayfalar","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"sort","sort":4,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (26,32,'directus_fields','4','{"id":4,"collection":"sayfalar","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_created","sort":5,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (27,33,'directus_fields','5','{"id":5,"collection":"sayfalar","field":"date_created","special":["date-created","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_created","sort":6,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (28,34,'directus_fields','6','{"id":6,"collection":"sayfalar","field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_updated","sort":7,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (29,35,'directus_fields','7','{"id":7,"collection":"sayfalar","field":"date_updated","special":["date-updated","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_updated","sort":8,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (30,36,'directus_fields','8','{"id":8,"collection":"sayfalar","field":"baslik","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"baslik","sort":9,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (31,37,'directus_fields','9','{"id":9,"collection":"sayfalar","field":"aciklama","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"aciklama","sort":10,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (32,38,'directus_fields','1','{"id":1,"collection":"sayfalar","field":"id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"id","sort":1,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (33,39,'directus_fields','8','{"id":8,"collection":"sayfalar","field":"baslik","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"baslik","sort":2,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (34,40,'directus_fields','10','{"id":10,"collection":"sayfalar","field":"slug","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"slug","sort":3,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (35,41,'directus_fields','2','{"id":2,"collection":"sayfalar","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"status","sort":4,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (36,42,'directus_fields','3','{"id":3,"collection":"sayfalar","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"sort","sort":5,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (37,43,'directus_fields','4','{"id":4,"collection":"sayfalar","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_created","sort":6,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (38,44,'directus_fields','5','{"id":5,"collection":"sayfalar","field":"date_created","special":["date-created","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_created","sort":7,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (39,45,'directus_fields','6','{"id":6,"collection":"sayfalar","field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_updated","sort":8,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (40,46,'directus_fields','7','{"id":7,"collection":"sayfalar","field":"date_updated","special":["date-updated","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":9,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_updated","sort":9,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (41,47,'directus_fields','9','{"id":9,"collection":"sayfalar","field":"aciklama","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"aciklama","sort":10,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (42,48,'directus_fields','1','{"id":1,"collection":"sayfalar","field":"id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"id","sort":1,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (43,49,'directus_fields','8','{"id":8,"collection":"sayfalar","field":"baslik","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"baslik","sort":2,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (44,50,'directus_fields','2','{"id":2,"collection":"sayfalar","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"status","sort":3,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (45,51,'directus_fields','3','{"id":3,"collection":"sayfalar","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"sort","sort":4,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (46,52,'directus_fields','10','{"id":10,"collection":"sayfalar","field":"slug","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"slug","sort":5,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (47,53,'directus_fields','4','{"id":4,"collection":"sayfalar","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_created","sort":6,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (48,54,'directus_fields','5','{"id":5,"collection":"sayfalar","field":"date_created","special":["date-created","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_created","sort":7,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (49,55,'directus_fields','6','{"id":6,"collection":"sayfalar","field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_updated","sort":8,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (50,56,'directus_fields','7','{"id":7,"collection":"sayfalar","field":"date_updated","special":["date-updated","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":9,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_updated","sort":9,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (51,57,'directus_fields','9','{"id":9,"collection":"sayfalar","field":"aciklama","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"aciklama","sort":10,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (52,58,'directus_fields','1','{"id":1,"collection":"sayfalar","field":"id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"id","sort":1,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (53,59,'directus_fields','2','{"id":2,"collection":"sayfalar","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"status","sort":2,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (54,60,'directus_fields','3','{"id":3,"collection":"sayfalar","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"sort","sort":3,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (55,61,'directus_fields','10','{"id":10,"collection":"sayfalar","field":"slug","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"slug","sort":4,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (56,62,'directus_fields','8','{"id":8,"collection":"sayfalar","field":"baslik","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"baslik","sort":5,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (57,63,'directus_fields','4','{"id":4,"collection":"sayfalar","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_created","sort":6,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (58,64,'directus_fields','5','{"id":5,"collection":"sayfalar","field":"date_created","special":["date-created","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_created","sort":7,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (59,65,'directus_fields','6','{"id":6,"collection":"sayfalar","field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_updated","sort":8,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (60,66,'directus_fields','7','{"id":7,"collection":"sayfalar","field":"date_updated","special":["date-updated","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":9,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_updated","sort":9,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (61,67,'directus_fields','9','{"id":9,"collection":"sayfalar","field":"aciklama","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"aciklama","sort":10,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (62,68,'directus_fields','10','{"id":10,"collection":"sayfalar","field":"slug","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"slug","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (63,69,'directus_fields','8','{"id":8,"collection":"sayfalar","field":"baslik","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"baslik","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (64,70,'sayfalar','8','{"slug":"iletisim","baslik":"İletişim","aciklama":"<p>Detay</p>"}','{"slug":"iletisim","baslik":"İletişim","aciklama":"<p>Detay</p>"}',NULL);
INSERT INTO "directus_revisions" VALUES (65,73,'sayfalar','1','{"id":1,"status":"published","sort":null,"user_created":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_created":"2023-02-09T13:07:45.101Z","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-09T22:09:30.578Z","baslik":"Hakkımızda ","aciklama":"<p>Deneeme</p>","slug":"hakkimizda"}','{"slug":"hakkimizda","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-09T22:09:30.578Z"}',NULL);
INSERT INTO "directus_revisions" VALUES (66,74,'sayfalar','8','{"id":8,"status":"draft","sort":null,"user_created":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_created":"2023-02-09T22:09:04.967Z","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-09T22:13:52.957Z","baslik":"İletişim","aciklama":"<ul>\n<li>Detay</li>\n<li>dsds</li>\n<li>ds</li>\n<li>dsd</li>\n<li>sds</li>\n<li>ds</li>\n<li>dsd</li>\n<li>ssdsdsd</li>\n<li>dsd</li>\n<li>sw</li>\n</ul>","slug":"iletisim"}','{"aciklama":"<ul>\n<li>Detay</li>\n<li>dsds</li>\n<li>ds</li>\n<li>dsd</li>\n<li>sds</li>\n<li>ds</li>\n<li>dsd</li>\n<li>ssdsdsd</li>\n<li>dsd</li>\n<li>sw</li>\n</ul>","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-09T22:13:52.957Z"}',NULL);
INSERT INTO "directus_revisions" VALUES (67,75,'directus_fields','11','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"cars"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"cars"}',NULL);
INSERT INTO "directus_revisions" VALUES (68,76,'directus_fields','12','{"width":"full","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"field":"status","collection":"cars"}','{"width":"full","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"field":"status","collection":"cars"}',NULL);
INSERT INTO "directus_revisions" VALUES (69,77,'directus_fields','13','{"special":["date-created","cast-timestamp"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"cars"}','{"special":["date-created","cast-timestamp"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"cars"}',NULL);
INSERT INTO "directus_revisions" VALUES (70,78,'directus_collections','cars','{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"cars"}','{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"cars"}',NULL);
INSERT INTO "directus_revisions" VALUES (71,79,'directus_fields','14','{"interface":"input","special":null,"options":{"placeholder":"Marka giriniz","iconLeft":"directions_car"},"collection":"cars","field":"Marka"}','{"interface":"input","special":null,"options":{"placeholder":"Marka giriniz","iconLeft":"directions_car"},"collection":"cars","field":"Marka"}',NULL);
INSERT INTO "directus_revisions" VALUES (72,80,'directus_fields','14','{"id":14,"collection":"cars","field":"Marka","special":null,"interface":"input","options":{"placeholder":"Marka giriniz","iconLeft":"directions_car"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Marka","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (73,81,'directus_fields','15','{"interface":"input","special":null,"options":{"placeholder":"Model giriniz"},"collection":"cars","field":"Model"}','{"interface":"input","special":null,"options":{"placeholder":"Model giriniz"},"collection":"cars","field":"Model"}',NULL);
INSERT INTO "directus_revisions" VALUES (74,82,'directus_fields','16','{"interface":"input","special":null,"options":{"placeholder":"Paket Giriniz"},"collection":"cars","field":"Paket"}','{"interface":"input","special":null,"options":{"placeholder":"Paket Giriniz"},"collection":"cars","field":"Paket"}',NULL);
INSERT INTO "directus_revisions" VALUES (75,83,'directus_fields','15','{"id":15,"collection":"cars","field":"Model","special":null,"interface":"input","options":{"placeholder":"Model giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Model","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (76,84,'directus_fields','16','{"id":16,"collection":"cars","field":"Paket","special":null,"interface":"input","options":{"placeholder":"Paket Giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Paket","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (77,85,'directus_fields','17','{"interface":"input","special":null,"options":{"placeholder":"Km Giriniz"},"collection":"cars","field":"Km"}','{"interface":"input","special":null,"options":{"placeholder":"Km Giriniz"},"collection":"cars","field":"Km"}',NULL);
INSERT INTO "directus_revisions" VALUES (78,86,'directus_fields','18','{"interface":"input","special":null,"options":{"placeholder":"Vites Tipini Giriniz"},"collection":"cars","field":"Vites"}','{"interface":"input","special":null,"options":{"placeholder":"Vites Tipini Giriniz"},"collection":"cars","field":"Vites"}',NULL);
INSERT INTO "directus_revisions" VALUES (79,87,'directus_fields','18','{"id":18,"collection":"cars","field":"Vites","special":null,"interface":"input","options":{"placeholder":"Vites Tipini Giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Vites","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (80,88,'directus_fields','17','{"id":17,"collection":"cars","field":"Km","special":null,"interface":"input","options":{"placeholder":"Km Giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Km","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (81,89,'directus_fields','19','{"interface":"input","special":null,"options":{"placeholder":"Değer Giriniz"},"collection":"cars","field":"Fiyat"}','{"interface":"input","special":null,"options":{"placeholder":"Değer Giriniz"},"collection":"cars","field":"Fiyat"}',NULL);
INSERT INTO "directus_revisions" VALUES (82,90,'directus_fields','20','{"interface":"file-image","special":["file"],"collection":"cars","field":"img"}','{"interface":"file-image","special":["file"],"collection":"cars","field":"img"}',NULL);
INSERT INTO "directus_revisions" VALUES (83,91,'directus_fields','20','{"id":20,"collection":"cars","field":"img","special":["file"],"interface":"file-image","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"img","special":["file"],"interface":"file-image","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}',NULL);
INSERT INTO "directus_revisions" VALUES (84,92,'directus_fields','20','{"id":20,"collection":"cars","field":"img","special":["file"],"interface":"file-image","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"img","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (85,93,'directus_fields','19','{"id":19,"collection":"cars","field":"Fiyat","special":null,"interface":"input","options":{"placeholder":"Değer Giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Fiyat","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (86,94,'directus_collections','cars','{"collection":"cars","icon":"directions_car","note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":null,"accountability":"all","color":"#702929","item_duplication_fields":null,"sort":null,"group":null,"collapse":"open"}','{"icon":"directions_car","color":"#702929"}',NULL);
INSERT INTO "directus_revisions" VALUES (87,95,'directus_files','fc1d4ba8-300d-4599-ba30-aa4b497d7b08','{"title":"Araba","filename_download":"araba.jpeg","type":"image/jpeg","storage":"local"}','{"title":"Araba","filename_download":"araba.jpeg","type":"image/jpeg","storage":"local"}',NULL);
INSERT INTO "directus_revisions" VALUES (88,96,'cars','1','{"status":"published","Marka":"Mercedes","Model":"A serisi","Paket":"amg","Km":"34000","Vites":"Otomatik","Fiyat":"550.000TL","img":"fc1d4ba8-300d-4599-ba30-aa4b497d7b08"}','{"status":"published","Marka":"Mercedes","Model":"A serisi","Paket":"amg","Km":"34000","Vites":"Otomatik","Fiyat":"550.000TL","img":"fc1d4ba8-300d-4599-ba30-aa4b497d7b08"}',NULL);
INSERT INTO "directus_revisions" VALUES (89,97,'directus_files','33d20a10-a440-4f29-b011-efa26316f4f0','{"title":"Car","filename_download":"car.webp","type":"image/webp","storage":"local"}','{"title":"Car","filename_download":"car.webp","type":"image/webp","storage":"local"}',NULL);
INSERT INTO "directus_revisions" VALUES (90,98,'cars','2','{"Marka":"Renault","Model":"Clio","Paket":"Joy","Km":"200.000","Vites":"Manuel","Fiyat":"300.000","img":"33d20a10-a440-4f29-b011-efa26316f4f0"}','{"Marka":"Renault","Model":"Clio","Paket":"Joy","Km":"200.000","Vites":"Manuel","Fiyat":"300.000","img":"33d20a10-a440-4f29-b011-efa26316f4f0"}',NULL);
INSERT INTO "directus_revisions" VALUES (91,99,'cars','2','{"id":2,"status":"published","date_created":"2023-02-10T12:12:57.699Z","Marka":"Renault","Model":"Clio","Paket":"Joy","Km":"200.000","Vites":"Manuel","Fiyat":"300.000","img":"33d20a10-a440-4f29-b011-efa26316f4f0"}','{"status":"published"}',NULL);
INSERT INTO "directus_revisions" VALUES (92,100,'directus_fields','21','{"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Otomatik","value":"oto"},{"text":"Manuel","value":"Manuel"}],"placeholder":"Vites Tipi Seçiniz"},"collection":"cars","field":"Vites"}','{"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Otomatik","value":"oto"},{"text":"Manuel","value":"Manuel"}],"placeholder":"Vites Tipi Seçiniz"},"collection":"cars","field":"Vites"}',NULL);
INSERT INTO "directus_revisions" VALUES (93,101,'directus_fields','21','{"id":21,"collection":"cars","field":"Vites","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"Otomatik","value":"oto"},{"text":"Manuel","value":"Manuel"}],"placeholder":"Vites Tipi Seçiniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":null,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Vites","width":"half"}',NULL);
INSERT INTO "directus_revisions" VALUES (94,102,'directus_fields','11','{"id":11,"collection":"cars","field":"id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"id","sort":1,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (95,103,'directus_fields','12','{"id":12,"collection":"cars","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"status","sort":2,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (96,104,'directus_fields','13','{"id":13,"collection":"cars","field":"date_created","special":["date-created","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"date_created","sort":3,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (97,105,'directus_fields','14','{"id":14,"collection":"cars","field":"Marka","special":null,"interface":"input","options":{"placeholder":"Marka giriniz","iconLeft":"directions_car"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Marka","sort":4,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (98,106,'directus_fields','15','{"id":15,"collection":"cars","field":"Model","special":null,"interface":"input","options":{"placeholder":"Model giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Model","sort":5,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (99,107,'directus_fields','16','{"id":16,"collection":"cars","field":"Paket","special":null,"interface":"input","options":{"placeholder":"Paket Giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Paket","sort":6,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (100,108,'directus_fields','17','{"id":17,"collection":"cars","field":"Km","special":null,"interface":"input","options":{"placeholder":"Km Giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Km","sort":7,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (101,109,'directus_fields','21','{"id":21,"collection":"cars","field":"Vites","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"Otomatik","value":"oto"},{"text":"Manuel","value":"Manuel"}],"placeholder":"Vites Tipi Seçiniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Vites","sort":8,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (102,110,'directus_fields','19','{"id":19,"collection":"cars","field":"Fiyat","special":null,"interface":"input","options":{"placeholder":"Değer Giriniz"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"Fiyat","sort":9,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (103,111,'directus_fields','20','{"id":20,"collection":"cars","field":"img","special":["file"],"interface":"file-image","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"img","sort":10,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (104,112,'cars','1','{"id":1,"status":"published","date_created":"2023-02-10T12:11:45.327Z","Marka":"Mercedes","Model":"A serisi","Paket":"amg","Km":"34000","Fiyat":"550.000TL","img":"fc1d4ba8-300d-4599-ba30-aa4b497d7b08","Vites":"oto"}','{"Vites":"oto"}',NULL);
INSERT INTO "directus_revisions" VALUES (105,113,'cars','2','{"id":2,"status":"published","date_created":"2023-02-10T12:12:57.699Z","Marka":"Renault","Model":"Clio","Paket":"Joy","Km":"200.000","Fiyat":"300.000","img":"33d20a10-a440-4f29-b011-efa26316f4f0","Vites":"Manuel"}','{"Vites":"Manuel"}',NULL);
INSERT INTO "directus_revisions" VALUES (106,114,'directus_permissions','3','{"role":null,"collection":"cars","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"cars","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (107,115,'sayfalar','9','{"slug":"sea","baslik":"sea","aciklama":"<p>sea</p>"}','{"slug":"sea","baslik":"sea","aciklama":"<p>sea</p>"}',NULL);
INSERT INTO "directus_revisions" VALUES (108,116,'directus_fields','20','{"id":20,"collection":"cars","field":"img","special":["file"],"interface":"file","options":null,"display":"image","display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"cars","field":"img","special":["file"],"interface":"file","options":null,"display":"image","display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}',NULL);
INSERT INTO "directus_revisions" VALUES (109,117,'directus_permissions','4','{"role":null,"collection":"directus_files","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"directus_files","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (110,118,'cars','1','{"id":1,"status":"published","date_created":"2023-02-10T12:11:45.327Z","Marka":"Mercedes","Model":"A serisi","Paket":"amg","Km":"34.000","Fiyat":"550.000TL","img":"fc1d4ba8-300d-4599-ba30-aa4b497d7b08","Vites":"oto"}','{"Km":"34.000"}',NULL);
INSERT INTO "directus_revisions" VALUES (111,224,'directus_permissions','5','{"role":null,"collection":"sayfalar","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"sayfalar","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (112,225,'directus_permissions','6','{"role":null,"collection":"cars","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"cars","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (113,434,'directus_fields','22','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"Hakkmzda"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"Hakkmzda"}',NULL);
INSERT INTO "directus_revisions" VALUES (114,435,'directus_collections','Hakkmzda','{"singleton":false,"collection":"Hakkmzda"}','{"singleton":false,"collection":"Hakkmzda"}',NULL);
INSERT INTO "directus_revisions" VALUES (115,436,'directus_fields','23','{"interface":"input-multiline","special":null,"options":{"placeholder":"Hakkımızda Alanının Başlık Yazısını Giriniz"},"collection":"Hakkmzda","field":"title"}','{"interface":"input-multiline","special":null,"options":{"placeholder":"Hakkımızda Alanının Başlık Yazısını Giriniz"},"collection":"Hakkmzda","field":"title"}',NULL);
INSERT INTO "directus_revisions" VALUES (116,437,'directus_fields','24','{"interface":"input-multiline","special":null,"options":{"placeholder":"Hakımızda alanının içerik yazsını girin"},"collection":"Hakkmzda","field":"icerik"}','{"interface":"input-multiline","special":null,"options":{"placeholder":"Hakımızda alanının içerik yazsını girin"},"collection":"Hakkmzda","field":"icerik"}',NULL);
INSERT INTO "directus_revisions" VALUES (118,446,'directus_fields','25','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"AboutMe"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"AboutMe"}',NULL);
INSERT INTO "directus_revisions" VALUES (119,447,'directus_collections','AboutMe','{"singleton":false,"collection":"AboutMe"}','{"singleton":false,"collection":"AboutMe"}',NULL);
INSERT INTO "directus_revisions" VALUES (120,448,'directus_fields','26','{"interface":"input-multiline","special":null,"collection":"AboutMe","field":"title"}','{"interface":"input-multiline","special":null,"collection":"AboutMe","field":"title"}',NULL);
INSERT INTO "directus_revisions" VALUES (121,449,'directus_fields','27','{"interface":"input-multiline","special":null,"collection":"AboutMe","field":"text"}','{"interface":"input-multiline","special":null,"collection":"AboutMe","field":"text"}',NULL);
INSERT INTO "directus_revisions" VALUES (123,471,'directus_collections','AboutMe','{"collection":"AboutMe","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":true,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":null,"group":null,"collapse":"open"}','{"singleton":true}',NULL);
INSERT INTO "directus_revisions" VALUES (124,473,'directus_fields','28','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"logo"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"logo"}',NULL);
INSERT INTO "directus_revisions" VALUES (125,474,'directus_collections','logo','{"singleton":true,"collection":"logo"}','{"singleton":true,"collection":"logo"}',NULL);
INSERT INTO "directus_revisions" VALUES (126,475,'directus_fields','29','{"interface":"file-image","special":["file"],"collection":"logo","field":"img"}','{"interface":"file-image","special":["file"],"collection":"logo","field":"img"}',NULL);
INSERT INTO "directus_revisions" VALUES (127,476,'directus_collections','logo','{"collection":"logo","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":true,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":"#934D6F","item_duplication_fields":null,"sort":null,"group":null,"collapse":"open"}','{"color":"#934D6F"}',NULL);
INSERT INTO "directus_revisions" VALUES (128,477,'directus_files','0a82274c-31f4-4872-afef-5608fb5ceace','{"title":"Logo","filename_download":"logo.png","type":"image/png","storage":"local"}','{"title":"Logo","filename_download":"logo.png","type":"image/png","storage":"local"}',NULL);
INSERT INTO "directus_revisions" VALUES (130,497,'directus_fields','30','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"contact"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"contact"}',NULL);
INSERT INTO "directus_revisions" VALUES (131,498,'directus_collections','contact','{"singleton":false,"collection":"contact"}','{"singleton":false,"collection":"contact"}',NULL);
INSERT INTO "directus_revisions" VALUES (132,499,'directus_fields','31','{"interface":"input","special":null,"collection":"contact","field":"email"}','{"interface":"input","special":null,"collection":"contact","field":"email"}',NULL);
INSERT INTO "directus_revisions" VALUES (133,500,'directus_fields','32','{"interface":"input","special":null,"collection":"contact","field":"phone"}','{"interface":"input","special":null,"collection":"contact","field":"phone"}',NULL);
INSERT INTO "directus_revisions" VALUES (134,501,'directus_fields','33','{"interface":"input","special":null,"collection":"contact","field":"adress"}','{"interface":"input","special":null,"collection":"contact","field":"adress"}',NULL);
INSERT INTO "directus_revisions" VALUES (135,502,'directus_fields','34','{"interface":"input","special":null,"collection":"directus_settings","field":"email"}','{"interface":"input","special":null,"collection":"directus_settings","field":"email"}',NULL);
INSERT INTO "directus_revisions" VALUES (136,503,'directus_fields','35','{"interface":"input","special":null,"collection":"directus_settings","field":"phone"}','{"interface":"input","special":null,"collection":"directus_settings","field":"phone"}',NULL);
INSERT INTO "directus_revisions" VALUES (137,504,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30"}','{"email":"deneme@gmail.com","phone":"0530 303 30 30"}',NULL);
INSERT INTO "directus_revisions" VALUES (138,505,'directus_files','d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2','{"title":"Logo","filename_download":"logo.png","type":"image/png","storage":"local"}','{"title":"Logo","filename_download":"logo.png","type":"image/png","storage":"local"}',NULL);
INSERT INTO "directus_revisions" VALUES (139,513,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30"}','{"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2"}',NULL);
INSERT INTO "directus_revisions" VALUES (140,520,'directus_fields','36','{"interface":"input","special":null,"collection":"directus_settings","field":"adress"}','{"interface":"input","special":null,"collection":"directus_settings","field":"adress"}',NULL);
INSERT INTO "directus_revisions" VALUES (141,521,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30","adress":"Yakuplu, 34524 Beylikdüzü/İstanbul"}','{"adress":"Yakuplu, 34524 Beylikdüzü/İstanbul"}',NULL);
INSERT INTO "directus_revisions" VALUES (142,523,'directus_fields','37','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"main"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"main"}',NULL);
INSERT INTO "directus_revisions" VALUES (143,524,'directus_collections','main','{"singleton":true,"collection":"main"}','{"singleton":true,"collection":"main"}',NULL);
INSERT INTO "directus_revisions" VALUES (144,525,'directus_fields','38','{"interface":"input-multiline","special":null,"collection":"main","field":"maintitle"}','{"interface":"input-multiline","special":null,"collection":"main","field":"maintitle"}',NULL);
INSERT INTO "directus_revisions" VALUES (145,526,'directus_fields','39','{"interface":"input","special":null,"collection":"main","field":"carsTitle"}','{"interface":"input","special":null,"collection":"main","field":"carsTitle"}',NULL);
INSERT INTO "directus_revisions" VALUES (146,528,'directus_fields','40','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"mainPage"}','{"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"mainPage"}',NULL);
INSERT INTO "directus_revisions" VALUES (147,529,'directus_collections','mainPage','{"singleton":true,"collection":"mainPage"}','{"singleton":true,"collection":"mainPage"}',NULL);
INSERT INTO "directus_revisions" VALUES (148,530,'directus_fields','41','{"interface":"input-multiline","special":null,"collection":"mainPage","field":"mainTitle"}','{"interface":"input-multiline","special":null,"collection":"mainPage","field":"mainTitle"}',NULL);
INSERT INTO "directus_revisions" VALUES (149,531,'directus_fields','42','{"interface":"input","special":null,"collection":"mainPage","field":"carsTitle"}','{"interface":"input","special":null,"collection":"mainPage","field":"carsTitle"}',NULL);
INSERT INTO "directus_revisions" VALUES (150,532,'directus_fields','43','{"interface":"input","special":null,"collection":"mainPage","field":"aboutTitle"}','{"interface":"input","special":null,"collection":"mainPage","field":"aboutTitle"}',NULL);
INSERT INTO "directus_revisions" VALUES (151,533,'directus_fields','44','{"interface":"input","special":null,"collection":"mainPage","field":"aboutDescTitle"}','{"interface":"input","special":null,"collection":"mainPage","field":"aboutDescTitle"}',NULL);
INSERT INTO "directus_revisions" VALUES (152,534,'directus_fields','45','{"interface":"input","special":null,"collection":"mainPage","field":"aboutText"}','{"interface":"input","special":null,"collection":"mainPage","field":"aboutText"}',NULL);
INSERT INTO "directus_revisions" VALUES (153,535,'directus_fields','46','{"interface":"file-image","special":["file"],"collection":"mainPage","field":"aboutImg"}','{"interface":"file-image","special":["file"],"collection":"mainPage","field":"aboutImg"}',NULL);
INSERT INTO "directus_revisions" VALUES (154,536,'directus_fields','47','{"interface":"input","special":null,"collection":"mainPage","field":"experianceTitle"}','{"interface":"input","special":null,"collection":"mainPage","field":"experianceTitle"}',NULL);
INSERT INTO "directus_revisions" VALUES (155,537,'directus_files','a8ab9893-6204-4cd3-b406-33cb58d59071','{"title":"Dealer","filename_download":"dealer.jpg","type":"image/jpeg","storage":"local"}','{"title":"Dealer","filename_download":"dealer.jpg","type":"image/jpeg","storage":"local"}',NULL);
INSERT INTO "directus_revisions" VALUES (156,538,'mainPage','1','{"mainTitle":"lorem lorem lorem lorem lorekm","carsTitle":"Araçlar","aboutTitle":"Hakkkımızda","aboutDescTitle":"lorem lorem lorem lorem","aboutText":"lorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem lorem","aboutImg":"a8ab9893-6204-4cd3-b406-33cb58d59071","experianceTitle":"daha iyi araç almak"}','{"mainTitle":"lorem lorem lorem lorem lorekm","carsTitle":"Araçlar","aboutTitle":"Hakkkımızda","aboutDescTitle":"lorem lorem lorem lorem","aboutText":"lorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem loremlorem lorem lorem lorem","aboutImg":"a8ab9893-6204-4cd3-b406-33cb58d59071","experianceTitle":"daha iyi araç almak"}',NULL);
INSERT INTO "directus_revisions" VALUES (157,555,'directus_permissions','7','{"role":null,"collection":"mainPage","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"mainPage","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (158,560,'directus_permissions','8','{"role":null,"collection":"mainPage","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"mainPage","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (159,561,'directus_permissions','9','{"role":null,"collection":"mainPage","action":"update","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"mainPage","action":"update","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (160,562,'directus_permissions','10','{"role":null,"collection":"mainPage","action":"create","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"mainPage","action":"create","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (161,563,'directus_permissions','11','{"role":null,"collection":"mainPage","action":"delete","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"mainPage","action":"delete","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (162,564,'directus_permissions','12','{"role":null,"collection":"mainPage","action":"share","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"mainPage","action":"share","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (163,565,'directus_permissions','13','{"role":null,"collection":"cars","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"cars","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (164,566,'directus_permissions','14','{"role":null,"collection":"sayfalar","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"sayfalar","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (165,576,'directus_permissions','15','{"role":null,"collection":"mainPage","action":"read","fields":["*"],"permissions":{},"validation":{}}','{"role":null,"collection":"mainPage","action":"read","fields":["*"],"permissions":{},"validation":{}}',NULL);
INSERT INTO "directus_revisions" VALUES (166,586,'directus_fields','48','{"interface":"input-multiline","special":null,"collection":"sayfalar","field":"summary"}','{"interface":"input-multiline","special":null,"collection":"sayfalar","field":"summary"}',NULL);
INSERT INTO "directus_revisions" VALUES (167,587,'directus_fields','1','{"id":1,"collection":"sayfalar","field":"id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"id","sort":1,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (168,588,'directus_fields','2','{"id":2,"collection":"sayfalar","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"status","sort":2,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (169,589,'directus_fields','3','{"id":3,"collection":"sayfalar","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"sort","sort":3,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (170,590,'directus_fields','10','{"id":10,"collection":"sayfalar","field":"slug","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"slug","sort":4,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (171,591,'directus_fields','8','{"id":8,"collection":"sayfalar","field":"baslik","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"baslik","sort":5,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (172,592,'directus_fields','4','{"id":4,"collection":"sayfalar","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_created","sort":6,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (173,593,'directus_fields','5','{"id":5,"collection":"sayfalar","field":"date_created","special":["date-created","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_created","sort":7,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (174,594,'directus_fields','6','{"id":6,"collection":"sayfalar","field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"user_updated","sort":8,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (175,595,'directus_fields','7','{"id":7,"collection":"sayfalar","field":"date_updated","special":["date-updated","cast-timestamp"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":9,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"date_updated","sort":9,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (176,596,'directus_fields','48','{"id":48,"collection":"sayfalar","field":"summary","special":null,"interface":"input-multiline","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"summary","sort":10,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (177,597,'directus_fields','9','{"id":9,"collection":"sayfalar","field":"aciklama","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}','{"collection":"sayfalar","field":"aciklama","sort":11,"group":null}',NULL);
INSERT INTO "directus_revisions" VALUES (178,598,'sayfalar','1','{"id":1,"status":"published","sort":null,"user_created":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_created":"2023-02-09T13:07:45.101Z","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-16T13:14:56.643Z","baslik":"Hakkımızda ","aciklama":"<p>Deneeme</p>","slug":"hakkimizda","summary":"Kısa acıklaam"}','{"summary":"Kısa acıklaam","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-16T13:14:56.643Z"}',NULL);
INSERT INTO "directus_revisions" VALUES (179,599,'sayfalar','1','{"id":1,"status":"published","sort":null,"user_created":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_created":"2023-02-09T13:07:45.101Z","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-16T13:19:43.643Z","baslik":"Hakkımızda ","aciklama":"<p>Deneeme</p>","slug":"hakkimizda","summary":"Lorem ipsum dolor, sit amet consectetur adipisicing elit. Quas voluptatem enim doloremque mollitia neque ipsam nemo quis minima cumque, ea cum odio commodi officia ab accusamus eum quam quaerat. Nisi sunt odio blanditiis ipsa, in, sapiente modi explicabo dolores error aliquid voluptatum quae rerum cupiditate id, veritatis molestiae quasi recusandae fuga. Voluptate voluptatibus incidunt ipsam quo, obcaecati quia, iusto rerum libero amet earum eveniet atque temporibus minima nulla mollitia voluptates consequuntur officiis ad aliquam! Reprehenderit fugit, tempore cumque officia maxime ducimus quod fuga non corporis provident accusantium quam impedit facilis quis ipsum saepe, dolore dolorem ab architecto necessitatibus? Dolores, dolorem.\n"}','{"summary":"Lorem ipsum dolor, sit amet consectetur adipisicing elit. Quas voluptatem enim doloremque mollitia neque ipsam nemo quis minima cumque, ea cum odio commodi officia ab accusamus eum quam quaerat. Nisi sunt odio blanditiis ipsa, in, sapiente modi explicabo dolores error aliquid voluptatum quae rerum cupiditate id, veritatis molestiae quasi recusandae fuga. Voluptate voluptatibus incidunt ipsam quo, obcaecati quia, iusto rerum libero amet earum eveniet atque temporibus minima nulla mollitia voluptates consequuntur officiis ad aliquam! Reprehenderit fugit, tempore cumque officia maxime ducimus quod fuga non corporis provident accusantium quam impedit facilis quis ipsum saepe, dolore dolorem ab architecto necessitatibus? Dolores, dolorem.\n","user_updated":"a3b7b6ba-de03-405f-9570-ebdc4f2acb1a","date_updated":"2023-02-16T13:19:43.643Z"}',NULL);
INSERT INTO "directus_revisions" VALUES (180,641,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":"pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g","module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30","adress":"Yakuplu, 34524 Beylikdüzü/İstanbul"}','{"mapbox_key":"pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g"}',NULL);
INSERT INTO "directus_revisions" VALUES (181,642,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":[{"name":"iletişim","type":"style","url":"mapbox://styles/ihsankck/cle8k9hge008301qgsotyeb55"}],"mapbox_key":"pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g","module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30","adress":"Yakuplu, 34524 Beylikdüzü/İstanbul"}','{"basemaps":[{"name":"iletişim","type":"style","url":"mapbox://styles/ihsankck/cle8k9hge008301qgsotyeb55"}]}',NULL);
INSERT INTO "directus_revisions" VALUES (182,644,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":[{"name":"contact","type":"style","url":"https://api.mapbox.com/styles/v1/ihsankck/cle8k9hge008301qgsotyeb55.html"}],"mapbox_key":"pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g","module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30","adress":"Yakuplu, 34524 Beylikdüzü/İstanbul"}','{"basemaps":[{"name":"contact","type":"style","url":"https://api.mapbox.com/styles/v1/ihsankck/cle8k9hge008301qgsotyeb55.html"}]}',NULL);
INSERT INTO "directus_revisions" VALUES (183,645,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":[{"name":"contact","type":"style","url":"mapbox://styles/ihsankck/cle8k9hge008301qgsotyeb55"}],"mapbox_key":"pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g","module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30","adress":"Yakuplu, 34524 Beylikdüzü/İstanbul"}','{"basemaps":[{"name":"contact","type":"style","url":"mapbox://styles/ihsankck/cle8k9hge008301qgsotyeb55"}]}',NULL);
INSERT INTO "directus_revisions" VALUES (184,646,'directus_fields','49','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":-8.44460280128851,"lat":2.842170943040401e-14},"zoom":-0.3706434003783814,"bearing":0,"pitch":0},"geometryType":"LineString"},"collection":"directus_settings","field":"location"}','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":-8.44460280128851,"lat":2.842170943040401e-14},"zoom":-0.3706434003783814,"bearing":0,"pitch":0},"geometryType":"LineString"},"collection":"directus_settings","field":"location"}',NULL);
INSERT INTO "directus_revisions" VALUES (185,647,'directus_fields','50','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":42.22301400634478,"lat":2.842170943040401e-14},"zoom":-0.3706434003783814,"bearing":0,"pitch":0},"geometryType":"LineString"},"collection":"directus_settings","field":"map"}','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":42.22301400634478,"lat":2.842170943040401e-14},"zoom":-0.3706434003783814,"bearing":0,"pitch":0},"geometryType":"LineString"},"collection":"directus_settings","field":"map"}',NULL);
INSERT INTO "directus_revisions" VALUES (186,648,'directus_settings','1','{"id":1,"project_name":"1Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":[{"name":"contact","type":"style","url":"mapbox://styles/ihsankck/cle8k9hge008301qgsotyeb55"}],"mapbox_key":"pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g","module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30"}','{"project_name":"1Deneme"}',NULL);
INSERT INTO "directus_revisions" VALUES (187,649,'directus_settings','1','{"id":1,"project_name":"Deneme","project_url":null,"project_color":null,"project_logo":"d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":[{"name":"contact","type":"style","url":"mapbox://styles/ihsankck/cle8k9hge008301qgsotyeb55"}],"mapbox_key":"pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g","module_bar":null,"project_descriptor":null,"translation_strings":null,"default_language":"tr-TR","custom_aspect_ratios":null,"email":"deneme@gmail.com","phone":"0530 303 30 30"}','{"project_name":"Deneme"}',NULL);
INSERT INTO "directus_revisions" VALUES (188,650,'directus_fields','51','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":-14.417614538750513,"lat":2.842170943040401e-14},"zoom":-0.3706434003783814,"bearing":0,"pitch":0},"geometryType":"Point"},"collection":"directus_settings","field":"map"}','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":-14.417614538750513,"lat":2.842170943040401e-14},"zoom":-0.3706434003783814,"bearing":0,"pitch":0},"geometryType":"Point"},"collection":"directus_settings","field":"map"}',NULL);
INSERT INTO "directus_revisions" VALUES (189,651,'directus_fields','52','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":0,"lat":0},"zoom":0,"bearing":0,"pitch":0},"geometryType":"Polygon"},"collection":"directus_settings","field":"map"}','{"interface":"map","special":null,"options":{"defaultView":{"center":{"lng":0,"lat":0},"zoom":0,"bearing":0,"pitch":0},"geometryType":"Polygon"},"collection":"directus_settings","field":"map"}',NULL);
INSERT INTO "directus_files" VALUES ('fc1d4ba8-300d-4599-ba30-aa4b497d7b08','local','fc1d4ba8-300d-4599-ba30-aa4b497d7b08.jpeg','araba.jpeg','Araba','image/jpeg',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a','2023-02-10 12:11:39',NULL,1676031099683,NULL,604278,2309,1732,NULL,NULL,NULL,NULL,NULL,'{}');
INSERT INTO "directus_files" VALUES ('33d20a10-a440-4f29-b011-efa26316f4f0','local','33d20a10-a440-4f29-b011-efa26316f4f0.webp','car.webp','Car','image/webp',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a','2023-02-10 12:12:55',NULL,1676031175605,NULL,121902,1920,1275,NULL,NULL,NULL,NULL,NULL,'{}');
INSERT INTO "directus_files" VALUES ('0a82274c-31f4-4872-afef-5608fb5ceace','local','0a82274c-31f4-4872-afef-5608fb5ceace.png','logo.png','Logo','image/png',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a','2023-02-14 14:14:09',NULL,1676384049494,NULL,156555,2048,2048,NULL,NULL,NULL,NULL,NULL,'{}');
INSERT INTO "directus_files" VALUES ('d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2','local','d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2.png','logo.png','Logo','image/png',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a','2023-02-14 15:23:29',NULL,1676388209235,NULL,156555,2048,2048,NULL,NULL,NULL,NULL,NULL,'{}');
INSERT INTO "directus_files" VALUES ('a8ab9893-6204-4cd3-b406-33cb58d59071','local','a8ab9893-6204-4cd3-b406-33cb58d59071.jpg','dealer.jpg','Dealer','image/jpeg',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a','2023-02-15 13:57:34',NULL,1676469454101,NULL,80008,1200,786,NULL,NULL,NULL,NULL,NULL,'{}');
INSERT INTO "directus_permissions" VALUES (4,NULL,'directus_files','read','{}','{}',NULL,'*');
INSERT INTO "directus_permissions" VALUES (15,NULL,'mainPage','read','{}','{}',NULL,'*');
INSERT INTO "directus_collections" VALUES ('sayfalar',NULL,NULL,NULL,0,0,NULL,'status',1,'archived','draft','sort','all',NULL,NULL,NULL,NULL,'open');
INSERT INTO "directus_collections" VALUES ('cars','directions_car',NULL,NULL,0,0,NULL,'status',1,'archived','draft',NULL,'all','#702929',NULL,NULL,NULL,'open');
INSERT INTO "directus_collections" VALUES ('mainPage',NULL,NULL,NULL,0,1,NULL,NULL,1,NULL,NULL,NULL,'all',NULL,NULL,NULL,NULL,'open');
INSERT INTO "directus_fields" VALUES (1,'sayfalar','id',NULL,'input',NULL,NULL,NULL,1,1,1,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (2,'sayfalar','status',NULL,'select-dropdown','{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}','labels','{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}',0,0,2,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (3,'sayfalar','sort',NULL,'input',NULL,NULL,NULL,0,1,3,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (4,'sayfalar','user_created','user-created','select-dropdown-m2o','{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}','user',NULL,1,1,6,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (5,'sayfalar','date_created','date-created,cast-timestamp','datetime',NULL,'datetime','{"relative":true}',1,1,7,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (6,'sayfalar','user_updated','user-updated','select-dropdown-m2o','{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}','user',NULL,1,1,8,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (7,'sayfalar','date_updated','date-updated,cast-timestamp','datetime',NULL,'datetime','{"relative":true}',1,1,9,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (8,'sayfalar','baslik',NULL,'input',NULL,NULL,NULL,0,0,5,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (9,'sayfalar','aciklama',NULL,'input-rich-text-html',NULL,NULL,NULL,0,0,11,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (10,'sayfalar','slug','uuid','input',NULL,NULL,NULL,0,0,4,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (11,'cars','id',NULL,'input',NULL,NULL,NULL,1,1,1,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (12,'cars','status',NULL,'select-dropdown','{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}','labels','{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}',0,0,2,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (13,'cars','date_created','date-created,cast-timestamp','datetime',NULL,'datetime','{"relative":true}',1,1,3,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (14,'cars','Marka',NULL,'input','{"placeholder":"Marka giriniz","iconLeft":"directions_car"}',NULL,NULL,0,0,4,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (15,'cars','Model',NULL,'input','{"placeholder":"Model giriniz"}',NULL,NULL,0,0,5,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (16,'cars','Paket',NULL,'input','{"placeholder":"Paket Giriniz"}',NULL,NULL,0,0,6,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (17,'cars','Km',NULL,'input','{"placeholder":"Km Giriniz"}',NULL,NULL,0,0,7,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (19,'cars','Fiyat',NULL,'input','{"placeholder":"Değer Giriniz"}',NULL,NULL,0,0,9,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (20,'cars','img','file','file',NULL,'image',NULL,0,0,10,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (21,'cars','Vites',NULL,'select-dropdown','{"choices":[{"text":"Otomatik","value":"oto"},{"text":"Manuel","value":"Manuel"}],"placeholder":"Vites Tipi Seçiniz"}',NULL,NULL,0,0,8,'half',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (34,'directus_settings','email',NULL,'input',NULL,NULL,NULL,0,0,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (35,'directus_settings','phone',NULL,'input',NULL,NULL,NULL,0,0,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (40,'mainPage','id',NULL,'input',NULL,NULL,NULL,1,1,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (41,'mainPage','mainTitle',NULL,'input-multiline',NULL,NULL,NULL,0,0,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (42,'mainPage','carsTitle',NULL,'input',NULL,NULL,NULL,0,0,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (46,'mainPage','aboutImg','file','file-image',NULL,NULL,NULL,0,0,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (47,'mainPage','experianceTitle',NULL,'input',NULL,NULL,NULL,0,0,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (48,'sayfalar','summary',NULL,'input-multiline',NULL,NULL,NULL,0,0,10,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_fields" VALUES (52,'directus_settings','map',NULL,'map','{"defaultView":{"center":{"lng":0,"lat":0},"zoom":0,"bearing":0,"pitch":0},"geometryType":"Polygon"}',NULL,NULL,0,0,NULL,'full',NULL,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO "directus_presets" VALUES (1,NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'directus_files',NULL,'cards','{"cards":{"sort":["-uploaded_on"],"page":1}}','{"cards":{"icon":"insert_drive_file","title":"{{ title }}","subtitle":"{{ type }} • {{ filesize }}","size":4,"imageFit":"crop"}}',NULL,NULL,'bookmark_outline',NULL);
INSERT INTO "directus_presets" VALUES (2,NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'directus_users',NULL,'cards','{"cards":{"sort":["email"],"page":1}}','{"cards":{"icon":"account_circle","title":"{{ first_name }} {{ last_name }}","subtitle":"{{ email }}","size":4}}',NULL,NULL,'bookmark_outline',NULL);
INSERT INTO "directus_presets" VALUES (3,NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'cars',NULL,NULL,'{"tabular":{"fields":["Marka","Model","Paket","Km","Fiyat"],"page":1}}',NULL,NULL,NULL,'bookmark_outline',NULL);
INSERT INTO "directus_presets" VALUES (6,NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'sayfalar',NULL,NULL,'{"tabular":{"page":1}}',NULL,NULL,NULL,'bookmark_outline',NULL);
INSERT INTO "directus_roles" VALUES ('60180583-1388-4d27-b2b5-4d46785498af','Administrator','verified','$t:admin_description',NULL,0,1,1);
INSERT INTO "directus_sessions" VALUES ('7oRdY17WfMFBQEEBQcgzNmUxLHgWBTFPOFvjXyYNxTTFzH47h_mEo3jPbiCec4Vk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645018033,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TZqG39HcFNulNZIWwddpSRvJhOoUqgml4c7GebWbYdszvhsmST0QhAkkb9UypVPQ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645173369,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('oX6lMT2xdWAkeWLPqp_n71UTn8UIpPkRN080CJKUI4vL4RCu-AmlQmpg9oKNZOpk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645203002,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('tyHiJuZciNtmj-GDYgonOgfs289tivq2-isPM9gW5KExxaLLIXVas-MXHBLhyAic','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645223001,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Lx2H8Wbz1ELBv9fu5UMBcBjXtINPYMDHWlgMKUUGmwgkGnwigOLYqOURyKk902cz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645232729,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ROEq3KW5t3X_IiQafGA-P1I18txSDgD5m-5uqeAvTEGZCBrGuIxxydstf6erI9b7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645237410,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_73G9d-nUh6riefQT-KFIQ7GAUcNzkB-Hq0SoXlEVNDUphtHe4DFa6FZ2-C1vm81','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645258535,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jw4EBxHDv_EO1EAwrPH2XgxmDbrs09_OmVLIMHFqs7ODWHiwnzsrRPOu5Rohfx6u','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645272017,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kBhjJWAPQHxBFzYW8SDtNlA75BNixfTnv4-y_mi0RQqNSAfjKFkIkTHzINoETEm9','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645509744,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('NygfDNszJ1gDBppaO6nHq1F5AFLgeVhPJKuXXDdsZWe-g5KVD7zXpssWyvhvXVy3','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645523941,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Ntw7qz0UPN11YHIXCgG0SzQu1_NFpjpXk_Z1ebS-5hjhphGtlAtEJxqp0MIw5wm6','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645530717,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Y_HVKv7I9VnUb2tGLOXNwzeb30w1TdxLR7Fydo4K8cbqH4638XpG5jookuu39bVU','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645556632,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('fvLMpWOoLxFqAoWvOGwdHt34V-d66FXBvhR3QFqLvnzUJRAbnLuungTUAFRvaHt6','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645775234,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('86pNcr67MFncs88miBkEB4_Ky4s6nCVg-OjGv0eRWIT7_wFxjnxyeix04fqcuiN5','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645776334,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('gsmiWFMtTfjqZ8j13fbhP3bT8V88gdKTQPS0poLeNd6oPwwtsxtYkx6iprmBvkYQ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645776413,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('SP-7ktbq2iRqDOGw-GmJiMleee-Njr2o1c8_16PSTkyBbIi6Rsa-hnLHfhQL-cx7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645776784,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9RRSoJvvbvDlpB8f9KDbZRmdnzDMN3Te6uPjpBdTML6WRVf-b2bEWn0W39O6mQIr','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645777992,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('bwOocyiPmmAmOKzlUc9qoXca2ctfgBBCpd734i5LOjB6AYgRphEF8ZFPFzaW_gml','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645792826,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('R9ZO3QgRNmkrgFLQDJziqCRUfXgfao8OSyMfJ2XGhKr8yDKE2_lB9TsNbatqBtiw','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645795293,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-9vO9aWt0-08I122HZlMGuqC3TjFb9igyMFeR61FHw93HdmiHeLjXH7S2cNoWvyH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645809579,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ReYYumFgSGuJvolQX1TJYFPfx_GIIYEEJQIAoY0Ndf8c5x1NHimGbnnyT4i1FaGe','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645834388,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('fax3JDWyVgwomV4QzB5opG-02sRK-iacGytDtoQ6nPj51bbm4g7e_woeGl-8FY4Z','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645843725,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9lkd2O0kiYoDF_fPd7goVz66U7k996-gKVcP3PgV1-a_I4_vjKR58asy-i0NxQI0','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645846184,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Bm7WtQTcJVxzHA-34N37zjxQcc0v_VvrCZmrUl3mu8N10RMAlQZ_y5rushy3JX-J','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645880066,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('WBiK1GSyUW_A9mS7V30xsl2DfkwDtafP1nR8NYNMDKsR5m-vrJqDCN_499isNq6d','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645889344,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_TPqAY6ynlMdt3E4O5aESyrgjd4_5bzY8hy7FcfblnkcBpJz-5LOMbOZdh7s3PYf','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645915923,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('q-jUT7HNj5RzexORPRHjEB_G6U8NsgXm1j4k7kNYc8jgbhhgawpPbo5dsP-RxPit','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645963655,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('8nrxpFjSqmZR04gVUuW6xDfbrUJMIUd3PuS36F81PpolUfbxMEhbpg6m5ndBQnsh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645963656,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('6jBxquxNWKDeVIAYE97-eXyutN7wwuFIRZSazYmT6qbROIeSRjDGr3jCwFs20yJp','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645974067,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('1CJ8E-uTFVNw1y3pbmMzsmNDoCUphdGnEo_pRtZ-rFJ0scQiIzpu6YaExrjveqer','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645974067,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('De4JQl33hv-Y0A0_6RhblPbv7dF28eEgGg_9kZCDR69ZF1R4YUNtslk7bqzYoWQj','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645977364,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('UHXobB8zi9W-nGQHG9Od0DmFO8NVjkB5d-cM1TbbIuWohtiGFK0SXlBGKvLYGern','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676645977364,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jqgH_iu81x2bMJWWmtpJgzlasF69nejF0Dx8eGulwbi3stL5ATx0zZnlZIa0DWTV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676646008260,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('fK9O74iu2kQl6i4zdBmwGjyBXdIXSf7q8gzw2LwVyYd2_RR94zMwSTqyoNNiLOab','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676646008262,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('eyPT0WVrUoo67GqV29-_PHYMszZ5cezqoAN1sQ_TcAZh6HXZDbes15bDSzZP4fHp','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676646009240,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('yBRYoI5_S8ktS41NbIdTqiWOu8qhC0t-sCJNeykS0PCJ7EZI3vM_0hIIk8daX0zB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676646009241,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zjzSJo-UTNmNGof1A_vCO9WvR3qAXs7lbjE_HnYO0e7vYfPIHvRbl3BaJI6Oms1J','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676646019934,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('4FdMhKaryhGPXATfmO74DvRuBb2fyAaSIcXBr2xpcKi_RM3PRJNHke81Ag4RVB59','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676646019934,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('qjmIfgw0u8WLEQBUv9uEFQwIHavE7P9gIJkjrqx1XTi3I0-DOeMb4nI9foPi4Sqd','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661214855,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('U-5NmjUEtqGOkLGfErtWLpfsTZpoaS-GTG6Q-xJV5Ee-bG41SHzX5O5ZFggrIdie','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661214856,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ExDXeT2dJhREkwIeH7whwu1x-iUsrMJ0GKDmF2NQZMnzSawvAQQC2BBtahH8ebaz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661260297,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jB7JTz2Cz1JhkZhRS6yZknSBBA9QnGm3o-Ng5dKkiNl5EUWrVGh4deSlHbPcEj4E','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661260301,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zkBRnxm5A9vgmjn7Yni-Dq8_9lLYQA6dGTvWDqkLqMMuTjWXC_pZm8dOYiQLFvE0','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661360804,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Qbvkvy0GvHSfvobBkVimuaUYjuH8_iNdoWG9F3A0B2De-GRLN0obSidqCdFgyp3s','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661360804,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('8VAQMJIS1AsROa6T-cxecCPO20DMepPnIu93yBOBMt7BkXmezsLyxadcuAqCKfAX','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661408599,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('LVRY2U-qPS4SyT3AIUzW1UUXMJgiwkRW3lGhPuanov4V4q57BF1j0i16inZj8db9','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661408604,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('FEN-FeyZtFRz1GJOhB_wqcF1sfrMvtL6MCzQr1PE0FiSXTbew9EDSiKmRA14pQoN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661449301,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('828MI1Lc2uTwr2KedixpEP1M2tUvg41Rb6Vxwk2JOUHsWuilK8034OjO7Kw1FiTW','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661449301,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('8RnDG8TNP3OJZZycH0C7tVpEPzC40z2tVJzDH14zqSTgaqCshS1odigiQY7SPtoi','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661466579,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Qo-uY5A_oKZpLzF51DRhcoPRd50s54UpmbhD1_VqH7kOCbstCVsnSL1VYjXlN3eD','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661466581,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('x3qjAagfvO52cZ9xLunH6z3kRE4juYhOvU-GYeSYNBhe-Lkfl2bP1DPMl2t8HhLK','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661689031,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('5eJ8jnxdIG8ZBknmr1c7519cMem6orpZcEp-_zsW6cAoGfpS2f1l0fu0C0lMnu2A','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661689033,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('PAWC8sPnoOI3BbfMAK4Pl9Lx91xNBfi_srnN544RHqa-8awqcm8slY4ZCgH3QGvU','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661740663,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('EYOnS4_FXc6b-qUGgyGJJMbtUXKvrEKpk_2JnXKR0vjS7WeVhV_JbDOztiIlLckj','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661740666,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('YmlXK_bUa_TazlNAk9wp5Ub_WEphhqlU1__2tR84cTMVk8q8pqc2p2YOzOFu1zhD','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661809733,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('MGMslusFi-vVIigfD_i6MI08JiQmnFVL2nPSDHng16ijSSQ22seDBRHUxbkBCF4J','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661809740,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Cm6GX2Av91KNQ4EQI9IYV_QULT7a7wL3NVUDhAnmruwuLWMa2IU18BZavLdbMTZg','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661812754,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('iAd70UYtz2L1_1EqA-w2W5uG0TaTsQEYchfIl81fL-OFluWxZIdzvDiq-8Z8ageW','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661812759,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9mNRFFNLJ9gZLQAK_zsCaYRgRp3KsSBWZmwBMtcWE3GLj1njADvALDfIfmfvaRtw','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661840692,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ddP42mwri0zsnkcLJCylZ8L4wePJwI-4RpDxuWctSJ-ms7HhgKFGq3eawZJfl2X6','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661840692,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Uxe1l6tYnyXvJxhoC_04HF93h_JzrAbeUqGLuEA2C7A0ynfzVQEzFw5ZzCWYUZ4r','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661853992,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zk-i3lIWe65E77PUOeHR9a8MNHxXCkkz4_yshStlC1w2VsrYA3pbh5Uk4yBLmS9Z','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661853995,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_7PKGPjU7JQGwt5zk4OsmdG3LrqRbp_NmlCC0JCGi7lTmYEh8J9U-xKsrZ31JqeX','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661868788,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('RMl_co31-lkwrbQ0HVIYE6Kn7GdHlLbEJtJbQvwfWKzW9Uz3IWA51E-7Me7SpjT1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661868792,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('o9Yhs2x0ptdpfvrFsYhtu_8fybXOR4S-pOd4cQlWwUetja10PeXRDf5Qww8mr7As','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661875467,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('bY0PoNz1h5QNryCPDSotiaBMwuC2ibcNn-kqTUYe2CTB11B9rfvG2XPFaR5f7wWz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661875468,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('AmfvFT8mQ3S4V2eMtYMnSYcBJ0o-QA4d5S1GQyoWd56muXKki4RhS9YSSsG10mqa','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661886144,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('oCLyOU2CHCrA90nt5LsYpprVfD2wypuBgo0RO3IZYd6aEAeb0dq7swNp0y0eThX7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661886151,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('REjV_2xplSXluTtEk6-cPyvzXflnBUus5YqR9y9iVHNQB9Et37li9UDFQeBGqYqM','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661939823,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('IDjtLjETPtDjdfY_b6Amnw9ZBNnIIVKbMVM_O84RRptmWoU5HF17_lPW0DVwj_lk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676661939825,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('G-lTphMsECBrt4zu02FDRcuRD-XJj_qLESRs5Zaxk7cthPwnRZqCChv4X7V7PsxV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662116547,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('dwf-OIOvOYoNM_qzCceBgN4iwKJW78ZgaLq7539ZSS6P8aML1QEpcqQu5AgHlb8o','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662116548,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('bUQxDgWCOKtdDp748KFjwh3SIxzV2f3_G_ynh7M2Z5ZrrVEmUHXH4oDCI6hSg5qF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662257010,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('eMkkQ4RYu9VhsVjvZeINi9M_DrKV5j8eoXaIZKITky6iqnVLFICKTC5FCxSa6H4c','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662257012,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('0zZj8FuQ90sBaIY9x3oZS-kw_iL4UmZxHg08a7Etlhrh0xaYCFNaK1Fr8xGaCD03','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662283376,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kzPOSUdOdGo7R-tD6Kr5c1LdLeci7lfoVKNvUcvt-X_sf9fOsS80iVe9-nj-qWEs','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662283378,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Na9dhhQ6EAarJ9ptNyfeUujwAMcPqJxywBhRwukI52-vdh5bBMvvZaP72OY-nC1K','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662360338,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('HXfrSEyg_nMDN8aXYgmYbhWDMH1vbSqFUZwXhUd_5kmOPg0AOnCmeCPSXzsUugZq','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662360345,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('THa5hNG_R0b47WHg2ub9LfyUWIfhQCFhEdrS-swQ1fVGdoTDnS9fjgjxQwfludQJ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662385094,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('LYCFvxxy0rt9h0LWv-3WIarnJnsIdlJvUaD4QMSpKNwaz0yDnqY3YLbeGqGTeile','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662385095,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('4eUgu-dUR4BnaMrwffENgYxX5l6dQxaRRe-qT2NP-yGhQ8jQjCcqw_fhMDAoOeeE','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662395745,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('q63C5Ol0yBhVRAJJYWlrqwRpuwr0P-3q_OuDQlwcObBeuSFAPXjGjt-n8FtSDKIx','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662395747,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('bWxaYgCRWvzalOMLzQK3v8wF4kbAXvN1mV2GCjqab4Y0DWfvV71nUR7jBldyqzEy','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662398981,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hmKkn8cx6tq33E7PMOaLI19EN4QMOdd2jWnzQJyGkjEuTMDsvNZ_j9Gh7thKaudF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662398982,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hkIAqEPfOUsT2NU8nA-wHrGv5yMi2vpZXm_YrV2Y2Tsg5bkuH0zDJkRAt6TRK6JY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662401959,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Bk4fHkWRJBEZfvjfnfUHunq3ZC6hnLYkiu2VpBP7LzrH49w4_qb3rqpGVl2CzgC0','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662401962,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('MOvNFDzRarAXiXmcq5RVEMEyLP3U1rttO7i5yNZZ-TssmdYFBHZmEPf69AI13U1v','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662643645,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Kvwe5Ty3dbF9uMNz2YHAZxV2E4x9usUbiq1QTgPi5wm4F_tRXY4rd97WRVDph4VR','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662643651,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('1YKSHOqxZziH0hIp2RMUAYF3fnCFK_9zsVSCqn7-SO8tzPmqxpn34HuN91hm5w4P','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662645550,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('JJZMMVHXHPt7eF9Md_4gaBMTFuV4gJrz8ziChRB3J8AGHXKOroGpmUwGNwznuFTG','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662645557,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('lu2p0HfZ6_gmnJBrWYKHY2AXBHsPhXmR4AQ2h_Y7FGCGNR1DlrZQBUv0xUgdB1c1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662663396,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('8gqjXpUxXc2BSbr461Ir0w_poGXuKW5xAfgMIBVCAsZETRpyBr8T2uFT4ZLtZWpV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662663399,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('FjkGjkme_zzWlug8LlTKw_1_Sfq2cwraw7FJx92EY1HqIruW8MaF35Fju42wiYra','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662877489,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('0dIcuaCW2OtD4LejF8Lz_IEKtQ1Idl4JXTOFaWW6-bDzdERDfPMBQ7-Elue6vJNq','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662877497,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xnC8bUeygDsVk6wpsGrUCFQMohfnvRcOC8fCIkDY9Z1m8Ln5a-3nnBuAFzfNqG75','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662922280,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('fhbe32vCxfZLPjRMmPxV75ufM4h2DtDvWYU84ttq6xps8aeYtrZd3pGjCx7rXjvH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662922282,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('nOqy44izQ9DLd0YT2JB7ndZuoo8VF3MTDsFo1B5C671fqfIl783AguJ6ZtIn8p84','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662938074,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('oDrim_jaLmgNcIUR5JG4dnUJA7LSKBTPprDEB4xSTqo3YTQ3wbm-1VevHD0ColRM','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662938078,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('eINOZhUBk5fb-JaI5TUtds7ObpFYYdEl7l9mnJcrrJBNAxiLpdUQIO8xr8DplDpl','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662977204,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('wx0QhRfS9MDgKHzZQaU3nZ7qG2ovYk6L2VQRg3RdkEE8BREG46-712mZyMuqt_ux','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676662977207,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jSHhEWdJzhEUAGAQX6yuDTtMLo4IMt607ZSdRkSdCpe1Z5LXU35SDCb87pZ-7lDc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663003412,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Kv4sgf37e8TcMU5FVLJxsyOC_lou1RD78Q95VI6Z3xN8Ebu5ABkTjquy0VCXnTr0','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663003415,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Q5apJf239PhhbBpJY55KwYU7eurfEeFb0RkA2en_0cQqzR7V4f1JOVPCAGi2WK1S','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663131301,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Hyv7dBxdd1VOe7JW1rpR7CAULe_R5R95CVupBIU4rFjVzWe6L7KIRf0SKfjiQ3XB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663131302,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TDEMQ0UPWVv_q_6qj8TYJq60HHjBms2rAOewBdlzwwMf5G9O_mqxVX7dUGAOnRnz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663163293,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('IRI1bQFnPO-ZiMKNIsaBM08igdbffdOj5qJ7ZxKcVWDK2QYu8Dc1KEvSXAeQmNX7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663163294,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_U5yVADNQyRjKOIcSdWgYKXWqoKB3UW9hmAxkK9-FAOSDpzc0O6h-GevaO0oosrM','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663200048,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('aCRJ19Nlh6I7M8Dr551kEWqY3_2uKuJ3BStf9UekZS-nnL75cJC8_ovgFBKL99Rc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663200052,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_x5d7J4H7jyXwzz9ksf-ICLAG6h-ibBtxPDy53v3y4mFB7eqKaAXTQMxUdDk4hFY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663236959,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ylFttfPk87FO9Qo4hVOWiDIp2aOdxBQqB3Is3Zs6CngrQ901qViT8JxPLv-SfQLG','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676663236961,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('K3rMNIXIRsGnVQTZAeytltt2OwZBDQ-IOej1FhCTRQ_EeCYCCVnI5CTX67iiMrsN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676665797572,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('L7gQnqiywSRmAWb_h0qqFQakC-6QUypqr2Wl0u3XjXp6CCbPjSsgtRI4gDZ-TBK6','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676665797572,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('nrIP4mw_raji3oa2K2LRt-xbHNbsF6uyryOiMr_T1WFM3JFqmJF1PZAIPsduexwk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676665951532,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('F89hY5kTjrNSyQyxRkRF-Bd6ke0NeuD6XCWfgSqnZLP62YqSQDaDAyp_X_N9ZsZV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676665951532,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('FscK_muayaTorfH2e6N6WuD5vCUTBuBiYUsfLSHNEPhU6K3Pt8lJt4wpng-v_aDH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676665983688,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Gfr_k3qlWTJtvh9qE_DmZQO0eXvtC0pUGLAHsla3XdQGRtkDIFSmxas9wEoH04u1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676665983688,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('PIvODe1IXDCnur2FsiJ9GPcK4ueaC3RgehSSrWeDF3MkqiSzHGdxeKqjYGLK3WvK','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666006893,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('nq9vqX1A2mr5xrABBpAHbSYIb9IZ5aF1hVu3HzcNRskuNpwm_xBKFxhM__eAidMB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666006894,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('5X6IsqN71w2523MmC1My4YTkZaEUocRKnoI-y8QGRV8KxJ_4c24qwcQIhJhKV5NP','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666021980,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('iqeW3gp62tIZgzvBnbK0_dSsi8OscgfKwRgFVBZhqlayRMha6lgzCUeIJNIrkp6w','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666021982,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('QgGtPhIr_M1JNU85O-jryfJIOtVLfyuSoT1M5PhDPmmulceMfq8W9S4x6MZBysSB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666040753,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('gccNxmUpgwI6uwyfVPFfkaGpix-LNurZKht1qou1OOAZRirhpg7NTaYHh0CJ2xaV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666040753,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TO3AgoMhcmZHv-7l1xnR1uDpIz28fgdGkQZ--fSXgbWDuOqWurVspylcZPQdwwIG','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666107078,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('6hRRA3EXSlRITz9BNp0vzeDyXK0VHSOGEdnnxgbUQ5jDxHuiuqy7IrmbhB6C7zK7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666107079,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('UsWpX3bytAe4vHpUMxYNDxTCWC4xdG5PfY02KleHS_43DdlSJCFKVtvkzkBIFtFk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666114898,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('0OADdXslEdc0oXbpZ53PohEbBfMHtsM7TobXL6-X3oQLZTvYwR-MXPL35LWNO9CA','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666114901,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('FYGGSDSWG5oPyKZ0jfMkxUL5zXp8qJZLMLwBpTkXygZMDPLQqe21OGWL4Tm24IfH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666147497,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xbhd60uCwznVRGHKQmMQkJ6NzAlyib3eXjGwDIyJXeLv11F2vaO3fGbGyS5LCzda','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666147498,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('abb09ZzJyZPnS1-8-4YvPAc-sBzVuJwwUvm0eOH7f0lVAT4HZCzQJCUDJ5rcEBuE','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666199278,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('50L4kpFhIefvpT1U5oL3ntZ8ddaLA-TQF8TRKp2gyE_i31T3jdGFrVkK2ND7cb1z','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666199279,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('FjbohcTmG780uon0kKvjDrB7wuirrDhXpEK8fqPLaccs3R4qE4Dq-bK_1ANCgVro','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666201230,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('SOfL_L1fsupVk_dY5Ft18WMWWWDy4ZVx0c5rO_Xz_dDLzuKJhBDnWNtWfxlPQ0gk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666201232,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('CQUtSbM8woaMEtPYSBvEE6epEmTtY_3gf2C98mvlLONycqsJNSNXFocUZePBJbfS','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666205089,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('l2aPYl9DEG_uv9f2PC2z8BBgTntux0LSu9JOyDCn0dHahCiUIPirCHsEBkFqv3U1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666205095,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('cxumS0Khik57Av51lZXGn03RtsD6efc_lFkbRVl657tBHCMrwqXvn6NyRn63EHR9','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666209534,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('LwBRHkllSQeSfgM9PrVq7DbDAILfDchgXd-xG1iOIUODh1z1HZkvsbXcq5wS0m-7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666209540,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-4xUrKP58hVwKoh2XF2ht5jlbYfj3RG8afy_gRS1MI58CaArbd3Fi8kSETJC3a26','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666244419,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('bFlKFHE-hK0wAIZMf0oylEDfWtt1Jyzju2ErTmSDXD0puqplTnz0937Y4iakKF4n','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666244421,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Ikf-OTEDbkBo3GBQzaxsQrfLF2-nq8-uQgixe0pppP3RSNmS6tygyu-UDrJOGcua','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666420644,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('7Q3z2fz0g1Ae6WUT8mYLAYs7vk6Z1AhGnnljPAhs-2tOr_qe1gIyu2hzLK9jKEW1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666420645,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Oz7e1OwcSUb0lzrHvJopcZT7xizFtHBBolGBAPe8xB1L2IDy1BIzOGQhzpJenyWV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666441555,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kyPgUvBHGs3IzwbcJTdBc0gtxrwV015S9bSJ57LkqjLkn_vMJfxxd3ANxnmdKqWf','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666441571,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('6zhzv3qa_Kg0KNgOtIDzrPT3HlUj4vWgyjKckUTFfpcdvTPghr8-drL-4WazdRT1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666492253,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('DVrIZ_qNRnfPlNlWY28n3XBvPVNQEGhyZraF38Evh6DjuHGMgDwdmvJxs6zsOFER','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666492254,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ZcBlZh1AFZjbNmmp-gxxJDYYdK3hk16xsT5yIpRox0qJ7CxhuYE85dy3lVHMqv1g','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666510408,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('vBPsx9e_VMhiA-PqpJlsK3u_k7u55PPximZiSrbtkmfosO2UI5ROdVHpji004Jha','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666510414,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('1TH9EkbBli2WxDRbkUvlOzAEhovE3c1AsgbNlCZVZLy1eSepFNseMFE3kB2NUoJq','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666519739,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('8otHV0Rgv2sLh1cjOEzIEM9avSWoE0nt6o3idwZHfHE6UADYTGa0kqpsOqY2yiFz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666519740,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('rii6TeojIcV9u8wVYAnNpIqxlnzmN8ytiYybxNwMwa-LNboN4A7-pevvEwIurNko','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666891966,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('BTFw1jDtZ0bcuqsE1Ymb6yjV3WclWfQqFGrEI9KrORZcZg8l6CvNH4BuIDdgKnK_','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676666891972,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ErNZ-SE0dizNY1RNvkVbaOVDVnc5xcMVCMvjVti4dvRrgfcy2uysvjLSY48waFu5','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667000563,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('JMb3qxWzVKkn1A5CkxXQEryop_C3VxL9qpN2yiE4RskFinTZxnuTOAm1zg8sq_Ay','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667000568,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('0ppc0A8YA6iQ06APOnm_d1JQq1uahqM7N9o8EOXfFyXbf-xirIZhHnAHe5OpZw03','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667017341,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('cFgvESnbFNIonTza_h9HsC0aql2fVJ8a6JjckTb2ME1ZMamP-Iz9ZWMKARQSx2_A','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667017344,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('b0tSdT31XWCwDxDB7VhGPRVp5n1L04f4GVhq-ehXAzAXXlZVQMm2yGKgjtql4HrL','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667258560,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('DzksmzGI2yOsfYX0qK9n8yFg2LatUSkcZFYYP8LOCu04DMRqsWtbyGaYdSxC_x3s','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667258563,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('a70dtj36LO7K5Ks_FrGxjsc9GLF7bbGRcv6WfXSBMWqQkkfLLyAi63mC9J526g2L','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667262173,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('15XYAdRPghOz85cyN-vlHEa4HEeUZUGBwpPp9EL9d1757YDTtULKb0Xb5Dsf1mGH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667262177,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('P1wOtl2micWEvo1kEAv__pxaqsiIfvP6FBnvue519SYFQHrOTk-MWixscwcSsrFP','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667271921,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('d02aQHX2_0X_oxw2VFZGO4kzY-QD-C7h63HaNqvJm-67hHUtqccwuvQ3otJGREht','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676667271932,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('4J2YUByllxJaXZejJVz9TTqUQLd73FKrCm1s4qrbUp5ZtQD6oDuj7PxNJZKde2tm','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668041593,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('klrut_tvWFLsUkFouffgajw21WAYCsY3bz4Nresfn5Fn_mBfkPBgD8Krz8kL8RaU','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668041598,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('CS_ve7DY4129unlKD__gieT_MHMF96QJxTe15d7goo7-1Ur6IhxQndQdvm-c26st','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668044529,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('WwJqYiBwpAVcQmXzuVcN7ctX05dyQQpk3fS-dIIr-H32XFrYoMPT99dsvF5JS0YV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668044531,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Gl6qBI-AIaue4lXD_bk22s9fJMIIn2dCgNW0fhxQp-4jJPpyXKW8ITQR9xY__SiI','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668094191,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('qwenhZiL-kM52qvP78ff6_snSP8I-BaYhGZgw9knwmnVQkO1F0pwwnPBqB-wtewH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668094192,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('rU-Z4h94HVYYdd2D6qxqxBoRWEBps-wV9FeviMZcDVDQkDV0iUjn6uMBt-HTWSFN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668125747,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('dEL-v4suNeMQZS760a9wcXFd05BKgq8ipvdJiftrNXrIiOLtW9FgzRlQ6AL3un0m','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668125748,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('cjLUBDom_0U2eMW6b4oQZSS7B5yQ0MyV5mhefhwc2u8z6rBB5_TagAKSTlLdQkH5','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668253495,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('pmqqXnZ3lAQyblGl_n6LnsgsV5MOdbfpRWJq8hhLaxFMoTp6EoZC7DSpR-f1ctdb','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668253496,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('A9lRn8jnPICMH6l9xFMnx61FFzmCY05ymP7M9hjtLziBEHurzB7YFMJjkivFs1LV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668291786,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zQqO7ApR5MriVDtmLzczlW39lDZcip80O96YYb8VXzvDOf0b5qeALl3fnwTrnrqE','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668291794,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('KQihfBeuOZIWT_4QQiKMpmjUGiR4DmwcIyNixBW-w7bzWo2Yiw9Ba8IZjD-g9xvf','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668297798,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('3-sB8Al7QnoFksFMfjeeX0e3lOODh_8wFFM_x60e5zKjdLd8Y51VpkwbUCezQieS','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668297799,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TlCFzrK_Znoiwl1n8-adcNXR9e00-Pw7171CXy8dpeFvhVRpmCexjiHnp2LJPTlo','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668349667,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('fzYjBskSnopr_RCC9x3oTeVZcwOBmX5xuhFkxONcDq93f0CcziVDwLJrRWqdmK5n','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668349675,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('iB-Jz_TCS41WSikmY3GIbs_xJnCeDkQ68V-JQp5CGTrb8Tgsk5s1jaKALzJsPc_S','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668350114,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('BJEP3DaR7t2YkW9F-Fgl1qP3QYVPGm5zXtzF0JWq0ppU6YfebIweRFOuTk7aNutS','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668350117,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ox2kd8C5ymiWYRZhctfC4OO5wkHXMySHwzcj0jgfE5zlxfjVGJ6odt9yizpGiKoY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668363261,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('K_NE3LyHd79FjBNTf2ZEac02RrGtb3zFR1q0sC-2eF8VYI431LC9lJg7gjDeSw5x','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668363264,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('JiaWqb_7NpH9Wwi5puWIhPCOzvu-YZX2xm5cdj4_-DbD9S4hkX7D9ZloxWEWFn9a','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668380483,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xjF45tp1WF3EtlK7g2Y7z2OGTzDnAhAlnpTxW293iGwyobnojMp7exZoMikGjnsa','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668380489,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TXZZx1CCCkFsb2TPuI3Px0PQSLvZ4Ag95qwqyWjxCZe_Q7AAneQWS5KsdjEzu_5B','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668386265,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('CB-dHIv-R7qUq_lncPXG7-ClBLQ4wOHuaU07x7uhcbwDXmvxpjsgOokJjuJnZ65_','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668386273,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_9PiHrIyWQffuu3TkTXN0XX6ZPJ19wRq0MYUzQhQ_VDcXcJ1Wf0VALmJjWoYtH_X','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668387445,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('sjK31NFHvcUdBjxg5zvnc1pEY_iaGpbrj2bQnkOJVVKM_gO60FmSz931LtlLXC1B','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668387450,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ENHrsAiODXHhiEc0yR8Ao36fL8sRe9twiDFdreK39WhDVNbotzWiI8nx-O-3OaEa','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668420428,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-avoBbJD061PUgbEZpjQywupQoCphqO-zw_SRAWboOdBGCbuWfk8cRmXr9ctRqTV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668420432,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('T7gZALW_96TeftigEln6xCAs92-CkES-Z5wso-4vawVgGSGt9DQdFwVQ2wsWIv3J','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668458981,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ssEm3zTh0eoHAsbAGkU2mUreU3jlgsPMF2Y6tK93Of6zo0ofQ6AsUTZdo7KWAzC0','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668459007,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('B5ta9TukoJXuBAn6xj95sYOp2YJNCEYw5PkuaLznTdgqb7gOBqdrYxlkqj4m133o','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668475566,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kBZT0AXPTRMNFD9L0Y_136BwKPmL6p64zwMyFPm9z48W84m06-yEdtiVsETsxie1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668475568,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('meWZi2kMAsfuJG1h3iU-aUyjGJXUmlv8RP0E10s8N5uUnZD6VGyF3S2T3jbp2w61','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668602820,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hxyem8SIoId1JXoTZBskleuxNZUGAZPlxAGqjF6_oqdrqCBwzZQ_H6tP9mxkWy8n','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668602821,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('p6rFCuu8pylnSGCURG9cs69BSPebV8VTj97TG10mexBTPPTyqf4LNiUBHJ4KtoBQ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668610087,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9HDzQsQl1c0ivASPYsgmiEsTzGQXT69sDcJP9l1C7hxCYOs0PPn52QdbRm92n1KQ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668610087,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('2EiL1RxNgOuyj5o8w3O0qVfKwECkkJwNrunmiBtw8hoObcBi4gKQsf5nWjtKF-Of','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668633241,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('r_Cxo6lFAxEIrPqtJKuyI9xcGaSLZIY7naAmPNxuwvWii8TdAQPMYLj3rQQR3vQY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668633246,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('XyO-X2tKf8V3S3ZWiQ67I2w3AV3lUs-T0hRYY9ydXp3I72UudD50l_o-YQ9XO_9-','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668649633,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('E8iKZFuiYeFHydhJTytqhJ4sOxU5v1NWkbGu_F8-gwuXnq0By5JAMeUVK9_zp5w4','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668649634,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('5hij4mpwO2N5pk64jhuHYZQQRN3UHol19YO3KhtPToRrHzXZ5LCX0tMbLkhXOfIk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668684431,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('uKOc0_ZWRMzVsUydw3hE0UDz5VGcQTkQ2lJxJCOcX9ngqGIHcDNFHj7rBRZw3Djh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668684435,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kt7bBZIu5IABmLGN7KcV6o4zl5PYDYcT9fqubRooCF9Yt6sQTFoCI0T-vdXkko9d','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668772445,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('KjiyMGqdrMsMWfN4tfIHpZo7QKOcwJ1kp4pIiRRZQqv9TQKs--7LQNlfcKqEVmPT','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668772451,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('586Wbor-G37uvOYMJbM60D2tDSXg2bBkI-SjQE4Ehgdyw9ZGGMdKv1PMkamvRz88','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668784236,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('3XyXd8y2_STVDbr-CmFqq8tuDWxLY4_5vfGCtQ83CPF7FsICueBmej7Y9OKI8fJF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668784237,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('JOe92_qn7Atb6-I3LyTvSDkDYvhOejCVh1-6sZ1T-NsEig5A_3nvKJHAyJ4zjw0y','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668790137,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('YMmcWR0iHYSEhaEYE6OxZjQ7-AvGk0kyZ5Iiyor63KdcXgouqFQrsyoQJ6wgpbB1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668790137,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Y_cRUBd5Gkap1Vr6wafHjqhXuCWzKJvd1ZWltWSZImRBrim0FN0sY1zteGInJZTv','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668817785,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('D5OMHytScnHHN7yIP0HzCvafnkBIqnJgU4TiUFFbcHfZIAsO5IzFQqgmyW8pCOAk','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668817792,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('peSXpe7UoFcJdMzoPGc_FPsk27eDyhRpPbYk3l30q2SokzqxU_pysRrdY_kU-iD7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668819696,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('3NW6wzZWt4As12KY85Spio-F75xufSETUqe2MPPCYKMOp70_G-qh4hYY7O6R-4Qc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676668819698,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('IWKJFiflQv8Ct8BSwVnxIvWSepQ2F3Rw0WWPQvPUcW2T3rL59J21_wtkWc_Mk2fF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670069741,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('qj1_FACKxo8q_Elpn1sXwtVXc3jzO3yaJ1a6YpcnLSLTDev0RHFJbIHsEx1Djgsb','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670069747,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('W8cvcm82JPcS2zKzXTzsZ7S4bJ8r5ZSNvV9pQbFb8NCI8OCOqiNvR1dlC7bv9F1G','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670150947,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TxfHBd3nowvz_Mxbm7_WoO9ouIopkZu0YZLFWo3JW_dDy6F2d-naiy9_sXuHt70l','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670150947,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zJg3PkILz2cgIRt9DFJHfaMhkjhhFZVZPrz6QE5MUkqG4rbwux5i0iDrEoYO05Xo','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670300536,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('JwTb0H0vrqH7utRJ-7pIxn1vL68zvXOSL-ItHF2Mpbg_KE0CqlNG5Ud1j8GkX4Uv','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670304092,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('KWkSkDvFZjgXy23N29kpvyWoJbdNzMZmzWKy_YV8skIaI6iQYj-q6klsuqHFAWig','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670344892,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ad1mRm-mckUQW__MB7Y1oBCpe0OZUQ5E3QtuQfM6mHGJLBLsvFwVZTkEzq7WDzAh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670369144,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('RGoT0cEKroE6Ir6VAUiqU2mBrP6aJ_uIdojk6qON-S6OSQZA-tZSefsJCxqs1WZq','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670380990,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('v36GKX4OMYhi-C_J_8X2QyA71tZnvU9MzLGVel3_C-kKecgz1cBJgH1iHlIGHPi0','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670383775,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('A6IOX_DKZb4GmuwK50j2JnqY5aBRaT6VcHa-SDGw815ZTXjscbzuTG0wLxONOrPf','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670387906,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-AuS0YEPE2iqKGcScLg92S-CLTRvH5paxc21kIuxH0jN1vgbnqYkJ-uU6ynLiche','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670389610,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('LZ05Tz_LXxp1MikZJDh6zpA-YQJklXYW8imRhinAgJLNNSz1OxpNuHzfaFA-MrIx','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670479399,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('dqhSrEq-6YHFQGekiE4aHV1vVXMAFQemFvLiHGdxydphzOWOoUEST41bdH2KKSU2','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670507847,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('OTjC5DS30m8QAX0AwCc_OG0kPd6Y2dZ9taT79f20MDX2xxHROLl3RyPD6UP-OwbN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676670509583,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_S7_e_ykf39fJTy-07uqux548pgKKMTyxpYJj4MYlbqg1fIaQymjCF1-dVD-ofGr','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671194648,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('fgauD9DJCS2P1dhzLilABJA3aCwTFe3JhIdk8MaoupDTnavyQJKc9StINIdhVpyf','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671207100,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zPtpemEdrIYNDdg8XxuYXB7ARKSM5f2LF5RBvKf-aZjxbekDlRLOhqhqilDpzW_b','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671232819,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('z3zr_yu3FBPcfeusRuDnb4qFY2eIo2Vzq5RV3zCrlkguoDrBmMwf85B8OrcKwkMS','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671236520,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jzMc6U7gaiY92b5YOlliXjHPuFf6almo5AYhxOe9qpuxwR-3boBVdJf9K1IC2SCc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671426588,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('cNE-S4aZQqNEubMvGS-JnHAmD05PfTWGuDL2osEfdpDgNJCqX-Ry-dTS3rpp_nLR','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671433312,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('WBJ2gvTgZy_j3xp_OHhEu8FfPaoboE-Az_sa8azjlBxeq1iEW0aj0pCfsnB5wfNX','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671438738,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ApJBHFOP-5bSDl85JLdTNyM1dK5L93IPXWzIuA5fnt0IXgP4WTwbWRFDcFS08LV7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671490794,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xSsiyNTAhonXHn_Ol0jl6-qiA1Lbp9oAEClFmeLymYesLQhUrL6r6-jS6f3AnuPi','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671498160,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('CDogJ2m3Si2YtNKwkWisTtntIhTvX8WfYoQ8gzCZUy4oqdjpX2SkBnFho0oMqlhu','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671510317,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('NofANa20nZ84uIMugge-7eGEjzeM-X5x7JWS1hf_x6c5z55bYJF8GJoV2XW30ygw','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671514571,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('wFnV8ZAW_l0zX3WO0-TaVarrHby1UYtRqX1AulXDrqJd2ihH3oxuJuixWN7OledS','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671602390,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('mLqSJYyUCLMsMRYsWLB44TRIy4J7DIf7zo0RIez2WyCodIURh92i-Nj54eAOVu0n','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671612402,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ZzcOeC07-BYpaXlP0ynPSb4ymju-PlYlh9IjCASCIm3OuD1S7UHfNkVJMxbhuaRm','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676671930803,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TCwKKgOu2Tt37ZNjDmyGM-GpRcuun7oolv7D_dJYClEyhHEZbg-Jqm_0BnCANnqS','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676672252237,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('a1kNfSEabAPwD0ycT1Myz9rb5C1PwFtop2gww-WRXnVrG--IZkLJDRHV7S8oTDkZ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676672253311,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('qK9Dxvza9fagI8lMe3A4q111LZVzNi2eK0j8CUElQoAj8488y7zAkA267xMl35bo','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676672298756,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jujtdmVGsrt_5yLhh0TEH6OTIZELVuX62dWikIM5hlohU4ftWy7qWgQe8nbgG5eP','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676673594328,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('MGug7mhLpBtEDK868VmFjoF1U61sR8ep3QL7Qt_RfKgns4G_OUNfKyHn1mzrIqct','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676673621607,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('YUqgtDiR9GE2V3GZlbtNtq81vpNH9NCI4TitmUaNsPVRdDHpqPOGA-fsIfsqU9S7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676673715262,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('mV0kEaPa3U9sEwuSWAsoF7FbJd3p42smctxym3cnFO81bYPcFq5ply0Z9nA01kHn','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674044507,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-BgTAtJdG8KeVikHfpm-xykzbkEIzH_Yk0EDxussJtD4VU7xcUh09pYzFDMvvxJ1','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674054946,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Zkxjshm9f3ppOTeLoSLaXDd4d-CRSM_5QZxF3rddpKsRQ5FUcBJNtKmap8dEbZcE','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674114945,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('UeqqccOGenp41ptpiB1ZWYHN9wAhnRYzmHZWI8dy7pFJRNcTOdv3lZ0helwwOy7f','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674116779,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('c0IWyN1m-svPy0EUhzBwDbX03WZ16YkmhD2D-opZNwNoazY4u9cX0RS0pTLVxhvz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674152096,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('MAUywVBVEt4P_yh_qnudo8WXKHZdfl-jD8Po8X2hm55XgYzRLxzF0r6nChQDbOOF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674162135,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('JydoPEZ8KU8yaqNoMx1xPGSbfUdOPSv2SQiCZmK1dTfbBXDLhVJOAdA4dFOEwQCy','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674196607,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('lNKs32-ycRvynJ7ixV1cfohxSINhuHgRAKruYP5rTTG_tulWkBPpKE8SosAB621Y','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674214811,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('dHUmgLdYYSE09alq2yM0_p-a2U8oZTGHTwxKPMean4b46IG5Ewg7IOdvvyoEim3d','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674219349,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('f_RrvwksKrhkJ6Gae1UofqErLAxkMSoM9YTDAYAYRvmCKxCvgKLJCdFijd5vRKdW','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674283207,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hwmurAkZ8VyNj33IvjdBhtzbMjWs59FnKJkiw2Z4qMg2T-IYAv41LiMKMC84sDkt','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674289215,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('j6Tt3XHBK1JqAG0HV71RiNGuwacFMvlKH6x-LUTJGZlS_QAu2FQBpHJyxlQu4G0n','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674305193,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('HxzoYI1u8J0ofivvTndJk4mSAlxt9uc4Cypsky824nhqfPq-q52FZRg1N5kOvqgN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674342797,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ABLEMtS_Dlzp1-Agvks-vYBY00xh-lT8LiZI015xVisVMyFIf3oi3ynaTKnGIOAJ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674361344,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('R1Kv_mwycYYckMB51ffEWUyLhNTem_msgxgcfAUfmYNYwJX8sYkm4ghj8xRbbqd4','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674393545,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zL66nuacNDP3WSaXFct-kZvHV6_97CNPpp56PG_VMmvJge_xdc1Xz5sV6gCESFlh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674413914,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('0GUntwvmu2QsiCHXIQNNdmaODgHRViZqpXtdRIguHB6LpyDslqqE184ozB8Lnpe0','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674433234,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('AvpPjiSdwODN-xm1fS8E2eQj77esNKGC0na6RL9MFFs6mKQig8M6Q3U2oSuTgQQc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674437509,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('fztYjhAnObSGUTMyyG8i6rMQ__c7tDlRnJJ-z4nVWzfqEuYBNYTg9fJ6V-5RmPrF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674452187,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('OMkhLSZLxpRP6dk0nWJy4vFYqnt-mrYZXp1DdOjD5A1ufF1iYSbFED1lR0_Yuo7C','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674464353,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ni_P_D1rlFJUh84gAFJSYmZsFOorXdbRrOxmNv5UjwqlgOuZR3U3_Q84xY4G3-TZ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674678619,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('SVdHCYfxeio5ETwoXClI_wmeicCLI_stJZL6nxQq2kz4RNG73rtjJ-Lb6o8zqu9g','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674683338,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('HkubuGSxt5Cq_jw_fRRQ77RaaLuWg-1M1gBE_PU-NhUwTffMABeAPIa1uz_PbwIY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674693253,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('smkMsqIf7gjrOIWl2HPHf2_5tFB9Jo-ZqaFf1zcIBVKmkjSZ4KWMVIs87DNv5Ehi','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674936009,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('k0DZTFJWWGDfmk8N6Tfb012qLV_F5ZdNNHmJYitwt4dXO3XeDHP-0o9YqknjnZEa','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674939166,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hE7EjlFOD-gg7H35pXRrgtkWEBSWcvFBSAgnBo5M92iofmsSncQIkQ823R8EPgjB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674971101,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('nbU3zw3M6F9_jt_nJTMr4gT7xtU8PljTi6vi4jy_22QD2YaHF2Txz2bgaJK9uEFO','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676674975165,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('iaZKhpGXAB2PEN9IhDuzUglTx9i62VnNQdWxvxno-TZoaBfd5vOselBF4Ift35JH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675161877,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('aeqbZtfFi_eWfEJ1g3PvvH7cq2Mn03b0OjfLXj-Ab7-CSbnB4Femt5f4Jk9qfA1e','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675363145,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('SRucWhJBUIWXF0VwJIUeuzxqrg2XiUACx_h74hvXr3SA3-L_ga21iy0oIH7HNXgg','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675364520,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('3p0Us-rGRtL0PWysR6aMED3YFPtE8G52nR-RZb7npcoaFXVC49iMRYxj2zH66O7P','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675495432,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Xnxmx6GHd6lNqO-EhWlQb56ezWlyEJ1kq3OdI6DTZFtKzMLVZT6WqJjOnzC5lULd','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675506726,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('eiAwfuOdF07O55wD2-qQvgtsyq4kTWkIHqqNG6AP3sH327t9HVSARyr-tur18Qln','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675539506,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('C32Ki-GJZhOub8GiI3AaBXbtPu9AyQA_9CIan-m6W8iuH_WZZIUpnwhzwtKYfS14','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675609285,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('l_mG2AXSjRCn0ZV8UNTg4uIUuDkz1JUPyLZ_5NVkyuogNHzQw-IOMH4-YfY3c_uO','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675609823,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('C1ObwM5iBt2zvpopqE-rwv8lw0PNwna9IvQPfGbziQgP_sQkYRDsJDvV8-Gp986Q','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675646753,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xv3Iy71eDtYfPzf-DH4aNUWLGuKD4C41NKFRQ0hAGYFeaJtvl1M52Kd0Zjd3kMBw','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675661862,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hEXkphpDb1NFd7OGZgIDDOTOs219QHLwtaxQyE14yhkD1GNK53LHIi_KkdNDXlf9','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675727038,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('0xT3nDpdtJtyrIk1aoiI1qF1K_4-K5sJ_5T3exAbJ6uwE-4_LN1Qr6vJU0h8W1ih','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675759146,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('08LZSqsgc5INK4A7BIYwRM1_94q8gUhrwOVVMlUXP2r46neYfsTf4cGuhl2Aammz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675765645,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('wZ0uqP_ffdl6aUoS73ZPUhPWJXRX3GUzs7Y4S22mSpTYxjvTZ-_hbWomTfq3Kxdj','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675795377,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kNM2ZXiKgTwr2d_VYkjI8BTzzbOFGSiTntCvR_qJWCrwtMDJDMpUAQpr5yv_c-Lc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675809704,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('l8SUHIHo--ZISU95j3_1xUM_uEgA9dhkO6M4GhG4_v2o3CbLrjXAY9VTGhUVfw1y','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675828472,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('mke8Kh3Pu3OJOf5jKHzO6DOFCbMAgPVBvB4FtJzrI4SgErw2cT6WZAX93eT49W61','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675855122,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('rtMj1owmjoi_QCe4aiJGidGzrr40Mu3YCinG7eoJI9lfIkVl8kSnvl-68hOer4rD','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675871062,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('olLqHNKcl-Covhjb3dcIFgPr3wrfz1OmFjHjxOM-02-644lozF3Zgy-DwH0lVPP2','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675873749,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('tyT0dW051wywDyLawy1jfHe4eBxoKnz85E_ePZY631YYRZrixpJkGCxAOK8rSKlZ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675914461,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zj22ciPp8FEh4dYiWTfGO6GpQqsBln0F15DPSkqy9a7DKwohfJJlxUWHV8qnE01D','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676675915565,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('qtgwPP1MvCrrZ_MFD3M5y8TB1euReSYJratBIGhpyd-LJnHbaTTkFdbayJXvg-5w','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676106401,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Oub5S8MBfTFSnr6ld8XAgMSvvoxnmFhrWuo6GLX8OBtlPDYVZt0lths9qB0aMZDB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676122063,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('mOJbCN-yDF0EAUVFDeu7fiksXCuPRpTqGGYLcbLrIko13wQyFH19Fud7m9MUIO4x','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676162617,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('oBRu5H2_gBTuFPLu9kZXwKv65vTvVXqCKzVR7rH_0Mbp6M46Bu2bZ8IX8YKZKhqR','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676188436,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('WWvz0FzH7BcX6rV0psDoRmZHqYP4EZrbhvG6Bgo1vSlSIBASezpw9ZUZL9DEbOKo','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676208354,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('LIrghU38KZZ0SRwiwNDvivzUPA1kFSPRuqph3e7ZAEN6dHgN_uCf2U0SyG8HcChW','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676297533,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('oucFpHWzcSKzxCr_-fmJ5wFD4b0BIxHe9XUR2okkXcrbTJI4mSNVJkSR3YWki9i8','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676345570,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('apt3Rqk-QKC9iRlG1uS_bKnJ2wwUC5OsDpPWu4SGOhLD10-zJDlbISx_XxtaDxxK','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676601613,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('x8VF0soRoYKv6Bl0BIbH1SX67KymSlFU2PlQs6lhj1JIXbgJSpXJVwavfZJeXfav','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676676647042,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zugiDNTXunZWsbQT3fkQFLdCmcV3AWdHA41PLakePRxbf3_fjsyC3eQteCkkL7qq','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676721757531,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('oYvWiiXLI1EAZTFr3bweIt6PftdyOJdyO-PYADeolLhX8IvA78hHI1GxvRDcDeMI','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676721925786,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('yT3IskVcYhpwDlG1JmZspMh8qvGUKhQRi_rcWCsq-yFULTMnN6FFsvu9XN2hc8B4','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676721927699,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Dmbavi0hlNZSxT3G9DgR8tcINvzFPE0yeuVgnQN3817hUv8LqmF9PFb1IweDO_lx','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676721944450,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('P7ZqSuHU5__opwrI7biof4w8Yhvut0HnJ50oCDQYyrkMLtIWLzgx3IWjYm7CdMcb','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722415861,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9ErF8PMJtPtRaWu3ui6pyZUXa1UtGi6Tg0Yxx3gM3OswQkSzix0cgVRRGJ6hnIr_','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722437830,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('4iMkdu4-7lHrAk7TzMdmR4Z-thlwJkZRPE5gcS8AEQmw2sTQ6ivQe3-mweNRb3RL','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722448299,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('liwEzgtWxpCeWUvExFEs06WDwtLn3sO8f4b6L55TT_WK1tdPQcWvmYbkQZa9yyCC','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722457001,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('tc2AeECDONcec5tRCSu9iOzlFeth1TTdv9xYxMDvoGVTGsw78Y7UAdtu6lkvuy1z','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722481521,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('H124n2NiX6I62kWsOMfSyYi959HYKoCSULgCFsyJwlD97QrcGH3kjifoamwc60Dz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722488392,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TvSQFA1MQ4sGQShD8qzAfxQ7xI2986-Wpzr08V-DacOaVVxHj9H_1p3OtmEtxz8H','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722598800,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zK6kOFDS7RZ3EK8Zjw_TRKLTTVAuvtSB_KtBE1gtzR0QZ514wzIPH5rCzBXfrUs_','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722606632,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ow-iaZ2soCMXZbH-FK4BGDR_YRihvMgibcG23ZDODKE2HqIPIGlAesNeyW-bawjs','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722628125,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('21slor_WwU8EM-5g0uTc6Wr4TC_R2LuTEwGvyt_qdMHbCVqSc7VaJRisOw16uiW9','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722660703,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-AZInWTJy_dM59Wet6U5lzNjWlGwsBai_EMco-hLB7LfkXX1txgYRs2jidsxn8DY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676722668705,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('8VJz3vb65NO-7GBNU2cege-xz9AejHmwgjH-KTkx1ul1y89Fq9JxrEpM5PTG1vYe','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676723043157,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('XA3kzhcJ7HAQmDksa6_rBnOk2BCz0knRWF6K1WRKrsBjwDzWvSEr4fEprUzLDEGi','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676723052561,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('NvgQFqEEwuI3l4kT-Q0GEqVFO2g7fYP7CoiWKAIFKJh9GkdvXX0I3OtpbWZ1n-VC','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676723199310,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('TpjomcwvH6aUhgwMiZXixgXSXzLRRyPkE1MzfmBlBPWqeN1MO6tV-rVjHG9S23io','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676723266314,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-wrvVTAHJxyYxPxiuhZ2WyumKNa0cgpYAGEQFdFawkPOV6fMg2lqgVu3oKwMl8WF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676723334067,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('VLkqiDGrasRY3b0XhZd96ku4PQa1FJcqia8ot5vS_PrvhmM0xzj8iLRfqgNDLnnA','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676725517701,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('El7yusnuoBirGLR2ZQ_fm-0s_u2oHpcBN-ladfTwgb1ZTkmzzDLRKvxauYVVsQ2y','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676725611369,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('U8lu0I7uVkJysbAyisBaMw9_-bLb34lTSpmwuxaBn5CF9UCOIWttBUpvTAiO_z0J','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676725620963,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('37dRSSdWs9EtqURyshet4K3z8r37SwfSepo7jdg4hcc1e3NTh-NF-yNvXHTDpLdF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676725696505,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('krWFR-NvhOxrn9ZkLvFeX_JwfiznlNdY9V3uCi-pWyM8VLlc6MmBFCH6RWCCXihU','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676730733172,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('WEOr4jaMirqG0unRIwXTKmhRJbcq6LNTuavKki-ocqm79NmBD27kFQ6PgFWyM4A3','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676925830390,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('pr_G3GE2N0cdbqTvIpwrZN3JAi36W85hkYluBQmLcJWc4r1wJSUYINuW_QfOVpVN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676927667043,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('sxouX0hX0Pm2ZPpVDdGUXsYikPnYBfmAX2QSNxceDeQefqiKoe-Xh1vQW-k0wdi_','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676927680021,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('DQVzt41_xf77zMz7AVFLJrexto3UaBJgTrHdmC1N8NhEGC4VDSl8nGjGBTGJWV9O','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676927699041,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('yl7cf1ngIA_lbN9i15OYOagmGugFdeIwR7pta1KzR9nUND5DG2QKvcvGzUS-2vze','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676988523114,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jrnhD2RTogokCySImaehSUAIVuiIkrlbPnrTA0ISNy5mF0J0wzv3c69ZQa625bTK','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989526053,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('HpcDTizc9Wcg3CZdgXgltXh07W9SzaiUuAmASoA4wKptnnd-rJTkhOg0sWEbjbWi','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989635444,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('VxKd5KxBrPX44TCJ09wOjCrV-0A-_7D0DsR7Aj-zgyptPGqwrOZ_OCPosXC6mXfh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989654887,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9a4cKWPuLaverMMqlen-XuMLVvgGj1u53rANqmGEUUQ_jTS-RqOXUsd9swrLeyF2','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989658751,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('RSn4vHFQoSA-u21x5wnmWmU_5gemWxx25_Obb_83aI0GNU8TMJEtIbx-CMLRrQX2','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989663054,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('u82rJuAePNdmuXgsmArDXLaeQtXzBhnzDGdE1PdS-ZmVGI5-LBlDhf3WsuIdCLd6','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989672428,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('N0S2Ptr5-o8VSmXFx_ccOLQCqugZ0Bv8R3c3AkQdmx8wcvXAN-VwtdvrKgWO7UoE','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989685560,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('IAZ7D2rtNmf9nLTrSd-yCQrfydOSuzk2aXEMkQ8sF-BkHULPnwlTjqcFcQj9h7mh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989705832,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('RTJQtC3CGovCyQMiitr9iHQhQSapzRooqZLl0ldpTx9H6-aZTI8RkvikOjNDdSql','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989714354,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('UmhaxAlVIkmmJ53xVpzAQcBnRbi2_XETtjYhRgmddpNyPAZAiEY1aBUIw4DcP-SA','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989806539,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('OOv10WKXxw3L5CnfL5BlmBmmKW12qxy1fafnqMiKIr5N1OynQxYqTGoIKapz7AB5','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676989808299,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('W8vRlFeJXBx42EgF8Uwv47SDlbfDu21Hp2hYmhWIvLi8ZgcWy75FMXAk7chG48k-','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676991235687,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('pAVzzyM2LJL32aCuS2fKXmFJjZ52fkGTqDL5aMbV4-TZBnnHt8sZdaf9IMUS8clz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676991274222,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('IYAIz8y62qZpN4W_TpMF9TYkticHmfSxZDMhEocJSUXkyggieHh6SgaJsDI_CkQA','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676991282533,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('2uxxr49o_ZZztb7L40P6CnUaIBUm4g0dC0ytDR3hUr4Ypuub9-85b6zzJfkAkV3K','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676991293042,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hBRReDDgNJKqWmxITGBIRrf6WIFOI5a2QNfggecHmgfdCkPH2Iepq_8Kl2hXpRRc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676991326312,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('S9ObCNaakspP5g8oD6HeS8IrkXlC2-EcCDVkxMFXY0UV5L9moZa7WjGtcjOdeUkg','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676991343137,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Fx-7j5rQoE5JlZV8zsQZ5pUtjRwuHyvi42tK70Z0oHW0HtI9PH-qjxidfSiATiva','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676991345780,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('RrORKvmPwD2L0l1WxiybA_dxGhh4pCBSfOazYlqQnwj3egxy4wYnKH0cYBHgik8V','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993480292,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('pucn0J2naFiL0XYssKZWgP_73Rt-eZcXWCoeCb4d60WfCplcPxAhqMxVhOEexYma','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993484492,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('eBf9Cr5GjfY6qZAxLU3JDF6rCq9bLE498UOHDnHHuV3f9K1KBp2hwbAG5uKvitol','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993495541,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('A0NQAh_9pxLbqv4n0idymupDkaCMKUefi_6tzcB2yn-N2Eo2n0wXcytFUJnFylWl','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993524316,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ZWOVpmXX2ATwBoT_1lE7ch5Aurw_9-rY0AxpESDNbzwRxgJviVAc4l-43kkDsnuT','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993530900,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('5OrAZTFCGJp8qCZJH5G_1pvDGsm8N0dZlBNxaR0IWEOUGMncUPrghJzxCFVDCytX','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993547797,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kLqaw553JbYcaQkwVyZcdrmdeYbEvTE77no-96x3l3DSnT-s85BVlYEQr1ok-y69','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993711683,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('m3EHBy9aqZZ7KVGVY-lIY7l1h4A6NDeGxvCuAWX_ypbHVV4tXnmRWIhjq95qewkO','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993779838,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('QG6OWWcfrOrKqj-eD2qdr74kYazkBf9mbz-n1CtCeEtv_r1d8GreUuDi6QBVPbPC','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993784155,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kStByI-wsUQ9I7YcmbJ9dLQB5hHM08wEF7S3lw4eTm9YC9pVdE40W-bRYjufUYVt','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993823471,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('01xdBKP5Zes64WGCeif4XxnFZOZ2jOAICThhMURukTtP_UsFZhl1DqB0YqYJgt5c','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676993846252,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ntQO1i8TrQfWJLRPoij0QgOfC7Q0qn565DbUm0vErB6_emGtIUExVeahkJm0YOvC','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676994767342,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_hh8_NtVwrpyv83SYiYoBXcLypfiSqOK2hxPwLyJHIc3kLQ4eXe77GaXVASpUkhv','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074288701,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9ZDT3A4dQ9uYQ4eC2MbTlB2ZN4yukiB6fmwOtp023ueWtr0hKqbpxonMlQpGMnFE','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074374895,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('pWFxMjn1LDKrSG2UjJ3oIkY1x_tXCpHS3GW4yEAg4pOhbeJUufn6YOiRObDmus-a','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074393757,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('gOG8uzhPEjdqYOmGA6vwW0qyE7yXYfOsgnkmHB1novQmAg5NbnAFD8P4hbQyPJ-M','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074435243,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ODekqEYu5WIDhnIt-fsNKb35uk7mt84UL20kT0IB-Eiw4y1YQ_l_j_1NnuA-gqAj','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074443031,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('reRyavQ2r_pLtrZI8-lCoXmzguKeLMt8VXiSz6by0Qmip6c1I-OVbxYR63l9CRGO','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074447500,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xBTEh0a76LfgALRT2DPrv2pGb3TtOj8dzuZNPKq2cuKqjCnMvnJU0jKjjf8Mm6ZR','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074451684,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jmc-hFtsO429Je3mfNSz4Ck9Y9J3GkJG3rkbm-Le8Ctgah6zEMJmx79UOhp2DWfh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074455474,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zKqQBHTDX8VmdDnQHldPduB7Oe_mB0lCQhwhKWzJS9UDx5H6xuDnLs3fIc-W7_LF','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074518721,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('YDVEpM0i7Fk204NmQV1X4m2Rjd1Bequ6rYAfaxqz58FQGoxUfz1gCgHstLSPwnMz','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074684225,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('SDmejKRoFqUsZBnQ6s0uVxZLsQOt5NRdj-frsBwRBt0UZ4d5K_EWch3r7pAywQXt','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074728062,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('gFTYmkQaxxG1JpwBSusq45uWRJrWevLe66WHzjPzP2rOdjsX3p0LUbB6XlCkKeGu','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074737941,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('CARE6FALgsIM_wtLxqK6b6EBX0I7s4jIUdpFUvy2RE8wiemS9hhkHMJcSqA2nn6D','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074761540,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('3dJTmo9qgcg32tvR7APJZtpj0O22buYvqb-bn8QJ6pov-SnbhVyPOTyywrXngfWj','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074792072,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('B88MF9Yd9on84wleCX6if22GBUFBeubHVuhgzxSbdT1_iljlGML4hSxnXT8xHLD6','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074796351,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('emG3ZBx0Nhfs0yhVWa0Dm6bxYup1f_sQK67F2zRlIf12HMVf4Y256_X7LtWounI6','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074849729,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('CZZOAwlBiYZOIp7Am1g6k8kx96UwdiYbNmN2Hb-6CAsqacCFQhq5rEV9hvVsohWw','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074929838,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('-fe76gNiTjKxAJOwDH5Y8hFUXNf-DyK-4k1medZ52ojSUsQLFID-tLKkAW8eE94W','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677074950310,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('kaiWVN8F5UUO-viFoK2vgbM-w31wSSxXlVnTy76uThOrQvkegFuWt9KAhthhztfr','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677186909264,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_sessions" VALUES ('m6IVlWpc6WscikigoZftqFalE4inSn0smmZkHS3tJ6oTxqMmEhfWABJ8LsHGQOar','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677077393274,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('tD1f3sI50gxVcMf2N8M-oLbPzl7dQyP_swBJRMeLC2YwdrlokF3JUtSiiVNO3beh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677101947700,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('UUBE8lSxcga3Jno1RJwgZeneFsC2q1THyUNwvgK-PZGrIOtuOOwt23r2QalP86yH','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677102132984,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('uZtOGCH3tiqHKPAZ9AVzZZe9PgPdd1Ch_RS7ka_LQa6_WsddiJas8yxKZ8Yo8G3i','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677102323878,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('VWjNI1ZfVGdk_1F1dWvcHfBjVnowAGN_p52CwCguN-EmvjFQE_F3UcRAgIBBJAbd','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677102464604,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('JbdC3P3oo25y8sfUaH3m07BqiaiVPboAcdnUgu-mrcQJb43hPljKuKI_hS1govG8','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677102519209,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('s9yVU4mSz2TmXR85LlqKdHqCB0E4KpmV3BoxRIU9dOTUYRWSe5BbJKnmrxbPuw7E','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677157457582,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('QO79NpuBeRElNSuv_Kw_0L5_5H9UttZ3BcoHdtYnW02m7u24EyNJkleLV0zLnvIZ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677157879269,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('25Ye1R6movwHFmuXtvAdMLQox6FGm8YgDs671zcN8CVHHSiMb1TQFFnDj32BTr4k','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677157943571,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jt8WLDvB2dUjw1hWs7MD2LFIegL4G-hkirBxTuayscd0R4JaV7jgGdAekRnfKbRB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677157964516,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('AdO3wO3R_XCY3eJe8iDbcMLpEyrdYuVwWPz6U-sRYTRKYUfrSUH7LPVpQZ_1RSFE','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677157975467,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Oa9-KqYeZGkdGKClfrAW_4BioYAYdPq-8Y9MfDSeR_nRhUVH9ZoM1ASY8q1G6pN2','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158681496,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('ZzPpVJJugwB9akxGNCCaCSoEkqrB8ppJ7A3u34bsnCkSla7iICF6AhFB543pZLyG','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158729523,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('B6UVVUKc3_IBxFaEkiAeK5mi3PQJYaSHlpMpyXYNqrTgXu3GFcQ0ZwyVwrzbn1LN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158738146,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('AgWHQms68DBjIVQbmT4akgOFsPKHv-ZQkUSkupQKl7HC8VuE09KV-oddAwPU3tQV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158798657,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('pHHCEfXDiqkDb0EPD7QcdJQG8q2sBrvt7JngNJztkfIViP_y3656082XZrcu8tY7','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158823049,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Z7X2xo_hotoxtHfzBIfWWoy8tDdN1nXkIC_6MmektTEr1hbOkCJngA-QWReC3OY9','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158870879,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('PlROXytFvTW00XnlF10Konvz7tQGi9rdUhw6XhwVrcBLa4tlfVnZ3ZLbpVgdMnva','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158878091,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('axgpLgpsBs6-4VqCwbX48a7z5k8wsBbGkFfY8xVLxKoVsP_MNPvRltsCe7Fkpw-S','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158890944,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('oHavyn1YSQGArGTMaiIRUzh23CcCnHWDbTi6Oo9Z3x5tOW3rz4ZFD-2R3-JUF2TM','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677158907979,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('4KaGAhA0WMkQjym8QRy-yFP9q1eI2DbB251kvAqE5HKXfwXjit7IQLb0O7mcfJOn','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161298284,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('e1wPNtq3LJnlFMAOSFwQdrxKG9sDtV44tYZip5-ocg7URzqXVlstyUW2G4e2fHY_','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161520011,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hRTjRtZ_ckNER_cUTrBBFH35iqh0mpajb0fZ-Nocpy_CsaXJn1TRm0Muz1n_dPzJ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161536259,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Uy8Lrn7jkMTjROvtSrl-50JhVpYcZ-9tTGxxxnbSL5x5Lfis8VlEezq7vnBYZLAV','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161540524,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('4DnYB42FRgQuUJbVIQXema_Pm5xcZAVk7q3almkyetJ39v7I-k1_jxSi9n-qisAX','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161579359,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Js_s7MFKhcigKSJeftie7g3RF7Rl9Ii1CWdHfhmhsjsOmeqZTDQc5kTqwv3eMF80','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161599962,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Gk0JUOT7FbVjTuWow51JfBob8U3-HsETCprW2-DCnD2Cc_m0xGsNXerVsVHtiL-s','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161602311,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xnh6a9fMlJ0IlSxD704bB1Sp1LuaUgUHb0Mk8PtAAwtIIx7IfTcDJD8P_xzoiYMh','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161608872,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('UmrvQ5CBtxnPW9OhxbIJACIZ1saxX5KhNpGIofDOIo8CZ6C4WN_iCZFhl4oE5zAB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161623481,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('GTgi2oDTId9uuDC1qf30JE6xw749ClmtHOgt8jpzDEDeVJEJ6AK-I_haeQ8TTbrB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161653084,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('__F8AveD0BgvvWjCdST1QKfmc5lyQOH6F8oSFlmq2lYUGvg_lzrLl3ppRjYBo540','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161708290,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('A-t_OJ5fBnupjcOdVP_AE9krr51mEIH95ZN34VxeYISCAa-V9AaZic0nBBJbFNTB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161736411,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('zTkY0b2EEL8mwg5jycvyWUzNeEnG8J9j-XcNZu_dXEblMW1qzgs4wsXBkWYKvxyS','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161762116,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('qUdEzs3mHOjxTJuF3z3aAVT5wkzlABIZcRYPwnfSv37S-_ZeOkYtfT93tQoKRvQi','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161823048,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('_UnydVqjSwFeN6B_EBPyr_Rd__20TqSGO5dX_SDkakfPISXMHBnR7eoL2oVEdmbP','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161825848,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('PR8nsqBj8064i__1NYHeHVL95QQZiDN3zTpUCVlbZce77RvuZCewjaBVDJ03sFSv','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161831555,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('BfKJLMxf5aPncE494oh-tZzrvY-OBFpuc_UtKsHAEwvQ5i_a2NbcNcbbhUXuaGmU','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161834798,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('yfz-oEQPAP3Yz9vvCbm-FMVS1tolD9YFQVuI3QDvHxnABbIls_tIOL1EfFd3S_VY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677161862731,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('L0cZFkTQ53tlLwuwUIVVs-uL_TLcn1cl_qk8zLiST0jad68F1eqUQaWBTWCMxCkJ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677167366005,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('omFTuh-7s9LyqULj3IpQ4Jij5gc0cznSCrncpHxymjdWSYWxCHVwZuXANZtJAP9H','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677186865164,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('6dWz4LO9113AvzBz3dGINzR3umJgDD0FwsLIBZKde79fLYQDTL5dq1KBx37atQxM','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677248311195,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',NULL,'http://localhost:8055');
INSERT INTO "directus_sessions" VALUES ('6Ff6JbWg1AS4sSs1rd7C70h0zbCor6-bEsy9-c3fu4umdHw1ByST76RTMjCtp0ib','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677197135662,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('mDNSmHxYE45cCNAPh68Y-KWufrQi_nIbsbDNhz0B0k8J99z8bJu_A4D2-pThx4Cg','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677197415327,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('SjD117WdZ5PZa-w1PXczh2QL9Y4u9cRa6V2tdcxZHIvK3n6X4zSYnFzUoYwKT0lB','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677197497680,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('pAkqam1UzJoA0_qcxDlPGlKYEzm9bzEK1d4n3LJ8GfBcl35M4K1_1drg8uOtjueQ','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677197523958,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('h32I0qHXVJrRPfs2eMf7SrvZ8IHtiGqgNovcr_3ZPFe1OEThriuFwFZu0rUqLIZL','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677197598376,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('jdYJ7Cr4XTikHIji7qTXBonrG9bQiLfP8IgclCZ-EoZpxPc-4Kw6O2szlRws081O','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677197908070,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('hcKpZamgMIimQQ2Iust_jTer20ak-pUcVeDtiDVwfioi6a7Ka0n_1CKW3F7QxejN','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677229632523,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('NWXeklg0q_xYOO6w_NQngjJD4UJCTja1OyFff3H_jpp1AejeXlLJ18A8HhIH28OL','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677229750860,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('xZY7w5QZOaE1WbpFsVC38tHc6Lzqbxn5TPgGMx59KLFTnmGDP-R7wQ9oo9tXk0zY','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677229986312,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('Jh10dnpHdaIoBf0cfT33Acix0Hd334FVER-IhcE3AgCcJq1n7g6JuQ7oZPkfdsGT','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677230462656,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('9dW7ip7R0yVVsw7Q8dP48PCvD5Xx5ky4AQ0YPaXTmJCAFU2cyX47T2LyLs5s7y8d','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677245214471,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_sessions" VALUES ('PAsCyELBaF1f2r2Nm1YvdNnZfB6-YzLM6GBtZSmNuYhXEwB6MKAbszCOhYaUgUmc','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1677247706270,'127.0.0.1','axios/0.27.2',NULL,NULL);
INSERT INTO "directus_users" VALUES ('a3b7b6ba-de03-405f-9570-ebdc4f2acb1a','Admin','User','admin@example.com','$argon2id$v=19$m=65536,t=3,p=4$1PrgQuVmc38HiMmrpFglkw$vvi/efsDrwj4kHYo7uZGmyqWo4s7IKSGnW86hHXwGFc',NULL,NULL,NULL,NULL,NULL,NULL,'auto',NULL,'active','60180583-1388-4d27-b2b5-4d46785498af',NULL,1676643511198,'/settings/project','default',NULL,NULL,1);
INSERT INTO "directus_activity" VALUES (1,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947874668,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (2,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947941211,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (3,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976739,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (4,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976743,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (5,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976746,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (6,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976756,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (7,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976761,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (8,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976765,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (9,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976769,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (10,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675947976772,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','sayfalar',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (11,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948021468,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (12,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948047601,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (13,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948065104,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (14,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948080013,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (15,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948624062,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (16,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948626616,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (17,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948628089,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (18,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675949273319,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (19,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675949745891,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (20,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675949749456,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (21,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675950569573,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (22,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675950569577,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (23,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675950569589,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (24,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675950569592,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (25,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675950597362,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (26,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675950608205,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (27,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980477089,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (28,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479864,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (29,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479899,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (30,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479916,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (31,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479928,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (32,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479940,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (33,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479953,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (34,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479985,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (35,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980479998,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (36,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980480008,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (37,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980480021,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (38,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484648,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (39,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484669,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (40,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484685,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (41,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484697,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (42,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484710,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (43,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484721,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (44,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484730,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (45,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484739,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (46,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484747,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (47,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980484755,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (48,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486861,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (49,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486887,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (50,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486906,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (51,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486920,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (52,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486945,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (53,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486955,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (54,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486980,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (55,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980486990,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (56,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980487000,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (57,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980487009,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (58,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488876,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (59,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488903,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (60,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488921,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (61,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488935,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (62,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488947,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (63,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488958,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (64,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488970,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (65,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980488994,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (66,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980489004,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (67,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980489012,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (68,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980491042,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (69,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980493955,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (70,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980544970,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (71,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980557393,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (72,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980561786,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (73,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980570580,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (74,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980832959,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (75,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030107340,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','11',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (76,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030107344,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','12',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (77,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030107347,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','13',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (78,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030107351,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','cars',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (79,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030151130,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','14',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (80,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030188269,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','14',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (81,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030228194,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','15',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (82,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030249283,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','16',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (83,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030253072,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','15',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (84,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030254890,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','16',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (85,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030280692,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','17',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (86,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030328218,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','18',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (87,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030332460,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','18',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (88,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030334475,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','17',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (89,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030371446,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','19',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (90,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030422967,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','20',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (91,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030444430,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','20',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (92,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030448835,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','20',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (93,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030451026,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','19',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (94,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676030469232,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','cars',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (95,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031099655,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_files','fc1d4ba8-300d-4599-ba30-aa4b497d7b08',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (96,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031105330,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','cars','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (97,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031175598,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_files','33d20a10-a440-4f29-b011-efa26316f4f0',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (98,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031177703,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','cars','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (99,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031184551,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','cars','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (100,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031708301,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','21',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (101,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031724615,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','21',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (102,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031726989,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','11',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (103,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727015,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','12',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (104,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727057,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','13',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (105,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727069,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','14',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (106,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727079,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','15',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (107,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727089,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','16',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (108,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727098,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','17',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (109,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727107,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','21',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (110,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727119,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','19',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (111,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031727128,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','20',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (112,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031741100,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','cars','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (113,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676031745678,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','cars','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (114,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676033652272,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (115,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676033826569,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','sayfalar','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (116,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676034247683,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','20',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (117,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676034604434,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (118,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676035807900,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','cars','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (119,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040218037,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (120,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040373406,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (121,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040403004,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (122,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040423003,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (123,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040432731,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (124,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040437412,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (125,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040458537,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (126,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040472019,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (127,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040709746,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (128,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040723943,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (129,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040730718,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (130,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040756635,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (131,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040975238,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (132,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040976335,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (133,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040976414,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (134,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040976786,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (135,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040977994,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (136,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040992829,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (137,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676040995294,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (138,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041009581,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (139,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041034391,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (140,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041043726,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (141,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041046186,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (142,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041080068,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (143,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041089345,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (144,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041115926,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (145,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041163659,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (146,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041163660,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (147,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041174069,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (148,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041174070,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (149,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041177366,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (150,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041177367,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (151,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041208267,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (152,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041208270,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (153,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041209242,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (154,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041209244,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (155,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041219937,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (156,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041219938,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (157,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041226741,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (158,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041235847,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (159,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676041237615,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (160,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056414863,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (161,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056414865,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (162,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056460300,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (163,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056460303,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (164,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056560818,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (165,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056560822,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (166,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056608601,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (167,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056608605,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (168,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056649303,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (169,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056649305,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (170,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056666584,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (171,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056666587,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (172,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056889039,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (173,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056889044,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (174,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056940671,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (175,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676056940687,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (176,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057009749,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (177,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057009753,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (178,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057012756,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (179,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057012763,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (180,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057040701,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (181,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057040705,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (182,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057053995,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (183,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057053999,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (184,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057068793,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (185,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057068804,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (186,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057075471,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (187,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057075473,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (188,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057086148,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (189,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057086153,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (190,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057139832,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (191,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057139836,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (192,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057316556,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (193,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057316558,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (194,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057457019,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (195,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057457020,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (196,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057483381,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (197,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057483383,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (198,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057560344,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (199,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057560348,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (200,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057585097,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (201,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057585099,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (202,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057595750,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (203,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057595760,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (204,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057598985,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (205,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057598986,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (206,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057601961,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (207,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057601968,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (208,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057843650,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (209,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057843655,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (210,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057845552,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (211,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057845558,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (212,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057863399,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (213,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676057863401,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (214,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058077501,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (215,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058077505,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (216,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058122284,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (217,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058122286,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (218,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058138078,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (219,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058138088,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (220,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058177214,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (221,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058177218,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (222,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058203415,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (223,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058203418,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (224,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058320015,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (225,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058322431,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (226,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058331315,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (227,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058331318,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (228,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058342733,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (229,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058344361,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_permissions','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (230,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058363298,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (231,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058363299,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (232,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058400055,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (233,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058400058,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (234,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058436962,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (235,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676058436963,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (236,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676060997577,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (237,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676060997578,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (238,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061151537,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (239,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061151538,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (240,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061183693,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (241,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061183695,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (242,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061206896,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (243,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061206897,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (244,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061221995,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (245,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061222001,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (246,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061240758,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (247,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061240760,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (248,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061307083,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (249,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061307084,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (250,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061314903,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (251,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061314906,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (252,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061347503,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (253,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061347506,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (254,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061399296,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (255,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061399301,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (256,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061401232,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (257,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061401234,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (258,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061405092,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (259,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061405096,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (260,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061409538,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (261,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061409542,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (262,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061444422,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (263,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061444423,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (264,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061620653,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (265,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061620656,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (266,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061641572,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (267,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061641587,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (268,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061692257,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (269,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061692258,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (270,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061710411,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (271,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061710415,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (272,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061719742,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (273,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676061719745,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (274,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062091975,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (275,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062091988,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (276,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062200568,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (277,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062200571,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (278,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062217345,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (279,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062217346,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (280,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062458565,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (281,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062458567,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (282,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062462175,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (283,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062462180,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (284,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062471943,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (285,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676062471946,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (286,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063241600,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (287,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063241603,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (288,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063244533,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (289,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063244535,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (290,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063294196,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (291,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063294198,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (292,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063325751,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (293,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063325753,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (294,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063453501,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (295,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063453504,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (296,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063491791,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (297,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063491796,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (298,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063497801,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (299,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063497802,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (300,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063549672,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (301,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063549677,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (302,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063550116,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (303,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063550119,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (304,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063563263,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (305,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063563266,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (306,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063580489,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (307,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063580494,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (308,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063586268,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (309,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063586274,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (310,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063587448,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (311,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063587460,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (312,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063620432,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (313,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063620434,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (314,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063658986,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (315,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063659008,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (316,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063675571,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (317,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063675572,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (318,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063802825,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (319,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063802827,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (320,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063810089,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (321,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063810090,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (322,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063833246,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (323,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063833252,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (324,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063849636,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (325,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063849638,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (326,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063884433,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (327,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063884441,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (328,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063972454,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (329,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063972458,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (330,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063984241,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (331,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063984242,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (332,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063990139,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (333,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676063990140,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (334,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676064017789,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (335,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676064017798,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (336,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676064019699,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (337,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676064019700,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (338,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065269746,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (339,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065269750,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (340,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065350956,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (341,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065350958,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (342,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065500540,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (343,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065504096,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (344,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065544896,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (345,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065569147,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (346,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065580992,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (347,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065583777,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (348,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065587909,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (349,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065589612,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (350,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065679402,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (351,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065707849,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (352,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676065709585,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (353,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066394652,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (354,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066407101,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (355,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066432821,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (356,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066436521,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (357,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066626591,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (358,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066633314,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (359,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066638742,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (360,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066690796,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (361,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066698166,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (362,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066710319,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (363,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066714572,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (364,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066802394,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (365,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676066812404,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (366,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676067130807,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (367,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676067452243,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (368,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676067453312,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (369,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676067498759,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (370,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676068794331,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (371,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676068821610,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (372,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676068915264,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (373,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069244510,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (374,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069254948,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (375,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069314947,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (376,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069316780,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (377,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069352101,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (378,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069362137,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (379,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069396608,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (380,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069414813,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (381,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069419351,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (382,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069483209,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (383,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069489217,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (384,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069505195,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (385,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069542799,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (386,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069561346,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (387,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069593546,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (388,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069613916,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (389,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069633237,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (390,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069637510,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (391,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069652189,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (392,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069664355,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (393,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069878621,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (394,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069883340,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (395,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676069893254,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (396,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070136011,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (397,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070139168,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (398,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070171103,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (399,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070175167,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (400,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070361879,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (401,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070563147,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (402,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070564522,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (403,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070695438,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (404,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070706727,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (405,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070739508,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (406,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070809288,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (407,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070809826,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (408,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070846755,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (409,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070861864,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (410,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070927040,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (411,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070959148,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (412,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070965647,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (413,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676070995378,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (414,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071009705,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (415,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071028473,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (416,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071055124,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (417,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071071064,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (418,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071073750,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (419,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071114462,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (420,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071115567,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (421,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071306406,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (422,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071322065,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (423,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071362619,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (424,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071388438,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (425,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071408356,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (426,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071497536,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (427,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071545572,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (428,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071801615,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (429,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071847044,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (430,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676071848988,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (431,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117125788,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (432,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117127700,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (433,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117144452,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (434,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117368138,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','22',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (435,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117368144,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','Hakkmzda',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (436,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117434902,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','23',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (437,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117484228,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','24',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (439,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117615863,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (440,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117637832,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (441,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117648301,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (442,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117657003,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (443,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117681523,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (444,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117688394,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (445,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117726717,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','Hakkmzda',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (446,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117750596,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','25',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (447,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117750602,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','AboutMe',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (448,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117763201,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','26',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (449,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117774650,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','27',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (450,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117798802,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (451,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117806634,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (452,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117828126,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (453,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117860705,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (454,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676117868707,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (455,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676118243160,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (456,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676118252563,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (457,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676118399313,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (458,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676118466317,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (459,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676118534070,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (460,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676118556548,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (462,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676120811370,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (463,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676120820965,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (464,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676120896507,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (465,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676120904661,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (466,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676321030393,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (467,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676322867047,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (468,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676322880023,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (469,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676322899042,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (470,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676322916014,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (471,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676323740035,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','AboutMe',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (472,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676323761462,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','AboutMe',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (473,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676383949321,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','28',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (474,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676383949325,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','logo',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (475,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676383979214,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','29',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (476,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384037086,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','logo',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (477,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384049462,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_files','0a82274c-31f4-4872-afef-5608fb5ceace',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (479,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384726056,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (480,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384835448,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (481,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384854891,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (482,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384858753,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (483,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384863057,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (484,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384872430,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (485,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384885561,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (486,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384905836,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (487,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676384914356,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (488,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676385006542,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (489,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676385008301,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (490,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676385103469,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (491,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386474225,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (492,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386482535,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (493,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386493046,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (494,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386526316,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (495,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386543138,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (496,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386545781,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (497,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386841931,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','30',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (498,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386841940,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','contact',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (499,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386873873,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','31',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (500,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386912630,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','32',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (501,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676386931437,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','33',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (502,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676387278352,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','34',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (503,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676387302716,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','35',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (504,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676387821191,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (505,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388209219,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_files','d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (506,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388680296,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (507,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388684494,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (508,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388695543,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (509,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388724320,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (510,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388730902,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (511,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388747799,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (512,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388911686,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (513,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388941842,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (514,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388979841,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (515,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676388984157,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (516,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676389023474,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (517,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676389046255,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (518,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676389085075,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (519,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676389310871,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_collections','contact',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (520,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676389390148,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_fields','36',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (521,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676389508711,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (522,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462596954,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_collections','logo',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (523,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462612334,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','37',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (524,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462612340,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_collections','main',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (525,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462835511,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','38',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (526,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462889553,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','39',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (527,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462902414,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_collections','main',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (528,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462918431,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','40',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (529,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462918437,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_collections','mainPage',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (530,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462933179,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','41',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (531,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462943765,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','42',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (532,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676462971114,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','43',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (533,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676463046732,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','44',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (534,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676463058502,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','45',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (535,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676463090097,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','46',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (536,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676463177027,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','47',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (537,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469454076,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_files','a8ab9893-6204-4cd3-b406-33cb58d59071',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (538,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469462296,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','mainPage','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (539,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469488703,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (540,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469574898,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (541,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469593759,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (542,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469635245,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (543,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469643032,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (544,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469647501,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (545,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469651685,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (546,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469655475,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (547,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469718723,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (548,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469884230,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (549,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469928063,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (550,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469937943,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (551,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469961541,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (552,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469992074,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (553,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676469996352,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (554,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676470049731,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (555,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676470122475,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (556,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676470129840,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (557,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676470150311,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (558,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676470162571,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (559,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676471089458,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (560,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676471202032,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (561,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472561056,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (562,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472562620,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (563,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472564022,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','11',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (564,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472565456,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','12',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (565,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472583492,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','13',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (566,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472585208,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','14',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (567,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472593276,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (568,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472616643,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','13',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (569,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472618204,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (570,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472619747,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','14',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (571,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472621261,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (572,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472622957,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (573,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472624607,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','11',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (574,'delete','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676472626207,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','12',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (575,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676497147703,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (576,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676497237736,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_permissions','15',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (577,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676497332986,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (578,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676497523879,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (579,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676497664605,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (580,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676497719213,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (581,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676497854234,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (582,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553079273,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (583,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553143574,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (584,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553164519,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (585,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553175471,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (586,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553270459,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','48',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (587,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276141,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (588,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276176,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','2',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (589,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276196,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','3',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (590,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276215,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','10',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (591,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276239,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','8',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (592,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276249,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','4',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (593,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276259,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','5',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (594,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276269,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','6',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (595,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276277,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','7',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (596,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276287,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','48',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (597,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553276296,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','9',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (598,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553296646,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','sayfalar','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (599,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553583646,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','sayfalar','1',NULL,'http://0.0.0.0:8055');
INSERT INTO "directus_activity" VALUES (600,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553881500,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (601,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553929525,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (602,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553938148,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (603,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553998660,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (604,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676554023052,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (605,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676554070882,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (606,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676554078092,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (607,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676554090946,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (608,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676554107982,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (609,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676554117891,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (610,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556720015,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (611,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556736262,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (612,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556740526,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (613,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556779362,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (614,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556799963,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (615,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556802313,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (616,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556808874,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (617,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556823484,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (618,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556853092,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (619,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556908297,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (620,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556936413,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (621,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676556962119,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (622,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676557023052,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (623,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676557025850,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (624,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676557031557,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (625,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676557034799,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (626,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676557062734,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (627,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676557064023,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (628,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676563360481,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (629,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676592252747,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (630,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676592335666,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (631,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676592615331,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (632,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676592697683,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (633,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676592723960,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (634,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676592798379,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (635,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676593108077,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (636,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676593160860,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (637,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676624950864,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (638,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676625186316,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (639,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676625662659,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (640,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676626165669,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (641,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676640088094,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (642,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676640326100,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (643,'login','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676640429398,'127.0.0.1','axios/0.27.2','directus_users','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',NULL,NULL);
INSERT INTO "directus_activity" VALUES (644,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676640880942,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (645,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676641464239,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (646,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676642857141,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','49',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (647,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676643075667,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','50',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (648,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676643132373,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (649,'update','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676643135585,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_settings','1',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (650,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676643163171,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','51',NULL,'http://localhost:8055');
INSERT INTO "directus_activity" VALUES (651,'create','a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676643558141,'127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36','directus_fields','52',NULL,'http://localhost:8055');
INSERT INTO "sayfalar" VALUES (1,'published',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675948065101,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676553583643,'Hakkımızda ','<p>Deneeme</p>','hakkimizda','Lorem ipsum dolor, sit amet consectetur adipisicing elit. Quas voluptatem enim doloremque mollitia neque ipsam nemo quis minima cumque, ea cum odio commodi officia ab accusamus eum quam quaerat. Nisi sunt odio blanditiis ipsa, in, sapiente modi explicabo dolores error aliquid voluptatum quae rerum cupiditate id, veritatis molestiae quasi recusandae fuga. Voluptate voluptatibus incidunt ipsam quo, obcaecati quia, iusto rerum libero amet earum eveniet atque temporibus minima nulla mollitia voluptates consequuntur officiis ad aliquam! Reprehenderit fugit, tempore cumque officia maxime ducimus quod fuga non corporis provident accusantium quam impedit facilis quis ipsum saepe, dolore dolorem ab architecto necessitatibus? Dolores, dolorem.
');
INSERT INTO "sayfalar" VALUES (8,'draft',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980544967,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1675980832957,'İletişim','<ul>
<li>Detay</li>
<li>dsds</li>
<li>ds</li>
<li>dsd</li>
<li>sds</li>
<li>ds</li>
<li>dsd</li>
<li>ssdsdsd</li>
<li>dsd</li>
<li>sw</li>
</ul>','iletisim',NULL);
INSERT INTO "sayfalar" VALUES (9,'draft',NULL,'a3b7b6ba-de03-405f-9570-ebdc4f2acb1a',1676033826566,NULL,NULL,'sea','<p>sea</p>','sea',NULL);
INSERT INTO "cars" VALUES (1,'published',1676031105327,'Mercedes','A serisi','amg','34.000','550.000TL','fc1d4ba8-300d-4599-ba30-aa4b497d7b08','oto');
INSERT INTO "cars" VALUES (2,'published',1676031177699,'Renault','Clio','Joy','200.000','300.000','33d20a10-a440-4f29-b011-efa26316f4f0','Manuel');
INSERT INTO "mainPage" VALUES (1,'lorem lorem lorem lorem lorekm','Araçlar','a8ab9893-6204-4cd3-b406-33cb58d59071','daha iyi araç almak');
INSERT INTO "directus_settings" VALUES (1,'Deneme',NULL,NULL,'d967acf1-e5b4-4f71-81fd-c0cbc03ea9e2',NULL,NULL,NULL,25,NULL,'all',NULL,NULL,NULL,'[{"name":"contact","type":"style","url":"mapbox://styles/ihsankck/cle8k9hge008301qgsotyeb55"}]','pk.eyJ1IjoiaWhzYW5rY2siLCJhIjoiY2xlOGs1eDZ4MGZxODNxcnp2YTZ5MDJhMyJ9.SqNF4yw3cqIg95jKmZUA-g',NULL,NULL,NULL,'tr-TR',NULL,'deneme@gmail.com','0530 303 30 30',NULL);
CREATE UNIQUE INDEX IF NOT EXISTS "directus_users_external_identifier_unique" ON "directus_users" (
	"external_identifier"
);
CREATE UNIQUE INDEX IF NOT EXISTS "directus_users_email_unique" ON "directus_users" (
	"email"
);
CREATE UNIQUE INDEX IF NOT EXISTS "directus_users_token_unique" ON "directus_users" (
	"token"
);
CREATE UNIQUE INDEX IF NOT EXISTS "directus_flows_operation_unique" ON "directus_flows" (
	"operation"
);
CREATE UNIQUE INDEX IF NOT EXISTS "directus_operations_resolve_unique" ON "directus_operations" (
	"resolve"
);
CREATE UNIQUE INDEX IF NOT EXISTS "directus_operations_reject_unique" ON "directus_operations" (
	"reject"
);
COMMIT;
