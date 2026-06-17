# System SQL Reference

Derived from the Core SQL DDL definitions by the Docs Chain `sql-to-doc` transform (§11.4.106). The `.sql` DDL files are the sole authority; this document is generated from them and MUST NOT be hand-edited (doc -> sql is intentionally unimplemented pending a §11.4.133 review). Regenerate via `docs_chain sync` on the `sql_definitions` context.

<!-- GENERATED FILE — do not edit by hand. Source of truth: core/Database/DDL/*.sql -->

## Table Inventory (all DDL blocks)

Total distinct tables across all DDL sources: **162**

- `account`
- `asset`
- `asset_comment_mapping`
- `asset_project_mapping`
- `asset_team_mapping`
- `asset_ticket_mapping`
- `audit`
- `audit_meta_data`
- `automated_documentation_rule`
- `board`
- `board_column`
- `board_history`
- `board_meta_data`
- `board_quick_filter`
- `board_swimlane`
- `chat`
- `chat_external_integration`
- `chat_google_mapping`
- `chat_participant`
- `chat_room`
- `chat_slack_mapping`
- `chat_telegram_mapping`
- `chat_whatsapp_mapping`
- `chat_yandex_mapping`
- `comment`
- `comment_document_mapping`
- `comment_history`
- `comment_mention_mapping`
- `comment_ticket_mapping`
- `component`
- `component_meta_data`
- `component_ticket_mapping`
- `configuration_data_extension_mapping`
- `content_document_mapping`
- `cross_entity_search_index`
- `custom_field`
- `custom_field_option`
- `cycle`
- `cycle_project_mapping`
- `dashboard`
- `dashboard_history`
- `dashboard_share_mapping`
- `dashboard_widget`
- `document`
- `document_analytics`
- `document_attachment`
- `document_blueprint`
- `document_comment`
- `document_comment_thread`
- `document_content`
- `document_entity_link`
- `document_inline_comment`
- `document_label`
- `document_label_mapping`
- `document_mention`
- `document_reaction`
- `document_relationship`
- `document_space`
- `document_tag`
- `document_tag_mapping`
- `document_template`
- `document_type`
- `document_version`
- `document_version_comment`
- `document_version_diff`
- `document_version_label`
- `document_version_mention`
- `document_version_tag`
- `document_view_history`
- `document_watcher`
- `entity_document_mapping`
- `entity_lock`
- `extension`
- `extension_meta_data`
- `filter`
- `filter_share_mapping`
- `label`
- `label_asset_mapping`
- `label_category`
- `label_document_mapping`
- `label_label_category_mapping`
- `label_project_mapping`
- `label_team_mapping`
- `label_ticket_mapping`
- `languages`
- `localization_audit_log`
- `localization_cache_keys`
- `localization_catalogs`
- `localization_keys`
- `localization_versions`
- `localizations`
- `message`
- `message_attachment`
- `message_reaction`
- `message_read_receipt`
- `notification_event`
- `notification_rule`
- `notification_scheme`
- `organization`
- `organization_account_mapping`
- `permission`
- `permission_cache`
- `permission_context`
- `permission_team_mapping`
- `permission_user_mapping`
- `priority`
- `project`
- `project_category`
- `project_document_template_mapping`
- `project_history`
- `project_organization_mapping`
- `project_role`
- `project_role_user_mapping`
- `project_wiki`
- `report`
- `report_meta_data`
- `repository`
- `repository_commit_ticket_mapping`
- `repository_project_mapping`
- `repository_type`
- `resolution`
- `schema_version`
- `security_audit`
- `security_level`
- `security_level_permission_mapping`
- `statements`
- `system_info`
- `team`
- `team_knowledge_base`
- `team_organization_mapping`
- `team_project_mapping`
- `ticket`
- `ticket_affected_version_mapping`
- `ticket_board_mapping`
- `ticket_custom_field_value`
- `ticket_cycle_mapping`
- `ticket_documentation_requirement`
- `ticket_fix_version_mapping`
- `ticket_history`
- `ticket_meta_data`
- `ticket_project_mapping`
- `ticket_relationship`
- `ticket_relationship_type`
- `ticket_status`
- `ticket_type`
- `ticket_type_project_mapping`
- `ticket_vote_mapping`
- `ticket_watcher_mapping`
- `time_tracking`
- `time_unit`
- `typing_indicator`
- `user_default_mapping`
- `user_organization_mapping`
- `user_presence`
- `user_team_mapping`
- `users`
- `version`
- `vote_mapping`
- `work_log`
- `workflow`
- `workflow_documentation_step`
- `workflow_step`

## Block 01

Tables defined in this DDL block: **60**

- `account`
- `asset`
- `asset_comment_mapping`
- `asset_project_mapping`
- `asset_team_mapping`
- `asset_ticket_mapping`
- `audit`
- `audit_meta_data`
- `board`
- `board_meta_data`
- `comment`
- `comment_ticket_mapping`
- `component`
- `component_meta_data`
- `component_ticket_mapping`
- `configuration_data_extension_mapping`
- `cycle`
- `cycle_project_mapping`
- `extension`
- `extension_meta_data`
- `label`
- `label_asset_mapping`
- `label_category`
- `label_label_category_mapping`
- `label_project_mapping`
- `label_team_mapping`
- `label_ticket_mapping`
- `organization`
- `organization_account_mapping`
- `permission`
- `permission_context`
- `permission_team_mapping`
- `permission_user_mapping`
- `project`
- `project_organization_mapping`
- `report`
- `report_meta_data`
- `repository`
- `repository_commit_ticket_mapping`
- `repository_project_mapping`
- `repository_type`
- `system_info`
- `team`
- `team_organization_mapping`
- `team_project_mapping`
- `ticket`
- `ticket_board_mapping`
- `ticket_cycle_mapping`
- `ticket_meta_data`
- `ticket_project_mapping`
- `ticket_relationship`
- `ticket_relationship_type`
- `ticket_status`
- `ticket_type`
- `ticket_type_project_mapping`
- `user_default_mapping`
- `user_organization_mapping`
- `user_team_mapping`
- `workflow`
- `workflow_step`

## Block 02

Tables defined in this DDL block: **12**

- `custom_field`
- `custom_field_option`
- `filter`
- `filter_share_mapping`
- `priority`
- `resolution`
- `statements`
- `ticket_affected_version_mapping`
- `ticket_custom_field_value`
- `ticket_fix_version_mapping`
- `ticket_watcher_mapping`
- `version`

## Block 03

Tables defined in this DDL block: **17**

- `board_column`
- `board_quick_filter`
- `board_swimlane`
- `comment_mention_mapping`
- `dashboard`
- `dashboard_share_mapping`
- `dashboard_widget`
- `notification_event`
- `notification_rule`
- `notification_scheme`
- `project_category`
- `project_role`
- `project_role_user_mapping`
- `security_level`
- `security_level_permission_mapping`
- `ticket_vote_mapping`
- `work_log`

## Block 04

Tables defined in this DDL block: **6**

- `board_history`
- `comment_history`
- `dashboard_history`
- `entity_lock`
- `project_history`
- `ticket_history`

## Block 05

Tables defined in this DDL block: **11**

- `automated_documentation_rule`
- `comment_document_mapping`
- `cross_entity_search_index`
- `entity_document_mapping`
- `label_document_mapping`
- `project_document_template_mapping`
- `project_wiki`
- `team_knowledge_base`
- `ticket_documentation_requirement`
- `vote_mapping`
- `workflow_documentation_step`

## Block 06

Tables defined in this DDL block: **11**

- `custom_field`
- `custom_field_option`
- `filter`
- `filter_share_mapping`
- `priority`
- `resolution`
- `ticket_affected_version_mapping`
- `ticket_custom_field_value`
- `ticket_fix_version_mapping`
- `ticket_watcher_mapping`
- `version`

## Block 07

Tables defined in this DDL block: **17**

- `board_column`
- `board_quick_filter`
- `board_swimlane`
- `comment_mention_mapping`
- `dashboard`
- `dashboard_share_mapping`
- `dashboard_widget`
- `notification_event`
- `notification_rule`
- `notification_scheme`
- `project_category`
- `project_role`
- `project_role_user_mapping`
- `security_level`
- `security_level_permission_mapping`
- `ticket_vote_mapping`
- `work_log`

## Block 08

Tables defined in this DDL block: **6**

- `board_history`
- `comment_history`
- `dashboard_history`
- `entity_lock`
- `project_history`
- `ticket_history`

## Block 09

Tables defined in this DDL block: **2**

- `permission_cache`
- `security_audit`

## Block 10

Tables defined in this DDL block: **0**

_No `CREATE TABLE` statements in this block._

## Block 11

Tables defined in this DDL block: **0**

_No `CREATE TABLE` statements in this block._

## Block 12

Tables defined in this DDL block: **6**

- `chat`
- `chat_google_mapping`
- `chat_slack_mapping`
- `chat_telegram_mapping`
- `chat_whatsapp_mapping`
- `chat_yandex_mapping`

## Block 13

Tables defined in this DDL block: **9**

- `chat_external_integration`
- `chat_participant`
- `chat_room`
- `message`
- `message_attachment`
- `message_reaction`
- `message_read_receipt`
- `typing_indicator`
- `user_presence`

## Block 14

Tables defined in this DDL block: **9**

- `chat_external_integration`
- `chat_participant`
- `chat_room`
- `message`
- `message_attachment`
- `message_reaction`
- `message_read_receipt`
- `typing_indicator`
- `user_presence`

## Block 15

Tables defined in this DDL block: **2**

- `content_document_mapping`
- `document`

## Block 16

Tables defined in this DDL block: **21**

- `document`
- `document_analytics`
- `document_attachment`
- `document_blueprint`
- `document_content`
- `document_entity_link`
- `document_inline_comment`
- `document_relationship`
- `document_space`
- `document_tag`
- `document_tag_mapping`
- `document_template`
- `document_type`
- `document_version`
- `document_version_comment`
- `document_version_diff`
- `document_version_label`
- `document_version_mention`
- `document_version_tag`
- `document_view_history`
- `document_watcher`

## Block 17

Tables defined in this DDL block: **27**

- `document`
- `document_analytics`
- `document_attachment`
- `document_blueprint`
- `document_comment`
- `document_comment_thread`
- `document_content`
- `document_entity_link`
- `document_inline_comment`
- `document_label`
- `document_label_mapping`
- `document_mention`
- `document_reaction`
- `document_relationship`
- `document_space`
- `document_tag`
- `document_tag_mapping`
- `document_template`
- `document_type`
- `document_version`
- `document_version_comment`
- `document_version_diff`
- `document_version_label`
- `document_version_mention`
- `document_version_tag`
- `document_view_history`
- `document_watcher`

## Block 18

Tables defined in this DDL block: **2**

- `time_tracking`
- `time_unit`

## Block 19

Tables defined in this DDL block: **1**

- `users`

## Block 20

Tables defined in this DDL block: **7**

- `languages`
- `localization_audit_log`
- `localization_cache_keys`
- `localization_catalogs`
- `localization_keys`
- `localizations`
- `schema_version`

## Block 21

Tables defined in this DDL block: **1**

- `localization_versions`

