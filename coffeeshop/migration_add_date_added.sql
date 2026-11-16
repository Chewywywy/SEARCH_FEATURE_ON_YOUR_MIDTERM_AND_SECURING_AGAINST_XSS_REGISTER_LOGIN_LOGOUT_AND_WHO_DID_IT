-- Run this ONCE in phpMyAdmin (SQL tab) on your existing `coffeeshop` database.
-- It keeps your data and adds the date_added column to the parent and child tables.
USE coffeeshop;

ALTER TABLE categories
  ADD COLUMN date_added TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP AFTER added_by;

ALTER TABLE menu_items
  ADD COLUMN date_added TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP AFTER added_by;

-- Optional: make last_updated empty until a record is really edited,
-- so you can clearly show the change after an update.
ALTER TABLE categories
  MODIFY last_updated TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE menu_items
  MODIFY last_updated TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;
