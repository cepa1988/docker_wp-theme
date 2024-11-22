
# WordPress Docker Setup with Database Backup

This repository contains a Docker setup for running a WordPress site with MySQL 8.0. It includes database persistence, automated backups, and an easy mechanism for restoring the database from a backup.

## Features
- WordPress site with persistent storage for plugins, themes, and uploads.
- MySQL database with persistent storage.
- Automatic database backup on startup.
- Manual database backup support.

---

## Prerequisites
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Directory Setup
Ensure the following directories exist in the project root:
- `wp-content/` (WordPress content)
- `wp-content/plugins/` (WordPress plugins)
- `wp-content/themes/` (WordPress themes)
- `wp-content/uploads/` (WordPress uploads)
- `db-backups/` (Database backups)

### 3. Run the Project
Start the containers using Docker Compose:
```bash
docker-compose up -d
```

- WordPress will be available at [http://localhost:8080](http://localhost:8080).
- MySQL database will be initialized with the credentials specified in `docker-compose.yml`.

### 4. Stop the Project
To stop the containers without removing volumes:
```bash
docker-compose down
```

To stop and remove containers, networks, and volumes:
```bash
docker-compose down -v
```

---

## Managing Database Backups

### Automatic Backups
Every time you run `docker-compose up`, the database backup (`db_backup.sql`) will be updated in the `db-backups` directory.

### Manual Backups
Run the following command to create a manual backup:
```bash
docker exec wordpress-db mysqldump -uroot -proot_password wordpress_db > backup.sql
```
The backup will be stored in `./db-backups/db_backup.sql`.

### Restoring from Backup
If the database is empty (e.g., after removing volumes), the backup in `db-backups/db_backup.sql` will be restored automatically when the containers are started.

To force restoration:
1. Stop the containers and remove the database volume:
   ```bash
   docker-compose down -v
   ```
2. Restart the containers:
   ```bash
   docker-compose up -d
   ```

---

## File Structure
```
.
├── wp-content/                # Persistent WordPress content
│   ├── plugins/
│   ├── themes/
│   └── uploads/
├── db-backups/                # Database backups
│   └── db_backup.sql          # Latest database backup
├── docker-compose.yml         # Docker Compose configuration
├── Dockerfile                 # WordPress Dockerfile (optional customizations)
└── README.md                  # Project instructions
```

---

## Environment Variables
The following environment variables are used in `docker-compose.yml`:

| Variable               | Description                     | Default Value       |
|------------------------|---------------------------------|---------------------|
| `WORDPRESS_DB_HOST`    | Database host                  | `db:3306`           |
| `WORDPRESS_DB_USER`    | WordPress database user        | `developer`         |
| `WORDPRESS_DB_PASSWORD`| WordPress database password    | `Default00!`|
| `WORDPRESS_DB_NAME`    | WordPress database name        | `wordpress_db`      |
| `MYSQL_ROOT_PASSWORD`  | MySQL root password            | `root_password`     |

---

## Troubleshooting

### Check Container Logs
```bash
docker-compose logs
```

### Access Database Shell
```bash
docker exec -it wordpress-db mysql -uwordpress -p
```

### Rebuild Containers
If changes are made to the `Dockerfile` or `docker-compose.yml`:
```bash
docker-compose up --build -d
```

---

## License
This project is licensed under the MIT License. See `LICENSE` for more details.
