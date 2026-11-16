# Bean Counter: Coffee Shop Menu System

A PHP + MySQL (PDO) web app for managing a coffee shop menu. It has user registration and login, full create/read/update/delete (CRUD) for categories and menu items, a search feature, and tracking of who added or changed each record and when. It is also secured against Cross-Site Scripting (XSS).

## Features

- Register, login, and logout with hashed passwords (`password_hash` / `password_verify`)
- **Categories** (parent) and **Menu items** (child) with a one-to-many relationship: one category has many menu items
- Add, edit, and delete records on both entities
- **Search** on both entities
  - Categories: by name or description
  - Menu items: by item name, size, or category name (works together with the category filter)
- **Record tracking** on both tables
  - `date_added`: when the record was created
  - `added_by`: id of the user who created it
  - `last_updated`: timestamp of the last edit
  - `last_updated_by`: id of the user who made the last edit
- Deleting a category also deletes its menu items (`ON DELETE CASCADE`)
- Pages are only available to logged-in users

## Security

| Measure | Where | What it does |
|---------|-------|--------------|
| Output escaping with `htmlspecialchars()` | `e()` in `dbconfig.php` | Shows injected scripts as plain text instead of running them |
| Input check for `<` and `>` | `has_html()` in `dbconfig.php` | Rejects HTML tags in names and descriptions |
| HttpOnly session cookie | `dbconfig.php` | Stops JavaScript from reading the session cookie |
| Content Security Policy header | `dbconfig.php` | Blocks inline scripts and scripts from other sources |
| `X-Content-Type-Options` and `X-XSS-Protection` headers | `dbconfig.php` | Extra browser-side protection |
| Password rules | `is_strong_password()` in `dbconfig.php` | 8+ characters with uppercase, lowercase, and a number |
| PDO prepared statements | All pages | Protects against SQL injection |

## Database

Database name: `coffeeshop`

| Table | Purpose | Key columns |
|-------|---------|-------------|
| `users` | Accounts | `user_id`, `username`, `email`, `password` |
| `categories` | Parent records | `category_id`, `category_name`, `description`, `date_added`, `added_by`, `last_updated`, `last_updated_by` |
| `menu_items` | Child records | `item_id`, `category_id` (FK), `item_name`, `price`, `size`, `date_added`, `added_by`, `last_updated`, `last_updated_by` |

## Project Structure

```
coffeeshop/
├── index.php                      # Menu overview
├── login.php / register.php / logout.php
├── dbconfig.php                   # PDO connection, security settings, helper functions
├── database.sql                   # Full database setup (tables and sample data)
├── migration_add_date_added.sql   # Adds date_added to an existing database
├── includes/                      # header.php, footer.php
├── categories/                    # list (with search), add, edit, delete
├── items/                         # list (with search), add, edit, delete, _form
└── assets/                        # style.css, app.js
```

## Requirements

- XAMPP (Apache + MySQL) with PHP 7.4 or newer
- A web browser

## Installation

1. Clone or download this repository.
2. Copy the `coffeeshop` folder into `C:\xampp\htdocs\`.
3. Start **Apache** and **MySQL** in the XAMPP Control Panel.
4. Open `http://localhost/phpmyadmin`, go to the **SQL** tab, paste the contents of `database.sql`, and click **Go**.
   - If you already have the database, run `migration_add_date_added.sql` instead to keep your data.
5. Open `http://localhost/coffeeshop/register.php`, create an account, then log in.

The folder must be named `coffeeshop`, or you must change `BASE_URL` in `dbconfig.php`.

## How to Use the Search

1. Log in and open **Categories** or **Menu items**.
2. Type a keyword in the search box and click **Search**.
3. Use **Edit** or **Delete** on a result to update or remove it.
4. Check `last_updated` and `last_updated_by` in the list or in phpMyAdmin to confirm the change was recorded.

## XSS Demo (for learning only)

`dbconfig.php` has a switch:

```php
define('SECURE_MODE', true);   // set to false to demonstrate the attack
```

With `SECURE_MODE` set to `false`, escaping and input checks are turned off so you can show how an injected script runs. Set it back to `true` to see the attack blocked. Only test on your own local system.

## Disclaimer

Made for educational purposes as part of a school activity.
